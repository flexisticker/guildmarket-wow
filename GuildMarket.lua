-- GuildMarket v0.1.0-alpha
-- Gildeninterner Marktplatz fuer "Der Hohe Rat"
-- Erstellt von MichaModus

local MSG_PREFIX  = "GUILDMKT"
local EXPIRE_SECS = 7 * 24 * 3600

-- Prefix registrieren: TBC Anniversary nutzt C_ChatInfo, Vanilla das Global
if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)
elseif RegisterAddonMessagePrefix then
    RegisterAddonMessagePrefix(MSG_PREFIX)
end

-- Kompatibler SendAddonMessage Wrapper
local function _SendAddonMsg(prefix, msg, channel)
    if C_ChatInfo and C_ChatInfo.SendAddonMessage then
        C_ChatInfo.SendAddonMessage(prefix, msg, channel)
    elseif SendAddonMessage then
        SendAddonMessage(prefix, msg, channel)
    end
end

-- Farben
local C_GOLD   = "|cffffd100"
local C_GREEN  = "|cff44ff44"
local C_YELLOW = "|cffffff44"
local C_TEAL   = "|cff00cccc"
local C_GREY   = "|cff888888"
local C_WHITE  = "|cffffffff"
local C_RED    = "|cffff4444"
local C_RESET  = "|r"

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
-- Netzwerk
-- ============================================================

local function SendGuild(msg)
    if IsInGuild() then
        _SendAddonMsg(MSG_PREFIX, msg, "GUILD")
    end
end

local function Serialize(action, id, e)
    local item = (e.item or ""):gsub("|", "/"):sub(1, 40)
    local note = (e.note or ""):gsub("|", "/"):sub(1, 55)
    return action.."|"..id.."|"..e.type.."|"..item.."|"
        ..tostring(e.amount or 0).."|"..note.."|"..tostring(e.expires)
end

local function Deserialize(msg)
    local t = {}
    for p in (msg.."|"):gmatch("([^|]*)|") do t[#t+1] = p end
    if #t < 7 then return nil, nil, nil end
    return t[1], t[2], {
        type    = t[3],
        item    = t[4],
        amount  = tonumber(t[5]) or 0,
        note    = t[6],
        expires = tonumber(t[7]) or 0,
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

local function PostListing(etype, item, amount, note)
    local me  = UnitName("player")
    local now = time()
    local id  = me.."-"..now
    local e   = { type=etype, item=item, amount=amount, note=note, contact=me, expires=now+EXPIRE_SECS }
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
    if t == "BIETE" then return C_GREEN..t..C_RESET end
    return C_YELLOW..t..C_RESET
end

local function FormatExpiry(ts)
    local diff = ts - time()
    if diff <= 0 then return C_RED.."abgel."..C_RESET end
    local d = math.floor(diff / 86400)
    if d > 0 then return C_GREY..d.."T"..C_RESET end
    local h = math.floor(diff / 3600)
    if h > 0 then return C_GREY..h.."h"..C_RESET end
    return C_GREY.."<1h"..C_RESET
end

local function GetFilteredListings(filter)
    local result, now = {}, time()
    for id, e in pairs(GuildMarketDB.listings) do
        if e.expires > now and (filter == "ALL" or e.type == filter) then
            result[#result+1] = { id=id, e=e }
        end
    end
    table.sort(result, function(a, b) return a.e.expires > b.e.expires end)
    return result
end

-- ============================================================
-- UI
-- ============================================================

local mainFrame, listContent, rows
local currentFilter  = "ALL"
local postType       = "BIETE"
rows = {}

local function RefreshList()
    if not listContent then return end
    for _, r in ipairs(rows) do r:Hide() end

    local listings = GetFilteredListings(currentFilter)
    local me = UnitName("player")
    local y  = 0

    for i, item in ipairs(listings) do
        local e, id = item.e, item.id

        if not rows[i] then
            local row = CreateFrame("Button", nil, listContent)
            row:SetHeight(22)
            row:SetPoint("TOPLEFT",  listContent, "TOPLEFT",  0, 0)
            row:SetPoint("TOPRIGHT", listContent, "TOPRIGHT", 0, 0)

            local bg = row:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(); row.bg = bg

            local hl = row:CreateTexture(nil, "HIGHLIGHT")
            hl:SetAllPoints(); hl:SetColorTexture(1,1,1,0.08)
            row:SetHighlightTexture(hl)

            local function Col(xOff, w, anchor)
                local fs = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                fs:SetPoint("LEFT", row, "LEFT", xOff, 0)
                fs:SetWidth(w); fs:SetJustifyH(anchor or "LEFT")
                return fs
            end
            row.colType    = Col(4,   52)
            row.colItem    = Col(60,  130)
            row.colAmount  = Col(194, 44, "CENTER")
            row.colContact = Col(242, 90)
            row.colExp     = Col(336, 36, "RIGHT")

            local del = CreateFrame("Button", nil, row)
            del:SetSize(18, 18)
            del:SetPoint("RIGHT", row, "RIGHT", -4, 0)
            del:SetNormalFontObject("GameFontNormalSmall")
            del:Hide(); row.del = del

            rows[i] = row
        end

        local row = rows[i]
        row.bg:SetColorTexture(i%2==0 and 0.08 or 0.04, i%2==0 and 0.08 or 0.04, i%2==0 and 0.14 or 0.09, 0.7)

        row.colType:SetText(ColorType(e.type))
        row.colItem:SetText(C_WHITE..(e.item or "")..C_RESET)
        row.colAmount:SetText(e.amount > 0 and C_GOLD..e.amount..C_RESET or "")
        row.colContact:SetText(C_TEAL..(e.contact or "")..C_RESET)
        row.colExp:SetText(FormatExpiry(e.expires))

        row:SetScript("OnEnter", function(self)
            if (e.note or "") ~= "" then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:ClearLines()
                GameTooltip:AddLine(e.item, 1, 1, 0)
                GameTooltip:AddLine(e.note, 1, 1, 1, true)
                GameTooltip:AddLine("Kontakt: "..(e.contact or ""), 0, 0.8, 0.8)
                GameTooltip:Show()
            end
        end)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        if e.contact == me then
            row.del:Show()
            row.del:SetText(C_RED.."✕"..C_RESET)
            row.del:SetScript("OnClick", function()
                DeleteListing(id); RefreshList()
            end)
        else
            row.del:Hide()
        end

        row:SetPoint("TOPLEFT", listContent, "TOPLEFT", 0, -y)
        row:Show()
        y = y + 22
    end

    listContent:SetHeight(math.max(y, 10))

    if not listContent.emptyText then
        listContent.emptyText = listContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        listContent.emptyText:SetPoint("CENTER", listContent, "TOP", 0, -60)
        listContent.emptyText:SetJustifyH("CENTER")
    end
    if #listings == 0 then
        listContent.emptyText:SetText(C_GREY.."Keine Eintraege.\nKlicke auf 'Sync' oder poste einen neuen Eintrag."..C_RESET)
        listContent.emptyText:Show()
    else
        listContent.emptyText:Hide()
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

    -- Titel
    f.TitleBg:SetHeight(30)
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("LEFT", f.TitleBg, "LEFT", 8, 0)
    title:SetText(C_GOLD.."Gildenmarkt"..C_RESET.." — Der Hohe Rat")

    local sub = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sub:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", 8, -4)
    sub:SetText(C_GREY.."by MichaModus  •  /gmarkt zum Oeffnen"..C_RESET)

    -- Tabs
    local function MakeTab(label, filter, x)
        local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        btn:SetSize(76, 22)
        btn:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", x, -22)
        btn:SetText(label)
        btn:SetScript("OnClick", function() currentFilter = filter; RefreshList() end)
        return btn
    end
    MakeTab("Alle",  "ALL",   6)
    MakeTab("Suche", "SUCHE", 86)
    MakeTab("Biete", "BIETE", 166)

    local syncBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    syncBtn:SetSize(110, 22)
    syncBtn:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -22)
    syncBtn:SetText("↻ Sync")
    syncBtn:SetScript("OnClick", function()
        RequestSync()
        print(C_TEAL.."[GuildMarkt]"..C_RESET.." Sync angefordert...")
    end)

    -- Spalten-Header
    local hBg = f:CreateTexture(nil, "BACKGROUND")
    hBg:SetPoint("TOPLEFT",  f.InsetBg, "TOPLEFT",  4, -48)
    hBg:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -48)
    hBg:SetHeight(18); hBg:SetColorTexture(0.12, 0.12, 0.22, 1)

    local function Hdr(txt, x, w)
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", x, -48)
        fs:SetSize(w, 18); fs:SetJustifyH("LEFT")
        fs:SetText(C_GOLD..txt..C_RESET)
    end
    Hdr("Typ",      8,  52)
    Hdr("Item",     64, 130)
    Hdr("Menge",   198, 44)
    Hdr("Kontakt", 246, 90)
    Hdr("Rest",    340, 40)

    -- ScrollFrame
    local sf = CreateFrame("ScrollFrame", "GuildMarketScroll", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     f.InsetBg, "TOPLEFT",     4,  -66)
    sf:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -26, 168)

    local content = CreateFrame("Frame", nil, sf)
    content:SetWidth(sf:GetWidth()); content:SetHeight(10)
    sf:SetScrollChild(content)
    listContent = content

    -- Trennlinie
    local div = f:CreateTexture(nil, "BACKGROUND")
    div:SetPoint("BOTTOMLEFT",  f.InsetBg, "BOTTOMLEFT",  4, 166)
    div:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -4, 166)
    div:SetHeight(1); div:SetColorTexture(0.3, 0.3, 0.5, 0.8)

    -- Neuer Eintrag - Label
    local newLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    newLabel:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 148)
    newLabel:SetText(C_GOLD.."Neuer Eintrag:"..C_RESET)

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

    -- Item
    local lbItem = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbItem:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 102, 147)
    lbItem:SetText(C_GREY.."Item:"..C_RESET)

    local ebItem = CreateFrame("EditBox", "GuildMarketItemBox", f, "InputBoxTemplate")
    ebItem:SetSize(148, 20); ebItem:SetAutoFocus(false); ebItem:SetMaxLetters(40)
    ebItem:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 102, 127)

    -- Menge
    local lbAmt = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 260, 147)
    lbAmt:SetText(C_GREY.."Menge:"..C_RESET)

    local ebAmt = CreateFrame("EditBox", "GuildMarketAmtBox", f, "InputBoxTemplate")
    ebAmt:SetSize(72, 20); ebAmt:SetAutoFocus(false); ebAmt:SetMaxLetters(6); ebAmt:SetNumeric(true)
    ebAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 260, 127)

    -- Notiz
    local lbNote = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbNote:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 108)
    lbNote:SetText(C_GREY.."Notiz (optional, max. 55 Zeichen):"..C_RESET)

    local ebNote = CreateFrame("EditBox", "GuildMarketNoteBox", f, "InputBoxTemplate")
    ebNote:SetSize(336, 20); ebNote:SetAutoFocus(false); ebNote:SetMaxLetters(55)
    ebNote:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 88)

    -- Post-Button
    local postBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    postBtn:SetSize(130, 24)
    postBtn:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 8, 58)
    postBtn:SetText("Eintrag posten")
    postBtn:SetScript("OnClick", function()
        local item = ebItem:GetText()
        if item == "" then
            print(C_RED.."[GuildMarkt]"..C_RESET.." Bitte ein Item eingeben."); return
        end
        local amt  = tonumber(ebAmt:GetText()) or 0
        local note = ebNote:GetText()
        PostListing(postType, item, amt, note)
        ebItem:SetText(""); ebAmt:SetText(""); ebNote:SetText("")
        RefreshList()
        print(C_TEAL.."[GuildMarkt]"..C_RESET.." Gepostet: "..ColorType(postType).." "..C_WHITE..item..C_RESET)
    end)

    -- Meine Einträge löschen Button
    local clearBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    clearBtn:SetSize(150, 24)
    clearBtn:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 148, 58)
    clearBtn:SetText("Meine Eintraege loeschen")
    clearBtn:SetScript("OnClick", function()
        local me, count = UnitName("player"), 0
        for id, e in pairs(GuildMarketDB.listings) do
            if e.contact == me then DeleteListing(id); count = count + 1 end
        end
        RefreshList()
        print(C_TEAL.."[GuildMarkt]"..C_RESET.." "..count.." Eintraege geloescht.")
    end)

    -- Footer
    local ft1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft1:SetPoint("BOTTOM", f.InsetBg, "BOTTOM", 0, 38)
    ft1:SetText(C_GREY.."Eintraege laufen nach 7 Tagen ab  •  Kontakt per Fluestern oder Treffpunkt"..C_RESET)

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
-- Verzögerter Startup-Timer (kein C_Timer in TBC/Vanilla)
-- ============================================================

local function DelayCall(seconds, fn)
    local frame = CreateFrame("Frame")
    local t = 0
    frame:SetScript("OnUpdate", function(self, dt)
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
        DelayCall(6, function()
            BroadcastMyListings()
            RequestSync()
        end)
        print(C_TEAL.."[GuildMarkt]"..C_RESET.." Geladen — "
            ..C_GOLD.."/gmarkt"..C_RESET.." zum Oeffnen  |  "
            ..C_GREY.."Der Hohe Rat"..C_RESET)

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, msg, _, sender = ...
        if prefix ~= MSG_PREFIX then return end

        if msg == "REQ" then
            BroadcastMyListings(); return
        end

        if msg:sub(1,3) == "DEL" then
            local id = msg:sub(5)
            if id and GuildMarketDB.listings[id] then
                local e = GuildMarketDB.listings[id]
                local sName = sender:match("^([^%-]+)") or sender
                if e.contact == sName then
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
        print(C_TEAL.."[GuildMarkt]"..C_RESET.." Sync angefordert.")
    else
        Toggle()
    end
end
