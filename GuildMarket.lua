-- GuildMarket v0.4.0
-- Gildeninterner Marktplatz — dynamischer Gildenname, Online-Status, Resize
-- Erstellt von MichaModus

local MSG_PREFIX  = "GUILDMKT"
local EXPIRE_SECS = 7 * 24 * 3600
local MIN_W, MIN_H = 470, 560

-- Spalten-Layout
local COL = {
    type    = { x=6,   w=52  },
    item    = { x=62,  w=130 },
    amount  = { x=196, w=44  },
    contact = { x=244, w=88  },
    online  = { x=336, w=22  },
    expiry  = { x=362, w=38  },
}
local ROW_H = 22
local ROW_W = 410

-- Prefix registrieren
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
local X  = "|r"

local function Clr(t) return t=="BIETE" and (Gr..t..X) or (Y..t..X) end

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
            local short = name:match("^([^%-]+)") or name
            onlineRoster[short] = true
        end
    end
end

local function IsOnline(name)
    return onlineRoster[name] == true
end

local function OpenWhisper(name)
    if ChatFrame_SendTell then
        ChatFrame_SendTell(name, DEFAULT_CHAT_FRAME)
    else
        -- Fallback: Chat-Box mit /w vorbefuellen
        local eb = DEFAULT_CHAT_FRAME.editBox
        if eb then
            eb:Show(); eb:SetFocus()
            ChatFrame_OpenChat("/w "..name.." ", DEFAULT_CHAT_FRAME)
        end
    end
end

-- ============================================================
-- Datenbank
-- ============================================================

local function InitDB()
    if not GuildMarketDB          then GuildMarketDB = {} end
    if not GuildMarketDB.listings then GuildMarketDB.listings = {} end
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
end

local function Deserialize(msg)
    local t = {}
    for p in (msg.."|"):gmatch("([^|]*)|") do t[#t+1] = p end
    if #t < 7 then return nil, nil, nil end
    local itemId = tonumber(t[8])
    local link   = itemId and select(2, GetItemInfo(itemId)) or nil
    return t[1], t[2], {
        type    = t[3],
        item    = t[4],
        amount  = tonumber(t[5]) or 0,
        note    = t[6],
        expires = tonumber(t[7]) or 0,
        itemId  = itemId,
        link    = link,
    }
end

local function Broadcast(id, e)    SendGuild(Serialize("POST", id, e)) end
local function DeleteListing(id)   GuildMarketDB.listings[id] = nil; SendGuild("DEL|"..id) end
local function RequestSync()       SendGuild("REQ") end

local function BroadcastMine()
    local me = UnitName("player")
    for id, e in pairs(GuildMarketDB.listings) do
        if e.contact == me then Broadcast(id, e) end
    end
end

local function PostListing(etype, item, amount, note, link)
    local me     = UnitName("player")
    local now    = time()
    local id     = me.."-"..now
    local itemId = link and tonumber(link:match("|Hitem:(%d+)"))
    local e = { type=etype, item=item, amount=amount, note=note,
                contact=me, expires=now+EXPIRE_SECS, link=link, itemId=itemId }
    GuildMarketDB.listings[id] = e
    Broadcast(id, e)
    return id
end

-- ============================================================
-- Hilfsfunktionen
-- ============================================================

local function FormatExpiry(ts)
    local d = ts - time()
    if d <= 0 then return R.."abgel."..X end
    local days = math.floor(d / 86400)
    if days > 0 then return Dg..days.."T"..X end
    local hrs = math.floor(d / 3600)
    if hrs  > 0 then return Dg..hrs.."h"..X end
    return Dg.."<1h"..X
end

local function GetLinkColor(link)
    if not link then return 1,1,1 end
    local hex = link:match("|c(%x%x%x%x%x%x%x%x)")
    if not hex then return 1,1,1 end
    return tonumber(hex:sub(3,4),16)/255,
           tonumber(hex:sub(5,6),16)/255,
           tonumber(hex:sub(7,8),16)/255
end

local function GetFilteredListings(filter)
    local out, now = {}, time()
    for id, e in pairs(GuildMarketDB.listings) do
        if e.expires > now and (filter=="ALL" or e.type==filter) then
            out[#out+1] = {id=id, e=e}
        end
    end
    -- Online-Eintraege zuerst, dann nach Ablauf sortiert
    table.sort(out, function(a, b)
        local ao = IsOnline(a.e.contact) and 1 or 0
        local bo = IsOnline(b.e.contact) and 1 or 0
        if ao ~= bo then return ao > bo end
        return a.e.expires > b.e.expires
    end)
    return out
end

local function GetDraggedItem()
    local iType, itemId = GetCursorInfo()
    if iType == "item" and itemId then return GetItemInfo(itemId) end
end

-- ============================================================
-- UI Globals
-- ============================================================

local mainFrame, listContent, countText, rows, ebItem
local currentFilter = "ALL"
local postType      = "BIETE"
rows = {}

-- ============================================================
-- Zeilen-Rendering
-- ============================================================

local function RefreshList()
    if not listContent then return end
    for _, r in ipairs(rows) do r:Hide() end

    local listings = GetFilteredListings(currentFilter)
    local me       = UnitName("player")
    local y        = 0

    -- Zaehltext
    if countText then
        local total, su, bi = 0, 0, 0
        local now = time()
        for _, e in pairs(GuildMarketDB.listings) do
            if e.expires > now then
                total=total+1
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

            local bg = row:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(); row.bg = bg

            local hl = row:CreateTexture(nil, "HIGHLIGHT")
            hl:SetAllPoints(); hl:SetColorTexture(0.8,0.8,1,0.08)
            row:SetHighlightTexture(hl)

            local border = CreateFrame("Frame", nil, row, "BackdropTemplate")
            border:SetAllPoints()
            border:SetBackdrop({ edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize=10 })
            border:SetBackdropBorderColor(0.4,0.8,1,0)
            border:SetFrameLevel(row:GetFrameLevel()+1)
            row.border = border

            local function FS(x, w, align, font)
                local fs = row:CreateFontString(nil, "OVERLAY", font or "GameFontNormalSmall")
                fs:SetPoint("LEFT", row, "LEFT", x, 0)
                fs:SetSize(w, ROW_H); fs:SetJustifyH(align or "LEFT")
                return fs
            end
            row.fType    = FS(COL.type.x,    COL.type.w)
            row.fItem    = FS(COL.item.x,    COL.item.w,    "LEFT", "GameFontNormal")
            row.fAmt     = FS(COL.amount.x,  COL.amount.w,  "CENTER")
            row.fContact = FS(COL.contact.x, COL.contact.w)
            row.fExp     = FS(COL.expiry.x,  COL.expiry.w,  "RIGHT")

            -- Online-Indikator (klickbar)
            local onlineBtn = CreateFrame("Button", nil, row)
            onlineBtn:SetSize(20, ROW_H)
            onlineBtn:SetPoint("LEFT", row, "LEFT", COL.online.x, 0)
            local onlineText = onlineBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            onlineText:SetAllPoints()
            onlineText:SetJustifyH("CENTER")
            row.onlineBtn  = onlineBtn
            row.onlineText = onlineText

            -- Delete-Button
            local del = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            del:SetSize(24, 18)
            del:SetPoint("RIGHT", row, "RIGHT", -2, 0)
            del:SetText("X")
            del:Hide(); row.del = del

            rows[i] = row
        end

        local row = rows[i]

        -- Zebrastreifen + Online-Highlight
        if online then
            if i%2==0 then row.bg:SetColorTexture(0.06,0.14,0.08,0.85)
            else            row.bg:SetColorTexture(0.04,0.10,0.05,0.70) end
        else
            if i%2==0 then row.bg:SetColorTexture(0.10,0.10,0.20,0.80)
            else            row.bg:SetColorTexture(0.05,0.05,0.12,0.55) end
        end

        row.fType:SetText(Clr(e.type))

        -- Item in Qualitaetsfarbe
        local link = e.link
        if not link and e.itemId then
            link = select(2, GetItemInfo(e.itemId))
            if link then e.link = link end
        end
        if link then
            local r2,g2,b2 = GetLinkColor(link)
            row.fItem:SetText(string.format("|cff%02x%02x%02x%s|r", r2*255, g2*255, b2*255, e.item or ""))
        else
            row.fItem:SetText(W..(e.item or "")..X)
        end

        row.fAmt:SetText(e.amount > 0 and (G..e.amount..X) or "")
        row.fContact:SetText(T..(e.contact or "")..X)
        row.fExp:SetText(FormatExpiry(e.expires))

        -- Online-Punkt
        if online then
            row.onlineText:SetText("|cff00ff44●|r")
            row.onlineBtn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:ClearLines()
                GameTooltip:AddLine("|cff00ff44"..e.contact.." ist online|r")
                GameTooltip:AddLine(Dg.."Klicken zum Fluestern"..X)
                GameTooltip:Show()
            end)
            row.onlineBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick", function()
                OpenWhisper(e.contact)
            end)
        else
            row.onlineText:SetText(Dg.."○"..X)
            row.onlineBtn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:ClearLines()
                GameTooltip:AddLine(Dg..e.contact.." ist offline"..X)
                GameTooltip:Show()
            end)
            row.onlineBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick", nil)
        end

        -- Zeilen-Tooltip (Item)
        row:SetScript("OnEnter", function(self)
            self.border:SetBackdropBorderColor(0.4,0.8,1,0.8)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            local ttLink = e.link or (e.itemId and select(2, GetItemInfo(e.itemId)))
            if ttLink then
                pcall(GameTooltip.SetHyperlink, GameTooltip, ttLink)
            else
                GameTooltip:AddLine(e.item or "", 1,1,0)
            end
            if (e.note or "") ~= "" then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine('"'..e.note..'"', 1,1,1,true)
            end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(Dg.."Kontakt: "..X..T..(e.contact or "")..X)
            GameTooltip:AddLine(Dg.."Laeuft ab: "..X..FormatExpiry(e.expires))
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave", function(self)
            self.border:SetBackdropBorderColor(0.4,0.8,1,0)
            GameTooltip:Hide()
        end)

        if e.contact == me then
            row.del:Show()
            row.del:SetScript("OnClick", function() DeleteListing(id); RefreshList() end)
        else
            row.del:Hide()
        end

        row:SetPoint("TOPLEFT", listContent, "TOPLEFT", 0, -y)
        row:Show()
        y = y + ROW_H
    end

    listContent:SetHeight(math.max(y, 20))

    if not listContent.empty then
        listContent.empty = listContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        listContent.empty:SetPoint("CENTER", listContent, "TOP", 0, -70)
        listContent.empty:SetJustifyH("CENTER")
    end
    if #listings == 0 then
        listContent.empty:SetText(Dg.."Keine Eintraege.\nSync anfordern oder neuen Eintrag posten."..X)
        listContent.empty:Show()
    else
        listContent.empty:Hide()
    end
end

-- ============================================================
-- UI Aufbau
-- ============================================================

local function BuildUI()
    local guildName = GetGuildInfo("player") or "Gilde"

    local f = CreateFrame("Frame", "GuildMarketMainFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(MIN_W, MIN_H)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetMovable(true); f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG")
    f:SetResizable(true)
    f:SetScript("OnSizeChanged", function(self, w, h)
    if w < MIN_W then self:SetWidth(MIN_W) end
    if h < MIN_H then self:SetHeight(MIN_H) end
end)
    f:Hide()

    -- Titel
    f.TitleBg:SetHeight(30)
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("LEFT", f.TitleBg, "LEFT", 8, 0)
    title:SetText(G.."Gildenmarkt"..X.." — "..T..guildName..X)

    local sub = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sub:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", 8, -5)
    sub:SetText(Dg.."by MichaModus  •  /gmarkt"..X)

    -- Resize-Griff unten rechts
    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown", function(self, btn)
        if btn=="LeftButton" then f:StartSizing("BOTTOMRIGHT") end
    end)
    grip:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)

    -- Tabs
    local function Tab(label, filter, x)
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(80, 22)
        b:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", x, -22)
        b:SetText(label)
        b:SetScript("OnClick", function() currentFilter=filter; RefreshList() end)
    end
    Tab("Alle",  "ALL",   6)
    Tab("Suche", "SUCHE", 90)
    Tab("Biete", "BIETE", 174)

    countText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    countText:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", 264, -28)

    local syncBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    syncBtn:SetSize(100, 22)
    syncBtn:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -22)
    syncBtn:SetText("↻  Sync")
    syncBtn:SetScript("OnClick", function()
        if GuildRoster then GuildRoster() end
        RequestSync()
        print(T.."[GuildMarkt]"..X.." Sync angefordert...")
    end)

    -- Spalten-Header
    local hBg = f:CreateTexture(nil, "BACKGROUND")
    hBg:SetPoint("TOPLEFT",  f.InsetBg, "TOPLEFT",  4, -48)
    hBg:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -48)
    hBg:SetHeight(18); hBg:SetColorTexture(0.10, 0.10, 0.22, 1)

    local hLine = f:CreateTexture(nil, "BACKGROUND")
    hLine:SetPoint("TOPLEFT",  f.InsetBg, "TOPLEFT",  4, -65)
    hLine:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -65)
    hLine:SetHeight(1); hLine:SetColorTexture(0.3,0.5,0.8,0.5)

    local function Hdr(txt, col, align)
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", col.x+4, -49)
        fs:SetSize(col.w, 16); fs:SetJustifyH(align or "LEFT")
        fs:SetText(G..txt..X)
    end
    Hdr("Typ",     COL.type)
    Hdr("Item",    COL.item)
    Hdr("Menge",   COL.amount,  "CENTER")
    Hdr("Kontakt", COL.contact)
    Hdr("●",       COL.online,  "CENTER")
    Hdr("Rest",    COL.expiry,  "RIGHT")

    -- ScrollFrame
    local sf = CreateFrame("ScrollFrame", "GuildMarketScroll", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     f.InsetBg, "TOPLEFT",     4,  -66)
    sf:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -22, 178)

    local content = CreateFrame("Frame", nil, sf)
    content:SetWidth(ROW_W); content:SetHeight(20)
    sf:SetScrollChild(content)
    listContent = content

    -- Trennlinie
    local div = f:CreateTexture(nil, "BACKGROUND")
    div:SetPoint("BOTTOMLEFT",  f.InsetBg, "BOTTOMLEFT",  4, 176)
    div:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -4, 176)
    div:SetHeight(1); div:SetColorTexture(0.3,0.5,0.8,0.6)

    -- Formular-BG
    local fBg = f:CreateTexture(nil, "BACKGROUND")
    fBg:SetPoint("BOTTOMLEFT",  f.InsetBg, "BOTTOMLEFT",  4, 46)
    fBg:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -4, 46)
    fBg:SetHeight(130); fBg:SetColorTexture(0.06,0.06,0.14,0.8)

    local newLbl = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    newLbl:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 10, 158)
    newLbl:SetText(G.."Neuer Eintrag"..X)

    -- Typ Dropdown
    local ddType = CreateFrame("Frame", "GuildMarketDDType", f, "UIDropDownMenuTemplate")
    ddType:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", -14, 126)
    UIDropDownMenu_SetWidth(ddType, 80)
    UIDropDownMenu_Initialize(ddType, function(_, level)
        for _, t in ipairs({"BIETE","SUCHE"}) do
            local info = UIDropDownMenu_CreateInfo()
            info.text=t; info.value=t; info.checked=(postType==t)
            info.func = function(btn)
                postType = btn.value
                UIDropDownMenu_SetSelectedValue(ddType, btn.value)
                UIDropDownMenu_SetText(ddType, btn.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddType,"BIETE")
    UIDropDownMenu_SetText(ddType,"BIETE")

    -- Item
    local lbItem = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbItem:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 104, 155)
    lbItem:SetText(Dg.."Item  (Drag aus Bag oder Shift+Klick):"..X)

    ebItem = CreateFrame("EditBox", "GuildMarketItemBox", f, "InputBoxTemplate")
    ebItem:SetSize(160, 22)
    ebItem:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 104, 133)
    ebItem:SetAutoFocus(false); ebItem:SetMaxLetters(40)
    ebItem.itemLink = nil

    ebItem:SetScript("OnReceiveDrag", function(self)
        local name, link = GetDraggedItem()
        if name then self:SetText(name); self.itemLink=link; ClearCursor() end
    end)
    ebItem:SetScript("OnMouseDown", function(self)
        local name, link = GetDraggedItem()
        if name then self:SetText(name); self.itemLink=link; ClearCursor() end
    end)
    ebItem:SetScript("OnTextChanged", function(self)
        if self.itemLink then
            local n = self.itemLink:match("|h%[(.-)%]|h")
            if n ~= self:GetText() then self.itemLink = nil end
        end
    end)

    -- Menge
    local lbAmt = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 276, 155)
    lbAmt:SetText(Dg.."Menge:"..X)

    local ebAmt = CreateFrame("EditBox", "GuildMarketAmtBox", f, "InputBoxTemplate")
    ebAmt:SetSize(80, 22)
    ebAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 276, 133)
    ebAmt:SetAutoFocus(false); ebAmt:SetMaxLetters(6); ebAmt:SetNumeric(true)

    -- Notiz
    local lbNote = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbNote:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 10, 112)
    lbNote:SetText(Dg.."Notiz (optional):"..X)

    local ebNote = CreateFrame("EditBox", "GuildMarketNoteBox", f, "InputBoxTemplate")
    ebNote:SetSize(350, 22)
    ebNote:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 10, 90)
    ebNote:SetAutoFocus(false); ebNote:SetMaxLetters(55)

    -- Buttons
    local postBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    postBtn:SetSize(140, 26)
    postBtn:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 10, 58)
    postBtn:SetText("Eintrag posten")
    postBtn:SetScript("OnClick", function()
        local name = ebItem:GetText()
        if name=="" then print(R.."[GuildMarkt]"..X.." Bitte Item eingeben."); return end
        PostListing(postType, name, tonumber(ebAmt:GetText()) or 0, ebNote:GetText(), ebItem.itemLink)
        ebItem:SetText(""); ebItem.itemLink=nil; ebAmt:SetText(""); ebNote:SetText("")
        RefreshList()
        print(T.."[GuildMarkt]"..X.." Gepostet: "..Clr(postType).." "..W..name..X)
    end)

    local clearBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    clearBtn:SetSize(160, 26)
    clearBtn:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 158, 58)
    clearBtn:SetText("Meine Eintr. loeschen")
    clearBtn:SetScript("OnClick", function()
        local me, n = UnitName("player"), 0
        for id, e in pairs(GuildMarketDB.listings) do
            if e.contact==me then DeleteListing(id); n=n+1 end
        end
        RefreshList()
        print(T.."[GuildMarkt]"..X.." "..n.." Eintraege geloescht.")
    end)

    -- Footer
    local ft = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft:SetPoint("BOTTOM", f.InsetBg, "BOTTOM", 0, 34)
    ft:SetText(Dg.."Eintraege laufen nach 7 Tagen ab  •  Klick auf ● zum Fluestern"..X)
    local ft2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft2:SetPoint("BOTTOM", f.InsetBg, "BOTTOM", 0, 20)
    ft2:SetText("|cff3a3a4aGuildMarket — "..guildName.."  •  by MichaModus|r")

    mainFrame = f
end

-- ============================================================
-- Shift+Klick Hook
-- ============================================================

local _origInsertLink = ChatEdit_InsertLink
function ChatEdit_InsertLink(text)
    if ebItem and ebItem:IsVisible() and ebItem:HasFocus() then
        local name = text and text:match("|h%[(.-)%]|h")
        if name then ebItem:SetText(name); ebItem.itemLink=text; return true end
    end
    return _origInsertLink and _origInsertLink(text)
end

-- ============================================================
-- Timer
-- ============================================================

local function DelayCall(sec, fn)
    local fr, t = CreateFrame("Frame"), 0
    fr:SetScript("OnUpdate", function(self, dt)
        t=t+dt; if t>=sec then self:SetScript("OnUpdate",nil); fn() end
    end)
end

-- ============================================================
-- Events
-- ============================================================

local ev = CreateFrame("Frame", "GuildMarketEventFrame", UIParent)
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:RegisterEvent("GUILD_ROSTER_UPDATE")

ev:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        InitDB(); PruneExpired()
        if GuildRoster then GuildRoster() end
        DelayCall(6, function() BroadcastMine(); RequestSync() end)
        local guild = GetGuildInfo("player") or "Gilde"
        print(T.."[GuildMarkt]"..X.." Geladen — "..G.."/gmarkt"..X.." | "..Dg..guild..X)

    elseif event == "GUILD_ROSTER_UPDATE" then
        UpdateRoster()
        if mainFrame and mainFrame:IsShown() then RefreshList() end

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, msg, _, sender = ...
        if prefix ~= MSG_PREFIX then return end

        if msg == "REQ" then BroadcastMine(); return end

        if msg:sub(1,3) == "DEL" then
            local id = msg:sub(5)
            if id and GuildMarketDB.listings[id] then
                local sName = sender:match("^([^%-]+)") or sender
                if GuildMarketDB.listings[id].contact == sName then
                    GuildMarketDB.listings[id] = nil
                    if mainFrame and mainFrame:IsShown() then RefreshList() end
                end
            end
            return
        end

        local action, id, entry = Deserialize(msg)
        if action=="POST" and id and entry then
            entry.contact = sender:match("^([^%-]+)") or sender
            if entry.expires > time() then
                GuildMarketDB.listings[id] = entry
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
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:ClearAllPoints()
        mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        if GuildRoster then GuildRoster() end
        PruneExpired(); RefreshList(); mainFrame:Show()
    end
end

-- ============================================================
-- Slash
-- ============================================================

SLASH_GUILDMARKET1 = "/gmarkt"
SLASH_GUILDMARKET2 = "/gildenmarkt"
SlashCmdList["GUILDMARKET"] = function(msg)
    if msg=="sync" then RequestSync(); print(T.."[GuildMarkt]"..X.." Sync angefordert.")
    else Toggle() end
end
