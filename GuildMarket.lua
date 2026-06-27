-- GuildMarket v0.6.0
-- Gildeninterner Marktplatz — Rang-Berechtigungen, Config-Panel
-- Erstellt von MichaModus

local MSG_PREFIX  = "GUILDMKT"
local EXPIRE_SECS = 7 * 24 * 3600
local MIN_W, MIN_H = 470, 580

local COL = {
    type    = { x=6,   w=50  },
    item    = { x=60,  w=118 },
    price   = { x=182, w=84  },
    contact = { x=270, w=80  },
    online  = { x=354, w=22  },
    expiry  = { x=380, w=30  },
}
local ROW_H = 22
local ROW_W = 414

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

local function FormatPrice(amt, cur, ptype)
    if cur=="free" then return "|cff00ff88Kostenlos"..X end
    local cCol = cur=="g" and Cg or cur=="s" and Cs or Ck
    local cLbl = cur=="g" and "g" or cur=="s" and "s" or "k"
    local ptLbl = ptype=="FP" and (Dg.." FP"..X) or (Dg.." VHB"..X)
    return cCol..(amt or "?")..cLbl..X..ptLbl
end

-- ============================================================
-- Rang-System
-- ============================================================

local playerRankIndex = 99  -- wird nach Login befuellt
local playerRankName  = ""

local function GetRankNames()
    local names = {}
    local num = GuildControlGetNumRanks and GuildControlGetNumRanks() or 0
    for i = 0, num-1 do
        local n = GuildControlGetRankName and GuildControlGetRankName(i) or ("Rang "..i)
        names[i] = (n ~= "" and n) or ("Rang "..i)
    end
    return names, num
end

local function UpdatePlayerRank()
    local me    = UnitName("player")
    local total = GetNumGuildMembers and GetNumGuildMembers() or 0
    for i = 1, total do
        local name, _, rankIdx = GetGuildRosterInfo(i)
        if name then
            local short = name:match("^([^%-]+)") or name
            if short == me then
                playerRankIndex = rankIdx or 99
                local rankNames = GetRankNames()
                playerRankName  = rankNames[rankIdx] or ""
                return
            end
        end
    end
end

local function CanPost()
    if not GuildMarketDB or not GuildMarketDB.config then return true end
    return playerRankIndex <= (GuildMarketDB.config.postRank or 9)
end

local function CanDeleteOthers()
    if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex <= 1 end
    return playerRankIndex <= (GuildMarketDB.config.deleteRank or 1)
end

local function CanDeleteEntry(e)
    return (e.contact == UnitName("player")) or CanDeleteOthers()
end

local function IsGM() return playerRankIndex == 0 end

-- ============================================================
-- Online-Roster
-- ============================================================

local onlineRoster = {}

local function UpdateRoster()
    onlineRoster = {}
    local total = GetNumGuildMembers and GetNumGuildMembers() or 0
    for i = 1, total do
        local info = { GetGuildRosterInfo(i) }
        local name, online = info[1], info[9]
        if name and online then
            onlineRoster[name:match("^([^%-]+)") or name] = true
        end
    end
    UpdatePlayerRank()
end

local function IsOnline(name) return onlineRoster[name] == true end

local function OpenWhisper(name)
    if ChatFrame_SendTell then
        ChatFrame_SendTell(name, DEFAULT_CHAT_FRAME)
    else
        ChatFrame_OpenChat("/w "..name.." ", DEFAULT_CHAT_FRAME)
    end
end

-- ============================================================
-- Datenbank / Config
-- ============================================================

local function InitDB()
    if not GuildMarketDB          then GuildMarketDB = {} end
    if not GuildMarketDB.listings then GuildMarketDB.listings = {} end
    if not GuildMarketDB.config   then
        GuildMarketDB.config = { postRank=9, deleteRank=1 }
    end
end

local function PruneExpired()
    local now = time()
    for id, e in pairs(GuildMarketDB.listings) do
        if e.expires < now then GuildMarketDB.listings[id] = nil end
    end
end

-- ============================================================
-- Netzwerk
-- ============================================================

local function SendGuild(msg)
    if IsInGuild() then _Send(MSG_PREFIX, msg, "GUILD") end
end

local function Serialize(action, id, e)
    local item = (e.item or ""):gsub("|",""):sub(1,40)
    local note = (e.note or ""):gsub("|",""):sub(1,50)
    return action.."|"..id.."|"..e.type.."|"..item.."|"
        ..tostring(e.amount or 0).."|"..note.."|"..tostring(e.expires)
        .."|"..tostring(e.itemId or "")
        .."|"..tostring(e.priceAmt or "")
        .."|"..tostring(e.priceCur or "g")
        .."|"..tostring(e.priceType or "VHB")
end

local function Deserialize(msg)
    local t = {}
    for p in (msg.."|"):gmatch("([^|]*)|") do t[#t+1] = p end
    if #t < 7 then return nil, nil, nil end
    local itemId = tonumber(t[8])
    return t[1], t[2], {
        type=t[3], item=t[4], amount=tonumber(t[5]) or 0,
        note=t[6], expires=tonumber(t[7]) or 0,
        itemId=itemId, link=itemId and select(2,GetItemInfo(itemId)) or nil,
        priceAmt=t[9]~="" and t[9] or nil,
        priceCur=t[10]~="" and t[10] or "g",
        priceType=t[11]~="" and t[11] or "VHB",
    }
end

local function Broadcast(id, e)   SendGuild(Serialize("POST", id, e)) end
local function DeleteListing(id)  GuildMarketDB.listings[id]=nil; SendGuild("DEL|"..id) end
local function RequestSync()      SendGuild("REQ") end

local function BroadcastConfig()
    local c = GuildMarketDB.config
    SendGuild("CFG|"..tostring(c.postRank).."|"..tostring(c.deleteRank))
end

local function BroadcastMine()
    local me = UnitName("player")
    for id, e in pairs(GuildMarketDB.listings) do
        if e.contact==me then Broadcast(id, e) end
    end
end

local function PostListing(etype, item, amount, note, link, priceAmt, priceCur, priceType)
    local me=UnitName("player"); local now=time(); local id=me.."-"..now
    local itemId = link and tonumber(link:match("|Hitem:(%d+)"))
    local e = { type=etype, item=item, amount=amount, note=note,
                contact=me, expires=now+EXPIRE_SECS, link=link, itemId=itemId,
                priceAmt=priceAmt, priceCur=priceCur, priceType=priceType }
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
    return tonumber(hex:sub(3,4),16)/255, tonumber(hex:sub(5,6),16)/255, tonumber(hex:sub(7,8),16)/255
end

local function GetFilteredListings(filter)
    local out,now={},time()
    for id,e in pairs(GuildMarketDB.listings) do
        if e.expires>now and (filter=="ALL" or e.type==filter) then
            out[#out+1]={id=id,e=e}
        end
    end
    table.sort(out, function(a,b)
        local ao=IsOnline(a.e.contact) and 1 or 0; local bo=IsOnline(b.e.contact) and 1 or 0
        if ao~=bo then return ao>bo end
        return a.e.expires>b.e.expires
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
local postBtn_ref  -- Referenz fuer Disable/Enable
local currentFilter="ALL"; local postType="BIETE"
local postPriceCur="g";    local postPriceType="VHB"
rows={}

-- ============================================================
-- Config-Frame
-- ============================================================

local function BuildConfigFrame()
    if configFrame then configFrame:Show(); return end

    local f = CreateFrame("Frame","GuildMarketConfigFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(360, 220)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetMovable(true); f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG")
    f:SetFrameLevel(20)
    f:Hide()

    f.TitleBg:SetHeight(26)
    local title = f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    title:SetPoint("CENTER", f.TitleBg,"CENTER", 0, 1)
    title:SetText(G.."GuildMarket "..X..Dg.."Einstellungen"..X)

    -- Hinweis nur fuer GM
    local hint = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hint:SetPoint("TOPLEFT", f.InsetBg,"TOPLEFT", 8, -8)
    hint:SetText(Dg.."Nur der Gildenmeister kann Einstellungen aendern und synchronisieren."..X)
    hint:SetWidth(330)

    -- Rang-Auswahl Hilfsfunktion
    local function RankDropdown(name, x, y, getVal, setVal, labelTxt)
        local lbl = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
        lbl:SetPoint("TOPLEFT", f.InsetBg,"TOPLEFT", x, y)
        lbl:SetText(labelTxt)

        local dd = CreateFrame("Frame", "GuildMarketDD_"..name, f, "UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT", f.InsetBg,"TOPLEFT", x-14, y-18)
        UIDropDownMenu_SetWidth(dd, 200)

        local function Refresh()
            local rankNames, num = GetRankNames()
            UIDropDownMenu_Initialize(dd, function(_, level)
                for i = 0, num-1 do
                    local info = UIDropDownMenu_CreateInfo()
                    local rn   = rankNames[i] or ("Rang "..i)
                    info.text    = "|cffffd100["..i.."]|r  "..rn
                    info.value   = i
                    info.checked = (getVal()==i)
                    info.func    = function(btn)
                        setVal(btn.value)
                        UIDropDownMenu_SetSelectedValue(dd, btn.value)
                        local selName = rankNames[btn.value] or ("Rang "..btn.value)
                        UIDropDownMenu_SetText(dd, "|cffffd100["..btn.value.."]|r "..selName)
                    end
                    UIDropDownMenu_AddButton(info, level)
                end
            end)
            local cur     = getVal()
            local curName = rankNames[cur] or ("Rang "..cur)
            UIDropDownMenu_SetSelectedValue(dd, cur)
            UIDropDownMenu_SetText(dd, "|cffffd100["..cur.."]|r "..curName)
        end

        dd.Refresh = Refresh
        return dd
    end

    local ddPost = RankDropdown("Post", 8, -34,
        function() return GuildMarketDB.config.postRank end,
        function(v) GuildMarketDB.config.postRank=v end,
        G.."Posten erlaubt ab Rang (und hoeher):"..X)

    local ddDel = RankDropdown("Del", 8, -96,
        function() return GuildMarketDB.config.deleteRank end,
        function(v) GuildMarketDB.config.deleteRank=v end,
        G.."Fremde Eintraege loeschen ab Rang:"..X)

    -- Erklaerung
    local info2 = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    info2:SetPoint("TOPLEFT", f.InsetBg,"TOPLEFT", 8, -158)
    info2:SetText(Dg.."Rang 0 = Gildenmeister  •  niedrigere Zahl = hoehere Position"..X)

    -- Speichern & Sync
    local saveBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    saveBtn:SetSize(160, 26)
    saveBtn:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT", 8, 12)
    saveBtn:SetText("Speichern & Sync")
    saveBtn:SetScript("OnClick", function()
        if not IsGM() then
            print(R.."[GuildMarkt]"..X.." Nur der Gildenmeister kann Einstellungen aendern.")
            return
        end
        BroadcastConfig()
        print(T.."[GuildMarkt]"..X.." Einstellungen gespeichert und an Gilde gesendet.")
        f:Hide()
    end)

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    closeBtn:SetSize(80, 26)
    closeBtn:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT", 176, 12)
    closeBtn:SetText("Schliessen")
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    f.ddPost = ddPost; f.ddDel = ddDel

    f:SetScript("OnShow", function()
        if not IsGM() then
            saveBtn:Disable()
            hint:SetText(R.."Nur der Gildenmeister kann Einstellungen aendern."..X)
        else
            saveBtn:Enable()
            hint:SetText(Dg.."Einstellungen werden per Sync an alle Gildenmitglieder verteilt."..X)
        end
        ddPost:Refresh(); ddDel:Refresh()
    end)

    configFrame = f
    f:Show()
end

-- ============================================================
-- Zeilen-Rendering
-- ============================================================

local function RefreshPostButton()
    if not postBtn_ref then return end
    if CanPost() then
        postBtn_ref:Enable()
        postBtn_ref:SetText("Eintrag posten")
    else
        postBtn_ref:Disable()
        local rankNames = GetRankNames()
        local needed = rankNames[GuildMarketDB.config.postRank or 9] or "?"
        postBtn_ref:SetText("Kein Zugriff")
        postBtn_ref:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:ClearLines()
            GameTooltip:AddLine(R.."Kein Zugriff"..X)
            GameTooltip:AddLine(Dg.."Benoetigter Rang: "..X..G..needed..X)
            GameTooltip:Show()
        end)
        postBtn_ref:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
end

local function RefreshList()
    if not listContent then return end
    for _, r in ipairs(rows) do r:Hide() end

    local listings=GetFilteredListings(currentFilter)
    local me=UnitName("player"); local y=0

    if countText then
        local total,su,bi=0,0,0; local now=time()
        for _,e in pairs(GuildMarketDB.listings) do
            if e.expires>now then total=total+1
                if e.type=="SUCHE" then su=su+1 else bi=bi+1 end
            end
        end
        countText:SetText(Dg..total.." Eintr.  "..Gr..bi.." Biete"..X.."  "..Y..su.." Suche"..X)
    end

    for i, item in ipairs(listings) do
        local e, id = item.e, item.id
        local online = IsOnline(e.contact)

        if not rows[i] then
            local row = CreateFrame("Button", nil, listContent)
            row:SetSize(ROW_W, ROW_H)
            local bg=row:CreateTexture(nil,"BACKGROUND"); bg:SetAllPoints(); row.bg=bg
            local hl=row:CreateTexture(nil,"HIGHLIGHT"); hl:SetAllPoints()
            hl:SetColorTexture(0.8,0.8,1,0.08); row:SetHighlightTexture(hl)
            local border=CreateFrame("Frame",nil,row,"BackdropTemplate"); border:SetAllPoints()
            border:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=10})
            border:SetBackdropBorderColor(0.4,0.8,1,0)
            border:SetFrameLevel(row:GetFrameLevel()+1); row.border=border

            local function FS(x,w,align,font)
                local fs=row:CreateFontString(nil,"OVERLAY",font or "GameFontNormalSmall")
                fs:SetPoint("LEFT",row,"LEFT",x,0); fs:SetSize(w,ROW_H)
                fs:SetJustifyH(align or "LEFT"); return fs
            end
            row.fType=FS(COL.type.x,COL.type.w)
            row.fItem=FS(COL.item.x,COL.item.w,"LEFT","GameFontNormal")
            row.fPrice=FS(COL.price.x,COL.price.w)
            row.fContact=FS(COL.contact.x,COL.contact.w)
            row.fExp=FS(COL.expiry.x,COL.expiry.w,"RIGHT")

            local onlineBtn=CreateFrame("Button",nil,row); onlineBtn:SetSize(20,ROW_H)
            onlineBtn:SetPoint("LEFT",row,"LEFT",COL.online.x,0)
            local dotTex=onlineBtn:CreateTexture(nil,"OVERLAY"); dotTex:SetSize(14,14)
            dotTex:SetPoint("CENTER",onlineBtn,"CENTER",0,0)
            dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Online")
            row.onlineBtn=onlineBtn; row.dotTex=dotTex

            local del=CreateFrame("Button",nil,row,"UIPanelButtonTemplate")
            del:SetSize(24,18); del:SetPoint("RIGHT",row,"RIGHT",-2,0)
            del:SetText("X"); del:Hide(); row.del=del

            rows[i]=row
        end

        local row=rows[i]

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

        if e.priceCur=="free" then row.fPrice:SetText("|cff00ff88Kostenlos"..X)
        elseif e.priceAmt and e.priceAmt~="" then row.fPrice:SetText(FormatPrice(e.priceAmt,e.priceCur,e.priceType))
        else row.fPrice:SetText(Dg.."k.A."..X) end

        row.fContact:SetText(T..(e.contact or "")..X)
        row.fExp:SetText(FormatExpiry(e.expires))

        if online then
            row.dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Online")
            row.dotTex:SetVertexColor(1,1,1,1)
            row.onlineBtn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                GameTooltip:AddLine("|cff00ff44"..e.contact.." ist online|r")
                GameTooltip:AddLine(Dg.."Klicken zum Fluestern"..X); GameTooltip:Show()
            end)
            row.onlineBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick",  function() OpenWhisper(e.contact) end)
        else
            row.dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Offline")
            row.dotTex:SetVertexColor(1,1,1,0.45)
            row.onlineBtn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                GameTooltip:AddLine(Dg..e.contact.." ist offline"..X); GameTooltip:Show()
            end)
            row.onlineBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick",  nil)
        end

        row:SetScript("OnEnter", function(self)
            self.border:SetBackdropBorderColor(0.4,0.8,1,0.8)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
            local ttLink=e.link or (e.itemId and select(2,GetItemInfo(e.itemId)))
            if ttLink then pcall(GameTooltip.SetHyperlink,GameTooltip,ttLink)
            else GameTooltip:AddLine(e.item or "",1,1,0) end
            GameTooltip:AddLine(" ")
            if e.priceCur=="free" then GameTooltip:AddLine("|cff00ff88Kostenlos|r")
            elseif e.priceAmt and e.priceAmt~="" then
                local ptLbl=e.priceType=="FP" and "Festpreis" or "Verhandlungsbasis"
                local cLbl=e.priceCur=="g" and (Cg..e.priceAmt.." Gold"..X)
                         or e.priceCur=="s" and (Cs..e.priceAmt.." Silber"..X)
                         or (Ck..e.priceAmt.." Kupfer"..X)
                GameTooltip:AddLine(cLbl.."  "..Dg.."("..ptLbl..")"..X)
            end
            if (e.amount or 0)>0 then GameTooltip:AddLine(Dg.."Menge: "..X..G..e.amount..X) end
            if (e.note or "")~="" then GameTooltip:AddLine(" "); GameTooltip:AddLine('"'..e.note..'"',1,1,1,true) end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(Dg.."Kontakt: "..X..T..(e.contact or "")..X)
            GameTooltip:AddLine(Dg.."Laeuft ab: "..X..FormatExpiry(e.expires))
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave", function(self)
            self.border:SetBackdropBorderColor(0.4,0.8,1,0); GameTooltip:Hide()
        end)

        -- Loeschen nur wenn berechtigt
        if CanDeleteEntry(e) then
            row.del:Show()
            row.del:SetScript("OnClick", function() DeleteListing(id); RefreshList() end)
            if e.contact~=me then
                -- GM/Offizier loescht fremden Eintrag -> Hinweis
                row.del:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                    GameTooltip:AddLine(R.."Eintrag loeschen"..X)
                    GameTooltip:AddLine(Dg.."Erstellt von: "..X..T..(e.contact or "")..X); GameTooltip:Show()
                end)
                row.del:SetScript("OnLeave", function() GameTooltip:Hide() end)
            else
                row.del:SetScript("OnEnter", nil)
                row.del:SetScript("OnLeave", nil)
            end
        else
            row.del:Hide()
        end

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
    sub:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-5)
    sub:SetText(Dg.."by MichaModus  •  /gmarkt"..X)

    -- Config-Button (Zahnrad-Icon)
    local cfgBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    cfgBtn:SetSize(26,20); cfgBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-4)
    cfgBtn:SetText("cfg")
    cfgBtn:SetScript("OnClick", BuildConfigFrame)
    cfgBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self,"ANCHOR_BOTTOM"); GameTooltip:ClearLines()
        GameTooltip:AddLine(G.."Einstellungen"..X)
        GameTooltip:AddLine(Dg.."Rang-Berechtigungen konfigurieren"..X); GameTooltip:Show()
    end)
    cfgBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- Resize-Griff
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

    -- Header
    local hBg=f:CreateTexture(nil,"BACKGROUND")
    hBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-48)
    hBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-48)
    hBg:SetHeight(18); hBg:SetColorTexture(0.10,0.10,0.22,1)
    local hLine=f:CreateTexture(nil,"BACKGROUND")
    hLine:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-65)
    hLine:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-65)
    hLine:SetHeight(1); hLine:SetColorTexture(0.3,0.5,0.8,0.5)

    local function Hdr(txt,col,align)
        local fs=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",col.x+4,-49)
        fs:SetSize(col.w,16); fs:SetJustifyH(align or "LEFT"); fs:SetText(G..txt..X)
    end
    Hdr("Typ",COL.type); Hdr("Item",COL.item); Hdr("Preis",COL.price)
    Hdr("Kontakt",COL.contact); Hdr("Online",COL.online,"CENTER"); Hdr("Rest",COL.expiry,"RIGHT")

    local sf=CreateFrame("ScrollFrame","GuildMarketScroll",f,"UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-66)
    sf:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-22,210)
    local content=CreateFrame("Frame",nil,sf)
    content:SetWidth(ROW_W); content:SetHeight(20); sf:SetScrollChild(content)
    listContent=content

    local div=f:CreateTexture(nil,"BACKGROUND")
    div:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,208)
    div:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,208)
    div:SetHeight(1); div:SetColorTexture(0.3,0.5,0.8,0.6)

    local fBg=f:CreateTexture(nil,"BACKGROUND")
    fBg:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,46)
    fBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,46)
    fBg:SetHeight(162); fBg:SetColorTexture(0.06,0.06,0.14,0.85)

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

    local lbItem=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbItem:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",104,189)
    lbItem:SetText(Dg.."Item  (Drag aus Bag oder Shift+Klick):"..X)

    ebItem=CreateFrame("EditBox","GuildMarketItemBox",f,"InputBoxTemplate")
    ebItem:SetSize(220,22); ebItem:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",104,167)
    ebItem:SetAutoFocus(false); ebItem:SetMaxLetters(40); ebItem.itemLink=nil
    ebItem:SetScript("OnReceiveDrag",function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebItem:SetScript("OnMouseDown",function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebItem:SetScript("OnTextChanged",function(self) if self.itemLink then local n=self.itemLink:match("|h%[(.-)%]|h"); if n~=self:GetText() then self.itemLink=nil end end end)

    local lbPrice=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbPrice:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,149); lbPrice:SetText(Dg.."Preisvorstellung:"..X)

    local ebPrice=CreateFrame("EditBox","GuildMarketPriceBox",f,"InputBoxTemplate")
    ebPrice:SetSize(70,22); ebPrice:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",118,127)
    ebPrice:SetAutoFocus(false); ebPrice:SetMaxLetters(8)

    local ddCur=CreateFrame("Frame","GuildMarketDDCur",f,"UIDropDownMenuTemplate")
    ddCur:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",174,128); UIDropDownMenu_SetWidth(ddCur,82)
    UIDropDownMenu_Initialize(ddCur,function(_,level)
        local choices={{label=Cg.."Gold"..X,value="g"},{label=Cs.."Silber"..X,value="s"},{label=Ck.."Kupfer"..X,value="k"},{label="|cff00ff88Free"..X,value="free"}}
        for _,c in ipairs(choices) do
            local info=UIDropDownMenu_CreateInfo(); info.text=c.label; info.value=c.value; info.checked=(postPriceCur==c.value)
            info.func=function(btn) postPriceCur=btn.value; UIDropDownMenu_SetSelectedValue(ddCur,btn.value); UIDropDownMenu_SetText(ddCur,btn.text); if btn.value=="free" then ebPrice:Hide() else ebPrice:Show() end end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddCur,"g"); UIDropDownMenu_SetText(ddCur,Cg.."Gold"..X)

    local ddPType=CreateFrame("Frame","GuildMarketDDPType",f,"UIDropDownMenuTemplate")
    ddPType:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",286,128); UIDropDownMenu_SetWidth(ddPType,108)
    UIDropDownMenu_Initialize(ddPType,function(_,level)
        for _,t in ipairs({"Festpreis","VHB"}) do
            local val=t=="Festpreis" and "FP" or "VHB"
            local info=UIDropDownMenu_CreateInfo(); info.text=t; info.value=val; info.checked=(postPriceType==val)
            info.func=function(btn) postPriceType=btn.value; UIDropDownMenu_SetSelectedValue(ddPType,btn.value); UIDropDownMenu_SetText(ddPType,btn.text) end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddPType,"VHB"); UIDropDownMenu_SetText(ddPType,"VHB")

    local lbAmt2=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbAmt2:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,131); lbAmt2:SetText(Dg.."Betrag:"..X)

    local lbMenge=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbMenge:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",334,149); lbMenge:SetText(Dg.."Menge:"..X)

    local ebAmt=CreateFrame("EditBox","GuildMarketAmtBox",f,"InputBoxTemplate")
    ebAmt:SetSize(70,22); ebAmt:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",334,127)
    ebAmt:SetAutoFocus(false); ebAmt:SetMaxLetters(6); ebAmt:SetNumeric(true)

    local lbNote=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbNote:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,108); lbNote:SetText(Dg.."Notiz (optional):"..X)

    local ebNote=CreateFrame("EditBox","GuildMarketNoteBox",f,"InputBoxTemplate")
    ebNote:SetSize(430,22); ebNote:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,86)
    ebNote:SetAutoFocus(false); ebNote:SetMaxLetters(55)

    local postBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    postBtn:SetSize(140,26); postBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,58)
    postBtn:SetText("Eintrag posten")
    postBtn:SetScript("OnClick",function()
        if not CanPost() then print(R.."[GuildMarkt]"..X.." Kein Zugriff — Rang zu niedrig."); return end
        local name=ebItem:GetText()
        if name=="" then print(R.."[GuildMarkt]"..X.." Bitte Item eingeben."); return end
        local pa=postPriceCur=="free" and nil or (ebPrice:GetText()~="" and ebPrice:GetText() or nil)
        PostListing(postType,name,tonumber(ebAmt:GetText()) or 0,ebNote:GetText(),ebItem.itemLink,pa,postPriceCur,postPriceType)
        ebItem:SetText(""); ebItem.itemLink=nil; ebPrice:SetText(""); ebAmt:SetText(""); ebNote:SetText("")
        RefreshList(); print(T.."[GuildMarkt]"..X.." Gepostet: "..Clr(postType).." "..W..name..X)
    end)
    postBtn_ref=postBtn

    local clearBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    clearBtn:SetSize(170,26); clearBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",158,58)
    clearBtn:SetText("Meine Eintr. loeschen")
    clearBtn:SetScript("OnClick",function()
        local me2,n=UnitName("player"),0
        for id,e in pairs(GuildMarketDB.listings) do
            if CanDeleteEntry(e) and e.contact==me2 then DeleteListing(id); n=n+1 end
        end
        RefreshList(); print(T.."[GuildMarkt]"..X.." "..n.." Eintraege geloescht.")
    end)

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
            -- Config-Sync vom GM empfangen
            local parts={}
            for p in (msg.."|"):gmatch("([^|]*)|") do parts[#parts+1]=p end
            if parts[2] and parts[3] then
                GuildMarketDB.config.postRank   = tonumber(parts[2]) or 9
                GuildMarketDB.config.deleteRank = tonumber(parts[3]) or 1
                print(T.."[GuildMarkt]"..X.." Einstellungen vom GM aktualisiert.")
                if mainFrame and mainFrame:IsShown() then RefreshList() end
            end
            return
        end
        if msg:sub(1,3)=="DEL" then
            local id=msg:sub(5)
            if id and GuildMarketDB.listings[id] then
                local sName=sender:match("^([^%-]+)") or sender
                -- nur Ersteller oder Spieler mit delete-Berechtigung
                local entry=GuildMarketDB.listings[id]
                if entry.contact==sName then
                    GuildMarketDB.listings[id]=nil
                    if mainFrame and mainFrame:IsShown() then RefreshList() end
                end
            end
            return
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
-- Toggle
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

-- ============================================================
-- Slash
-- ============================================================

SLASH_GUILDMARKET1="/gmarkt"; SLASH_GUILDMARKET2="/gildenmarkt"
SlashCmdList["GUILDMARKET"]=function(msg)
    if msg=="sync" then RequestSync(); print(T.."[GuildMarkt]"..X.." Sync angefordert.")
    elseif msg=="config" then if not mainFrame then BuildUI() end; BuildConfigFrame()
    else Toggle() end
end
