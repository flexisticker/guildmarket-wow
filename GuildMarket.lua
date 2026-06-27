-- GuildMarket v0.9.8
-- Guild-internal Marketplace — TBC Classic Anniversary (20505) + Classic Era (11508)
-- Created by MichaModus

local MSG_PREFIX  = "GUILDMKT"
local EXPIRE_SECS = 7 * 24 * 3600
local MIN_W, MIN_H = 680, 680

-- ============================================================
-- Lokalisierung / Localization
-- ============================================================
local isDE = GetLocale() == "deDE"
local L = {
    -- Tabs
    TAB_ALL   = isDE and "Alle"   or "All",
    TAB_WTB   = isDE and "Suche"  or "WTB",
    TAB_WTS   = isDE and "Biete"  or "WTS",
    TAB_SVC   = isDE and "Dienst" or "Service",
    -- Typ-Labels (Protokoll-Codes bleiben BIETE/SUCHE/DIENST)
    TYPE_BIETE = isDE and "BIETE"   or "OFFER",
    TYPE_SUCHE = isDE and "SUCHE"   or "SEARCH",
    TYPE_DIENST= isDE and "DIENST"  or "SERVICE",
    -- Formular
    NEW_LISTING = isDE and "Neuer Eintrag"   or "New Listing",
    LBL_TYPE   = isDE and "Typ:"            or "Type:",
    LBL_ITEM   = isDE and "Item  (Drag aus Bag oder Shift+Klick):"
                       or "Item  (Drag from Bag or Shift+Click):",
    LBL_AMOUNT = isDE and "Menge:"          or "Qty:",
    LBL_NOTE   = isDE and "Notiz (optional):" or "Note (optional):",
    LBL_PRICE  = isDE and "Preis:"          or "Price:",
    LBL_GOLD   = isDE and "Gold"   or "Gold",
    LBL_SILVER = isDE and "Silber" or "Silver",
    LBL_COPPER = isDE and "Kupfer" or "Copper",
    LBL_PTYPE  = isDE and "Art:"   or "Mode:",
    LBL_PROF   = isDE and "Beruf:"           or "Profession:",
    LBL_SERVICE= isDE and "Leistung / Bezeichnung:" or "Service / Description:",
    LBL_DUNGEON= isDE and "Dungeon:"         or "Dungeon:",
    LBL_MATS   = isDE and "Benoetigte Mats (kommagetrennt):"
                       or "Required Mats (comma-separated):",
    -- Buttons
    BTN_POST   = isDE and "Eintrag posten"           or "Post Listing",
    BTN_CLEAR  = isDE and "Meine Eintraege loeschen" or "Delete My Listings",
    BTN_SYNC   = isDE and "Sync" or "Sync",
    BTN_FREE_N = isDE and "Free: Nein" or "Free: No",
    BTN_FREE_Y = isDE and "Free: JA"   or "Free: YES",
    -- Preistypen
    PT_FIXED   = isDE and "Festpreis" or "Fixed",
    PT_NEG     = "VHB",
    PT_FIXED_L = isDE and "Festpreis"          or "Fixed Price",
    PT_NEG_L   = isDE and "Verhandlungsbasis"  or "Negotiable",
    -- Spalten-Header
    HDR_TYPE   = isDE and "Typ"    or "Type",
    HDR_ITEM   = isDE and "Item / Leistung" or "Item / Service",
    HDR_AMOUNT = isDE and "Mng"    or "Qty",
    HDR_PRICE  = isDE and "Preis"  or "Price",
    HDR_CONTACT= isDE and "Kontakt" or "Contact",
    HDR_ONLINE = "On",
    HDR_EXPIRY = isDE and "Rest"   or "Left",
    -- Meldungen
    MSG_LOADED  = isDE and "Geladen" or "Loaded",
    MSG_SYNC    = isDE and "Sync..." or "Sync...",
    MSG_POSTED  = isDE and "Gepostet:" or "Posted:",
    MSG_DELETED = isDE and "Eintraege geloescht." or "listings deleted.",
    MSG_SETTINGS= isDE and "Einstellungen aktualisiert." or "Settings updated.",
    MSG_NO_ACCESS=isDE and "Kein Zugriff." or "No access.",
    MSG_NO_ITEM = isDE and "Bitte Item eingeben."     or "Please enter an item.",
    MSG_NO_SVC  = isDE and "Bitte Leistung eingeben." or "Please enter a service.",
    MSG_NO_DGN  = isDE and "Bitte Dungeon auswaehlen." or "Please select a dungeon.",
    -- Tooltips
    TT_SEARCH  = isDE and "Suche:"    or "Search:",
    TT_CONTACT = isDE and "Kontakt: " or "Contact: ",
    TT_EXPIRES = isDE and "Laeuft ab: " or "Expires: ",
    TT_AMOUNT  = isDE and "Menge: "   or "Amount: ",
    TT_NEEDED  = isDE and "Benoetigt:" or "Required:",
    TT_FROM    = isDE and "Von: "     or "From: ",
    TT_DELETE  = isDE and "Eintrag loeschen" or "Delete listing",
    TT_NORIGHT = isDE and "Kein Zugriff"     or "No access",
    TT_NEED_RNK= isDE and "Benoetigt: " or "Requires: ",
    TT_RULES   = isDE and "Marktplatz-Regeln & Kontakt" or "Market Rules & Contact",
    -- Info-Popup
    INFO_ROSTER = isDE and "Roster neu laden" or "Reload Roster",
    INFO_WHISPER= isDE and "Fluestern" or "Whisper",
    INFO_GM     = isDE and "Gildenmeister" or "Guild Master",
    INFO_OFFICER= isDE and "Offizier" or "Officer",
    INFO_INTRO1 = isDE and "Herzlich willkommen im Gildenmarkt von"
                       or  "Welcome to the Guild Market of",
    INFO_INTRO2 = isDE and "Bitte halte dich an folgende Regeln, damit alle Mitglieder\nfair und angenehm miteinander handeln koennen:"
                       or  "Please follow these rules so all members\ncan trade fairly and respectfully:",
    -- Config
    CFG_POSTRANK= isDE and "Postier-Rang:"   or "Post Rank:",
    CFG_DELRANK = isDE and "Loeschrecht ab:" or "Delete Access:",
    CFG_SAVE    = isDE and "Speichern" or "Save",
    -- Footer
    FOOTER1 = isDE and "7 Tage Laufzeit  •  Online-Icon anklicken zum Fluestern"
                    or  "7-day listings  •  Click online icon to whisper",
    -- Sonstiges
    COUNT_USERS  = isDE and "Addon-Nutzer" or "Addon Users",
    EMPTY_SEARCH = isDE and 'Keine Eintraege fuer "' or 'No listings for "',
    EMPTY_LIST   = isDE and "Keine Eintraege.\nSync anfordern oder neuen Eintrag posten."
                        or  "No listings.\nRequest sync or post a new listing.",
}

-- Spalten (icon + verschiebt sich rechts von item beim Resize)
local COL = {
    icon    = { x=4,   w=18  },
    type    = { x=26,  w=52  },
    item    = { x=82,  w=162 },  -- expandiert
    menge   = { x=248, w=36  },
    price   = { x=288, w=98  },
    contact = { x=390, w=84  },
    online  = { x=478, w=22  },
    expiry  = { x=504, w=40  },
}
local ROW_H = 22
local ROW_W = 548

-- Berufe / Professions
local BERUFE = isDE and {
    "Alchemie","Angeln","Bergbau","Erste Hilfe","Farmservice",
    "Ingenieurskunst","Juwelenschleifen","Kochkunst",
    "Kraeuterkunde","Kuerschnerei","Lederverarbeitung",
    "Schneiderei","Schmiedekunst","Verzauberkunst","Ziehdienst",
} or {
    "Alchemy","Blacksmithing","Carry Service","Cooking","Enchanting",
    "Engineering","Farm Service","First Aid","Fishing",
    "Herbalism","Jewelcrafting","Leatherworking","Mining","Skinning","Tailoring",
}

-- { name, minCarryLevel }
local DUNGEONS = isDE and {
    { "Wunsch-Dungeon",          1  },
    { "Totenwacht (RFC)",        20 },
    { "Tiefklingen-Wacht",       22 },
    { "Totenminen",              22 },
    { "Burg Shadowfang",         26 },
    { "Die Schmiede",            26 },
    { "Gnomeregan",              30 },
    { "SM: Bibliothek",          36 },
    { "SM: Grabmal",             38 },
    { "SM: Waffenkammer",        40 },
    { "SM: Kathedrale",          42 },
    { "Razorfen Kraul",          38 },
    { "Razorfen Downs",          44 },
    { "Uldaman",                 46 },
    { "Zul'Farrak",              50 },
    { "Maraudon",                52 },
    { "Versunkener Tempel",      55 },
    { "Blackrock Tiefen",        58 },
    { "Untere Schwarzfelsspitze",58 },
    { "Obere Schwarzfelsspitze", 58 },
    { "Duesterbuch",             58 },
    { "Scholomanz",              58 },
    { "Stratholme",              58 },
    { "Hoellenfeuerfestung",     62 },
    { "Blutkessel",              62 },
    { "Sklavenpferche",          62 },
    { "Unterholz",               63 },
    { "Manatumuli",              64 },
    { "Auchenai Krypten",        64 },
    { "Sethekk-Hallen",          65 },
    { "Schattenlabyrinth",       68 },
    { "Zerschmetterte Hallen",   68 },
    { "Dampfkammern",            68 },
    { "Die Botanica",            68 },
    { "Die Arcatraz",            68 },
    { "Altes Hillsbrad",         66 },
    { "Der schwarze Morast",     68 },
    { "Magisterterasse",         68 },
} or {
    { "Custom Dungeon",          1  },
    { "Ragefire Chasm",          20 },
    { "Wailing Caverns",         22 },
    { "The Deadmines",           22 },
    { "Shadowfang Keep",         26 },
    { "The Stockade",            26 },
    { "Gnomeregan",              30 },
    { "SM: Library",             36 },
    { "SM: Graveyard",           38 },
    { "SM: Armory",              40 },
    { "SM: Cathedral",           42 },
    { "Razorfen Kraul",          38 },
    { "Razorfen Downs",          44 },
    { "Uldaman",                 46 },
    { "Zul'Farrak",              50 },
    { "Maraudon",                52 },
    { "Sunken Temple",           55 },
    { "Blackrock Depths",        58 },
    { "Lower Blackrock Spire",   58 },
    { "Upper Blackrock Spire",   58 },
    { "Dire Maul",               58 },
    { "Scholomance",             58 },
    { "Stratholme",              58 },
    { "Hellfire Ramparts",       62 },
    { "The Blood Furnace",       62 },
    { "The Slave Pens",          62 },
    { "The Underbog",            63 },
    { "Mana-Tombs",              64 },
    { "Auchenai Crypts",         64 },
    { "Sethekk Halls",           65 },
    { "Shadow Labyrinth",        68 },
    { "The Shattered Halls",     68 },
    { "The Steam Vaults",        68 },
    { "The Botanica",            68 },
    { "The Arcatraz",            68 },
    { "Old Hillsbrad Foothills", 66 },
    { "The Black Morass",        68 },
    { "Magisters' Terrace",      68 },
}

-- Berufs-Icons (Spell-Texture Pfade, TBC Classic) — DE + EN keys
local BERUF_ICONS = {
    ["Alchemie"]         = "Interface\\Icons\\Trade_Alchemy",
    ["Alchemy"]          = "Interface\\Icons\\Trade_Alchemy",
    ["Angeln"]           = "Interface\\Icons\\Trade_Fishing",
    ["Fishing"]          = "Interface\\Icons\\Trade_Fishing",
    ["Bergbau"]          = "Interface\\Icons\\Trade_Mining",
    ["Mining"]           = "Interface\\Icons\\Trade_Mining",
    ["Erste Hilfe"]      = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
    ["First Aid"]        = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
    ["Farmservice"]      = "Interface\\Icons\\INV_Misc_Food_15",
    ["Farm Service"]     = "Interface\\Icons\\INV_Misc_Food_15",
    ["Ingenieurskunst"]  = "Interface\\Icons\\Trade_Engineering",
    ["Engineering"]      = "Interface\\Icons\\Trade_Engineering",
    ["Juwelenschleifen"] = "Interface\\Icons\\INV_Misc_Gem_01",
    ["Jewelcrafting"]    = "Interface\\Icons\\INV_Misc_Gem_01",
    ["Kochkunst"]        = "Interface\\Icons\\INV_Misc_Food_15",
    ["Cooking"]          = "Interface\\Icons\\INV_Misc_Food_15",
    ["Kraeuterkunde"]    = "Interface\\Icons\\Trade_Herbalism",
    ["Herbalism"]        = "Interface\\Icons\\Trade_Herbalism",
    ["Kuerschnerei"]     = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
    ["Skinning"]         = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
    ["Lederverarbeitung"]= "Interface\\Icons\\Trade_LeatherWorking",
    ["Leatherworking"]   = "Interface\\Icons\\Trade_LeatherWorking",
    ["Schneiderei"]      = "Interface\\Icons\\Trade_Tailoring",
    ["Tailoring"]        = "Interface\\Icons\\Trade_Tailoring",
    ["Schmiedekunst"]    = "Interface\\Icons\\Trade_BlackSmithing",
    ["Blacksmithing"]    = "Interface\\Icons\\Trade_BlackSmithing",
    ["Verzauberkunst"]   = "Interface\\Icons\\Trade_Engraving",
    ["Enchanting"]       = "Interface\\Icons\\Trade_Engraving",
    ["Ziehdienst"]       = "Interface\\Icons\\Ability_Warrior_Charge",
    ["Carry Service"]    = "Interface\\Icons\\Ability_Warrior_Charge",
}

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
local G  = "|cffffd100"; local Gr = "|cff44ff44"; local Y  = "|cffffff44"
local T  = "|cff00cccc"; local Dg = "|cff888888"; local W  = "|cffffffff"
local R  = "|cffff5555"; local Cg = "|cffffd700"; local Cs = "|cffc0c0c0"
local Ck = "|cffad6333"; local Pu = "|cffcc88ff"; local X  = "|r"

local function Clr(t)
    if t=="BIETE"  then return Gr..L.TYPE_BIETE..X end
    if t=="SUCHE"  then return Y..L.TYPE_SUCHE..X end
    if t=="DIENST" then return Pu..L.TYPE_DIENST..X end
    return W..t..X
end

local function FormatPriceShort(pg,ps,pk,pfree,ptype)
    if pfree=="1" then return "|cff00ff88Kostenlos"..X end
    local g,s,k=tonumber(pg) or 0,tonumber(ps) or 0,tonumber(pk) or 0
    if g==0 and s==0 and k==0 then return Dg.."k.A."..X end
    local p={}
    if g>0 then p[#p+1]=Cg..g.."g"..X end
    if s>0 then p[#p+1]=Cs..s.."s"..X end
    if k>0 then p[#p+1]=Ck..k.."k"..X end
    return table.concat(p," ").." "..Dg..(ptype=="FP" and "FP" or "VHB")..X
end

local function FormatPriceLong(pg,ps,pk,pfree,ptype)
    if pfree=="1" then return "|cff00ff88Kostenlos|r","" end
    local g,s,k=tonumber(pg) or 0,tonumber(ps) or 0,tonumber(pk) or 0
    if g==0 and s==0 and k==0 then return Dg.."Keine Angabe"..X,"" end
    local p={}
    if g>0 then p[#p+1]=Cg..g.." Gold"..X end
    if s>0 then p[#p+1]=Cs..s.." Silber"..X end
    if k>0 then p[#p+1]=Ck..k.." Kupfer"..X end
    local pt=ptype=="FP" and "Festpreis" or "Verhandlungsbasis"
    return table.concat(p," + "),Dg.."("..pt..")"..X
end

-- ============================================================
-- Rang-System
-- ============================================================
local playerRankIndex=99
local function GetRankNames()
    local names,num={},GuildControlGetNumRanks and GuildControlGetNumRanks() or 0
    for i=0,num-1 do local n=GuildControlGetRankName and GuildControlGetRankName(i) or ("Rang "..i); names[i]=(n~="" and n) or ("Rang "..i) end
    return names,num
end
local function UpdatePlayerRank()
    local me=UnitName("player"); local total=GetNumGuildMembers and GetNumGuildMembers() or 0
    for i=1,total do local name,_,ri=GetGuildRosterInfo(i); if name and (name:match("^([^%-]+)") or name)==me then playerRankIndex=ri or 99; return end end
end
local function CanPost() if not GuildMarketDB or not GuildMarketDB.config then return true end; return playerRankIndex<=(GuildMarketDB.config.postRank or 9) end
local function CanDeleteOthers() if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end; return playerRankIndex<=(GuildMarketDB.config.deleteRank or 1) end
local function CanDeleteEntry(e) return (e.contact==UnitName("player")) or CanDeleteOthers() end
local function IsGM() return playerRankIndex==0 end

-- ============================================================
-- Online-Roster
-- ============================================================
local onlineRoster={}
local function UpdateRoster()
    onlineRoster={}; local total=GetNumGuildMembers and GetNumGuildMembers() or 0
    for i=1,total do local info={GetGuildRosterInfo(i)}; if info[1] and info[9] then onlineRoster[info[1]:match("^([^%-]+)") or info[1]]=true end end
    UpdatePlayerRank()
end
local function IsOnline(name) return onlineRoster[name]==true end
local function OpenWhisper(name)
    if ChatFrame_SendTell then ChatFrame_SendTell(name,DEFAULT_CHAT_FRAME)
    else ChatFrame_OpenChat("/w "..name.." ",DEFAULT_CHAT_FRAME) end
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
    for id,e in pairs(GuildMarketDB.listings) do if e.expires<now then GuildMarketDB.listings[id]=nil end end
end

-- ============================================================
-- Netzwerk
-- ============================================================
local function SendGuild(msg) if IsInGuild() then _Send(MSG_PREFIX,msg,"GUILD") end end

local function Serialize(action,id,e)
    local item=(e.item or ""):gsub("|",""):sub(1,40); local note=(e.note or ""):gsub("|",""):sub(1,50)
    local mats=(e.mats or ""):gsub("|",""):sub(1,80); local beruf=(e.beruf or ""):gsub("|",""):sub(1,30)
    return action.."|"..id.."|"..e.type.."|"..item.."|"..tostring(e.amount or 0).."|"..note.."|"..tostring(e.expires)
        .."|"..tostring(e.itemId or "").."|"..tostring(e.priceG or "0").."|"..tostring(e.priceS or "0")
        .."|"..tostring(e.priceK or "0").."|"..tostring(e.priceFree or "0").."|"..tostring(e.priceType or "VHB")
        .."|"..beruf.."|"..mats
end
local function Deserialize(msg)
    local t={}; for p in (msg.."|"):gmatch("([^|]*)|") do t[#t+1]=p end
    if #t<7 then return nil,nil,nil end
    local itemId=tonumber(t[8])
    return t[1],t[2],{type=t[3],item=t[4],amount=tonumber(t[5]) or 0,note=t[6],expires=tonumber(t[7]) or 0,
        itemId=itemId,link=itemId and select(2,GetItemInfo(itemId)) or nil,
        priceG=t[9] or "0",priceS=t[10] or "0",priceK=t[11] or "0",priceFree=t[12] or "0",priceType=t[13] or "VHB",
        beruf=t[14] or "",mats=t[15] or ""}
end
local function Broadcast(id,e)   SendGuild(Serialize("POST",id,e)) end
local function DeleteListing(id) GuildMarketDB.listings[id]=nil; SendGuild("DEL|"..id) end
local function RequestSync()     SendGuild("REQ") end
local function BroadcastConfig() local c=GuildMarketDB.config; SendGuild("CFG|"..c.postRank.."|"..c.deleteRank) end
local function BroadcastMine()   local me=UnitName("player"); for id,e in pairs(GuildMarketDB.listings) do if e.contact==me then Broadcast(id,e) end end end
local function PostListing(etype,item,amount,note,link,pg,ps,pk,pfree,ptype,beruf,mats)
    local me=UnitName("player"); local now=time(); local id=me.."-"..now
    local itemId=link and tonumber(link:match("|Hitem:(%d+)"))
    local e={type=etype,item=item,amount=amount,note=note,contact=me,expires=now+EXPIRE_SECS,link=link,itemId=itemId,
             priceG=pg,priceS=ps,priceK=pk,priceFree=pfree,priceType=ptype,beruf=beruf,mats=mats}
    GuildMarketDB.listings[id]=e; Broadcast(id,e); return id
end

-- ============================================================
-- Hilfsfunktionen
-- ============================================================
local function FormatExpiry(ts)
    local d=ts-time(); if d<=0 then return R.."abgel."..X end
    local days=math.floor(d/86400); if days>0 then return Dg..days.."T"..X end
    local hrs=math.floor(d/3600); if hrs>0 then return Dg..hrs.."h"..X end
    return Dg.."<1h"..X
end
local function GetLinkColor(link)
    if not link then return 1,1,1 end
    local hex=link:match("|c(%x%x%x%x%x%x%x%x)"); if not hex then return 1,1,1 end
    return tonumber(hex:sub(3,4),16)/255,tonumber(hex:sub(5,6),16)/255,tonumber(hex:sub(7,8),16)/255
end

-- ============================================================
-- UI Globals
-- ============================================================
local mainFrame,configFrame,listContent,countText,userCountText,rows,ebItem
local hdrFS={}; local postBtn_ref
local addonUsers={}
local secNormal,secDienst
local currentFilter="ALL"; local searchText=""
local postType="BIETE"; local postPriceType="VHB"; local postFree=false; local postBeruf=BERUFE[1]
local postDungeon=DUNGEONS[1][1]  -- lokalisiert: "Wunsch-Dungeon" (DE) / "Custom Dungeon" (EN)
rows={}

-- ============================================================
-- Filter
-- ============================================================
local function GetFilteredListings()
    local out,now={},time(); local st=searchText:lower()
    for id,e in pairs(GuildMarketDB.listings) do
        if e.expires>now and (currentFilter=="ALL" or e.type==currentFilter) then
            local match=st=="" or
                (e.item    and e.item:lower():find(st,1,true)) or
                (e.beruf   and e.beruf:lower():find(st,1,true)) or
                (e.contact and e.contact:lower():find(st,1,true)) or
                (e.mats    and e.mats:lower():find(st,1,true))
            if match then out[#out+1]={id=id,e=e} end
        end
    end
    table.sort(out,function(a,b)
        local ao=IsOnline(a.e.contact) and 1 or 0; local bo=IsOnline(b.e.contact) and 1 or 0
        if ao~=bo then return ao>bo end; return a.e.expires>b.e.expires
    end)
    return out
end
local function GetDraggedItem()
    local iType,itemId=GetCursorInfo(); if iType=="item" and itemId then return GetItemInfo(itemId) end
end

-- ============================================================
-- Backdrop-Hilfsfunktion  (vor BuildInfoFrame benoetigt)
-- ============================================================
local function MakeBg(parent,r,g2,b,a,er,eg2,eb)
    local fr=CreateFrame("Frame",nil,parent,"BackdropTemplate")
    fr:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=10,
        insets={left=3,right=3,top=3,bottom=3}})
    fr:SetBackdropColor(r or 0.06,g2 or 0.06,b or 0.12,a or 0.95)
    fr:SetBackdropBorderColor(er or 0.25,eg2 or 0.25,eb or 0.45,0.8)
    return fr
end

-- ============================================================
-- Info / Regeln-Frame
-- ============================================================
local infoFrame

local RULES = isDE and {
    { G.."1.  Nur echte Angebote"..X,
      "Poste nur Items, Dienste oder Gesuche, die du tatsaechlich anbieten\noder kaufen moechtest. Keine Phantomeintraege oder Spam." },
    { G.."2.  Gildenrabatt"..X,
      "Biete Gildenmitgliedern einen guenstigeren Preis als extern.\nEin kleiner Nachlass zeigt Zusammenhalt und wird geschaetzt." },
    { G.."3.  Ehrlichkeit bei Qualitaet"..X,
      "Beschreibe Items und Leistungen korrekt. Falsche Angaben\n(z.B. falsche Verzauberung, falscher Zustand) sind ein Verstoss." },
    { G.."4.  Kein Betrug"..X,
      "Versuche nie, Gildenmitglieder zu ueberteuern oder zu taeuschen.\nDas Vertrauen in der Gilde ist unser groesstes Gut." },
    { G.."5.  Gilde geht vor"..X,
      "Besteht Bedarf innerhalb der Gilde, haben Gildenmitglieder\nVorrang gegenueber Kaeufen oder Verkaeufen an Externe." },
    { G.."6.  Eintraege aktuell halten"..X,
      "Losche deinen Eintrag sobald das Item vergeben oder der\nDienst erledigt ist. Eintraege laufen nach 7 Tagen ab." },
    { G.."7.  Respektvoller Umgang"..X,
      "Behandle Kaeufer und Verkaeufer so, wie du selbst behandelt\nwerden moechtest. Freundlichkeit ist keine Schwaeche." },
    { G.."8.  Meldepflicht"..X,
      "Unserioses Verhalten bitte umgehend der Gildenleitung\noder einem Offizier melden (Buttons unten)." },
} or {
    { G.."1.  Genuine Listings Only"..X,
      "Only post items, services, or requests you actually intend to offer\nor buy. No placeholder entries or spam." },
    { G.."2.  Guild Discount"..X,
      "Offer guild members a better price than you would to outsiders.\nA small discount shows solidarity and is always appreciated." },
    { G.."3.  Honest Descriptions"..X,
      "Describe items and services accurately. False claims\n(wrong enchant, wrong condition, etc.) are a violation." },
    { G.."4.  No Scamming"..X,
      "Never try to overcharge or deceive fellow guild members.\nTrust within the guild is our most valuable resource." },
    { G.."5.  Guild Members First"..X,
      "When there is demand inside the guild, members have priority\nover external buyers or sellers." },
    { G.."6.  Keep Listings Up to Date"..X,
      "Remove your listing once the item is sold or the service completed.\nListings expire automatically after 7 days." },
    { G.."7.  Be Respectful"..X,
      "Treat buyers and sellers the way you would want to be treated.\nKindness is not a weakness." },
    { G.."8.  Report Misconduct"..X,
      "If you witness dishonest behavior, please report it to the\nguild leadership or an officer (buttons below)." },
}

local function BuildInfoFrame()
    if infoFrame then
        infoFrame:Show(); return
    end

    local f=CreateFrame("Frame","GuildMarketInfoFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(520,540); f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(25)

    f.TitleBg:SetHeight(28)
    local title=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    title:SetPoint("CENTER",f.TitleBg,"CENTER",0,2)
    title:SetText(G.."Gildenmarkt — "..L.TT_RULES..X)

    -- ScrollFrame fuer Regeltext
    local sf=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,-6)
    sf:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-26,160)

    local sc=CreateFrame("Frame",nil,sf); sc:SetWidth(470); sc:SetHeight(10); sf:SetScrollChild(sc)

    -- Einleitung
    local intro=sc:CreateFontString(nil,"OVERLAY","GameFontNormal")
    intro:SetPoint("TOPLEFT",sc,"TOPLEFT",4,-4); intro:SetWidth(462); intro:SetJustifyH("LEFT")
    local gn=GetGuildInfo("player") or (isDE and "deiner Gilde" or "your guild")
    intro:SetText(T..L.INFO_INTRO1.." \""..gn.."\"!"..X.."\n\n"
        ..W..L.INFO_INTRO2..X)

    local yOff=-60
    for _,rule in ipairs(RULES) do
        local hdr=sc:CreateFontString(nil,"OVERLAY","GameFontNormal")
        hdr:SetPoint("TOPLEFT",sc,"TOPLEFT",4,yOff); hdr:SetWidth(462); hdr:SetJustifyH("LEFT")
        hdr:SetText(rule[1]); yOff=yOff-18

        local body=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        body:SetPoint("TOPLEFT",sc,"TOPLEFT",14,yOff); body:SetWidth(448); body:SetJustifyH("LEFT")
        body:SetText(Dg..rule[2]..X); yOff=yOff-28
        local bodyH=select(2,body:GetFont()) -- approx line height
        -- Dynamische Hoehe schaetzen: 2 Zeilen = 28, sonst mehr
        local lines=select(2,(rule[2]):gsub("\n","")) + 1
        yOff=yOff-(lines>2 and 8 or 0)
    end
    sc:SetHeight(math.abs(yOff)+20)

    -- Trennlinie
    local sep=f:CreateTexture(nil,"BACKGROUND")
    sep:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,158)
    sep:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,158)
    sep:SetHeight(2); sep:SetColorTexture(0.3,0.5,0.8,0.8)

    -- Kontakt-Sektion
    -- ── Kontakt-Sektion (scrollbar) ─────────────────────────
    local contTitle=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    contTitle:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,158)
    contTitle:SetText(R.."Unserioes? Melde dich bei der Gildenleitung:"..X)

    local contBg=MakeBg(f,0.05,0.05,0.12,0.95,0.2,0.2,0.45)
    contBg:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,34)
    contBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,34)
    contBg:SetPoint("TOPLEFT",f.InsetBg,"BOTTOMLEFT",4,156)

    -- ScrollFrame fuer die Personenliste
    local csf=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    csf:SetPoint("TOPLEFT", contBg,"TOPLEFT",  4,-4)
    csf:SetPoint("BOTTOMRIGHT",contBg,"BOTTOMRIGHT",-24,4)
    local csc=CreateFrame("Frame",nil,csf); csc:SetWidth(460); csc:SetHeight(20); csf:SetScrollChild(csc)

    -- Hilfsfunktion: eine Person-Zeile im ScrollContent
    local rowY = 0
    local function PersonRow(rankLabel, rankColor, name)
        -- Zebra-Hintergrund
        local rowBg=csc:CreateTexture(nil,"BACKGROUND"); rowBg:SetHeight(26)
        rowBg:SetPoint("TOPLEFT",csc,"TOPLEFT",0,-rowY)
        rowBg:SetPoint("TOPRIGHT",csc,"TOPRIGHT",0,-rowY)
        if (rowY/26)%2==0 then rowBg:SetColorTexture(0.08,0.08,0.18,0.7)
        else rowBg:SetColorTexture(0.05,0.05,0.12,0.5) end

        local lbRank=csc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbRank:SetPoint("TOPLEFT",csc,"TOPLEFT",6,-rowY-5)
        lbRank:SetText(rankColor..rankLabel..X); lbRank:SetSize(110,16)

        local lbName=csc:CreateFontString(nil,"OVERLAY","GameFontNormal")
        lbName:SetPoint("TOPLEFT",csc,"TOPLEFT",122,-rowY-5)
        lbName:SetText(W..name..X); lbName:SetSize(180,16)

        local dot=csc:CreateTexture(nil,"OVERLAY"); dot:SetSize(16,16)
        dot:SetPoint("TOPLEFT",csc,"TOPLEFT",306,-rowY-5)
        local online=IsOnline(name)
        local function UpdateDot()
            if IsOnline(name) then
                dot:SetTexture("Interface\\FriendsFrame\\StatusIcon-Online")
                dot:SetVertexColor(1,1,1,1)
                lbName:SetTextColor(1,1,1,1)
            else
                dot:SetTexture("Interface\\FriendsFrame\\StatusIcon-Offline")
                dot:SetVertexColor(1,1,1,0.35)
                lbName:SetTextColor(0.5,0.5,0.5,1)
            end
        end
        UpdateDot(); f:HookScript("OnShow",UpdateDot)

        local whisperBtn=CreateFrame("Button",nil,csc,"UIPanelButtonTemplate")
        whisperBtn:SetSize(100,20); whisperBtn:SetPoint("TOPLEFT",csc,"TOPLEFT",328,-rowY-3)
        if not online then whisperBtn:SetAlpha(0.5) end
        whisperBtn:SetText(L.INFO_WHISPER)
        whisperBtn:SetScript("OnClick",function() OpenWhisper(name) end)
        whisperBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:ClearLines(); GameTooltip:AddLine(T.."/w "..name..X); GameTooltip:Show() end)
        whisperBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)

        rowY=rowY+26
        csc:SetHeight(rowY)
    end

    -- Gildenleitung + Offiziere aus dem Roster
    local function PopulateLeadership()
        local gm,officers={},{}
        local total=GetNumGuildMembers and GetNumGuildMembers() or 0
        for i=1,total do
            local name,_,rankIdx=GetGuildRosterInfo(i)
            if name then
                local sn=name:match("^([^%-]+)") or name
                if rankIdx==0 then gm[#gm+1]=sn
                elseif rankIdx==1 then officers[#officers+1]=sn end
            end
        end
        if #gm==0 and #officers==0 then
            local hint=csc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            hint:SetPoint("TOPLEFT",csc,"TOPLEFT",8,-6)
            hint:SetText(Dg.."Roster noch nicht geladen — bitte Sync / Roster neu laden."..X)
            csc:SetHeight(26); return
        end
        -- Online zuerst sortieren
        local function SortOnlineFirst(list)
            table.sort(list,function(a,b)
                local ao=IsOnline(a) and 1 or 0
                local bo=IsOnline(b) and 1 or 0
                if ao~=bo then return ao>bo end
                return a<b
            end)
        end
        SortOnlineFirst(gm); SortOnlineFirst(officers)
        for _,n in ipairs(gm)      do PersonRow(L.INFO_GM,      G,n) end
        for _,n in ipairs(officers) do PersonRow(L.INFO_OFFICER, T,n) end
    end
    PopulateLeadership()

    -- Schliessen-Button
    local closeBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    closeBtn:SetSize(120,22); closeBtn:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-8,6)
    closeBtn:SetText(isDE and "Schliessen" or "Close"); closeBtn:SetScript("OnClick",function() f:Hide() end)

    local reloadBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    reloadBtn:SetSize(140,22); reloadBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,6)
    reloadBtn:SetText(L.INFO_ROSTER)
    reloadBtn:SetScript("OnClick",function()
        if GuildRoster then GuildRoster() end
        UpdateRoster()
        f:Hide(); infoFrame=nil; BuildInfoFrame()
    end)

    infoFrame=f
end

-- ============================================================
-- Config-Frame
-- ============================================================
local function BuildConfigFrame()
    if configFrame then configFrame:Show(); return end
    local f=CreateFrame("Frame","GuildMarketConfigFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(380,230); f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(20); f:Hide()
    f.TitleBg:SetHeight(26)
    local title=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    title:SetPoint("CENTER",f.TitleBg,"CENTER",0,1); title:SetText(G.."GuildMarket "..X..Dg.."Einstellungen"..X)
    local hint=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hint:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-8); hint:SetWidth(350)
    local function RankDD(name,x,y,getV,setV,lbl)
        local l=f:CreateFontString(nil,"OVERLAY","GameFontNormal"); l:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",x,y); l:SetText(lbl)
        local dd=CreateFrame("Frame","GuildMarketDD_"..name,f,"UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",x-14,y-18); UIDropDownMenu_SetWidth(dd,220)
        function dd:Refresh()
            local rn,num=GetRankNames()
            UIDropDownMenu_Initialize(dd,function(_,lv)
                for i=0,num-1 do local info=UIDropDownMenu_CreateInfo(); info.text="["..i.."] "..(rn[i] or "Rang "..i); info.value=i; info.checked=(getV()==i)
                    info.func=function(btn) setV(btn.value); UIDropDownMenu_SetSelectedValue(dd,btn.value); UIDropDownMenu_SetText(dd,"["..btn.value.."] "..(rn[btn.value] or "")) end
                    UIDropDownMenu_AddButton(info,lv) end
            end)
            local c=getV(); UIDropDownMenu_SetSelectedValue(dd,c); UIDropDownMenu_SetText(dd,"["..c.."] "..(rn[c] or "Rang "..c))
        end; return dd
    end
    local ddP=RankDD("Post",8,-34,function() return GuildMarketDB.config.postRank end,function(v) GuildMarketDB.config.postRank=v end,G.."Posten erlaubt ab Rang:"..X)
    local ddD=RankDD("Del",8,-96,function() return GuildMarketDB.config.deleteRank end,function(v) GuildMarketDB.config.deleteRank=v end,G.."Fremde Eintraege loeschen ab Rang:"..X)
    local i2=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); i2:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-164); i2:SetText(Dg.."Rang 0 = Gildenmeister  (niedrigere Zahl = hoehere Position)"..X)
    local sB=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); sB:SetSize(160,26); sB:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,12); sB:SetText("Speichern & Sync")
    sB:SetScript("OnClick",function() if not IsGM() then print(R.."[GuildMarkt]"..X.." Nur GM."); return end; BroadcastConfig(); print(T.."[GuildMarkt]"..X.." Gespeichert."); f:Hide() end)
    local cB=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); cB:SetSize(80,26); cB:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",176,12); cB:SetText("Schliessen"); cB:SetScript("OnClick",function() f:Hide() end)
    f:SetScript("OnShow",function()
        if not IsGM() then sB:Disable(); hint:SetText(R.."Nur der Gildenmeister kann aendern."..X)
        else sB:Enable(); hint:SetText(Dg.."Einstellungen werden per Sync verteilt."..X) end
        ddP:Refresh(); ddD:Refresh()
    end)
    configFrame=f; f:Show()
end

-- ============================================================
-- Zeilen-Rendering
-- ============================================================
local function GetExtraW() if not listContent then return 0 end; return math.max(0,listContent:GetWidth()-ROW_W) end

local function RefreshPostButton()
    if not postBtn_ref then return end
    if CanPost() then postBtn_ref:Enable(); postBtn_ref:SetText("Eintrag posten")
    else postBtn_ref:Disable(); postBtn_ref:SetText("Kein Zugriff")
        local rn=GetRankNames(); local nd=rn[GuildMarketDB.config.postRank or 9] or "?"
        postBtn_ref:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:ClearLines(); GameTooltip:AddLine(R.."Kein Zugriff"..X); GameTooltip:AddLine(Dg.."Benoetigt: "..X..G..nd..X); GameTooltip:Show() end)
        postBtn_ref:SetScript("OnLeave",function() GameTooltip:Hide() end)
    end
end

local function UpdateHeaders()
    local extra=GetExtraW()
    for key,fs in pairs(hdrFS) do
        local col=COL[key]; if col then
            fs:ClearAllPoints()
            local sx=(key=="type" or key=="item" or key=="icon") and col.x or (col.x+extra)
            fs:SetPoint("TOPLEFT",mainFrame.InsetBg,"TOPLEFT",sx+2,-76)
            fs:SetSize(key=="item" and (col.w+extra) or col.w,16)
        end
    end
end

local function RefreshList()
    if not listContent then return end
    for _,r in ipairs(rows) do r:Hide() end
    local listings=GetFilteredListings()
    local me=UnitName("player"); local y=0
    local extra=GetExtraW(); local curW=ROW_W+extra

    if countText then
        local total,su,bi,di=0,0,0,0; local now=time()
        for _,e in pairs(GuildMarketDB.listings) do
            if e.expires>now then total=total+1
                if e.type=="SUCHE" then su=su+1 elseif e.type=="DIENST" then di=di+1 else bi=bi+1 end
            end
        end
        countText:SetText(Dg..total.."  "..Gr..bi.."B"..X.."  "..Y..su.."S"..X.."  "..Pu..di.."D"..X)
    end
    UpdateHeaders()

    for i,item in ipairs(listings) do
        local e,id=item.e,item.id; local online=IsOnline(e.contact)

        if not rows[i] then
            local row=CreateFrame("Button",nil,listContent); row:SetSize(curW,ROW_H)
            local bg=row:CreateTexture(nil,"BACKGROUND"); bg:SetAllPoints(); row.bg=bg
            local hl=row:CreateTexture(nil,"HIGHLIGHT"); hl:SetAllPoints(); hl:SetColorTexture(0.8,0.8,1,0.06); row:SetHighlightTexture(hl)
            local border=CreateFrame("Frame",nil,row,"BackdropTemplate"); border:SetAllPoints()
            border:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=10})
            border:SetBackdropBorderColor(0.4,0.8,1,0); border:SetFrameLevel(row:GetFrameLevel()+1); row.border=border

            -- Item-Icon
            local iconTex=row:CreateTexture(nil,"ARTWORK"); iconTex:SetSize(16,16); row.iconTex=iconTex

            local function MakeFS(font,jh) local fs=row:CreateFontString(nil,"OVERLAY",font or "GameFontNormalSmall"); fs:SetJustifyH(jh or "LEFT"); return fs end
            row.fType=MakeFS(); row.fItem=MakeFS("GameFontNormal"); row.fMenge=MakeFS(nil,"CENTER")
            row.fPrice=MakeFS(); row.fContact=MakeFS(); row.fExp=MakeFS(nil,"RIGHT")

            local obtn=CreateFrame("Button",nil,row); obtn:SetSize(20,ROW_H)
            local dotTex=obtn:CreateTexture(nil,"OVERLAY"); dotTex:SetSize(14,14); dotTex:SetPoint("CENTER",obtn,"CENTER",0,0)
            dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Online")
            row.onlineBtn=obtn; row.dotTex=dotTex

            local del=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); del:SetSize(24,18); del:SetText("X"); del:Hide(); row.del=del
            rows[i]=row
        end

        local row=rows[i]; row:SetWidth(curW)

        -- Spalten neu ankern
        local function Anc(fs,col,w)
            fs:ClearAllPoints()
            local sx=(col==COL.type or col==COL.item or col==COL.icon) and col.x or (col.x+extra)
            fs:SetPoint("LEFT",row,"LEFT",sx,0); fs:SetSize(w or col.w,ROW_H)
        end
        row.iconTex:ClearAllPoints(); row.iconTex:SetPoint("LEFT",row,"LEFT",COL.icon.x,0)
        Anc(row.fType,COL.type); Anc(row.fItem,COL.item,COL.item.w+extra)
        Anc(row.fMenge,COL.menge); Anc(row.fPrice,COL.price); Anc(row.fContact,COL.contact); Anc(row.fExp,COL.expiry)
        row.onlineBtn:ClearAllPoints(); row.onlineBtn:SetPoint("LEFT",row,"LEFT",COL.online.x+extra,0)
        row.del:ClearAllPoints(); row.del:SetPoint("RIGHT",row,"RIGHT",-2,0)

        -- Farben
        if e.type=="DIENST" then
            if i%2==0 then row.bg:SetColorTexture(0.12,0.06,0.18,0.85) else row.bg:SetColorTexture(0.08,0.04,0.12,0.70) end
        elseif online then
            if i%2==0 then row.bg:SetColorTexture(0.06,0.14,0.08,0.85) else row.bg:SetColorTexture(0.04,0.10,0.05,0.70) end
        else
            if i%2==0 then row.bg:SetColorTexture(0.10,0.10,0.20,0.80) else row.bg:SetColorTexture(0.05,0.05,0.12,0.55) end
        end

        -- Icon
        local icon
        if e.type=="DIENST" then
            icon=BERUF_ICONS[e.beruf] or "Interface\\Icons\\INV_Misc_Note_01"
        elseif e.itemId then
            icon=select(10,GetItemInfo(e.itemId))
        end
        if icon then row.iconTex:SetTexture(icon); row.iconTex:Show()
        else row.iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark"); row.iconTex:Show() end

        row.fType:SetText(Clr(e.type))

        -- Item-Name
        local link=e.link
        if not link and e.itemId then link=select(2,GetItemInfo(e.itemId)); if link then e.link=link end end
        local dispName
        if e.type=="DIENST" then
            dispName=(e.beruf and e.beruf~="" and (Pu..e.beruf..X..Dg..":"..X.." ") or "")..(W..(e.item or "")..X)
        elseif link then
            local r2,g2,b2=GetLinkColor(link)
            dispName=string.format("|cff%02x%02x%02x%s|r",r2*255,g2*255,b2*255,e.item or "")
        else
            dispName=W..(e.item or "")..X
        end
        row.fItem:SetText(dispName)

        local amt=tonumber(e.amount) or 0
        row.fMenge:SetText(amt>0 and (G..amt..X) or "")
        row.fPrice:SetText(FormatPriceShort(e.priceG,e.priceS,e.priceK,e.priceFree,e.priceType))
        row.fContact:SetText(T..(e.contact or "")..X)
        row.fExp:SetText(FormatExpiry(e.expires))

        -- Online-Dot
        if online then
            row.dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Online"); row.dotTex:SetVertexColor(1,1,1,1)
            row.onlineBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines(); GameTooltip:AddLine("|cff00ff44"..e.contact..(isDE and " ist online" or " is online").."|r"); GameTooltip:AddLine(Dg..(isDE and "Klicken zum Fluestern" or "Click to whisper")..X); GameTooltip:Show() end)
            row.onlineBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick",function() OpenWhisper(e.contact) end)
        else
            row.dotTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-Offline"); row.dotTex:SetVertexColor(1,1,1,0.4)
            row.onlineBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines(); GameTooltip:AddLine(Dg..e.contact..(isDE and " ist offline" or " is offline")..X); GameTooltip:Show() end)
            row.onlineBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
            row.onlineBtn:SetScript("OnClick",nil)
        end

        -- Tooltip
        row:SetScript("OnEnter",function(self)
            self.border:SetBackdropBorderColor(0.4,0.8,1,0.8)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
            if e.type=="DIENST" then
                GameTooltip:AddLine(Pu..(e.beruf or "Dienst")..X)
                GameTooltip:AddLine(W..(e.item or "")..X)
                if (e.mats or "")~="" then GameTooltip:AddLine(" "); GameTooltip:AddLine(G..L.TT_NEEDED..X)
                    for part in (e.mats..","):gmatch("([^,]+),") do local p=part:match("^%s*(.-)%s*$"); if p~="" then GameTooltip:AddLine("  "..Dg..p..X) end end
                end
            else
                local ttLink=e.link or (e.itemId and select(2,GetItemInfo(e.itemId)))
                if ttLink then pcall(GameTooltip.SetHyperlink,GameTooltip,ttLink) else GameTooltip:AddLine(e.item or "",1,1,0) end
            end
            GameTooltip:AddLine(" ")
            local pl,pt=FormatPriceLong(e.priceG,e.priceS,e.priceK,e.priceFree,e.priceType)
            GameTooltip:AddLine(pl.."  "..pt)
            if amt>0 then GameTooltip:AddLine(Dg..L.TT_AMOUNT..X..G..amt..X) end
            if (e.note or "")~="" then GameTooltip:AddLine(" "); GameTooltip:AddLine('"'..e.note..'"',1,1,1,true) end
            GameTooltip:AddLine(" "); GameTooltip:AddLine(Dg..L.TT_CONTACT..X..T..(e.contact or "")..X)
            GameTooltip:AddLine(Dg..L.TT_EXPIRES..X..FormatExpiry(e.expires)); GameTooltip:Show()
        end)
        row:SetScript("OnLeave",function(self) self.border:SetBackdropBorderColor(0.4,0.8,1,0); GameTooltip:Hide() end)

        if CanDeleteEntry(e) then
            row.del:Show(); row.del:SetScript("OnClick",function() DeleteListing(id); RefreshList() end)
            if e.contact~=me then row.del:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines(); GameTooltip:AddLine(R..L.TT_DELETE..X); GameTooltip:AddLine(Dg..L.TT_FROM..X..T..(e.contact or "")..X); GameTooltip:Show() end); row.del:SetScript("OnLeave",function() GameTooltip:Hide() end) end
        else row.del:Hide() end

        row:SetPoint("TOPLEFT",listContent,"TOPLEFT",0,-y); row:Show(); y=y+ROW_H
    end

    listContent:SetHeight(math.max(y,20))
    if not listContent.empty then
        listContent.empty=listContent:CreateFontString(nil,"OVERLAY","GameFontNormal")
        listContent.empty:SetPoint("CENTER",listContent,"TOP",0,-80); listContent.empty:SetJustifyH("CENTER")
    end
    if #listings==0 then
        local msg=searchText~="" and (Dg..L.EMPTY_SEARCH..searchText..'"'..X) or Dg..L.EMPTY_LIST..X
        listContent.empty:SetText(msg); listContent.empty:Show()
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
    f:SetScript("OnSizeChanged",function(self,w,h) if w<MIN_W then self:SetWidth(MIN_W) end; if h<MIN_H then self:SetHeight(MIN_H) end end)
    f:Hide()

    -- Titel
    f.TitleBg:SetHeight(28)
    local title=f:CreateFontString(nil,"OVERLAY","GameFontHighlightLarge")
    title:SetPoint("CENTER",f.TitleBg,"CENTER",0,2)
    title:SetText(G.."Gildenmarkt"..X.."  "..T..guildName..X)
    local sub=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    sub:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-5); sub:SetText(Dg.."by MichaModus  •  /gmarkt"..X)

    local cfgBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    cfgBtn:SetSize(30,20); cfgBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-4)
    cfgBtn:SetText("cfg"); cfgBtn:SetScript("OnClick",BuildConfigFrame)

    local infoBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    infoBtn:SetSize(22,20); infoBtn:SetPoint("RIGHT",cfgBtn,"LEFT",-4,0)
    infoBtn:SetText("?")
    infoBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_BOTTOM"); GameTooltip:ClearLines(); GameTooltip:AddLine(G.."Marktplatz-Regeln & Kontakt"..X); GameTooltip:Show() end)
    infoBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    infoBtn:SetScript("OnClick",BuildInfoFrame)

    local grip=CreateFrame("Button",nil,f); grip:SetSize(16,16); grip:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-2,2)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown",function(self,btn) if btn=="LeftButton" then f:StartSizing("BOTTOMRIGHT") end end)
    grip:SetScript("OnMouseUp",function() f:StopMovingOrSizing() end)

    -- ══ Tab-Leiste ══
    local tabBg=MakeBg(f,0.06,0.06,0.12,0.9,0.2,0.2,0.4)
    tabBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-20)
    tabBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-20); tabBg:SetHeight(28)

    local function Tab(label,filter,x,w)
        local b=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
        b:SetSize(w or 80,22); b:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",x,-24); b:SetText(label)
        b:SetScript("OnClick",function() currentFilter=filter; RefreshList() end)
    end
    Tab(L.TAB_ALL,"ALL",8,70); Tab(L.TAB_WTB,"SUCHE",82,70); Tab(L.TAB_WTS,"BIETE",156,70); Tab(L.TAB_SVC,"DIENST",230,70)

    countText=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    countText:SetPoint("LEFT",f.InsetBg,"TOPLEFT",310,-32)

    userCountText=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    userCountText:SetPoint("RIGHT",f.InsetBg,"TOPRIGHT",-42,-32)
    userCountText:SetText(G.."1"..X..Dg.." "..L.COUNT_USERS..X)

    local syncBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    syncBtn:SetSize(80,22); syncBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-38,-24)
    syncBtn:SetText(L.BTN_SYNC); syncBtn:SetScript("OnClick",function() if GuildRoster then GuildRoster() end; RequestSync(); print(T.."[GuildMarkt]"..X.." "..L.MSG_SYNC) end)

    -- ══ Such-Leiste ══
    local searchBg=MakeBg(f,0.04,0.04,0.10,0.9,0.2,0.4,0.6)
    searchBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-52)
    searchBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-52); searchBg:SetHeight(26)

    local searchIcon=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    searchIcon:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-58); searchIcon:SetText(Dg..L.TT_SEARCH..X)

    local ebSearch=CreateFrame("EditBox","GuildMarketSearchBox",f,"InputBoxTemplate")
    ebSearch:SetSize(350,18); ebSearch:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",58,-58)
    ebSearch:SetAutoFocus(false); ebSearch:SetMaxLetters(40)
    ebSearch:SetScript("OnTextChanged",function(self) searchText=self:GetText(); RefreshList() end)
    ebSearch:SetScript("OnEscapePressed",function(self) self:SetText(""); searchText=""; RefreshList() end)

    local clearSearch=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    clearSearch:SetSize(50,18); clearSearch:SetPoint("LEFT",ebSearch,"RIGHT",4,0)
    clearSearch:SetText("X"); clearSearch:SetScript("OnClick",function() ebSearch:SetText(""); searchText=""; RefreshList() end)

    -- ══ Header ══
    local hBg=f:CreateTexture(nil,"BACKGROUND")
    hBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-80); hBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-80)
    hBg:SetHeight(18); hBg:SetColorTexture(0.10,0.10,0.24,1)
    local hLine=f:CreateTexture(nil,"BACKGROUND")
    hLine:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-97); hLine:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-97)
    hLine:SetHeight(1); hLine:SetColorTexture(0.3,0.5,0.8,0.5)

    local function Hdr(key,txt,align)
        local col=COL[key]; local fs=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",col.x+2,-81)
        fs:SetSize(col.w,16); fs:SetJustifyH(align or "LEFT"); fs:SetText(G..txt..X); hdrFS[key]=fs
    end
    Hdr("icon",""); Hdr("type",L.HDR_TYPE); Hdr("item",L.HDR_ITEM)
    Hdr("menge",L.HDR_AMOUNT,"CENTER"); Hdr("price",L.HDR_PRICE); Hdr("contact",L.HDR_CONTACT)
    Hdr("online",L.HDR_ONLINE,"CENTER"); Hdr("expiry",L.HDR_EXPIRY,"RIGHT")

    -- ══ ScrollFrame ══
    local sf=CreateFrame("ScrollFrame","GuildMarketScroll",f,"UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-98)
    sf:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-22,288)
    local content=CreateFrame("Frame",nil,sf)
    content:SetWidth(ROW_W); content:SetHeight(20); sf:SetScrollChild(content)
    listContent=content
    sf:SetScript("OnSizeChanged",function(self) local nw=math.max(self:GetWidth()-18,ROW_W); listContent:SetWidth(nw); if mainFrame and mainFrame:IsShown() then RefreshList() end end)

    -- Trennlinie Formular
    local div=f:CreateTexture(nil,"BACKGROUND")
    div:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,286); div:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,286)
    div:SetHeight(2); div:SetColorTexture(0.3,0.5,0.8,0.8)

    -- ══════════════════════════════════════════
    -- FORMULAR  (Koordinaten: alle y von InsetBg BOTTOMLEFT nach oben)
    --
    --  y=  8  Footer 2
    --  y= 22  Footer 1
    --  y= 44  Buttons  (h=28 → top 72)
    --  y= 76  ── notizBg ──────────────── (h=40 → top 116)
    --  y= 80  ebNote box                  (h=22 → top 102)
    --  y=104  "Notiz:" label
    --  y=116  ── preisBg ──────────────── (h=50 → top 166)
    --  y=120  G/S/K boxes + freeBtn + FP/VHB dropdown  (h=22 → top 142)
    --  y=144  coin-labels + "Preis:"
    --  y=166  ── itemBg ───────────────── (h=100 → top 266)
    --  y=172  ebMats (DIENST Zeile 2)     (h=22 → top 194)
    --  y=196  "Mats:"-label
    --  y=200  ebItem / ebLeist + ddBeruf  (h=22 → top 222)  ← gleiche Y wie ddType
    --  y=224  field-labels ("Item...", "Beruf:", "Leistung:")
    --  y=238  "Typ:"-label / ddType button (h=22 → top 260)
    --  y=248  "Neuer Eintrag" heading
    -- ══════════════════════════════════════════

    -- Footer
    local ft =f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); ft:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,22); ft:SetText(Dg..L.FOOTER1..X)
    local ft2=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); ft2:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8, 8); ft2:SetText("|cff3a3a4aGuildMarket — "..guildName.."  •  by MichaModus|r")

    -- ── Buttons ──────────────────────────────── y=44
    local postBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    postBtn:SetSize(150,28); postBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,44); postBtn:SetText(L.BTN_POST)
    postBtn_ref=postBtn

    local clearBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    clearBtn:SetSize(190,28); clearBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",166,44); clearBtn:SetText(L.BTN_CLEAR)
    clearBtn:SetScript("OnClick",function()
        local me2,n=UnitName("player"),0
        for id,e in pairs(GuildMarketDB.listings) do if e.contact==me2 then DeleteListing(id); n=n+1 end end
        RefreshList(); print(T.."[GuildMarkt]"..X.." "..n.." "..L.MSG_DELETED)
    end)

    -- ── Notiz ────────────────────────────────── bg y=76..116
    local notizBg=MakeBg(f,0.04,0.04,0.10,0.92,0.15,0.15,0.35)
    notizBg:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT",4, 101)
    notizBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,101); notizBg:SetHeight(40)
    local lbNote=notizBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbNote:SetPoint("TOPLEFT",notizBg,"TOPLEFT",6,-6); lbNote:SetText(Dg..L.LBL_NOTE..X)
    local ebNote=CreateFrame("EditBox","GuildMarketNoteBox",f,"InputBoxTemplate")
    ebNote:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT",116, 105)
    ebNote:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT", -10, 105)
    ebNote:SetHeight(22); ebNote:SetAutoFocus(false); ebNote:SetMaxLetters(55)

    -- ── Preis ────────────────────────────────── bg y=116..166
    local preisBg=MakeBg(f,0.06,0.05,0.08,0.95,0.38,0.28,0.08)
    preisBg:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT",4,141)
    preisBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,141); preisBg:SetHeight(50)

    local lbPreis=preisBg:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbPreis:SetPoint("TOPLEFT",preisBg,"TOPLEFT",6,-6); lbPreis:SetText(G..L.LBL_PRICE..X)

    -- Coin-Felder: Label oben, Box unten (TOPLEFT von preisBg)
    local function CoinF(lbl,color,bx)
        local l=preisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        l:SetPoint("TOPLEFT",preisBg,"TOPLEFT",bx-4,-6); l:SetText(color..lbl..X)
        local eb=CreateFrame("EditBox","GuildMarketEB_"..lbl,f,"InputBoxTemplate")
        eb:SetSize(72,22); eb:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",bx,145)
        eb:SetAutoFocus(false); eb:SetMaxLetters(6); eb:SetNumeric(true)
        return eb
    end
    local ebGold=CoinF(L.LBL_GOLD,Cg,56); local ebSilber=CoinF(L.LBL_SILVER,Cs,150); local ebKupfer=CoinF(L.LBL_COPPER,Ck,254)

    local freeBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    freeBtn:SetSize(90,22); freeBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",346,145); freeBtn:SetText(L.BTN_FREE_N)
    freeBtn:SetScript("OnClick",function()
        postFree=not postFree
        if postFree then freeBtn:SetText(L.BTN_FREE_Y); ebGold:Disable(); ebSilber:Disable(); ebKupfer:Disable()
        else freeBtn:SetText(L.BTN_FREE_N); ebGold:Enable(); ebSilber:Enable(); ebKupfer:Enable() end
    end)

    -- FP/VHB: Label y=144, Button y=120
    local lbPType=preisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbPType:SetPoint("TOPLEFT",preisBg,"TOPLEFT",444,-6); lbPType:SetText(Dg..L.LBL_PTYPE..X)
    local ddPType=CreateFrame("Frame","GuildMarketDDPType",f,"UIDropDownMenuTemplate")
    ddPType:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",434,146); UIDropDownMenu_SetWidth(ddPType,110)
    UIDropDownMenu_Initialize(ddPType,function(_,level)
        for _,pair in ipairs({{L.PT_FIXED,"FP"},{L.PT_NEG,"VHB"}}) do
            local info=UIDropDownMenu_CreateInfo(); info.text=pair[1]; info.value=pair[2]; info.checked=(postPriceType==pair[2])
            info.func=function(btn) postPriceType=btn.value; UIDropDownMenu_SetSelectedValue(ddPType,btn.value); UIDropDownMenu_SetText(ddPType,btn.text) end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddPType,"VHB"); UIDropDownMenu_SetText(ddPType,L.PT_NEG)

    -- ── Eintrag-Sektion ──────────────────────── bg y=166..266
    local itemBg=MakeBg(f,0.05,0.05,0.14,0.95,0.18,0.28,0.50)
    itemBg:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT",4,191)
    itemBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,191); itemBg:SetHeight(95)

    -- Kinder von itemBg → rendern ÜBER dem Backdrop-Rahmen (OVERLAY > BORDER)
    local newLbl=itemBg:CreateFontString(nil,"OVERLAY","GameFontNormal")
    newLbl:SetPoint("TOPLEFT",itemBg,"TOPLEFT",8,-8); newLbl:SetText(G..L.NEW_LISTING..X)

    local lbTyp=itemBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbTyp:SetPoint("TOPLEFT",itemBg,"TOPLEFT",8,-26); lbTyp:SetText(Dg..L.LBL_TYPE..X)

    local ddType=CreateFrame("Frame","GuildMarketDDType",f,"UIDropDownMenuTemplate")
    ddType:SetPoint("TOPLEFT",itemBg,"TOPLEFT",-4,-40)
    UIDropDownMenu_SetWidth(ddType,74)   -- sichtbarer Button = 100px, endet bei x≈110

    -- ── BIETE/SUCHE-Sektion (y=168, h=62) ──────────────────
    local sN=CreateFrame("Frame",nil,f)
    sN:SetPoint("TOPLEFT",itemBg,"TOPLEFT",0,-43); sN:SetSize(660,50); secNormal=sN

    local lbI=sN:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    -- x=120: klar rechts vom Dropdown-Ende (110), mit 10px Luft
    lbI:SetPoint("TOPLEFT",sN,"TOPLEFT",120,-2); lbI:SetText(Dg..L.LBL_ITEM..X)

    ebItem=CreateFrame("EditBox","GuildMarketItemBox",sN,"InputBoxTemplate")
    ebItem:SetSize(418,22); ebItem:SetPoint("TOPLEFT",sN,"TOPLEFT",120,-16)
    ebItem:SetAutoFocus(false); ebItem:SetMaxLetters(40); ebItem.itemLink=nil
    ebItem:SetScript("OnReceiveDrag",function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebItem:SetScript("OnMouseDown",  function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebItem:SetScript("OnTextChanged",function(self) if self.itemLink then local nm=self.itemLink:match("|h%[(.-)%]|h"); if nm~=self:GetText() then self.itemLink=nil end end end)

    local lbMg=sN:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbMg:SetPoint("TOPLEFT",sN,"TOPLEFT",550,-2); lbMg:SetText(Dg..L.LBL_AMOUNT..X)
    local ebAmt=CreateFrame("EditBox","GuildMarketAmtBox",sN,"InputBoxTemplate")
    ebAmt:SetSize(88,22); ebAmt:SetPoint("TOPLEFT",sN,"TOPLEFT",550,-16)
    ebAmt:SetAutoFocus(false); ebAmt:SetMaxLetters(6); ebAmt:SetNumeric(true)

    -- ── DIENST-Sektion (y=200 Zeile1, y=168 Zeile2) ─────────
    local sD=CreateFrame("Frame",nil,f)
    sD:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",0,245); sD:SetSize(660,62); sD:Hide(); secDienst=sD

    -- Zeile 1 Beruf + Leistung
    local lbB=sD:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbB:SetPoint("TOPLEFT",sD,"TOPLEFT",120,-2); lbB:SetText(Dg..L.LBL_PROF..X)

    local ddBeruf=CreateFrame("Frame","GuildMarketDDBeruf",sD,"UIDropDownMenuTemplate")
    ddBeruf:SetPoint("TOPLEFT",sD,"TOPLEFT",106,-14)
    UIDropDownMenu_SetWidth(ddBeruf,130)  -- button ≈ 156px → endet bei x=276
    local lbL=sD:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbL:SetPoint("TOPLEFT",sD,"TOPLEFT",286,-2); lbL:SetText(Dg..L.LBL_SERVICE..X)

    local ebLeist=CreateFrame("EditBox","GuildMarketLeistBox",sD,"InputBoxTemplate")
    ebLeist:SetSize(352,22); ebLeist:SetPoint("TOPLEFT",sD,"TOPLEFT",286,-16)
    ebLeist:SetAutoFocus(false); ebLeist:SetMaxLetters(40); ebLeist.itemLink=nil
    ebLeist:SetScript("OnReceiveDrag",function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebLeist:SetScript("OnMouseDown",  function(self) local n,l=GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)

    -- Dungeon-Dropdown (nur bei Ziehdienst sichtbar)
    local ddDungeon=CreateFrame("Frame","GuildMarketDDDungeon",sD,"UIDropDownMenuTemplate")
    ddDungeon:SetPoint("TOPLEFT",sD,"TOPLEFT",272,-14)
    UIDropDownMenu_SetWidth(ddDungeon,326)  -- button ≈ 352px, passt auf ebLeist-Breite
    ddDungeon:Hide()

    local function RefreshDungeonDD()
        local plvl=UnitLevel("player") or 70
        UIDropDownMenu_Initialize(ddDungeon,function(_,level)
            for _,d in ipairs(DUNGEONS) do
                if plvl>=d[2] then
                    local info=UIDropDownMenu_CreateInfo(); info.text=d[1]; info.value=d[1]
                    info.checked=(postDungeon==d[1])
                    info.func=function(btn) postDungeon=btn.value; UIDropDownMenu_SetSelectedValue(ddDungeon,btn.value); UIDropDownMenu_SetText(ddDungeon,btn.value) end
                    UIDropDownMenu_AddButton(info,level)
                end
            end
        end)
        UIDropDownMenu_SetSelectedValue(ddDungeon,postDungeon); UIDropDownMenu_SetText(ddDungeon,postDungeon)
    end

    local function UpdateDienstFields()
        local carryName = isDE and "Ziehdienst" or "Carry Service"
        if postBeruf==carryName then
            ebLeist:Hide(); ddDungeon:Show(); lbL:SetText(Dg..L.LBL_DUNGEON..X)
            RefreshDungeonDD()
        else
            ddDungeon:Hide(); ebLeist:Show(); lbL:SetText(Dg..L.LBL_SERVICE..X)
        end
    end

    UIDropDownMenu_Initialize(ddBeruf,function(_,level)
        for _,b in ipairs(BERUFE) do
            local info=UIDropDownMenu_CreateInfo(); info.text=b; info.value=b; info.checked=(postBeruf==b)
            info.func=function(btn)
                postBeruf=btn.value; UIDropDownMenu_SetSelectedValue(ddBeruf,btn.value); UIDropDownMenu_SetText(ddBeruf,btn.value)
                UpdateDienstFields()
            end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddBeruf,BERUFE[1]); UIDropDownMenu_SetText(ddBeruf,BERUFE[1])

    -- Zeile 2 Mats (eigener Frame bei y=168)
    local sMats=CreateFrame("Frame",nil,f)
    sMats:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",0,213); sMats:SetSize(660,44); sMats:Hide()
    local lbM=sMats:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbM:SetPoint("TOPLEFT",sMats,"TOPLEFT",120,-4); lbM:SetText(Dg..L.LBL_MATS..X)
    local ebMats=CreateFrame("EditBox","GuildMarketMatsBox",sMats,"InputBoxTemplate")
    ebMats:SetSize(516,22); ebMats:SetPoint("BOTTOMLEFT",sMats,"BOTTOMLEFT",120,4)
    ebMats:SetAutoFocus(false); ebMats:SetMaxLetters(80)

    -- ShowSection: resized itemBg + ScrollFrame dynamisch
    local function ShowSection(typ)
        if typ=="DIENST" then
            sN:Hide(); sD:Show(); sMats:Show()
            itemBg:SetHeight(120)
            sf:ClearAllPoints()
            sf:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-98)
            sf:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-22,313)
            div:ClearAllPoints()
            div:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,311)
            div:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,311)
        else
            sN:Show(); sD:Hide(); sMats:Hide()
            itemBg:SetHeight(95)
            sf:ClearAllPoints()
            sf:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-98)
            sf:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-22,288)
            div:ClearAllPoints()
            div:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,286)
            div:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,286)
        end
    end

    local TYPE_OPTS={{v="BIETE",t=L.TYPE_BIETE},{v="SUCHE",t=L.TYPE_SUCHE},{v="DIENST",t=L.TYPE_DIENST}}
    UIDropDownMenu_Initialize(ddType,function(_,level)
        for _,td in ipairs(TYPE_OPTS) do
            local info=UIDropDownMenu_CreateInfo(); info.text=td.t; info.value=td.v; info.checked=(postType==td.v)
            info.func=function(btn) postType=btn.value; UIDropDownMenu_SetSelectedValue(ddType,btn.value); UIDropDownMenu_SetText(ddType,btn.text); ShowSection(btn.value) end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddType,"BIETE"); UIDropDownMenu_SetText(ddType,L.TYPE_BIETE)
    ShowSection(postType)  -- initiale Anpassung (setzt itemBg-Höhe + sf/div)

    -- ── Post-Button ──────────────────────────────────────────
    postBtn:SetScript("OnClick",function()
        if not CanPost() then print(R.."[GuildMarkt]"..X.." "..L.MSG_NO_ACCESS); return end
        local name,link,beruf,mats,amount
        local carryName = isDE and "Ziehdienst" or "Carry Service"
        if postType=="DIENST" then
            if postBeruf==carryName then
                name=postDungeon; link=nil; beruf=postBeruf; mats=ebMats:GetText(); amount=0
                if not name or name=="" then print(R.."[GuildMarkt]"..X.." "..L.MSG_NO_DGN); return end
            else
                name=ebLeist:GetText(); link=ebLeist.itemLink; beruf=postBeruf; mats=ebMats:GetText(); amount=0
                if name=="" then print(R.."[GuildMarkt]"..X.." "..L.MSG_NO_SVC); return end
            end
        else
            name=ebItem:GetText(); link=ebItem.itemLink; beruf=""; mats=""
            amount=tonumber(ebAmt:GetText()) or 0
            if name=="" then print(R.."[GuildMarkt]"..X.." "..L.MSG_NO_ITEM); return end
        end
        local pg=ebGold:GetText(); local ps=ebSilber:GetText(); local pk=ebKupfer:GetText()
        PostListing(postType,name,amount,ebNote:GetText(),link,pg,ps,pk,postFree and "1" or "0",postPriceType,beruf,mats)
        ebItem:SetText(""); ebItem.itemLink=nil; ebLeist:SetText(""); ebLeist.itemLink=nil
        postDungeon=DUNGEONS[1][1]
        ebGold:SetText(""); ebSilber:SetText(""); ebKupfer:SetText("")
        ebAmt:SetText(""); ebNote:SetText(""); ebMats:SetText("")
        postFree=false; freeBtn:SetText(L.BTN_FREE_N); ebGold:Enable(); ebSilber:Enable(); ebKupfer:Enable()
        RefreshList(); print(T.."[GuildMarkt]"..X.." "..L.MSG_POSTED.." "..Clr(postType).." "..W..name..X)
    end)

    mainFrame=f
end

-- ============================================================
-- Shift+Klick Hook
-- ============================================================
local _origInsertLink=ChatEdit_InsertLink
function ChatEdit_InsertLink(text)
    if ebItem and ebItem:IsVisible() and ebItem:HasFocus() then
        local n=text and text:match("|h%[(.-)%]|h"); if n then ebItem:SetText(n); ebItem.itemLink=text; return true end
    end
    local eL=_G["GuildMarketLeistBox"]
    if eL and eL:IsVisible() and eL:HasFocus() then
        local n=text and text:match("|h%[(.-)%]|h"); if n then eL:SetText(n); eL.itemLink=text; return true end
    end
    return _origInsertLink and _origInsertLink(text)
end

-- ============================================================
-- Timer / Events
-- ============================================================
local function DelayCall(sec,fn)
    local fr,t=CreateFrame("Frame"),0
    fr:SetScript("OnUpdate",function(self,dt) t=t+dt; if t>=sec then self:SetScript("OnUpdate",nil); fn() end end)
end

local ev=CreateFrame("Frame","GuildMarketEventFrame",UIParent)
ev:RegisterEvent("PLAYER_LOGIN"); ev:RegisterEvent("CHAT_MSG_ADDON"); ev:RegisterEvent("GUILD_ROSTER_UPDATE")
ev:SetScript("OnEvent",function(self,event,...)
    if event=="PLAYER_LOGIN" then
        InitDB(); PruneExpired(); if GuildRoster then GuildRoster() end
        local me=UnitName("player"); if me then addonUsers[me]=true end
        DelayCall(6,function() BroadcastMine(); RequestSync() end)
        print(T.."[GuildMarkt]"..X.." "..L.MSG_LOADED.." — "..G.."/gmarkt"..X.." | "..Dg..(GetGuildInfo("player") or "")..X)
    elseif event=="GUILD_ROSTER_UPDATE" then
        UpdateRoster(); if mainFrame and mainFrame:IsShown() then RefreshList() end
    elseif event=="CHAT_MSG_ADDON" then
        local prefix,msg,_,sender=...
        if prefix~=MSG_PREFIX then return end
        local sn=sender:match("^([^%-]+)") or sender; addonUsers[sn]=true
        if userCountText then local n=0; for _ in pairs(addonUsers) do n=n+1 end; userCountText:SetText(G..n..X..Dg.." "..L.COUNT_USERS..X) end
        if msg=="REQ" then BroadcastMine(); return end
        if msg:sub(1,3)=="CFG" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            if p[2] and p[3] then GuildMarketDB.config.postRank=tonumber(p[2]) or 9; GuildMarketDB.config.deleteRank=tonumber(p[3]) or 1
                print(T.."[GuildMarkt]"..X.." "..L.MSG_SETTINGS); if mainFrame and mainFrame:IsShown() then RefreshList() end end; return
        end
        if msg:sub(1,3)=="DEL" then
            local id=msg:sub(5)
            if id and GuildMarketDB.listings[id] then local sN=sender:match("^([^%-]+)") or sender
                if GuildMarketDB.listings[id].contact==sN then GuildMarketDB.listings[id]=nil; if mainFrame and mainFrame:IsShown() then RefreshList() end end end; return
        end
        local action,id,entry=Deserialize(msg)
        if action=="POST" and id and entry then
            entry.contact=sender:match("^([^%-]+)") or sender
            if entry.expires>time() then GuildMarketDB.listings[id]=entry; if mainFrame and mainFrame:IsShown() then RefreshList() end end
        end
    end
end)

-- ============================================================
-- Toggle & Slash
-- ============================================================
local function Toggle()
    if not mainFrame then BuildUI() end
    if mainFrame:IsShown() then mainFrame:Hide()
    else mainFrame:ClearAllPoints(); mainFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
        if GuildRoster then GuildRoster() end; PruneExpired(); RefreshList(); mainFrame:Show()
    end
end
SLASH_GUILDMARKET1="/gmarkt"; SLASH_GUILDMARKET2="/gildenmarkt"
SlashCmdList["GUILDMARKET"]=function(msg)
    if msg=="sync" then RequestSync(); print(T.."[GuildMarkt]"..X.." Sync angefordert.")
    elseif msg=="config" then if not mainFrame then BuildUI() end; BuildConfigFrame()
    else Toggle() end
end
