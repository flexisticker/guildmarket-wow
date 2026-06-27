-- GuildMarket v0.3.0
-- Gildeninterner Marktplatz — dynamischer Gildenname
-- Erstellt von MichaModus

local MSG_PREFIX  = "GUILDMKT"
local EXPIRE_SECS = 7 * 24 * 3600

-- Spalten-Layout (Konstanten fuer Header UND Zeilen identisch)
local COL = {
    type    = { x=6,   w=54  },
    item    = { x=64,  w=140 },
    amount  = { x=208, w=46  },
    contact = { x=258, w=92  },
    expiry  = { x=354, w=38  },
}
local ROW_H    = 22
local ROW_W    = 406

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
local G = "|cffffd100"   -- gold
local Gr = "|cff44ff44"  -- gruen (Biete)
local Y = "|cffffff44"   -- gelb  (Suche)
local T = "|cff00cccc"   -- teal
local Dg = "|cff888888"  -- dunkelgrau
local W = "|cffffffff"   -- weiss
local R = "|cffff5555"   -- rot
local X = "|r"

local function Clr(t) return t=="BIETE" and (Gr..t..X) or (Y..t..X) end

-- ============================================================
-- Datenbank
-- ============================================================

local function InitDB()
    if not GuildMarketDB              then GuildMarketDB = {} end
    if not GuildMarketDB.listings     then GuildMarketDB.listings = {} end
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
    local item   = (e.item or ""):gsub("|",""):sub(1,40)
    local note   = (e.note or ""):gsub("|",""):sub(1,50)
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

local function Broadcast(id, e)
    SendGuild(Serialize("POST", id, e))
end

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

local function DeleteListing(id)
    GuildMarketDB.listings[id] = nil
    SendGuild("DEL|"..id)
end

local function RequestSync() SendGuild("REQ") end

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
    -- Gibt r,g,b aus der Itemqualitaetsfarbe zurueck
    if not link then return 1,1,1 end
    local hex = link:match("|c(%x%x%x%x%x%x%x%x)")
    if not hex then return 1,1,1 end
    local r = tonumber(hex:sub(3,4),16)/255
    local g = tonumber(hex:sub(5,6),16)/255
    local b = tonumber(hex:sub(7,8),16)/255
    return r, g, b
end

local function GetFilteredListings(filter)
    local out, now = {}, time()
    for id, e in pairs(GuildMarketDB.listings) do
        if e.expires > now and (filter=="ALL" or e.type==filter) then
            out[#out+1] = {id=id, e=e}
        end
    end
    table.sort(out, function(a,b) return a.e.expires > b.e.expires end)
    return out
end

local function GetDraggedItem()
    local iType, itemId = GetCursorInfo()
    if iType == "item" and itemId then
        return GetItemInfo(itemId)
    end
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

    -- Zaehltext aktualisieren
    if countText then
        local total, suche, biete = 0, 0, 0
        local now = time()
        for _, e in pairs(GuildMarketDB.listings) do
            if e.expires > now then
                total = total + 1
                if e.type == "SUCHE" then suche=suche+1 else biete=biete+1 end
            end
        end
        countText:SetText(Dg..total.." Eintraege  ("..Gr.."Biete: "..biete..X..Dg.."  /  "..Y.."Suche: "..suche..X..Dg..")"..X)
    end

    for i, item in ipairs(listings) do
        local e, id = item.e, item.id

        if not rows[i] then
            -- Zeile erstellen
            local row = CreateFrame("Button", nil, listContent)
            row:SetSize(ROW_W, ROW_H)

            local bg = row:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(); row.bg = bg

            local hl = row:CreateTexture(nil, "HIGHLIGHT")
            hl:SetAllPoints()
            hl:SetColorTexture(0.8, 0.8, 1, 0.08)
            row:SetHighlightTexture(hl)

            -- Selektionsrahmen beim Hover
            local border = CreateFrame("Frame", nil, row, "BackdropTemplate")
            border:SetAllPoints()
            border:SetBackdrop({ edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize=12 })
            border:SetBackdropBorderColor(0.4, 0.8, 1, 0)
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

            local del = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            del:SetSize(24, 18)
            del:SetPoint("RIGHT", row, "RIGHT", -2, 0)
            del:SetText("X")
            del:Hide(); row.del = del

            rows[i] = row
        end

        local row = rows[i]

        -- Zebrastreifen
        if i % 2 == 0 then
            row.bg:SetColorTexture(0.10, 0.10, 0.20, 0.80)
        else
            row.bg:SetColorTexture(0.05, 0.05, 0.12, 0.55)
        end

        -- Item-Link auffrischen falls jetzt gecacht
        local link = e.link
        if not link and e.itemId then
            link = select(2, GetItemInfo(e.itemId))
            if link then e.link = link end
        end

        row.fType:SetText(Clr(e.type))

        -- Item in Qualitaetsfarbe
        if link then
            local r, g, b = GetLinkColor(link)
            row.fItem:SetText(string.format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, e.item or ""))
        else
            row.fItem:SetText(W..(e.item or "")..X)
        end

        row.fAmt:SetText(e.amount > 0 and (G..e.amount..X) or "")
        row.fContact:SetText(T..(e.contact or "")..X)
        row.fExp:SetText(FormatExpiry(e.expires))

        -- Tooltip
        row:SetScript("OnEnter", function(self)
            self.border:SetBackdropBorderColor(0.4, 0.8, 1, 0.8)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            local ttLink = e.link
            if not ttLink and e.itemId then
                ttLink = select(2, GetItemInfo(e.itemId))
            end
            if ttLink then
                pcall(GameTooltip.SetHyperlink, GameTooltip, ttLink)
            else
                GameTooltip:AddLine(e.item or "", 1, 1, 0)
            end
            if (e.note or "") ~= "" then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine('"'..(e.note)..'"', 1, 1, 1, true)
            end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(Dg.."Kontakt: "..X..T..(e.contact or "")..X)
            GameTooltip:AddLine(Dg.."Laeuft ab: "..X..FormatExpiry(e.expires))
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave", function(self)
            self.border:SetBackdropBorderColor(0.4, 0.8, 1, 0)
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
        listContent.empty:SetText(Dg.."Keine Eintraege vorhanden.\nSync anfordern oder neuen Eintrag posten."..X)
        listContent.empty:Show()
    else
        listContent.empty:Hide()
    end
end

-- ============================================================
-- UI Aufbau
-- ============================================================

local function BuildUI()
    -- Gildenname dynamisch
    local guildName = GetGuildInfo("player") or "Gilde"

    local f = CreateFrame("Frame", "GuildMarketMainFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(470, 560)
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
    title:SetText(G.."Gildenmarkt"..X.." — "..T..guildName..X)

    local sub = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sub:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", 8, -5)
    sub:SetText(Dg.."by MichaModus  •  /gmarkt"..X)

    -- Tabs + Zaehler in einer Reihe
    local function Tab(label, filter, x)
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(80, 22)
        b:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", x, -22)
        b:SetText(label)
        b:SetScript("OnClick", function() currentFilter = filter; RefreshList() end)
    end
    Tab("Alle",  "ALL",   6)
    Tab("Suche", "SUCHE", 90)
    Tab("Biete", "BIETE", 174)

    countText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    countText:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", 264, -28)
    countText:SetText("")

    local syncBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    syncBtn:SetSize(100, 22)
    syncBtn:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -22)
    syncBtn:SetText("↻  Sync")
    syncBtn:SetScript("OnClick", function()
        RequestSync()
        print(T.."[GuildMarkt]"..X.." Sync angefordert...")
    end)

    -- Spalten-Header Hintergrund
    local hBg = f:CreateTexture(nil, "BACKGROUND")
    hBg:SetPoint("TOPLEFT",  f.InsetBg, "TOPLEFT",  4, -48)
    hBg:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -48)
    hBg:SetHeight(18); hBg:SetColorTexture(0.10, 0.10, 0.22, 1)

    -- Dünne Linie unter Header
    local hLine = f:CreateTexture(nil, "BACKGROUND")
    hLine:SetPoint("TOPLEFT",  f.InsetBg, "TOPLEFT",  4, -65)
    hLine:SetPoint("TOPRIGHT", f.InsetBg, "TOPRIGHT", -4, -65)
    hLine:SetHeight(1); hLine:SetColorTexture(0.3, 0.5, 0.8, 0.5)

    local function Hdr(txt, col)
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", f.InsetBg, "TOPLEFT", col.x+4, -49)
        fs:SetSize(col.w, 16); fs:SetJustifyH("LEFT")
        fs:SetText(G..txt..X)
    end
    Hdr("Typ",     COL.type)
    Hdr("Item",    COL.item)
    Hdr("Menge",   COL.amount)
    Hdr("Kontakt", COL.contact)
    Hdr("Rest",    COL.expiry)

    -- ScrollFrame
    local sf = CreateFrame("ScrollFrame", "GuildMarketScroll", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     f.InsetBg, "TOPLEFT",     4,  -66)
    sf:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -22, 178)

    local content = CreateFrame("Frame", nil, sf)
    content:SetWidth(ROW_W); content:SetHeight(20)
    sf:SetScrollChild(content)
    listContent = content

    -- Trennlinie ueber Formular
    local div = f:CreateTexture(nil, "BACKGROUND")
    div:SetPoint("BOTTOMLEFT",  f.InsetBg, "BOTTOMLEFT",  4, 176)
    div:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -4, 176)
    div:SetHeight(1); div:SetColorTexture(0.3, 0.5, 0.8, 0.6)

    -- Formular Hintergrund
    local fBg = f:CreateTexture(nil, "BACKGROUND")
    fBg:SetPoint("BOTTOMLEFT",  f.InsetBg, "BOTTOMLEFT",  4, 46)
    fBg:SetPoint("BOTTOMRIGHT", f.InsetBg, "BOTTOMRIGHT", -4, 46)
    fBg:SetHeight(130); fBg:SetColorTexture(0.06, 0.06, 0.14, 0.8)

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

    -- Item Label + Box
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

    -- Menge Label + Box
    local lbAmt = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 276, 155)
    lbAmt:SetText(Dg.."Menge:"..X)

    local ebAmt = CreateFrame("EditBox", "GuildMarketAmtBox", f, "InputBoxTemplate")
    ebAmt:SetSize(80, 22)
    ebAmt:SetPoint("BOTTOMLEFT", f.InsetBg, "BOTTOMLEFT", 276, 133)
    ebAmt:SetAutoFocus(false); ebAmt:SetMaxLetters(6); ebAmt:SetNumeric(true)

    -- Notiz Label + Box (volle Breite)
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
        if name=="" then
            print(R.."[GuildMarkt]"..X.." Bitte ein Item eingeben."); return
        end
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
    ft:SetText(Dg.."Eintraege laufen nach 7 Tagen ab  •  Kontakt per Fluestern oder Treffpunkt"..X)
    local ft2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft2:SetPoint("BOTTOM", f.InsetBg, "BOTTOM", 0, 20)
    ft2:SetText("|cff3a3a4aGuildMarket — "..guildName.."  •  by MichaModus|r")

    mainFrame = f
end

local function Toggle()
    if not mainFrame then BuildUI() end
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:ClearAllPoints()
        mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        PruneExpired(); RefreshList(); mainFrame:Show()
    end
end

-- ============================================================
-- Shift+Klick Hook
-- ============================================================

local _origInsertLink = ChatEdit_InsertLink
function ChatEdit_InsertLink(text)
    if ebItem and ebItem:IsVisible() and ebItem:HasFocus() then
        local name = text and text:match("|h%[(.-)%]|h")
        if name then
            ebItem:SetText(name); ebItem.itemLink = text; return true
        end
    end
    return _origInsertLink and _origInsertLink(text)
end

-- ============================================================
-- Timer Helper
-- ============================================================

local function DelayCall(sec, fn)
    local fr, t = CreateFrame("Frame"), 0
    fr:SetScript("OnUpdate", function(self, dt)
        t=t+dt
        if t>=sec then self:SetScript("OnUpdate",nil); fn() end
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
        DelayCall(6, function() BroadcastMine(); RequestSync() end)
        local guild = GetGuildInfo("player") or "Gilde"
        print(T.."[GuildMarkt]"..X.." Geladen — "..G.."/gmarkt"..X.." | "..Dg..guild..X)

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
-- Slash Commands
-- ============================================================

SLASH_GUILDMARKET1 = "/gmarkt"
SLASH_GUILDMARKET2 = "/gildenmarkt"
SlashCmdList["GUILDMARKET"] = function(msg)
    if msg=="sync" then
        RequestSync(); print(T.."[GuildMarkt]"..X.." Sync angefordert.")
    else
        Toggle()
    end
end
