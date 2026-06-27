-- GuildMarket v0.7.0
-- Gildeninterner Marktplatz — G/S/K Preisfelder, dynamische Spaltenbreite
-- Erstellt von MichaModus

local MSG_PREFIX  = "GUILDMKT"
local EXPIRE_SECS = 7 * 24 * 3600
local MIN_W, MIN_H = 470, 580

-- Basis-Spalten (x-Positionen sind relativ; item-Spalte expandiert beim Resize)
-- Alles rechts von item wird um extraW verschoben
local COL = {
    type    = { x=6,   w=50  },
    item    = { x=60,  w=120 },  -- expandiert
    price   = { x=184, w=86  },  -- wird verschoben
    contact = { x=274, w=80  },  -- wird verschoben
    online  = { x=358, w=22  },  -- wird verschoben
    expiry  = { x=384, w=30  },  -- wird verschoben
}
local ROW_H   = 22
local ROW_W   = 418  -- Basis-Breite (ohne extra)

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)
elseif RegisterAddonMessagePrefix then
    RegisterAddonMessagePrefix(MSG_PREFIX)
end

local function _Send(prefix, msg, channel)
    if C_ChatInfo and C_ChatInfo.SendAddonMessage then
        C_ChatInfo.SendAddonMessage(prefix, msg, channel)
    elseif SendAddonMessage then
        SendAddonMessage(prefix, msg, channel)
    end
end

-- Farben
local G  = "|cffffd100"
local Gr = "|cff44ff44"
local Y  = "|cffffff44"
local T  = "|cff00cccc"
local Dg = "|cff888888"
local W  = "|cffffffff"
local R  = "|cffff5555"
local Cg = "|cffffd700"
local Cs = "|cffc0c0c0"
local Ck = "|cffad6333"
local X  = "|r"

local function Clr(t) return t=="BIETE" and (Gr..t..X) or (Y..t..X) end

-- Preis formatieren (kompakt fuer Spalte)
local function FormatPriceShort(pg, ps, pk, pfree, ptype)
    if pfree=="1" then return "|cff00ff88Kostenlos"..X end
    local g,s,k = tonumber(pg) or 0, tonumber(ps) or 0, tonumber(pk) or 0
    if g==0 and s==0 and k==0 then return Dg.."k.A."..X end
    local parts={}
    if g>0 then parts[#parts+1]=Cg..g.."g"..X end
    if s>0 then parts[#parts+1]=Cs..s.."s"..X end
    if k>0 then parts[#parts+1]=Ck..k.."k"..X end
    local ptLbl = ptype=="FP" and (Dg.." FP"..X) or (Dg.." VHB"..X)
    return table.concat(parts," ")..ptLbl
end

-- Preis formatieren (lang fuer Tooltip)
local function FormatPriceLong(pg, ps, pk, pfree, ptype)
    if pfree=="1" then return "|cff00ff88Kostenlos|r", "" end
    local g,s,k = tonumber(pg) or 0, tonumber(ps) or 0, tonumber(pk) or 0
    if g==0 and s==0 and k==0 then return Dg.."Keine Angabe"..X, "" end
    local parts={}
    if g>0 then parts[#parts+1]=Cg..g.." Gold"..X end
    if s>0 then parts[#parts+1]=Cs..s.." Silber"..X end
    if k>0 then parts[#parts+1]=Ck..k.." Kupfer"..X end
    local ptLbl = ptype=="FP" and "Festpreis" or "Verhandlungsbasis"
    return table.concat(parts," + "), Dg.."("..ptLbl..")"..X
end

-- ============================================================
-- Rang-System
-- ============================================================

local playerRankIndex = 99

local function GetRankNames()
    local names, num = {}, GuildControlGetNumRanks and GuildControlGetNumRanks() or 0
    for i=0,num-1 do
        local n = GuildControlGetRankName and GuildControlGetRankName(i) or ("Rang "..i)
        names[i] = (n~="" and n) or ("Rang "..i)
    end
    return names, num
end

local function UpdatePlayerRank()
    local me    = UnitName("player")
    local total = GetNumGuildMembers and GetNumGuildMembers() or 0
    for i=1,total do
        local name,_,rankIdx = GetGuildRosterInfo(i)
        if name and (name:match("^([^%-]+)") or name)==me then
            playerRankIndex = rankIdx or 99; return
        end
    end
end

local function CanPost()
    if not GuildMarketDB or not GuildMarketDB.config then return true end
    return playerRankIndex <= (GuildMarketDB.config.postRank or 9)
end
local function CanDeleteOthers()
    if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end
    return playerRankIndex <= (GuildMarketDB.config.deleteRank or 1)
end
local function CanDeleteEntry(e) return (e.contact==UnitName("player")) or CanDeleteOthers() end
local function IsGM() return playerRankIndex==0 end

-- ============================================================
-- Online-Roster
-- ============================================================

local onlineRoster = {}

local function UpdateRoster()
    onlineRoster = {}
    local total = GetNumGuildMembers and GetNumGuildMembers() or 0
    for i=1,total do
        local info = { GetGuildRosterInfo(i) }
        local name, online = info[1], info[9]
        if name and online then onlineRoster[name:match("^([^%-]+)") or name]=true end
    end
    UpdatePlayerRank()
end

local function IsOnline(name) return onlineRoster[name]==true end

local function OpenWhisper(name)
    if ChatFrame_SendTell then ChatFrame_SendTell(name, DEFAULT_CHAT_FRAME)
    else ChatFrame_OpenChat("/w "..name.." ", DEFAULT_CHAT_FRAME) end
end

-- ============================================================
-- Datenbank
-- ============================================================

local function InitDB()
    if not GuildMarketDB          then GuildMarketDB={} end
    if not GuildMarketDB.listings then GuildMarketDB.listings={} end
    if not GuildMarketDB.config   then GuildMarketDB.config={postRank=9,deleteRank=1} end
end

local function PruneExpired()
    local now=time()
    for id,e in pairs(GuildMarketDB.listings) do
        if e.expires<now then GuildMarketDB.listings[id]=nil end
    end
end

-- ============================================================
-- Netzwerk  POST|ID|TYPE|ITEM|AMT|NOTE|EXPIRES|ITEMID|PG|PS|PK|PFREE|PTYPE
-- ============================================================

local function SendGuild(msg) if IsInGuild() then _Send(MSG_PREFIX,msg,"GUILD") end end

local function Serialize(action,id,e)
    local item=(e.item or ""):gsub("|",""):sub(1,40)
    local note=(e.note or ""):gsub("|",""):sub(1,50)
    return action.."|"..id.."|"..e.type.."|"..item.."|"
        ..tostring(e.amount or 0).."|"..note.."|"..tostring(e.expires)
        .."|"..tostring(e.itemId or "")
        .."|"..tostring(e.priceG  or "0")
        .."|"..tostring(e.priceS  or "0")
        .."|"..tostring(e.priceK  or "0")
        .."|"..tostring(e.priceFree or "0")
        .."|"..tostring(e.priceType or "VHB")
end

local function Deserialize(msg)
    local t={}; for p in (msg.."|"):gmatch("([^|]*)|") do t[#t+1]=p end
    if #t<7 then return nil,nil,nil end
    local itemId=tonumber(t[8])
    return t[1],t[2],{
        type=t[3],item=t[4],amount=tonumber(t[5]) or 0,
        note=t[6],expires=tonumber(t[7]) or 0,
        itemId=itemId, link=itemId and select(2,GetItemInfo(itemId)) or nil,
        priceG=t[9]  or "0", priceS=t[10] or "0", priceK=t[11] or "0",
        priceFree=t[12] or "0", priceType=t[13] or "VHB",
    }
end

local function Broadcast(id,e)  SendGuild(Serialize("POST",id,e)) end
local function DeleteListing(id) GuildMarketDB.listings[id]=nil; SendGuild("DEL|"..id) end
local function RequestSync()    SendGuild("REQ") end

local function BroadcastConfig()
    local c=GuildMarketDB.config
    SendGuild("CFG|"..tostring(c.postRank).."|"..tostring(c.deleteRank))
end

local function BroadcastMine()
    local me=UnitName("player")
    for id,e in pairs(GuildMarketDB.listings) do if e.contact==me then Broadcast(id,e) end end
end

local function PostListing(etype,item,amount,note,link,pg,ps,pk,pfree,ptype)
    local me=UnitName("player"); local now=time(); local id=me.."-"..now
    local itemId=link and tonumber(link:match("|Hitem:(%d+)"))
    local e={type=etype,item=item,amount=amount,note=note,
             contact=me,expires=now+EXPIRE_SECS,link=link,itemId=itemId,
             priceG=pg,priceS=ps,priceK=pk,priceFree=pfree,priceType=ptype}
    GuildMarketDB.listings[id]=e; Broadcast(id,e); return id
end

-- ============================================================
-- Hilfsfunktionen
-- ============================================================

local function FormatExpiry(ts)
    local d=ts-time(); if d<=0 then return R.."abgel."..X end
    local days=math.floor(d/86400); if days>0 then return Dg..days.."T"..X end
    local hrs=math.floor(d/3600);   if hrs>0  then return Dg..hrs.."h"..X end
    return Dg.."<1h"..X
end

local function GetLinkColor(link)
    if not link then return 1,1,1 end
    local hex=link:match("|c(%x%x%x%x%x%x%x%x)")
    if not hex then return 1,1,1 end
    return tonumber(hex:sub(3,4),16)/255,tonumber(hex:sub(5,6),16)/255,tonumber(hex:sub(7,8),16)/255
end

local function GetFilteredListings(filter)
    local out,now={},time()
    for id,e in pairs(GuildMarketDB.listings) do
        if e.expires>now and (filter=="ALL" or e.type==filter) then out[#out+1]={id=id,e=e} end
    end
    table.sort(out,function(a,b)
        local ao=IsOnline(a.e.contact) and 1 or 0; local bo=IsOnline(b.e.contact) and 1 or 0
        if ao~=bo then return ao>bo end; return a.e.expires>b.e.expires
    end)
    return out
end

local function GetDraggedItem()
    local iType,itemId=GetCursorInfo()
    if iType=="item" and itemId then return GetItemInfo(itemId) end
end

-- ============================================================
-- UI Globals
-- ============================================================

local mainFrame, configFrame, listContent, countText, rows, ebItem
local hdrFS = {}         -- Header-FontStrings fuer Resize
local postBtn_ref
local currentFilter="ALL"; local postType="BIETE"; local postPriceType="VHB"
local postFree=false
rows={}

-- ============================================================
-- Config-Frame
-- ============================================================

local function BuildConfigFrame()
    if configFrame then configFrame:Show(); return end
    local f=CreateFrame("Frame","GuildMarketConfigFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(360,220); f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(20); f:Hide()

    f.TitleBg:SetHeight(26)
    local title=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    title:SetPoint("CENTER",f.TitleBg,"CENTER",0,1)
    title:SetText(G.."GuildMarket "..X..Dg.."Einstellungen"..X)

    local hint=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hint:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-8); hint:SetWidth(330)

    local function RankDropdown(name,x,y,getVal,setVal,labelTxt)
        local lbl=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
        lbl:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",x,y); lbl:SetText(labelTxt)
        local dd=CreateFrame("Frame","GuildMarketDD_"..name,f,"UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",x-14,y-18); UIDropDownMenu_SetWidth(dd,200)
        function dd:Refresh()
            local rankNames,num=GetRankNames()
            UIDropDownMenu_Initialize(dd,function(_,level)
                for i=0,num-1 do
                    local info=UIDropDownMenu_CreateInfo()
                    local rn=rankNames[i] or ("Rang "..i)
                    info.text=G.."["..i.."]"..X.."  "..rn; info.value=i; info.checked=(getVal()==i)
                    info.func=function(btn)
                        setVal(btn.value); UIDropDownMenu_SetSelectedValue(dd,btn.value)
                        UIDropDownMenu_SetText(dd,G.."["..btn.value.."]"..X.." "..(rankNames[btn.value] or ""))
                    end
                    UIDropDownMenu_AddButton(info,level)
                end
            end)
            local cur=getVal(); local cn=rankNames[cur] or ("Rang "..cur)
            UIDropDownMenu_SetSelectedValue(dd,cur); UIDropDownMenu_SetText(dd,G.."["..cur.."]"..X.." "..cn)
        end
        return dd
    end

    local ddPost=RankDropdown("Post",8,-34,
        function() return GuildMarketDB.config.postRank end,
        function(v) GuildMarketDB.config.postRank=v end, G.."Posten erlaubt ab Rang:"..X)
    local ddDel=RankDropdown("Del",8,-96,
        function() return GuildMarketDB.config.deleteRank end,
        function(v) GuildMarketDB.config.deleteRank=v end, G.."Fremde Eintraege loeschen ab Rang:"..X)

    local info2=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    info2:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-158)
    info2:SetText(Dg.."Rang 0 = Gildenmeister  •  niedrigere Zahl = hoehere Position"..X)

    local saveBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    saveBtn:SetSize(160,26); saveBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,12)
    saveBtn:SetText("Speichern & Sync")
    saveBtn:SetScript("OnClick",function()
        if not IsGM() then print(R.."[GuildMarkt]"..X.." Nur GM darf aendern."); return end
        BroadcastConfig(); print(T.."[GuildMarkt]"..X.." Einstellungen gespeichert."); f:Hide()
    end)
    local closeBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    closeBtn:SetSize(80,26); closeBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",176,12)
    closeBtn:SetText("Schliessen"); closeBtn:SetScript("OnClick",function() f:Hide() end)

    f:SetScript("OnShow",function()
        if not IsGM() then saveBtn:Disable(); hint:SetText(R.."Nur der Gildenmeister kann aendern."..X)
        else saveBtn:Enable(); hint:SetText(Dg.."Einstellungen werden per Sync verteilt."..X) end
        ddPost:Refresh(); ddDel:Refresh()
    end)
    configFrame=f; f:Show()
end

-- ============================================================
-- Zeilen-Rendering
-- ============================================================

local function GetExtraW()
    if not listContent then return 0 end
    return math.max(0, listContent:GetWidth() - ROW_W)
end

local function RefreshPostButton()
    if not postBtn_ref then return end
    if CanPost() then postBtn_ref:Enable(); postBtn_ref:SetText("Eintrag posten")
    else
        postBtn_ref:Disable(); postBtn_ref:SetText("Kein Zugriff")
        local rn=GetRankNames(); local needed=rn[GuildMarketDB.config.postRank or 9] or "?"
        postBtn_ref:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:ClearLines()
            GameTooltip:AddLine(R.."Kein Zugriff"..X)
            GameTooltip:AddLine(Dg.."Benoetigt: "..X..G..needed..X); GameTooltip:Show()
        end)
        postBtn_ref:SetScript("OnLeave",function() GameTooltip:Hide() end)
    end
end

-- Header-Positionen aktualisieren beim Resize
local function UpdateHeaders()
    local extra=GetExtraW()
    for key,fs in pairs(hdrFS) do
        local col=COL[key]; if col then
            fs:ClearAllPoints()
            local shiftedX = (key=="type" or key=="item") and col.x or (col.x+extra)
            fs:SetPoint("TOPLEFT", mainFrame.InsetBg, "TOPLEFT", shiftedX+4, -49)
            if key=="item" then fs:SetSize(col.w+extra, 16)
            else fs:SetSize(col.w, 16) end
        end
    end
end

local function RefreshList()
    if not listContent then return end
    for _,r in ipairs(rows) do r:Hide() end

    local listings=GetFilteredListings(currentFilter)
    local me=UnitName("player"); local y=0
    local extra=GetExtraW()
    local curW=ROW_W+extra

    if countText then
        local total,su,bi=0,0,0; local now=time()
        for _,e in pairs(GuildMarketDB.listings) do
            if e.expires>now then total=total+1
                if e.type=="SUCHE" then su=su+1 else bi=bi+1 end
            end
        end
        countText:SetText(Dg..total.." Eintr.  "..Gr..bi.." Biete"..X.."  "..Y..su.." Suche"..X)
    end

    UpdateHeaders()

    for i,item in ipairs(listings) do
        local e,id=item.e,item.id
        local online=IsOnline(e.contact)

        if not rows[i] then
            local row=CreateFrame("Button",nil,listContent); row:SetSize(curW,ROW_H)
            local bg=row:CreateTexture(nil,"BACKGROUND"); bg:SetAllPoints(); row.bg=bg
            local hl=row:CreateTexture(nil,"HIGHLIGHT"); hl:SetAllPoints()
            hl:SetColorTexture(0.8,0.8,1,0.08); row:SetHighlightTexture(hl)
            local border=CreateFrame("Frame",nil,row,"BackdropTemplate"); border:SetAllPoints()
            border:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=10})
            border:SetBackdropBorderColor(0.4,0.8,1,0)
            border:SetFrameLevel(row:GetFrameLevel()+1); row.border=border

            -- Spalten werden beim Update via ClearAllPoints neu gesetzt
            local function MakeFS(font)
                local fs=row:CreateFontString(nil,"OVERLAY",font or "GameFontNormalSmall")
                return fs
            end
            row.fType=MakeFS(); row.fType:SetSize(COL.type.w,ROW_H); row.fType:SetJustifyH("LEFT")
            row.fItem=MakeFS("GameFontNormal"); row.fItem:SetJustifyH("LEFT")
            row.fPrice=MakeFS(); row.fPrice:SetJustifyH("LEFT")
            row.fContact=MakeFS(); row.fContact:SetJustifyH("LEFT")
            row.fExp=MakeFS(); row.fExp:SetJustifyH("RIGHT")

            local onlineBtn=CreateFrame("Button",nil,row); onlineBtn:SetSize(20,ROW_H)
            local dotTex=onlineBtn:CreateTexture(nil,"OVERLAY"); dotTex:SetSize(14,14)
            dotTex:SetPoint("CENTER",onlineBtn,"CENTER",0,0)
            dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Online")
            row.onlineBtn=onlineBtn; row.dotTex=dotTex

            local del=CreateFrame("Button",nil,row,"UIPanelButtonTemplate")
            del:SetSize(24,18); del:Hide(); del:SetText("X"); row.del=del

            rows[i]=row
        end

        local row=rows[i]
        row:SetWidth(curW)

        -- Spalten-Positionen mit extra-Verschiebung neu setzen
        row.fType:ClearAllPoints()
        row.fType:SetPoint("LEFT",row,"LEFT",COL.type.x,0)

        row.fItem:ClearAllPoints()
        row.fItem:SetPoint("LEFT",row,"LEFT",COL.item.x,0)
        row.fItem:SetSize(COL.item.w+extra, ROW_H)

        row.fPrice:ClearAllPoints()
        row.fPrice:SetPoint("LEFT",row,"LEFT",COL.price.x+extra,0)
        row.fPrice:SetSize(COL.price.w, ROW_H)

        row.fContact:ClearAllPoints()
        row.fContact:SetPoint("LEFT",row,"LEFT",COL.contact.x+extra,0)
        row.fContact:SetSize(COL.contact.w, ROW_H)

        row.onlineBtn:ClearAllPoints()
        row.onlineBtn:SetPoint("LEFT",row,"LEFT",COL.online.x+extra,0)

        row.fExp:ClearAllPoints()
        row.fExp:SetPoint("LEFT",row,"LEFT",COL.expiry.x+extra,0)
        row.fExp:SetSize(COL.expiry.w, ROW_H)

        row.del:ClearAllPoints()
        row.del:SetPoint("RIGHT",row,"RIGHT",-2,0)

        -- Zebrastreifen
        if online then
            if i%2==0 then row.bg:SetColorTexture(0.06,0.14,0.08,0.85)
            else            row.bg:SetColorTexture(0.04,0.10,0.05,0.70) end
        else
            if i%2==0 then row.bg:SetColorTexture(0.10,0.10,0.20,0.80)
            else            row.bg:SetColorTexture(0.05,0.05,0.12,0.55) end
        end

        row.fType:SetText(Clr(e.type))

        local link=e.link
        if not link and e.itemId then link=select(2,GetItemInfo(e.itemId)); if link then e.link=link end end
        if link then
            local r2,g2,b2=GetLinkColor(link)
            row.fItem:SetText(string.format("|cff%02x%02x%02x%s|r",r2*255,g2*255,b2*255,e.item or ""))
        else row.fItem:SetText(W..(e.item or "")..X) end

        row.fPrice:SetText(FormatPriceShort(e.priceG,e.priceS,e.priceK,e.priceFree,e.priceType))
        row.fContact:SetText(T..(e.contact or "")..X)
        row.fExp:SetText(FormatExpiry(e.expires))

        if online then
            row.dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Online")
            row.dotTex:SetVertexColor(1,1,1,1)
            row.onlineBtn:SetScript("OnEnter",function(self)
                GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                GameTooltip:AddLine("|cff00ff44"..e.contact.." ist online|r")
                GameTooltip:AddLine(Dg.."Klicken zum Fluestern"..X); GameTooltip:Show()
            end)
            row.onlineBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick",function() OpenWhisper(e.contact) end)
        else
            row.dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Offline")
            row.dotTex:SetVertexColor(1,1,1,0.45)
            row.onlineBtn:SetScript("OnEnter",function(self)
                GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                GameTooltip:AddLine(Dg..e.contact.." ist offline"..X); GameTooltip:Show()
            end)
            row.onlineBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick",nil)
        end

        row:SetScript("OnEnter",function(self)
            self.border:SetBackdropBorderColor(0.4,0.8,1,0.8)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
            local ttLink=e.link or (e.itemId and select(2,GetItemInfo(e.itemId)))
            if ttLink then pcall(GameTooltip.SetHyperlink,GameTooltip,ttLink)
            else GameTooltip:AddLine(e.item or "",1,1,0) end
            GameTooltip:AddLine(" ")
            local pLine,pType=FormatPriceLong(e.priceG,e.priceS,e.priceK,e.priceFree,e.priceType)
            GameTooltip:AddLine(pLine.."  "..pType)
            if (e.amount or 0)>0 then GameTooltip:AddLine(Dg.."Menge: "..X..G..e.amount..X) end
            if (e.note or "")~="" then GameTooltip:AddLine(" "); GameTooltip:AddLine('"'..e.note..'"',1,1,1,true) end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(Dg.."Kontakt: "..X..T..(e.contact or "")..X)
            GameTooltip:AddLine(Dg.."Laeuft ab: "..X..FormatExpiry(e.expires))
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave",function(self)
            self.border:SetBackdropBorderColor(0.4,0.8,1,0); GameTooltip:Hide()
        end)

        if CanDeleteEntry(e) then
            row.del:Show()
            row.del:SetScript("OnClick",function() DeleteListing(id); RefreshList() end)
            if e.contact~=me then
                row.del:SetScript("OnEnter",function(self)
                    GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                    GameTooltip:AddLine(R.."Eintrag loeschen"..X)
                    GameTooltip:AddLine(Dg.."Erstellt von: "..X..T..(e.contact or "")..X); GameTooltip:Show()
                end)
                row.del:SetScript("OnLeave",function() GameTooltip:Hide() end)
            else
                row.del:SetScript("OnEnter",nil); row.del:SetScript("OnLeave",nil)
            end
        else row.del:Hide() end

        row:SetPoint("TOPLEFT",listContent,"TOPLEFT",0,-y); row:Show(); y=y+ROW_H
    end

    listContent:SetHeight(math.max(y,20))
    if not listContent.empty then
        listContent.empty=listContent:CreateFontString(nil,"OVERLAY","GameFontNormal")
        listContent.empty:SetPoint("CENTER",listContent,"TOP",0,-70); listContent.empty:SetJustifyH("CENTER")
    end
    if #listings==0 then
        listContent.empty:SetText(Dg.."Keine Eintraege.\nSync anfordern oder neuen Eintrag posten."..X)
        listContent.empty:Show()
    else listContent.empty:Hide() end

    RefreshPostButton()
end

-- ============================================================
-- Haupt-UI
-- ============================================================

local function BuildUI()
    local guildName=GetGuildInfo("player") or "Gilde"

    local f=CreateFrame("Frame","GuildMarketMainFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(MIN_W,MIN_H); f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetResizable(true)
    f:SetScript("OnSizeChanged",function(self,w,h)
        if w<MIN_W then self:SetWidth(MIN_W) end
        if h<MIN_H then self:SetHeight(MIN_H) end
    end)
    f:Hide()

    f.TitleBg:SetHeight(28)
    local title=f:CreateFontString(nil,"OVERLAY","GameFontHighlightLarge")
    title:SetPoint("CENTER",f.TitleBg,"CENTER",0,2)
    title:SetText(G.."Gildenmarkt"..X.."  "..T..guildName..X)

    local sub=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    sub:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-5); sub:SetText(Dg.."by MichaModus  •  /gmarkt"..X)

    local cfgBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    cfgBtn:SetSize(26,20); cfgBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-4)
    cfgBtn:SetText("cfg"); cfgBtn:SetScript("OnClick",BuildConfigFrame)

    local grip=CreateFrame("Button",nil,f); grip:SetSize(16,16)
    grip:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-2,2)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown",function(self,btn) if btn=="LeftButton" then f:StartSizing("BOTTOMRIGHT") end end)
    grip:SetScript("OnMouseUp",function() f:StopMovingOrSizing() end)

    -- Tabs
    local function Tab(label,filter,x)
        local b=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
        b:SetSize(80,22); b:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",x,-22); b:SetText(label)
        b:SetScript("OnClick",function() currentFilter=filter; RefreshList() end)
    end
    Tab("Alle","ALL",6); Tab("Suche","SUCHE",90); Tab("Biete","BIETE",174)

    countText=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    countText:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",264,-28)

    local syncBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    syncBtn:SetSize(80,22); syncBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-34,-22)
    syncBtn:SetText("Sync")
    syncBtn:SetScript("OnClick",function()
        if GuildRoster then GuildRoster() end; RequestSync()
        print(T.."[GuildMarkt]"..X.." Sync angefordert...")
    end)

    -- Header-Hintergrund
    local hBg=f:CreateTexture(nil,"BACKGROUND")
    hBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-48)
    hBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-48)
    hBg:SetHeight(18); hBg:SetColorTexture(0.10,0.10,0.22,1)
    local hLine=f:CreateTexture(nil,"BACKGROUND")
    hLine:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-65)
    hLine:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-65)
    hLine:SetHeight(1); hLine:SetColorTexture(0.3,0.5,0.8,0.5)

    -- Headers (Referenzen speichern fuer Resize)
    local function Hdr(key,txt,align)
        local col=COL[key]
        local fs=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",col.x+4,-49)
        fs:SetSize(col.w,16); fs:SetJustifyH(align or "LEFT"); fs:SetText(G..txt..X)
        hdrFS[key]=fs
    end
    Hdr("type","Typ"); Hdr("item","Item"); Hdr("price","Preis")
    Hdr("contact","Kontakt"); Hdr("online","Online","CENTER"); Hdr("expiry","Rest","RIGHT")

    -- ScrollFrame
    local sf=CreateFrame("ScrollFrame","GuildMarketScroll",f,"UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-66)
    sf:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-22,210)

    local content=CreateFrame("Frame",nil,sf)
    content:SetWidth(ROW_W); content:SetHeight(20); sf:SetScrollChild(content)
    listContent=content

    -- Resize: ScrollFrame breiter → Content + Zeilen aktualisieren
    sf:SetScript("OnSizeChanged",function(self)
        local newW=math.max(self:GetWidth()-18, ROW_W)
        listContent:SetWidth(newW)
        if mainFrame and mainFrame:IsShown() then RefreshList() end
    end)

    local div=f:CreateTexture(nil,"BACKGROUND")
    div:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,208)
    div:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,208)
    div:SetHeight(1); div:SetColorTexture(0.3,0.5,0.8,0.6)

    -- Formular-BG
    local fBg=f:CreateTexture(nil,"BACKGROUND")
    fBg:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,46)
    fBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,46)
    fBg:SetHeight(162); fBg:SetColorTexture(0.06,0.06,0.14,0.85)

    -- === Zeile 1: Neuer Eintrag Label ===
    local newLbl=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    newLbl:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,192)
    newLbl:SetText(G.."Neuer Eintrag"..X)

    -- Typ-Dropdown
    local ddType=CreateFrame("Frame","GuildMarketDDType",f,"UIDropDownMenuTemplate")
    ddType:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",-14,160)
    UIDropDownMenu_SetWidth(ddType,80)
    UIDropDownMenu_Initialize(ddType,function(_,level)
        for _,t in ipairs({"BIETE","SUCHE"}) do
            local info=UIDropDownMenu_CreateInfo(); info.text=t; info.value=t; info.checked=(postType==t)
            info.func=function(btn) postType=btn.value; UIDropDownMenu_SetSelectedValue(ddType,btn.value); UIDropDownMenu_SetText(ddType,btn.value) end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddType,"BIETE"); UIDropDownMenu_SetText(ddType,"BIETE")

    -- Item-Box
    local lbItem=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbItem:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",104,189)
    lbItem:SetText(Dg.."Item  (Drag aus Bag oder Shift+Klick):"..X)

    ebItem=CreateFrame("EditBox","GuildMarketItemBox",f,"InputBoxTemplate")
    ebItem:SetSize(330,22); ebItem:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",104,167)
    ebItem:SetAutoFocus(false); ebItem:SetMaxLetters(40); ebItem.itemLink=nil
    ebItem:SetScript("OnReceiveDrag",function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebItem:SetScript("OnMouseDown",function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebItem:SetScript("OnTextChanged",function(self) if self.itemLink then local n=self.itemLink:match("|h%[(.-)%]|h"); if n~=self:GetText() then self.itemLink=nil end end end)

    -- === Zeile 2: Preis G / S / K  +  FP/VHB  +  Free  ===
    local lbPreis=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbPreis:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,143)
    lbPreis:SetText(G.."Preis:"..X)

    -- Helper: kleines Muenzfeld mit farbigem Label
    local function CoinField(lbl,color,bx,by,width)
        local l=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        l:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",bx,143)
        l:SetText(color..lbl..X)
        local eb=CreateFrame("EditBox","GuildMarketEB_"..lbl,f,"InputBoxTemplate")
        eb:SetSize(width,22); eb:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",bx,121)
        eb:SetAutoFocus(false); eb:SetMaxLetters(6); eb:SetNumeric(true)
        return eb
    end
    local ebGold   = CoinField("Gold",   Cg, 56,  0, 72)
    local ebSilber = CoinField("Silber", Cs, 138, 0, 72)
    local ebKupfer = CoinField("Kupfer", Ck, 220, 0, 72)

    -- Free-Button (Toggle)
    local freeBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    freeBtn:SetSize(60,22); freeBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",302,121)
    freeBtn:SetText("Free: Nein")
    freeBtn:SetScript("OnClick",function()
        postFree=not postFree
        if postFree then
            freeBtn:SetText(Gr.."Free: Ja"..X)
            ebGold:Disable(); ebSilber:Disable(); ebKupfer:Disable()
        else
            freeBtn:SetText("Free: Nein")
            ebGold:Enable(); ebSilber:Enable(); ebKupfer:Enable()
        end
    end)

    -- FP/VHB Dropdown
    local ddPType=CreateFrame("Frame","GuildMarketDDPType",f,"UIDropDownMenuTemplate")
    ddPType:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",348,122); UIDropDownMenu_SetWidth(ddPType,90)
    UIDropDownMenu_Initialize(ddPType,function(_,level)
        for _,t in ipairs({"Festpreis","VHB"}) do
            local val=t=="Festpreis" and "FP" or "VHB"
            local info=UIDropDownMenu_CreateInfo(); info.text=t; info.value=val; info.checked=(postPriceType==val)
            info.func=function(btn) postPriceType=btn.value; UIDropDownMenu_SetSelectedValue(ddPType,btn.value); UIDropDownMenu_SetText(ddPType,btn.text) end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddPType,"VHB"); UIDropDownMenu_SetText(ddPType,"VHB")

    -- === Zeile 3: Menge + Notiz ===
    local lbMenge=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbMenge:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,103); lbMenge:SetText(Dg.."Menge:"..X)
    local ebAmt=CreateFrame("EditBox","GuildMarketAmtBox",f,"InputBoxTemplate")
    ebAmt:SetSize(60,22); ebAmt:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",56,81)
    ebAmt:SetAutoFocus(false); ebAmt:SetMaxLetters(6); ebAmt:SetNumeric(true)

    local lbNote=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbNote:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",128,103); lbNote:SetText(Dg.."Notiz (optional):"..X)
    local ebNote=CreateFrame("EditBox","GuildMarketNoteBox",f,"InputBoxTemplate")
    ebNote:SetSize(316,22); ebNote:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",128,81)
    ebNote:SetAutoFocus(false); ebNote:SetMaxLetters(55)

    -- === Buttons ===
    local postBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    postBtn:SetSize(140,26); postBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,53)
    postBtn:SetText("Eintrag posten")
    postBtn:SetScript("OnClick",function()
        if not CanPost() then print(R.."[GuildMarkt]"..X.." Kein Zugriff."); return end
        local name=ebItem:GetText()
        if name=="" then print(R.."[GuildMarkt]"..X.." Bitte Item eingeben."); return end
        local pg=ebGold:GetText();  local ps=ebSilber:GetText(); local pk=ebKupfer:GetText()
        local pfree=postFree and "1" or "0"
        PostListing(postType,name,tonumber(ebAmt:GetText()) or 0,ebNote:GetText(),
                    ebItem.itemLink, pg,ps,pk,pfree,postPriceType)
        ebItem:SetText(""); ebItem.itemLink=nil
        ebGold:SetText(""); ebSilber:SetText(""); ebKupfer:SetText(""); ebAmt:SetText(""); ebNote:SetText("")
        postFree=false; freeBtn:SetText("Free: Nein"); ebGold:Enable(); ebSilber:Enable(); ebKupfer:Enable()
        RefreshList(); print(T.."[GuildMarkt]"..X.." Gepostet: "..Clr(postType).." "..W..name..X)
    end)
    postBtn_ref=postBtn

    local clearBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    clearBtn:SetSize(170,26); clearBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",158,53)
    clearBtn:SetText("Meine Eintr. loeschen")
    clearBtn:SetScript("OnClick",function()
        local me2,n=UnitName("player"),0
        for id,e in pairs(GuildMarketDB.listings) do
            if e.contact==me2 then DeleteListing(id); n=n+1 end
        end
        RefreshList(); print(T.."[GuildMarkt]"..X.." "..n.." Eintraege geloescht.")
    end)

    -- Footer
    local ft=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    ft:SetPoint("BOTTOM",f.InsetBg,"BOTTOM",0,34)
    ft:SetText(Dg.."Eintraege laufen nach 7 Tagen ab  •  Status-Icon anklicken zum Fluestern"..X)
    local ft2=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    ft2:SetPoint("BOTTOM",f.InsetBg,"BOTTOM",0,20)
    ft2:SetText("|cff3a3a4aGuildMarket — "..guildName.."  •  by MichaModus|r")

    mainFrame=f
end

-- ============================================================
-- Shift+Klick Hook
-- ============================================================

local _origInsertLink=ChatEdit_InsertLink
function ChatEdit_InsertLink(text)
    if ebItem and ebItem:IsVisible() and ebItem:HasFocus() then
        local name=text and text:match("|h%[(.-)%]|h")
        if name then ebItem:SetText(name); ebItem.itemLink=text; return true end
    end
    return _origInsertLink and _origInsertLink(text)
end

-- ============================================================
-- Timer
-- ============================================================

local function DelayCall(sec,fn)
    local fr,t=CreateFrame("Frame"),0
    fr:SetScript("OnUpdate",function(self,dt) t=t+dt; if t>=sec then self:SetScript("OnUpdate",nil); fn() end end)
end

-- ============================================================
-- Events
-- ============================================================

local ev=CreateFrame("Frame","GuildMarketEventFrame",UIParent)
ev:RegisterEvent("PLAYER_LOGIN"); ev:RegisterEvent("CHAT_MSG_ADDON"); ev:RegisterEvent("GUILD_ROSTER_UPDATE")

ev:SetScript("OnEvent",function(self,event,...)
    if event=="PLAYER_LOGIN" then
        InitDB(); PruneExpired()
        if GuildRoster then GuildRoster() end
        DelayCall(6,function() BroadcastMine(); RequestSync() end)
        print(T.."[GuildMarkt]"..X.." Geladen — "..G.."/gmarkt"..X.." | "..Dg..(GetGuildInfo("player") or "")..X)

    elseif event=="GUILD_ROSTER_UPDATE" then
        UpdateRoster()
        if mainFrame and mainFrame:IsShown() then RefreshList() end

    elseif event=="CHAT_MSG_ADDON" then
        local prefix,msg,_,sender=...
        if prefix~=MSG_PREFIX then return end
        if msg=="REQ" then BroadcastMine(); return end
        if msg:sub(1,3)=="CFG" then
            local parts={}; for p in (msg.."|"):gmatch("([^|]*)|") do parts[#parts+1]=p end
            if parts[2] and parts[3] then
                GuildMarketDB.config.postRank=tonumber(parts[2]) or 9
                GuildMarketDB.config.deleteRank=tonumber(parts[3]) or 1
                print(T.."[GuildMarkt]"..X.." Einstellungen vom GM aktualisiert.")
                if mainFrame and mainFrame:IsShown() then RefreshList() end
            end; return
        end
        if msg:sub(1,3)=="DEL" then
            local id=msg:sub(5)
            if id and GuildMarketDB.listings[id] then
                local sName=sender:match("^([^%-]+)") or sender
                if GuildMarketDB.listings[id].contact==sName then
                    GuildMarketDB.listings[id]=nil
                    if mainFrame and mainFrame:IsShown() then RefreshList() end
                end
            end; return
        end
        local action,id,entry=Deserialize(msg)
        if action=="POST" and id and entry then
            entry.contact=sender:match("^([^%-]+)") or sender
            if entry.expires>time() then
                GuildMarketDB.listings[id]=entry
                if mainFrame and mainFrame:IsShown() then RefreshList() end
            end
        end
    end
end)

-- ============================================================
-- Toggle & Slash
-- ============================================================

local function Toggle()
    if not mainFrame then BuildUI() end
    if mainFrame:IsShown() then mainFrame:Hide()
    else
        mainFrame:ClearAllPoints(); mainFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
        if GuildRoster then GuildRoster() end
        PruneExpired(); RefreshList(); mainFrame:Show()
    end
end

SLASH_GUILDMARKET1="/gmarkt"; SLASH_GUILDMARKET2="/gildenmarkt"
SlashCmdList["GUILDMARKET"]=function(msg)
    if msg=="sync" then RequestSync(); print(T.."[GuildMarkt]"..X.." Sync angefordert.")
    elseif msg=="config" then if not mainFrame then BuildUI() end; BuildConfigFrame()
    else Toggle() end
end
