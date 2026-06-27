-- GuildMarket v0.2.0-alpha
-- Gildeninterner Marktplatz fuer "Der Hohe Rat"
-- Erstellt von MichaModus

local MSG_PREFIX  = "GUILDMKT"
local EXPIRE_SECS = 7 * 24 * 3600
local ROW_WIDTH   = 410  -- feste Breite fuer stabile Darstellung
local ROW_HEIGHT  = 22

-- Prefix registrieren
if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)
elseif RegisterAddonMessagePrefix then
    RegisterAddonMessagePrefix(MSG_PREFIX)
end

local function _SendAddonMsg(prefix, msg, channel)
    if C_ChatInfo and C_ChatInfo.SendAddonMessage then
        C_ChatInfo.SendAddonMessage(prefix, msg, channel)
    elseif SendAddonMessage then
        SendAddonMessage(prefix, msg, channel)
    end
end

-- Farben
local CG = "|cffffd100"  -- gold
local CR = "|cff44ff44"  -- gruen (biete)
local CY = "|cffffff44"  -- gelb  (suche)
local CT = "|cff00cccc"  -- teal
local CC = "|cff888888"  -- grau
local CW = "|cffffffff"  -- weiss
local CE = "|cffff4444"  -- rot
local C0 = "|r"

-- ============================================================
-- Datenbank
-- ============================================================

local function InitDB()
    if not GuildMarketDB then GuildMarketDB = {} end
    if not GuildMarketDB.listings then GuildMarketDB.listings = {} end
end

local function PruneExpired()
    local now = time()
    for id, e in pairs(GuildMarketDB.listings) do
        if e.expires < now then GuildMarketDB.listings[id] = nil end
    end
end

-- ============================================================
-- Netzwerk — Protokoll: ACTION|ID|TYPE|ITEM|AMT|NOTE|EXPIRES|ITEMID
-- ============================================================

local function SendGuild(msg)
    if IsInGuild() then _SendAddonMsg(MSG_PREFIX, msg, "GUILD") end
end

local function Serialize(action, id, e)
    local item   = (e.item   or ""):gsub("|",""):sub(1,40)
    local note   = (e.note   or ""):gsub("|",""):sub(1,50)
    local itemId = tostring(e.itemId or "")
    return action.."|"..id.."|"..e.type.."|"..item.."|"
        ..tostring(e.amount or 0).."|"..note.."|"..tostring(e.expires).."|"..itemId
end

local function Deserialize(msg)
    local t = {}
    for p in (msg.."|"):gmatch("([^|]*)|") do t[#t+1] = p end
    if #t < 7 then return nil, nil, nil end
    local itemId = tonumber(t[8])
    local link   = nil
    if itemId then
        local _, il = GetItemInfo(itemId)
        link = il
    end
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

local function BroadcastEntry(id, e)
    SendGuild(Serialize("POST", id, e))
end

local function BroadcastMyListings()
    local me = UnitName("player")
    for id, e in pairs(GuildMarketDB.listings) do
        if e.contact == me then BroadcastEntry(id, e) end
    end
end

local function PostListing(etype, item, amount, note, link)
    local me     = UnitName("player")
    local now    = time()
    local id     = me.."-"..now
    local itemId = link and tonumber(link:match("|Hitem:(%d+)"))
    local e = {
        type    = etype,
        item    = item,
        amount  = amount,
        note    = note,
        contact = me,
        expires = now + EXPIRE_SECS,
        link    = link,
        itemId  = itemId,
    }
    GuildMarketDB.listings[id] = e
    BroadcastEntry(id, e)
    return id
end

local function DeleteListing(id)
    GuildMarketDB.listings[id] = nil
    SendGuild("DEL|"..id)
end

local function RequestSync()
    SendGuild("REQ")
end

-- ============================================================
-- Hilfsfunktionen
-- ============================================================

local function ColorType(t)
    return t == "BIETE" and (CR..t..C0) or (CY..t..C0)
end

local function FormatExpiry(ts)
    local d = ts - time()
    if d <= 0 then return CE.."abgel."..C0 end
    local days = math.floor(d / 86400)
    if days > 0 then return CC..days.."T"..C0 end
    local hrs = math.floor(d / 3600)
    if hrs  > 0 then return CC..hrs.."h"..C0 end
    return CC.."<1h"..C0
end

local function GetFilteredListings(filter)
    local out, now = {}, time()
    for id, e in pairs(GuildMarketDB.listings) do
        if e.expires > now and (filter == "ALL" or e.type == filter) then
            out[#out+1] = { id=id, e=e }
        end
    end
    table.sort(out, function(a,b) return a.e.expires > b.e.expires end)
    return out
end

-- ============================================================
-- Item-Link Helfer
-- ============================================================

-- Gibt Name + Link aus einem Drag-Cursor zurueck
local function GetDraggedItemInfo()
    local iType, itemId = GetCursorInfo()
    if iType == "item" and itemId then
        local name, link = GetItemInfo(itemId)
        return name, link
    end
    return nil, nil
end

-- ============================================================
-- UI
-- ============================================================

local mainFrame, listContent, rows, ebItem
local currentFilter = "ALL"
local postType      = "BIETE"
rows = {}

local function ShowItemTooltip(owner, e)
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    -- Versuche echten Item-Tooltip; fallback auf Text
    local link = e.link
    if not link and e.itemId then
        local _, il = GetItemInfo(e.itemId)
        link = il
    end
    if link then
        pcall(function() GameTooltip:SetHyperlink(link) end)
    else
        GameTooltip:AddLine(e.item or "", 1, 1, 0)
    end
    if (e.note or "") ~= "" then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine('"'..(e.note or "")..'"', 1, 1, 1, true)
    end
    GameTooltip:AddLine(CC.."Kontakt: "..C0..CT..(e.contact or "")..C0)
    GameTooltip:Show()
end

local function RefreshList()
    if not listContent then return end
    for _, r in ipairs(rows) do r:Hide() end

    local listings = GetFilteredListings(currentFilter)
    local me       = UnitName("player")
    local y        = 0

    for i, item in ipairs(listings) do
        local e, id = item.e, item.id

        if not rows[i] then
            local row = CreateFrame("Button", nil, listContent)
            row:SetSize(ROW_WIDTH, ROW_HEIGHT)

            local bg = row:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(); row.bg = bg

            local hl = row:CreateTexture(nil, "HIGHLIGHT")
            hl:SetAllPoints(); hl:SetColorTexture(1,1,1,0.07)
            row:SetHighlightTexture(hl)

            local function Col(x, w, align)
                local fs = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                fs:SetPoint("LEFT", row, "LEFT", x, 0)
                fs:SetSize(w, ROW_HEIGHT)
                fs:SetJustifyH(align or "LEFT")
                return fs
            end
            row.cType    = Col(4,   54)
            row.cItem    = Col(62,  130)
            row.cAmt     = Col(196, 44,  "CENTER")
            row.cContact = Col(244, 88)
            row.cExp     = Col(336, 40,  "RIGHT")

            local del = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            del:SetSize(24, 18)
            del:SetPoint("RIGHT", row, "RIGHT", -2, 0)
            del:SetText("X")
            del:Hide(); row.del = del

            rows[i] = row
        end

        local row = rows[i]
        if i % 2 == 0 then
            row.bg:SetColorTexture(0.10, 0.10, 0.18, 0.75)
        else
            row.bg:SetColorTexture(0.05, 0.05, 0.12, 0.60)
        end

        row.cType:SetText(ColorType(e.type))
        row.cItem:SetText(CW..(e.item or "")..C0)
        row.cAmt:SetText(e.amount > 0 and (CG..e.amount..C0) or "")
        row.cContact:SetText(CT..(e.contact or "")..C0)
        row.cExp:SetText(FormatExpiry(e.expires))

        row:SetScript("OnEnter", function(self) ShowItemTooltip(self, e) end)
        row:SetScript("OnLeave", function()     GameTooltip:Hide() end)

        if e.contact == me then
            row.del:Show()
            row.del:SetScript("OnClick", function()
                DeleteListing(id); RefreshList()
            end)
        else
            row.del:Hide()
        end

        row:SetPoint("TOPLEFT", listContent, "TOPLEFT", 0, -y)
        row:Show()
        y = y + ROW_HEIGHT
    end

    listContent:SetHeight(math.max(y, 20))

    if not listContent.empty then
        listContent.empty = listContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        listContent.empty:SetPoint("CENTER", listContent, "TOP", 0, -60)
        listContent.empty:SetJustifyH("CENTER")
    end
    if #listings == 0 then
        listContent.empty:SetText(CC.."Keine Eintraege vorhanden.\nSync anfordern oder neuen Eintrag posten."..C0)
        listContent.empty:Show()
    else
        listContent.empty:Hide()
    end
end

local function BuildUI()
    local f = CreateFrame("Frame", "GuildMarketMainFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(460, 540)
    f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG")
    f:Hide()

    f.TitleBg:SetHeight(30)
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("LEFT", f.TitleBg, "LEFT", 8, 0)
    title:SetText(CG.."Gildenmarkt"..C0.." — Der Hohe Rat")

    local sub = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sub:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", 8, -4)
    sub:SetText(CC.."by MichaModus  •  /gmarkt"..C0)

    -- Tabs
    local function Tab(label, filter, x)
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(76, 22)
        b:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", x, -22)
        b:SetText(label)
        b:SetScript("OnClick", function() currentFilter = filter; RefreshList() end)
    end
    Tab("Alle",  "ALL",   6)
    Tab("Suche", "SUCHE", 86)
    Tab("Biete", "BIETE", 166)

    local syncBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    syncBtn:SetSize(110, 22)
    syncBtn:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -22)
    syncBtn:SetText("Sync anfordern")
    syncBtn:SetScript("OnClick", function()
        RequestSync()
        print(CT.."[GuildMarkt]"..C0.." Sync angefordert...")
    end)

    -- Spalten-Header
    local hBg = f:CreateTexture(nil, "BACKGROUND")
    hBg:SetPoint("TOPLEFT",  f.InsetBg, "TOPLEFT",  4, -48)
    hBg:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -48)
    hBg:SetHeight(18); hBg:SetColorTexture(0.12, 0.12, 0.22, 1)

    local function Hdr(txt, x)
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", x, -49)
        fs:SetHeight(16); fs:SetJustifyH("LEFT")
        fs:SetText(CG..txt..C0)
    end
    Hdr("Typ",      12)
    Hdr("Item",     70)
    Hdr("Menge",   204)
    Hdr("Kontakt", 252)
    Hdr("Rest",    344)

    -- ScrollFrame mit fester Breite
    local sf = CreateFrame("ScrollFrame", "GuildMarketScroll", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     f.InsetBg, "TOPLEFT",     4,  -66)
    sf:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -26, 168)

    local content = CreateFrame("Frame", nil, sf)
    content:SetWidth(ROW_WIDTH)
    content:SetHeight(20)
    sf:SetScrollChild(content)
    listContent = content

    -- Trennlinie
    local div = f:CreateTexture(nil, "BACKGROUND")
    div:SetPoint("BOTTOMLEFT",  f.InsetBg, "BOTTOMLEFT",  4, 166)
    div:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -4, 166)
    div:SetHeight(1); div:SetColorTexture(0.3, 0.3, 0.5, 0.9)

    -- Neuer Eintrag
    local newLbl = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    newLbl:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 148)
    newLbl:SetText(CG.."Neuer Eintrag:"..C0)

    -- Typ Dropdown
    local ddType = CreateFrame("Frame", "GuildMarketDDType", f, "UIDropDownMenuTemplate")
    ddType:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", -12, 116)
    UIDropDownMenu_SetWidth(ddType, 76)
    UIDropDownMenu_Initialize(ddType, function(_, level)
        for _, t in ipairs({"BIETE", "SUCHE"}) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = t; info.value = t
            info.checked = (postType == t)
            info.func = function(btn)
                postType = btn.value
                UIDropDownMenu_SetSelectedValue(ddType, btn.value)
                UIDropDownMenu_SetText(ddType, btn.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddType, "BIETE")
    UIDropDownMenu_SetText(ddType, "BIETE")

    -- Item-Eingabe
    local lbItem = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbItem:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 102, 147)
    lbItem:SetText(CC.."Item (Drag oder Shift+Klick):"..C0)

    ebItem = CreateFrame("EditBox", "GuildMarketItemBox", f, "InputBoxTemplate")
    ebItem:SetSize(148, 20)
    ebItem:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 102, 127)
    ebItem:SetAutoFocus(false)
    ebItem:SetMaxLetters(40)
    ebItem.itemLink = nil  -- gespeicherter Item-Link

    -- Item per Drag reinziehen
    ebItem:SetScript("OnReceiveDrag", function(self)
        local name, link = GetDraggedItemInfo()
        if name then
            self:SetText(name)
            self.itemLink = link
            ClearCursor()
        end
    end)
    ebItem:SetScript("OnMouseDown", function(self)
        local name, link = GetDraggedItemInfo()
        if name then
            self:SetText(name)
            self.itemLink = link
            ClearCursor()
        end
    end)
    -- Text geaendert => Link zuruecksetzen
    ebItem:SetScript("OnTextChanged", function(self)
        if self.itemLink then
            local linkedName = self.itemLink:match("|h%[(.-)%]|h")
            if linkedName ~= self:GetText() then
                self.itemLink = nil
            end
        end
    end)

    -- Menge
    local lbAmt = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 260, 147)
    lbAmt:SetText(CC.."Menge:"..C0)

    local ebAmt = CreateFrame("EditBox", "GuildMarketAmtBox", f, "InputBoxTemplate")
    ebAmt:SetSize(72, 20)
    ebAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 260, 127)
    ebAmt:SetAutoFocus(false); ebAmt:SetMaxLetters(6); ebAmt:SetNumeric(true)

    -- Notiz
    local lbNote = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbNote:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 108)
    lbNote:SetText(CC.."Notiz (optional):"..C0)

    local ebNote = CreateFrame("EditBox", "GuildMarketNoteBox", f, "InputBoxTemplate")
    ebNote:SetSize(336, 20)
    ebNote:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 88)
    ebNote:SetAutoFocus(false); ebNote:SetMaxLetters(55)

    -- Post-Button
    local postBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    postBtn:SetSize(130, 24)
    postBtn:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 58)
    postBtn:SetText("Eintrag posten")
    postBtn:SetScript("OnClick", function()
        local itemName = ebItem:GetText()
        if itemName == "" then
            print(CE.."[GuildMarkt]"..C0.." Bitte ein Item eingeben."); return
        end
        local amt  = tonumber(ebAmt:GetText()) or 0
        local note = ebNote:GetText()
        PostListing(postType, itemName, amt, note, ebItem.itemLink)
        ebItem:SetText(""); ebItem.itemLink = nil
        ebAmt:SetText(""); ebNote:SetText("")
        RefreshList()
        print(CT.."[GuildMarkt]"..C0.." Gepostet: "..ColorType(postType).." "..CW..itemName..C0)
    end)

    -- Loeschen-Button
    local clearBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    clearBtn:SetSize(155, 24)
    clearBtn:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 148, 58)
    clearBtn:SetText("Meine Eintr. loeschen")
    clearBtn:SetScript("OnClick", function()
        local me, count = UnitName("player"), 0
        for id, e in pairs(GuildMarketDB.listings) do
            if e.contact == me then DeleteListing(id); count = count + 1 end
        end
        RefreshList()
        print(CT.."[GuildMarkt]"..C0.." "..count.." Eintraege geloescht.")
    end)

    -- Footer
    local ft1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft1:SetPoint("BOTTOM", f.InsetBg, "BOTTOM", 0, 38)
    ft1:SetText(CC.."Eintraege laufen nach 7 Tagen ab  •  Kontakt per Fluestern"..C0)

    local ft2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft2:SetPoint("BOTTOM", f.InsetBg, "BOTTOM", 0, 24)
    ft2:SetText("|cff444444GuildMarket — Der Hohe Rat  •  by MichaModus|r")

    mainFrame = f
end

local function Toggle()
    if not mainFrame then BuildUI() end
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        PruneExpired(); RefreshList(); mainFrame:Show()
    end
end

-- ============================================================
-- Shift+Klick Item-Link Hook
-- ============================================================

local _origInsertLink = ChatEdit_InsertLink
function ChatEdit_InsertLink(text)
    -- Wenn unser Item-Feld fokussiert ist, Link dorthin umleiten
    if ebItem and ebItem:IsVisible() and ebItem:HasFocus() then
        local name = text and text:match("|h%[(.-)%]|h")
        if name then
            ebItem:SetText(name)
            ebItem.itemLink = text
            return true
        end
    end
    return _origInsertLink and _origInsertLink(text)
end

-- ============================================================
-- Verzögerter Timer
-- ============================================================

local function DelayCall(seconds, fn)
    local fr, t = CreateFrame("Frame"), 0
    fr:SetScript("OnUpdate", function(self, dt)
        t = t + dt
        if t >= seconds then self:SetScript("OnUpdate", nil); fn() end
    end)
end

-- ============================================================
-- Events
-- ============================================================

local ev = CreateFrame("Frame", "GuildMarketEventFrame", UIParent)
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("CHAT_MSG_ADDON")

ev:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        InitDB(); PruneExpired()
        DelayCall(6, function() BroadcastMyListings(); RequestSync() end)
        print(CT.."[GuildMarkt]"..C0.." Geladen — "..CG.."/gmarkt"..C0.." zum Oeffnen | "..CC.."Der Hohe Rat"..C0)

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, msg, _, sender = ...
        if prefix ~= MSG_PREFIX then return end

        if msg == "REQ" then
            BroadcastMyListings(); return
        end

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
        if action == "POST" and id and entry then
            entry.contact = sender:match("^([^%-]+)") or sender
            if entry.expires > time() then
                GuildMarketDB.listings[id] = entry
                if mainFrame and mainFrame:IsShown() then RefreshList() end
            end
        end
    end
end)

-- ============================================================
-- Slash Commands
-- ============================================================

SLASH_GUILDMARKET1 = "/gmarkt"
SLASH_GUILDMARKET2 = "/gildenmarkt"
SlashCmdList["GUILDMARKET"] = function(msg)
    if msg == "sync" then
        RequestSync()
        print(CT.."[GuildMarkt]"..C0.." Sync angefordert.")
    else
        Toggle()
    end
end
