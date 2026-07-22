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
    -- Kalender / Calendar
    CAL_TAB      = isDE and "Kalender"  or "Calendar",
    CAL_NEW      = isDE and "Neues Event" or "New Event",
    CAL_TITLE    = isDE and "Titel:"    or "Title:",
    CAL_DATE     = isDE and "Datum (TT.MM.JJJJ):"  or "Date (DD.MM.YYYY):",
    CAL_TIME     = isDE and "Uhrzeit (HH:MM):"      or "Time (HH:MM):",
    CAL_DESC     = isDE and "Beschreibung (optional):" or "Description (optional):",
    CAL_CREATE   = isDE and "Event erstellen"   or "Create Event",
    CAL_SIGNUP   = isDE and "Anmelden"          or "Sign up",
    CAL_LEAVE    = isDE and "Abmelden"          or "Leave",
    CAL_DETAIL   = isDE and "Event-Details"     or "Event Details",
    CAL_SIGNUPS  = isDE and "Anmeldungen:"      or "Signups:",
    CAL_NORANKC  = isDE and "Kein Zugriff — nur Offiziere koennen Events erstellen."
                        or  "No access — only officers can create events.",
    CAL_NOTITLE  = isDE and "Bitte Titel eingeben."   or "Please enter a title.",
    CAL_NODATE   = isDE and "Ungültiges Datum. Format: TT.MM.JJJJ" or "Invalid date. Format: DD.MM.YYYY",
    CAL_NOTIME   = isDE and "Ungültige Uhrzeit. Format: HH:MM"     or "Invalid time. Format: HH:MM",
    CAL_PAST     = isDE and "Datum liegt in der Vergangenheit."     or "Date is in the past.",
    CAL_CREATED  = isDE and "Event erstellt:"  or "Event created:",
    CAL_DELETED  = isDE and "Event geloescht." or "Event deleted.",
    CAL_JOINED   = isDE and "Angemeldet fuer:" or "Signed up for:",
    CAL_LEFT     = isDE and "Abgemeldet von:"  or "Left event:",
    CAL_CREATOR  = isDE and "Ersteller: "      or "Creator: ",
    CAL_NOSIGNUP = isDE and "Noch keine Anmeldungen." or "No signups yet.",
    CFG_EVTRANK  = isDE and "Event erstellen ab:" or "Event creation rank:",
    CFG_EVTDELRANK = isDE and "Event loeschen ab:" or "Event delete rank:",
    CAL_CHANGE   = isDE and "Aendern"           or "Change",
    CAL_ROLEFULL = isDE and "Rolle ist voll — Wechsel nicht moeglich." or "Role is full — cannot switch.",
    CAL_CHANGED  = isDE and "Anmeldung geaendert." or "Signup updated.",
    CAL_DELETE   = isDE and "Loeschen"          or "Delete",
    CFG_DKPPER   = isDE and "Punkte-Vorgabe pro Event:" or "Default points per event:",
    CFG_CONFRANK = isDE and "Teilnahme bestaetigen ab:" or "Confirm attendance rank:",
    CFG_GEVTRANK = isDE and "Gilden-Event erstellen ab:" or "Guild event rank:",
    CFG_CFGRANK  = isDE and "Rechte aendern ab:" or "Change settings rank:",
    CFG_NOEDIT   = isDE and "Kein Zugriff — nur der Gildenmeister (oder freigegebener Rang) kann aendern." or "No access — only the guild master (or authorized rank) can change settings.",
    CFG_AUCRANK  = isDE and "Auktion erstellen ab:" or "Auction creation rank:",
    AUC_TITLE    = isDE and "Loot-Auktion"      or "Loot Auction",
    AUC_ITEM     = isDE and "Item (reinziehen):" or "Item (drag here):",
    AUC_MINBID   = isDE and "Mindestgebot:"     or "Min. bid:",
    AUC_DUR      = isDE and "Dauer (Min):"      or "Duration (min):",
    AUC_START    = isDE and "Auktion starten"   or "Start auction",
    AUC_BID      = isDE and "Bieten"            or "Bid",
    AUC_CLOSE    = isDE and "Beenden"           or "End now",
    AUC_TOPBID   = isDE and "Hoechstgebot:"     or "Top bid:",
    AUC_NOBIDS   = isDE and "Keine Gebote"      or "No bids",
    AUC_WON      = isDE and "gewinnt"           or "wins",
    AUC_EXPIRED  = isDE and "Beendet"           or "Ended",
    AUC_EMPTY    = isDE and "Keine Auktionen. Items koennen per Drag&Drop eingestellt werden." or "No auctions. Drag an item to list it.",
    AUC_NOITEM   = isDE and "Bitte ein Item reinziehen."   or "Please drag an item first.",
    AUC_LOWBID   = isDE and "Gebot zu niedrig."            or "Bid too low.",
    AUC_NOPOINTS = isDE and "Nicht genug Punkte."          or "Not enough points.",
    AUC_NORANK   = isDE and "Kein Zugriff — Rang zu niedrig fuer Auktionen." or "No access — rank too low for auctions.",
    AUC_CREATED  = isDE and "Auktion gestartet:"           or "Auction started:",
    AUC_BIDSET   = isDE and "Gebot abgegeben:"             or "Bid placed:",
    AUC_NOWINNER = isDE and "Auktion beendet ohne Gebote:" or "Auction ended without bids:",
    AUC_SELLER   = isDE and "Von:"              or "By:",
    AUC_YOURBID  = isDE and "Dein Gebot"        or "Your bid",
    REMIND_TODAY = isDE and "Heute:"            or "Today:",
    REMIND_SIGNED= isDE and "(angemeldet)"      or "(signed up)",
    DKP_ADJ      = isDE and "Anpassung:"        or "Adjust:",
    DKP_ADJUSTED = isDE and "Punkte angepasst:" or "Points adjusted:",
    MM_LEFT      = isDE and "Links: Marktplatz oeffnen"  or "Left: open marketplace",
    MM_RIGHT     = isDE and "Rechts: Kalender oeffnen"   or "Right: open calendar",
    CFG_DKPADJRANK = isDE and "Punkte anpassen ab:"   or "Adjust points rank:",
    CFG_MERCHRANK  = isDE and "Merch anlegen ab:"     or "Create merch rank:",
    DKP_SEARCH   = isDE and "Suchen..."               or "Search...",
    DKP_ONLINE   = isDE and "Nur Online"              or "Online only",
    MSH_TITLE    = isDE and "Merch-Shop"              or "Merch Shop",
    MSH_ITEM     = isDE and "Artikel (Name/Item):"    or "Item (name/drag):",
    MSH_PRICE    = isDE and "Preis (Punkte):"         or "Price (points):",
    MSH_STOCK    = isDE and "Anzahl (0=unbegrenzt):"  or "Stock (0=unlimited):",
    MSH_CREATE   = isDE and "Anlegen"                 or "Create",
    MSH_BUY      = isDE and "Kaufen"                  or "Buy",
    MSH_SOLDOUT  = isDE and "Ausverkauft"             or "Sold out",
    MSH_EMPTY    = isDE and "Keine Artikel im Shop."  or "No items in the shop.",
    MSH_NOITEM   = isDE and "Bitte Artikel eingeben." or "Please enter an item.",
    MSH_NOPRICE  = isDE and "Bitte Preis angeben."    or "Please enter a price.",
    MSH_NOPOINTS = isDE and "Nicht genug Punkte."     or "Not enough points.",
    MSH_NORANK   = isDE and "Kein Zugriff — Rang zu niedrig fuer den Merch-Shop." or "No access — rank too low for the merch shop.",
    MSH_CREATED  = isDE and "Artikel angelegt:"       or "Item created:",
    MSH_BOUGHT   = isDE and "kauft"                   or "buys",
    MSH_FROM     = isDE and "von"                     or "from",
    MSH_STOCKLBL = isDE and "Bestand:"                or "Stock:",
    MSH_ORDERS   = isDE and "Offene Kaeufe"           or "Pending purchases",
    MSH_CONFIRM  = isDE and "Uebergeben"              or "Delivered",
    MSH_CONFIRMED= isDE and "Kauf bestaetigt:"        or "Purchase confirmed:",
    MSH_PENDING  = isDE and "wartet auf Uebergabe"    or "awaiting delivery",
    CAL_ANNOUNCE = isDE and "Im Gildenchat ankuendigen" or "Announce in guild chat",
    CAL_CHAT_NEW = isDE and "Neues Event: '%s' am %s um %s%s — Anmeldung im Gildenmarkt (/gmarkt)!"
                        or  "New event: '%s' on %s at %s%s — sign up in the guild market (/gmarkt)!",
    CAL_CHAT_REM = isDE and "Erinnerung: '%s' startet um %s (in ca. 1 Stunde)! Anmeldungen: %d — jetzt noch eintragen: /gmarkt"
                        or  "Reminder: '%s' starts at %s (in about 1 hour)! Signups: %d — join now: /gmarkt",
    -- Kontinente + Mindeststufe
    CONT_EK      = isDE and "Dungeons: Oestliche Koenigreiche" or "Dungeons: Eastern Kingdoms",
    CONT_KAL     = isDE and "Dungeons: Kalimdor"               or "Dungeons: Kalimdor",
    CONT_TBC     = isDE and "Dungeons: Scherbenwelt"           or "Dungeons: Outland",
    CAL_MINLVL   = isDE and "Mindeststufe:"                    or "Min. level:",
    CAL_LOWLEVEL = isDE and "Anmeldung nicht moeglich — Mindeststufe %d nicht erreicht." or "Cannot sign up — minimum level %d not met.",
    -- Wiederkehrende Events
    REP_NONE     = isDE and "Einmalig"          or "One-time",
    REP_WEEKLY   = isDE and "Woechentlich"      or "Weekly",
    REP_BIWEEKLY = isDE and "Alle 2 Wochen"     or "Every 2 weeks",
    REP_CREATED  = isDE and "Naechster Termin automatisch angelegt:" or "Next occurrence auto-created:",
    REP_HINT     = isDE and "(wiederholt sich)" or "(recurring)",
    -- Anwesenheit
    DKP_ATT_HDR  = isDE and "Events"            or "Events",
    -- DKP-Verfall
    CFG_DECAYPCT = isDE and "DKP-Verfall in % (0=aus):" or "DKP decay % (0=off):",
    CFG_DECAYDAYS= isDE and "Verfall alle X Tage:"      or "Decay every X days:",
    DECAY_DONE   = isDE and "DKP-Verfall angewendet: -%d%% auf alle Konten." or "DKP decay applied: -%d%% on all balances.",
    -- Berufe-Verzeichnis
    PROF_TITLE   = isDE and "Berufe-Verzeichnis" or "Profession Directory",
    PROF_BTN     = isDE and "Berufe"             or "Profs",
    PROF_EMPTY   = isDE and "Noch keine Berufe erfasst. Berufe werden beim Login automatisch erkannt." or "No professions registered yet. Professions are detected automatically at login.",
    PROF_SEARCH  = isDE and "Suchen..."          or "Search...",
    PROF_RECIPES = isDE and "Rezepte"            or "Recipes",
    PROF_RCP_LOADING = isDE and "Lade Rezepte..." or "Loading recipes...",
    PROF_RCP_NONE = isDE and "%s hat die Rezepte noch nicht erfasst — bitte einmal das Berufsfenster oeffnen." or "%s hasn't scanned recipes yet — please open the profession window once.",
    PROF_RCP_TIMEOUT = isDE and "Keine Antwort — evtl. offline oder ohne Addon." or "No response — offline or without the addon.",
    PROF_RCP_EMPTY = isDE and "Keine Rezepte gefunden." or "No recipes found.",
    PROF_SCAN_HINT = isDE and "Bitte oeffne einmal deine Berufsfenster (%s), damit deine Rezepte gildenweit sichtbar werden." or "Please open your profession windows (%s) once so your recipes become visible guild-wide.",
    PROF_SCANNED = isDE and "Rezepte erfasst: %s (%d)" or "Recipes scanned: %s (%d)",
    -- Schwarzes Brett
    BRD_TITLE    = isDE and "Schwarzes Brett"    or "Guild Board",
    BRD_BTN      = isDE and "Brett"              or "Board",
    BRD_SAVE     = isDE and "Veroeffentlichen"   or "Publish",
    BRD_EMPTY    = isDE and "Keine Ankuendigung vorhanden." or "No announcement.",
    BRD_BY       = isDE and "Von"                or "By",
    BRD_OK       = isDE and "Verstanden"         or "Got it",
    BRD_NORANK   = isDE and "Kein Zugriff — Rang zu niedrig fuer das Schwarze Brett." or "No access — rank too low for the guild board.",
    BRD_POSTED   = isDE and "Ankuendigung veroeffentlicht." or "Announcement published.",
    CFG_BRDRANK  = isDE and "Brett schreiben ab:" or "Board post rank:",
    ETYPE_DUNGEON= isDE and "Dungeon-Event"     or "Dungeon Event",
    ETYPE_GUILD  = isDE and "Gilden-Event"      or "Guild Event",
    CAL_POINTS   = isDE and "Punkte:"           or "Points:",
    CAL_NORANKG  = isDE and "Kein Zugriff — Rang zu niedrig fuer Gilden-Events." or "No access — rank too low for guild events.",
    DKP_TITLE    = isDE and "Gildenpunkte"      or "Guild Points",
    DKP_YOURS    = isDE and "Deine Punkte:"     or "Your points:",
    DKP_EMPTY    = isDE and "Noch keine Punkte vergeben." or "No points awarded yet.",
    DKP_CONFIRM  = isDE and "Teilnahme bestaetigen" or "Confirm attendance",
    DKP_CONFIRMED= isDE and "Bestaetigt"        or "Confirmed",
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

-- { Name, Mindestlevel, Fraktion, Kontinent }
-- Fraktion: "A"=nur Allianz, "H"=nur Horde, "-"=beide
-- Kontinent: "EK"=Oestliche Koenigreiche, "KAL"=Kalimdor, "TBC"=Scherbenwelt/BC (inkl. HdZ + MgT)
local DUNGEONS = isDE and {
    { "Wunsch-Dungeon",             1,  "-", "-"   },
    { "Der Flammenschlund",         13, "H", "KAL" },
    { "Die Hoehlen des Wehklagens", 15, "-", "KAL" },
    { "Die Todesminen",             15, "-", "EK"  },
    { "Burg Schattenfang",          18, "-", "EK"  },
    { "Das Verlies",                22, "A", "EK"  },
    { "Tiefschwarze Grotte",        20, "-", "KAL" },
    { "Der Kral von Razorfen",      25, "-", "KAL" },
    { "Gnomeregan",                 24, "-", "EK"  },
    { "Kloster: Friedhof",          28, "-", "EK"  },
    { "Kloster: Bibliothek",        32, "-", "EK"  },
    { "Kloster: Waffenkammer",      35, "-", "EK"  },
    { "Kloster: Kathedrale",        38, "-", "EK"  },
    { "Die Huegel von Razorfen",    35, "-", "KAL" },
    { "Uldaman",                    40, "-", "EK"  },
    { "Zul'Farrak",                 42, "-", "KAL" },
    { "Maraudon",                   45, "-", "KAL" },
    { "Der Tempel von Atal'Hakkar", 48, "-", "EK"  },
    { "Blackrocktiefen",            50, "-", "EK"  },
    { "Untere Schwarzfelsspitze",   55, "-", "EK"  },
    { "Obere Schwarzfelsspitze",    55, "-", "EK"  },
    { "Duesterbruch",               55, "-", "KAL" },
    { "Scholomance",                55, "-", "EK"  },
    { "Stratholme",                 55, "-", "EK"  },
    { "Hoellenfeuerbollwerk",       58, "-", "TBC" },
    { "Der Blutkessel",             59, "-", "TBC" },
    { "Die Sklavenunterkuenfte",    60, "-", "TBC" },
    { "Der Tiefensumpf",            61, "-", "TBC" },
    { "Die Managruft",              62, "-", "TBC" },
    { "Auchenaikrypta",             63, "-", "TBC" },
    { "Sethekkhallen",              65, "-", "TBC" },
    { "Das Schattenlabyrinth",      68, "-", "TBC" },
    { "Die Zerschmetterten Hallen", 68, "-", "TBC" },
    { "Die Dampfkammer",            68, "-", "TBC" },
    { "Die Botanika",               68, "-", "TBC" },
    { "Die Arkatraz",               68, "-", "TBC" },
    { "Das alte Hillsbrad",         66, "-", "TBC" },
    { "Der Schwarze Morast",        68, "-", "TBC" },
    { "Magisterterrasse",           68, "-", "TBC" },
} or {
    { "Custom Dungeon",             1,  "-", "-"   },
    { "Ragefire Chasm",             13, "H", "KAL" },
    { "Wailing Caverns",            15, "-", "KAL" },
    { "The Deadmines",              15, "-", "EK"  },
    { "Shadowfang Keep",            18, "-", "EK"  },
    { "The Stockade",               22, "A", "EK"  },
    { "Blackfathom Deeps",          20, "-", "KAL" },
    { "Razorfen Kraul",             25, "-", "KAL" },
    { "Gnomeregan",                 24, "-", "EK"  },
    { "Monastery: Graveyard",       28, "-", "EK"  },
    { "Monastery: Library",         32, "-", "EK"  },
    { "Monastery: Armory",          35, "-", "EK"  },
    { "Monastery: Cathedral",       38, "-", "EK"  },
    { "Razorfen Downs",             35, "-", "KAL" },
    { "Uldaman",                    40, "-", "EK"  },
    { "Zul'Farrak",                 42, "-", "KAL" },
    { "Maraudon",                   45, "-", "KAL" },
    { "Sunken Temple",              48, "-", "EK"  },
    { "Blackrock Depths",           50, "-", "EK"  },
    { "Lower Blackrock Spire",      55, "-", "EK"  },
    { "Upper Blackrock Spire",      55, "-", "EK"  },
    { "Dire Maul",                  55, "-", "KAL" },
    { "Scholomance",                55, "-", "EK"  },
    { "Stratholme",                 55, "-", "EK"  },
    { "Hellfire Ramparts",          58, "-", "TBC" },
    { "The Blood Furnace",          59, "-", "TBC" },
    { "The Slave Pens",             60, "-", "TBC" },
    { "The Underbog",               61, "-", "TBC" },
    { "Mana-Tombs",                 62, "-", "TBC" },
    { "Auchenai Crypts",            63, "-", "TBC" },
    { "Sethekk Halls",              65, "-", "TBC" },
    { "Shadow Labyrinth",           68, "-", "TBC" },
    { "The Shattered Halls",        68, "-", "TBC" },
    { "The Steam Vaults",           68, "-", "TBC" },
    { "The Botanica",               68, "-", "TBC" },
    { "The Arcatraz",               68, "-", "TBC" },
    { "Old Hillsbrad Foothills",    66, "-", "TBC" },
    { "The Black Morass",           68, "-", "TBC" },
    { "Magisters' Terrace",         68, "-", "TBC" },
}
-- Eigene Fraktion einmalig ermitteln; Eintraege der Gegenfraktion werden ausgeblendet
local playerFaction = UnitFactionGroup and UnitFactionGroup("player") or "Alliance"
local function DungeonFitsFaction(d)
    if d[3]~="A" and d[3]~="H" then return true end
    return (d[3]=="A" and playerFaction=="Alliance") or (d[3]=="H" and playerFaction=="Horde")
end

-- Raids: { Name, Raid-Groesse, Mindestlevel } — Groesse steuert die Rollen-Vorbefuellung
local RAIDS = isDE and {
    { "Karazhan",                    10, 68 },
    { "Zul'Aman",                    10, 70 },
    { "Gruuls Unterschlupf",         25, 70 },
    { "Magtheridons Kammer",         25, 70 },
    { "Hoehle des Schlangenschreins",25, 70 },
    { "Festung der Stuerme",         25, 70 },
    { "Schlacht um den Hyjal",       25, 70 },
    { "Der Schwarze Tempel",         25, 70 },
    { "Sonnenbrunnenplateau",        25, 70 },
    { "Zul'Gurub",                   20, 51 },
    { "Ruinen von Ahn'Qiraj",        20, 50 },
    { "Geschmolzener Kern",          40, 54 },
    { "Onyxias Hort",                40, 55 },
    { "Pechschwingenhort",           40, 60 },
    { "Tempel von Ahn'Qiraj",        40, 60 },
    { "Naxxramas",                   40, 60 },
} or {
    { "Karazhan",                    10, 68 },
    { "Zul'Aman",                    10, 70 },
    { "Gruul's Lair",                25, 70 },
    { "Magtheridon's Lair",          25, 70 },
    { "Serpentshrine Cavern",        25, 70 },
    { "Tempest Keep",                25, 70 },
    { "Battle for Mount Hyjal",      25, 70 },
    { "Black Temple",                25, 70 },
    { "Sunwell Plateau",             25, 70 },
    { "Zul'Gurub",                   20, 51 },
    { "Ruins of Ahn'Qiraj",          20, 50 },
    { "Molten Core",                 40, 54 },
    { "Onyxia's Lair",               40, 55 },
    { "Blackwing Lair",              40, 60 },
    { "Temple of Ahn'Qiraj",         40, 60 },
    { "Naxxramas",                   40, 60 },
}
-- Mindestlevel einer gewaehlten Instanz (Dungeon oder Raid); 0 = keine Anforderung
function GM_InstanceMinLevel(name)
    if not name or name=="" then return 0 end
    for _,d in ipairs(DUNGEONS) do if d[1]==name then return d[2] or 0 end end
    for _,r in ipairs(RAIDS) do if r[1]==name then return r[3] or 0 end end
    return 0
end
-- Rollen-Presets nach Raid-Groesse: {TANK, HEAL, DPS}
local RAID_PRESETS = { [10]={2,3,5}, [20]={2,5,13}, [25]={3,6,16}, [40]={4,10,26} }

-- Instanz-Namen sprachneutral uebertragen: DE- und EN-Listen sind parallel sortiert,
-- daher reicht der Index ("D:5" / "R:3"). Freitext (Wunsch-Dungeon, alte Events) bleibt unveraendert.
local function InstanceToToken(name)
    if not name or name=="" then return "" end
    for i,d in ipairs(DUNGEONS) do if d[1]==name then return "D:"..i end end
    for i,r in ipairs(RAIDS) do if r[1]==name then return "R:"..i end end
    return name
end
local function TokenToInstance(tok)
    if not tok or tok=="" then return "" end
    local t,i=tok:match("^([DR]):(%d+)$")
    if t=="D" then local d=DUNGEONS[tonumber(i)]; return d and d[1] or tok end
    if t=="R" then local r=RAIDS[tonumber(i)]; return r and r[1] or tok end
    return tok
end

-- Berufe fuer das Verzeichnis: DE/EN parallel sortiert (Index = sprachneutraler Token).
-- Namen muessen EXAKT den Skill-Zeilen des Clients entsprechen (GetSkillLineInfo-Match),
-- daher hier mit echten Umlauten.
local PROF_NAMES = isDE and {
    "Alchimie", "Schmiedekunst", "Verzauberkunst", "Ingenieurskunst",
    "Kräuterkunde", "Juwelenschleifen", "Lederverarbeitung", "Bergbau",
    "Schneiderei", "Kürschnerei", "Kochkunst", "Erste Hilfe", "Angeln",
} or {
    "Alchemy", "Blacksmithing", "Enchanting", "Engineering",
    "Herbalism", "Jewelcrafting", "Leatherworking", "Mining",
    "Tailoring", "Skinning", "Cooking", "First Aid", "Fishing",
}
-- Welche Berufe haben ein Rezeptfenster (herstellbar)? Sammelberufe (Kräuter/Bergbau/
-- Kürschner) und Angeln haben keine Rezepte. Index passt zu PROF_NAMES.
local PROF_HAS_RECIPES = {[1]=true,[2]=true,[3]=true,[4]=true,[6]=true,[7]=true,[9]=true,[11]=true,[12]=true}
local function ProfIdxByName(nm)
    if not nm then return nil end
    for idx,pn in ipairs(PROF_NAMES) do if pn==nm then return idx end end
end

-- Klassen/Rollen fuer Event-Signup (TBC Classic: keine Death Knights/Monks)
local CLASS_TOKENS = {"WARRIOR","PALADIN","HUNTER","ROGUE","PRIEST","SHAMAN","MAGE","WARLOCK","DRUID"}
local ROLE_TOKENS = {"TANK","HEAL","DPS"}
local ROLE_LABEL = { TANK = isDE and "Tank" or "Tank", HEAL = isDE and "Heiler" or "Healer", DPS = "DPS" }
local ROLE_COLOR = { TANK = "|cff3399ff", HEAL = "|cff33dd66", DPS = "|cffdd4444" }
local function ClassName(tok) return (LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[tok]) or tok or "?" end
local function ClassColorCode(tok)
    local cc=RAID_CLASS_COLORS and RAID_CLASS_COLORS[tok]
    return (cc and cc.colorStr and ("|c"..cc.colorStr)) or "|cffffffff"
end

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
function GM_CanPost() if not GuildMarketDB or not GuildMarketDB.config then return true end; return playerRankIndex<=(GuildMarketDB.config.postRank or 9) end
local function CanDeleteOthers() if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end; return playerRankIndex<=(GuildMarketDB.config.deleteRank or 1) end
local function CanDeleteEntry(e) return (e.contact==UnitName("player")) or CanDeleteOthers() end
local function IsGM() return playerRankIndex==0 end
local function CanEditConfig()
    if IsGM() then return true end -- GM darf immer
    if not GuildMarketDB or not GuildMarketDB.config then return false end
    return playerRankIndex<=(GuildMarketDB.config.configRank or 0)
end

-- ============================================================
-- Online-Roster
-- ============================================================
local onlineRoster={}
local rosterRank={}
local function UpdateRoster()
    onlineRoster={}; rosterRank={}; local total=GetNumGuildMembers and GetNumGuildMembers() or 0
    for i=1,total do
        local info={GetGuildRosterInfo(i)}
        if info[1] then
            local short=info[1]:match("^([^%-]+)") or info[1]
            rosterRank[short]=info[3]
            if info[9] then onlineRoster[short]=true end
        end
    end
    UpdatePlayerRank()
end
local function GetMemberRank(name) return rosterRank[name] end
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
    if not GuildMarketDB.events   then GuildMarketDB.events={} end
    if not GuildMarketDB.config   then GuildMarketDB.config={postRank=9,deleteRank=9,eventRank=9,eventDeleteRank=9} end
    if not GuildMarketDB.config.eventRank then GuildMarketDB.config.eventRank=9 end
    if not GuildMarketDB.config.eventDeleteRank then GuildMarketDB.config.eventDeleteRank=9 end
    if not GuildMarketDB.config.dkpPerEvent then GuildMarketDB.config.dkpPerEvent=10 end
    if not GuildMarketDB.config.eventConfirmRank then GuildMarketDB.config.eventConfirmRank=9 end
    if not GuildMarketDB.config.guildEventRank then GuildMarketDB.config.guildEventRank=9 end
    if not GuildMarketDB.config.configRank then GuildMarketDB.config.configRank=0 end
    if not GuildMarketDB.config.auctionRank then GuildMarketDB.config.auctionRank=9 end
    if not GuildMarketDB.config.dkpAdjustRank then GuildMarketDB.config.dkpAdjustRank=9 end
    if not GuildMarketDB.config.merchRank then GuildMarketDB.config.merchRank=9 end
    if not GuildMarketDB.auctions then GuildMarketDB.auctions={} end
    if not GuildMarketDB.merch then GuildMarketDB.merch={} end
    if not GuildMarketDB.merchOrders then GuildMarketDB.merchOrders={} end
    if not GuildMarketDB.merchDone then GuildMarketDB.merchDone={} end
    if not GuildMarketDB.addonUsersSeen then GuildMarketDB.addonUsersSeen={} end
    if not GuildMarketDB.attendance then GuildMarketDB.attendance={} end
    if not GuildMarketDB.profs then GuildMarketDB.profs={} end
    if not GuildMarketDB.myRecipes then GuildMarketDB.myRecipes={} end
    if not GuildMarketDB.config.boardRank then GuildMarketDB.config.boardRank=9 end
    if not GuildMarketDB.config.dkpDecayPercent then GuildMarketDB.config.dkpDecayPercent=0 end
    if not GuildMarketDB.config.dkpDecayDays then GuildMarketDB.config.dkpDecayDays=7 end
    if not GuildMarketDB.config.dkpLastDecay then GuildMarketDB.config.dkpLastDecay=time() end
    -- Migration v2: alle Rechte auf "jeder" zuruecksetzen (fruehere Defaults waren Offizier)
    if (GuildMarketDB.config.cfgVer or 0)<2 then
        GuildMarketDB.config.eventConfirmRank=9; GuildMarketDB.config.guildEventRank=9; GuildMarketDB.config.cfgVer=2
    end
    if not GuildMarketDB.dkp then GuildMarketDB.dkp={} end
end
local function PruneExpired()
    local now=time()
    for id,e in pairs(GuildMarketDB.listings) do if e.expires<now then GuildMarketDB.listings[id]=nil end end
end
local function PruneExpiredEvents()
    if not GuildMarketDB or not GuildMarketDB.events then return end
    local now=time(); local oneDay=86400
    for id,ev in pairs(GuildMarketDB.events) do
        if (ev.datets or 0)+oneDay < now then GuildMarketDB.events[id]=nil end
    end
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
function GM_DeleteListing(id) GuildMarketDB.listings[id]=nil; SendGuild("DEL|"..id) end
function GM_RequestSync()     SendGuild("REQ") end
local function BroadcastConfig() local c=GuildMarketDB.config; SendGuild("CFG|"..c.postRank.."|"..c.deleteRank.."|"..(c.eventRank or 9).."|"..(c.eventDeleteRank or 9).."|"..(c.dkpPerEvent or 10).."|"..(c.eventConfirmRank or 9).."|"..(c.guildEventRank or 9).."|"..(c.configRank or 0).."|"..(c.auctionRank or 9).."|"..(c.dkpAdjustRank or 9).."|"..(c.merchRank or 9).."|"..(c.boardRank or 9).."|"..(c.dkpDecayPercent or 0).."|"..(c.dkpDecayDays or 7).."|"..(c.dkpLastDecay or 0)) end

-- ============================================================
-- DKP-Punktekonto (Sync: neuester Zeitstempel pro Spieler gewinnt)
-- ============================================================
local function GetDKP(name)
    local d=GuildMarketDB and GuildMarketDB.dkp and GuildMarketDB.dkp[name]
    return (d and d.bal) or 0
end
local function ApplyDKP(name,bal,ts)
    local d=GuildMarketDB.dkp[name]
    if not d or (ts or 0)>=(d.ts or 0) then GuildMarketDB.dkp[name]={bal=bal,ts=ts or time()} end
end
local function BroadcastDKP()
    if not GuildMarketDB or not GuildMarketDB.dkp then return end
    local parts={}; local len=8
    for name,d in pairs(GuildMarketDB.dkp) do
        local seg=name..":"..(d.bal or 0)..":"..(d.ts or 0)..":"..((GuildMarketDB.attendance and GuildMarketDB.attendance[name]) or 0)
        if len+#seg+1>240 then SendGuild("DKPSYNC|"..table.concat(parts,"|")); parts={}; len=8 end
        parts[#parts+1]=seg; len=len+#seg+1
    end
    if #parts>0 then SendGuild("DKPSYNC|"..table.concat(parts,"|")) end
end

-- DKP-Verfall: fuehrt NUR der GM-Client aus (authoritativ, kein Doppel-Verfall).
-- Konfigurierbar: dkpDecayPercent (0=aus) alle dkpDecayDays Tage; Catch-up bei
-- laengerer Abwesenheit (max. 12 Perioden), danach Sync + Config-Broadcast.
local function CheckDkpDecay()
    if not IsGM() then return end
    if not GuildMarketDB or not GuildMarketDB.config then return end
    local c=GuildMarketDB.config
    local pct=tonumber(c.dkpDecayPercent) or 0
    local days=tonumber(c.dkpDecayDays) or 7
    if pct<=0 or pct>=100 or days<1 then return end
    local now=time(); local interval=days*86400
    local applied=0
    while (c.dkpLastDecay or now)+interval<=now and applied<12 do
        for name,d in pairs(GuildMarketDB.dkp or {}) do
            d.bal=math.floor((d.bal or 0)*(100-pct)/100); d.ts=now
        end
        c.dkpLastDecay=(c.dkpLastDecay or now)+interval
        applied=applied+1
    end
    if applied>0 then
        c.dkpLastDecay=now -- Drift vermeiden, ab jetzt frisch zaehlen
        BroadcastDKP(); BroadcastConfig()
        print(T.."[GuildMarkt]"..X.." "..string.format(L.DECAY_DONE,pct)..(applied>1 and (" (x"..applied..")") or ""))
    end
end

-- ============================================================
-- Loot-Auktion (Biet-DKP wie EQdkp: Hoechstgebot gewinnt, Punkte werden abgezogen)
-- ============================================================
local RefreshLootFrame  -- forward-declared, in GM_BuildLootFrame gesetzt
local function CanCreateAuction()
    if not GuildMarketDB or not GuildMarketDB.config then return true end
    return playerRankIndex<=(GuildMarketDB.config.auctionRank or 9)
end
local function CanManageAuction(a)
    if a.seller==UnitName("player") then return true end
    if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end
    return playerRankIndex<=(GuildMarketDB.config.eventConfirmRank or 9)
end
-- Empfangsseitige Pruefung: Darf dieser Absender die Auktion beenden/abbrechen?
local function IsAucSenderAuthorized(a,senderName)
    if a.seller==senderName then return true end
    local r=GetMemberRank(senderName)
    if r==nil then return false end
    return r==0 or r<=((GuildMarketDB.config and GuildMarketDB.config.eventConfirmRank) or 9)
end
local function AuctionTopBid(a)
    local top,topAmt=nil,0
    for name,b in pairs(a.bids or {}) do
        if (b.amt or 0)>topAmt or ((b.amt or 0)==topAmt and top and (b.ts or 0)<((a.bids[top] or {}).ts or 0)) then
            top=name; topAmt=b.amt or 0
        end
    end
    return top,topAmt
end
local function SerializeAuction(id,a)
    local item=(a.item or ""):gsub("|",""):sub(1,40)
    return "AUCPOST|"..id.."|"..tostring(a.itemId or 0).."|"..tostring(a.minBid or 1).."|"..tostring(a.endts or 0).."|"..item
end
local function PostAuction(item,itemId,link,minBid,durMin)
    local me=UnitName("player"); local id="AUC:"..me..":"..time()
    local a={item=item,itemId=itemId,link=link,minBid=minBid,endts=time()+durMin*60,seller=me,bids={}}
    GuildMarketDB.auctions[id]=a; SendGuild(SerializeAuction(id,a)); return id
end
local function BidAuction(id,amt)
    local a=GuildMarketDB.auctions[id]; if not a or a.closed then return end
    local me=UnitName("player"); local ts=time()
    a.bids[me]={amt=amt,ts=ts}
    SendGuild("AUCBID|"..id.."|"..amt.."|"..ts)
end
local function CancelAuction(id)
    GuildMarketDB.auctions[id]=nil; SendGuild("AUCDEL|"..id)
end
local function CloseAuction(id)
    local a=GuildMarketDB.auctions[id]; if not a or a.closed then return end
    local top,topAmt=AuctionTopBid(a)
    a.closed=true; a.closedAt=time()
    if top then
        a.winner=top; a.winAmt=topAmt
        local ts=time(); local nb=GetDKP(top)-topAmt
        ApplyDKP(top,nb,ts)
        SendGuild("AUCEND|"..id.."|"..top.."|"..topAmt.."|"..nb.."|"..ts)
        print(T.."[GuildMarkt]"..X.." "..Gr..top..X.." "..L.AUC_WON..": "..W..(a.item or "?")..X.." ("..G..topAmt..X..")")
    else
        SendGuild("AUCEND|"..id.."|-|0|0|"..time())
        print(T.."[GuildMarkt]"..X.." "..L.AUC_NOWINNER.." "..W..(a.item or "?")..X)
    end
end
local function BroadcastAuctions()
    if not GuildMarketDB or not GuildMarketDB.auctions then return end
    local me=UnitName("player")
    for id,a in pairs(GuildMarketDB.auctions) do
        if a.seller==me and not a.closed then
            SendGuild(SerializeAuction(id,a))
            -- Verkaeufer relayed alle bekannten Gebote (auch von Offline-Bietern)
            local cur=""
            for name,b in pairs(a.bids or {}) do
                local e=name..":"..(b.amt or 0)..":"..(b.ts or 0)
                if cur~="" and #cur+#e+1>190 then SendGuild("AUCBIDR|"..id.."|"..cur); cur=e
                else cur=(cur=="" and e or cur.."|"..e) end
            end
            if cur~="" then SendGuild("AUCBIDR|"..id.."|"..cur) end
        elseif a.seller==me and a.closed then
            -- Verpasste Zuschlaege nachziehen (ohne Kontostand: der kommt via DKPSYNC)
            SendGuild("AUCEND|"..id.."|"..(a.winner or "-").."|"..(a.winAmt or 0).."||")
        end
        local b=a.bids and a.bids[me]
        if b and not a.closed then SendGuild("AUCBID|"..id.."|"..(b.amt or 0).."|"..(b.ts or time())) end
    end
end
local function PruneAuctions()
    if not GuildMarketDB or not GuildMarketDB.auctions then return end
    local now=time()
    for id,a in pairs(GuildMarketDB.auctions) do
        if a.closed and (a.closedAt or 0)+86400<now then GuildMarketDB.auctions[id]=nil
        elseif not a.closed and (a.endts or 0)+7*86400<now then GuildMarketDB.auctions[id]=nil end
    end
end
-- Auto-Abschluss eigener abgelaufener Auktionen (alle 10s, laeuft auch bei geschlossenem Fenster)
local aucTicker=CreateFrame("Frame",nil,UIParent)
do
    local acc=0
    aucTicker:SetScript("OnUpdate",function(_,dt)
        acc=acc+dt; if acc<10 then return end
        acc=0
        if not GuildMarketDB or not GuildMarketDB.auctions then return end
        local me=UnitName("player"); local now=time()
        for id,a in pairs(GuildMarketDB.auctions) do
            if not a.closed and a.seller==me and (a.endts or 0)<=now then
                CloseAuction(id)
                if RefreshLootFrame then RefreshLootFrame() end
            end
        end
    end)
end
local function BroadcastMine()   local me=UnitName("player"); for id,e in pairs(GuildMarketDB.listings) do if e.contact==me then Broadcast(id,e) end end end

-- ============================================================
-- Merch-Shop (Artikel gegen Gildenpunkte; stock: 0=unbegrenzt, -1=ausverkauft)
-- ============================================================
local RefreshMerchFrame  -- forward-declared, in GM_BuildMerchFrame gesetzt
local function CanCreateMerch()
    if IsGM() then return true end
    if not GuildMarketDB or not GuildMarketDB.config then return true end
    return playerRankIndex<=(GuildMarketDB.config.merchRank or 9)
end
local function CanManageMerch(m)
    if m.seller==UnitName("player") then return true end
    return CanCreateMerch()
end
local function IsMerchSenderAuthorized(m,senderName)
    if m.seller==senderName then return true end
    local r=GetMemberRank(senderName)
    if r==nil then return false end
    return r==0 or r<=((GuildMarketDB.config and GuildMarketDB.config.merchRank) or 9)
end
local function SerializeMerch(id,m)
    local item=(m.item or ""):gsub("|",""):sub(1,40)
    return "MSHPOST|"..id.."|"..tostring(m.itemId or 0).."|"..tostring(m.price or 1).."|"..tostring(m.stock or 0).."|"..item
end
local function PostMerch(item,itemId,link,price,stock)
    local me=UnitName("player"); local id="MSH:"..me..":"..time()
    local m={item=item,itemId=itemId,link=link,price=price,stock=stock,seller=me,created=time()}
    GuildMarketDB.merch[id]=m; SendGuild(SerializeMerch(id,m)); return id
end
local function DeleteMerch(id) GuildMarketDB.merch[id]=nil; SendGuild("MSHDEL|"..id) end
local function ApplyMerchPurchase(m)
    if (m.stock or 0)>1 then m.stock=m.stock-1
    elseif m.stock==1 then m.stock=-1 end -- letzter Artikel → ausverkauft
end
-- Kauf-Ankuendigung im echten Gildenchat (zufaelliger Spruch, sendet nur der Kaeufer)
local MSH_CHAT_LINES = isDE and {
    "%s hat im Gilden-Shop zugeschlagen: %s fuer %d Punkte! Ein Kauf mit Stil!",
    "Frisch ueber die Ladentheke: %s goennt sich %s (%d Punkte). Viel Freude damit!",
    "Kassensturz im Merch-Shop! %s kauft %s fuer %d Punkte.",
    "Shoppingtour erfolgreich: %s ist jetzt stolzer Besitzer von %s (%d Punkte)!",
} or {
    "%s just splurged in the guild shop: %s for %d points! Shopping in style!",
    "Fresh off the counter: %s treats themselves to %s (%d points). Enjoy!",
    "Cha-ching! %s buys %s for %d points in the merch shop.",
    "Shopping spree complete: %s is now the proud owner of %s (%d points)!",
}
local function CanConfirmOrder(o)
    if o.buyer==UnitName("player") then return false end -- eigener Kauf: nur ansehen
    if o.seller==UnitName("player") then return true end
    return CanCreateMerch() -- merchRank-berechtigt oder GM
end
local function CountPendingForMe()
    local n=0
    for _,o in pairs((GuildMarketDB and GuildMarketDB.merchOrders) or {}) do
        if CanConfirmOrder(o) then n=n+1 end
    end
    return n
end
local function ConfirmOrder(oid)
    local o=GuildMarketDB.merchOrders[oid]; if not o then return end
    GuildMarketDB.merchOrders[oid]=nil; GuildMarketDB.merchDone[oid]=time()
    SendGuild("MSHCONF|"..oid)
    print(T.."[GuildMarkt]"..X.." "..L.MSH_CONFIRMED.." "..W..(o.item or "?")..X.." — "..Gr..(o.buyer or "?")..X)
    if GM_UpdateMerchButton then GM_UpdateMerchButton() end
end
local function BuyMerch(id)
    local m=GuildMarketDB.merch[id]; if not m or m.stock==-1 then return end
    local me=UnitName("player")
    local price=tonumber(m.price) or 0
    if GetDKP(me)<price then print(R.."[GuildMarkt]"..X.." "..L.MSH_NOPOINTS); return end
    ApplyMerchPurchase(m)
    local ts=time(); local nb=GetDKP(me)-price
    ApplyDKP(me,nb,ts)
    local oid="ORD:"..me..":"..ts
    GuildMarketDB.merchOrders[oid]={mid=id,item=m.item,buyer=me,seller=m.seller,price=price,ts=ts}
    SendGuild("MSHBUY|"..id.."|"..nb.."|"..ts.."|"..oid)
    print(T.."[GuildMarkt]"..X.." "..Gr..me..X.." "..L.MSH_BOUGHT.." "..W..(m.item or "?")..X.." ("..G..price..X..") "..L.MSH_FROM.." "..W..(m.seller or "?")..X)
    if IsInGuild() then
        local line=MSH_CHAT_LINES[math.random(#MSH_CHAT_LINES)]
        SendChatMessage("[GuildMarkt] "..string.format(line,me,(m.item or "?"),price),"GUILD")
    end
end
local function BroadcastMerch()
    if not GuildMarketDB or not GuildMarketDB.merch then return end
    local me=UnitName("player")
    for id,m in pairs(GuildMarketDB.merch) do
        if m.seller==me then SendGuild(SerializeMerch(id,m)) end
    end
    -- eigene offene Kaeufe nachverteilen (Item-Name pipe-bereinigt, letztes Feld)
    for oid,o in pairs(GuildMarketDB.merchOrders or {}) do
        if o.buyer==me then
            SendGuild("MSHORD|"..oid.."|"..(o.mid or "").."|"..tostring(o.price or 0).."|"..tostring(o.ts or 0)
                .."|"..(o.seller or "?").."|"..((o.item or "?"):gsub("|","")))
        end
    end
end
local function PruneMerchOrders()
    if not GuildMarketDB then return end
    local now=time()
    for oid,ts in pairs(GuildMarketDB.merchDone or {}) do
        if ts+7*86400<now then GuildMarketDB.merchDone[oid]=nil end
    end
    for oid,o in pairs(GuildMarketDB.merchOrders or {}) do
        if (o.ts or 0)+30*86400<now then GuildMarketDB.merchOrders[oid]=nil end
    end
end

-- ============================================================
-- Kalender-Hilfsfunktionen / Calendar helpers
-- ============================================================
function GM_ParseEventDate(str)
    local d,m,y=str:match("^(%d+)%.(%d+)%.(%d+)$")
    if not d then return nil end
    d,m,y=tonumber(d),tonumber(m),tonumber(y); if y<100 then y=y+2000 end
    local ok,ts=pcall(time,{year=y,month=m,day=d,hour=0,min=0,sec=0})
    return ok and ts or nil
end
local function FormatEventDate(ts) return date("%d.%m.%Y",ts) end
function GM_TodayTs() local t=date("*t"); return time({year=t.year,month=t.month,day=t.day,hour=0,min=0,sec=0}) end
local function DaysInMonth(y,m) return date("*t",time({year=y,month=m+1,day=0})).day end
local function FirstWeekdayMon(y,m) return (date("*t",time({year=y,month=m,day=1})).wday+5)%7 end -- 0=Mo..6=So
local MONTH_NAMES = isDE
    and {"Januar","Februar","März","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember"}
    or  {"January","February","March","April","May","June","July","August","September","October","November","December"}
local WEEKDAY_SHORT = isDE and {"Mo","Di","Mi","Do","Fr","Sa","So"} or {"Mo","Tu","We","Th","Fr","Sa","Su"}
function GM_CanCreateEvent()
    if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end
    return playerRankIndex<=(GuildMarketDB.config.eventRank or 1)
end
local function CanRemoveEvent(ev)
    if ev.creator==UnitName("player") then return true end
    if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end
    return playerRankIndex<=(GuildMarketDB.config.eventDeleteRank or 9)
end
function GM_CanCreateGuildEvent()
    if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end
    return playerRankIndex<=(GuildMarketDB.config.guildEventRank or 1)
end
local function SerializeEvent(id,ev)
    local title=(ev.title or ""):gsub("|",""):sub(1,50)
    local desc=(ev.desc or ""):gsub("|",""):sub(1,60)
    local tstr=(ev.tstr or "00:00"):sub(1,5)
    local dungeon=InstanceToToken((ev.dungeon or ""):gsub("|",""))
    local r=ev.roles or {}
    return "EVTPOST|"..id.."|"..title.."|"..tostring(ev.datets or 0).."|"..tstr.."|"
        ..tostring(r.TANK or 0).."|"..tostring(r.HEAL or 0).."|"..tostring(r.DPS or 0).."|"..dungeon
        .."|"..(ev.etype or "DUNGEON").."|"..tostring(ev.points or 0).."|"..desc.."|"..tostring(ev.minlvl or 0)
end
local function DeserializeEvent(msg)
    local t={}; for p in (msg.."|"):gmatch("([^|]*)|") do t[#t+1]=p end
    if #t<12 then return nil,nil end
    return t[2],{title=t[3],datets=tonumber(t[4]) or 0,tstr=t[5],
        roles={TANK=tonumber(t[6]) or 0,HEAL=tonumber(t[7]) or 0,DPS=tonumber(t[8]) or 0},
        dungeon=TokenToInstance(t[9] or ""),etype=t[10]=="GUILD" and "GUILD" or "DUNGEON",points=tonumber(t[11]) or 0,
        desc=t[12] or "",minlvl=tonumber(t[13]) or 0,signups={},creator=""}
end
-- Rollen-Status wird nicht mit-synchronisiert, sondern deterministisch aus signups+ts hergeleitet,
-- damit alle Clients ohne Extra-Nachrichten auf denselben Ersatz/Signed-Stand kommen.
local function GetEventStatus(ev)
    local byRole={TANK={},HEAL={},DPS={}}
    for name,s in pairs(ev.signups or {}) do
        if type(s)~="table" then s={role="DPS",ts=time()}; ev.signups[name]=s end -- Migration: alte booleschen Signups (vor Rollen/Klassen-Feature)
        local r=byRole[s.role] and s.role or "DPS"
        table.insert(byRole[r],{name=name,ts=s.ts or 0})
    end
    local statusByName,counts={},{}
    for _,role in ipairs(ROLE_TOKENS) do
        local list=byRole[role]
        table.sort(list,function(a,b) return a.ts<b.ts end)
        local cap=(ev.roles or {})[role] or 0
        local signed=0
        for i,entry in ipairs(list) do
            if cap>0 and i>cap then statusByName[entry.name]="reserve"
            else statusByName[entry.name]="signed"; signed=signed+1 end
        end
        counts[role]={signed=signed,cap=cap}
    end
    return statusByName,counts
end
function GM_PostEvent(title,datets,tstr,roles,desc,dungeon,etype,points,minlvl)
    local me=UnitName("player"); local id="EVT:"..me..":"..time()
    local ev={title=title,datets=datets,tstr=tstr,roles=roles,desc=desc,dungeon=dungeon or "",
        etype=etype or "DUNGEON",points=points or 0,minlvl=minlvl or 0,signups={},creator=me,created=time()}
    GuildMarketDB.events[id]=ev; SendGuild(SerializeEvent(id,ev)); return id
end
local function DeleteEvent(id) GuildMarketDB.events[id]=nil; SendGuild("EVTDEL|"..id) end
local function SignEvent(id,role,class)
    local ev=GuildMarketDB.events[id]; if not ev then return end
    -- Mindeststufe der Instanz muss erreicht sein
    if (ev.minlvl or 0)>(UnitLevel("player") or 0) then
        print(R.."[GuildMarkt]"..X.." "..string.format(L.CAL_LOWLEVEL,ev.minlvl))
        return
    end
    local me=UnitName("player")
    local old=ev.signups[me]
    -- Rollenwechsel = neue Position in der Ziel-Rolle; reiner Klassenwechsel behaelt die Position
    local ts=(type(old)=="table" and old.role==role and old.ts) or time()
    ev.signups[me]={role=role,class=class,ts=ts}
    SendGuild("EVTSIGN|"..id.."|"..role.."|"..class.."|"..ts)
end
local function UnsignEvent(id)
    local ev=GuildMarketDB.events[id]; if not ev then return end
    local me=UnitName("player"); ev.signups[me]=nil; SendGuild("EVTUNSIGN|"..id)
end
local function CanConfirmAttendance(ev)
    if ev.creator==UnitName("player") then return true end
    if not GuildMarketDB or not GuildMarketDB.config then return playerRankIndex<=1 end
    return playerRankIndex<=(GuildMarketDB.config.eventConfirmRank or 1)
end
local function ConfirmAttendance(eventId,player)
    local ev=GuildMarketDB.events[eventId]; if not ev then return end
    if ev.etype~="GUILD" then return end -- nur Gilden-Events vergeben Punkte
    local s=ev.signups and ev.signups[player]
    if type(s)~="table" or s.confirmed then return end
    s.confirmed=true
    GuildMarketDB.attendance[player]=(GuildMarketDB.attendance[player] or 0)+1
    local per=tonumber(ev.points) or 0
    local ts=time()
    local newBal=GetDKP(player)+per
    ApplyDKP(player,newBal,ts)
    SendGuild("EVTCONF|"..eventId.."|"..player.."|"..newBal.."|"..ts)
end
-- Roster-Snapshot des Erstellers: verteilt ALLE Signups (auch von Offline-Spielern)
-- und raeumt verpasste Abmeldungen ab, da der Empfaenger die Liste komplett ersetzt.
-- Chunks: F = einzige Nachricht, B/M/E = Beginn/Mitte/Ende (Reihenfolge pro Sender garantiert)
local function SendEventRoster(id,ev)
    local entries={}
    for name,s in pairs(ev.signups or {}) do
        if type(s)=="table" then
            entries[#entries+1]=name..":"..(s.role or "DPS")..":"..(s.class or "")..":"..(s.ts or 0)..":"..(s.confirmed and 1 or 0)
        end
    end
    local chunks={}; local cur=""
    for _,e in ipairs(entries) do
        if cur~="" and #cur+#e+1>190 then chunks[#chunks+1]=cur; cur=e
        else cur=(cur=="" and e or cur.."|"..e) end
    end
    chunks[#chunks+1]=cur -- auch leer senden: leert das Roster beim Empfaenger (Unsign-Nachzug)
    for i,c in ipairs(chunks) do
        local flag=(#chunks==1 and "F") or (i==1 and "B") or (i==#chunks and "E") or "M"
        SendGuild("EVTROS|"..id.."|"..flag..(c~="" and ("|"..c) or ""))
    end
end
local function BroadcastEvents()
    if not GuildMarketDB or not GuildMarketDB.events then return end
    local me=UnitName("player")
    for id,ev in pairs(GuildMarketDB.events) do
        if ev.creator==me then SendGuild(SerializeEvent(id,ev)); SendEventRoster(id,ev) end
        local s=ev.signups and ev.signups[me]
        if type(s)=="table" then SendGuild("EVTSIGN|"..id.."|"..(s.role or "DPS").."|"..(s.class or "").."|"..(s.ts or time())) end
    end
end
function GM_PostListing(etype,item,amount,note,link,pg,ps,pk,pfree,ptype,beruf,mats)
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
local mainFrame,configFrame,listContent,calContent,countText,userCountText,rows,ebItem
local hdrFS={}; local postBtn_ref; local merchBtn_ref
local calMonthLbl; local calWeekFS={}; local calSetDateField
local addonUsers={}
local secNormal,secDienst
local currentFilter="ALL"; local searchText=""
local currentMode="LIST"; local selectedEventId=nil
local calViewYear, calViewMonth
do local t=date("*t"); calViewYear,calViewMonth=t.year,t.month end

-- Addon-Nutzer erfassen: Session-Set + persistente "zuletzt gesehen"-Liste (SavedVariables)
local function MarkAddonUser(name)
    addonUsers[name]=true
    if GuildMarketDB and GuildMarketDB.addonUsersSeen then GuildMarketDB.addonUsersSeen[name]=time() end
end
function GM_UpdateUserCount()
    if not userCountText then return end
    local n=0; for _ in pairs(addonUsers) do n=n+1 end
    userCountText:SetText(G..n..X..Dg.." "..L.COUNT_USERS..X)
end
-- Beim Login: bekannte Nutzer der letzten 14 Tage vorladen (Zaehler startet nicht bei 1),
-- Eintraege aelter als 60 Tage vergessen
local function LoadKnownAddonUsers()
    if not GuildMarketDB or not GuildMarketDB.addonUsersSeen then return end
    local now=time()
    for name,ts in pairs(GuildMarketDB.addonUsersSeen) do
        if ts+60*86400<now then GuildMarketDB.addonUsersSeen[name]=nil
        elseif ts+14*86400>=now then addonUsers[name]=true end
    end
end

-- ============================================================
-- Berufe-Verzeichnis: Auto-Scan der eigenen Skill-Zeilen + Sync
-- (jeder Spieler ist nur fuer die eigenen Berufe autoritativ)
-- ============================================================
local function BroadcastMyProfs()
    local me=UnitName("player")
    local p=GuildMarketDB and GuildMarketDB.profs and GuildMarketDB.profs[me]
    if not p or not p.s or not next(p.s) then return end
    local parts={}
    for idx,rank in pairs(p.s) do parts[#parts+1]=idx..":"..rank end
    SendGuild("PROFSET|"..table.concat(parts,"|"))
end
local function ScanOwnProfs()
    if not GetNumSkillLines or not GuildMarketDB then return end
    local me=UnitName("player"); if not me then return end
    local mine={}
    for i=1,GetNumSkillLines() do
        local sname,isHeader,_,rank=GetSkillLineInfo(i)
        if sname and not isHeader then
            for idx,pn in ipairs(PROF_NAMES) do
                if pn==sname then mine[idx]=rank or 0 end
            end
        end
    end
    if next(mine) then
        GuildMarketDB.profs[me]={s=mine,ts=time()}
        BroadcastMyProfs()
    end
end
local function PruneProfs()
    if not GuildMarketDB or not GuildMarketDB.profs then return end
    local now=time()
    for name,p in pairs(GuildMarketDB.profs) do
        if (p.ts or 0)+60*86400<now then GuildMarketDB.profs[name]=nil end
    end
end

-- ============================================================
-- Rezept-Scan: liest die eigenen herstellbaren Rezepte beim Oeffnen des
-- Berufsfensters aus und cached sie lokal (GuildMarketDB.myRecipes[profIdx]).
-- Andere Spieler koennen sie per On-Demand-Anfrage abrufen (RCPREQ/RCPLIST).
-- ============================================================
local scanBusy=false
local function ScanOpenTradeSkill()
    if scanBusy or not GetTradeSkillLine or not GuildMarketDB or not GuildMarketDB.myRecipes then return end
    local line=GetTradeSkillLine()
    if not line or line=="UNKNOWN" then return end
    local profIdx=ProfIdxByName(line)
    if not profIdx then return end
    scanBusy=true
    -- alle Kategorien ausklappen, damit keine Rezepte fehlen
    local i=1
    while i<=GetNumTradeSkills() do
        local _,skType,_,isExpanded=GetTradeSkillInfo(i)
        if skType=="header" and not isExpanded then ExpandTradeSkillSubClass(i) else i=i+1 end
    end
    local names={}
    for j=1,GetNumTradeSkills() do
        local nm,skType=GetTradeSkillInfo(j)
        if nm and skType~="header" then
            local link=GetTradeSkillItemLink and GetTradeSkillItemLink(j)
            local id=link and tonumber(link:match("item:(%d+)"))
            names[#names+1]={n=nm,i=id}
        end
    end
    scanBusy=false
    if #names>0 then
        local prev=GuildMarketDB.myRecipes[profIdx]
        GuildMarketDB.myRecipes[profIdx]={r=names,ts=time()}
        if not prev or not prev.r or #prev.r~=#names then
            print(T.."[GuildMarkt]"..X.." "..string.format(L.PROF_SCANNED,PROF_NAMES[profIdx],#names))
        end
    end
end
local function ScanOpenCraft()
    if scanBusy or not GetNumCrafts or not GuildMarketDB or not GuildMarketDB.myRecipes then return end
    -- Verzauberkunst ist der einzige Craft-Beruf in TBC
    local profIdx=ProfIdxByName(isDE and "Verzauberkunst" or "Enchanting")
    if not profIdx then return end
    local names={}
    for i=1,GetNumCrafts() do
        local nm,_,craftType=GetCraftInfo(i)
        if nm and craftType~="header" then
            local link=GetCraftItemLink and GetCraftItemLink(i)
            local id=link and tonumber(link:match("item:(%d+)"))
            names[#names+1]={n=nm,i=id}
        end
    end
    if #names>0 then
        local prev=GuildMarketDB.myRecipes[profIdx]
        GuildMarketDB.myRecipes[profIdx]={r=names,ts=time()}
        if not prev or not prev.r or #prev.r~=#names then
            print(T.."[GuildMarkt]"..X.." "..string.format(L.PROF_SCANNED,PROF_NAMES[profIdx],#names))
        end
    end
end
-- Debounce: TRADE_SKILL_UPDATE feuert mehrfach beim Oeffnen; erst nach Ruhe scannen
local scanFrame=CreateFrame("Frame",nil,UIParent)
scanFrame:RegisterEvent("TRADE_SKILL_SHOW")
scanFrame:RegisterEvent("TRADE_SKILL_UPDATE")
scanFrame:RegisterEvent("CRAFT_SHOW")
scanFrame:RegisterEvent("CRAFT_UPDATE")
do
    local pending,kind,acc=false,nil,0
    scanFrame:SetScript("OnEvent",function(_,e)
        kind=(e=="CRAFT_SHOW" or e=="CRAFT_UPDATE") and "craft" or "trade"
        pending=true; acc=0
    end)
    scanFrame:SetScript("OnUpdate",function(_,dt)
        if not pending then return end
        acc=acc+dt; if acc<0.4 then return end
        pending=false
        if kind=="craft" then ScanOpenCraft() else ScanOpenTradeSkill() end
    end)
end
-- Login-Erinnerung: fuer herstellbare Berufe ohne Rezept-Cache das Fenster oeffnen lassen
local function RemindUnscannedProfs()
    if not GuildMarketDB then return end
    local me=UnitName("player")
    local p=GuildMarketDB.profs and GuildMarketDB.profs[me]
    if not p or not p.s then return end
    local missing={}
    for idx in pairs(p.s) do
        if PROF_HAS_RECIPES[idx] and not (GuildMarketDB.myRecipes and GuildMarketDB.myRecipes[idx]) then
            missing[#missing+1]=PROF_NAMES[idx]
        end
    end
    if #missing>0 then
        print(T.."[GuildMarkt]"..X.." "..string.format(L.PROF_SCAN_HINT,table.concat(missing,", ")))
    end
end

-- ============================================================
-- Gedrosselter Gilden-Sender (fuer laengere Rezeptlisten): 1 Nachricht/0.2s,
-- damit ein Antwort-Schwung den Client nicht in die Server-Drossel treibt.
-- ============================================================
local sendQueue={}
do
    local acc=0
    local qf=CreateFrame("Frame",nil,UIParent)
    qf:SetScript("OnUpdate",function(_,dt)
        if #sendQueue==0 then return end
        acc=acc+dt; if acc<0.2 then return end
        acc=0; SendGuild(table.remove(sendQueue,1))
    end)
end
local function QueueGuild(msg) sendQueue[#sendQueue+1]=msg end

-- ============================================================
-- On-Demand-Rezepte: Anfrage (RCPREQ) an einen Spieler, Antwort (RCPLIST/RCPNONE).
-- Antwort geht ans Gildennetz; nur Clients mit offener Anfrage werten sie aus.
-- ============================================================
-- Antwort auf eingehende RCPREQ (bin ich das Ziel?)
local function AnswerRecipeRequest(profIdx)
    local entry=GuildMarketDB and GuildMarketDB.myRecipes and GuildMarketDB.myRecipes[profIdx]
    if not entry or not entry.r or #entry.r==0 then
        SendGuild("RCPNONE|"..profIdx); return
    end
    -- Jeder Eintrag als "<itemID>:<name>" (ID leer bei Enchants); Eintraege per Tab getrennt
    local parts={}
    for _,rc in ipairs(entry.r) do
        local nm=type(rc)=="table" and rc.n or rc
        local id=type(rc)=="table" and rc.i or nil
        parts[#parts+1]=(id and tostring(id) or "")..":"..(nm or "?")
    end
    local payload=table.concat(parts,"\t")
    local chunks={}
    while #payload>0 do chunks[#chunks+1]=payload:sub(1,200); payload=payload:sub(201) end
    for i,c in ipairs(chunks) do
        local flag=(#chunks==1 and "F") or (i==1 and "B") or (i==#chunks and "E") or "M"
        QueueGuild("RCPLIST|"..profIdx.."|"..flag.."|"..c)
    end
end
-- Requester-Seite: eine offene Anfrage + Timeout; Callback liefert names|nil,reason
local pendingRcp=nil  -- {target,profIdx,buf,cb}
local rcpTimeout=CreateFrame("Frame",nil,UIParent)
do
    local acc=0
    rcpTimeout:SetScript("OnUpdate",function(_,dt)
        if not pendingRcp then acc=0; return end
        acc=acc+dt
        if acc>=6 then
            local cb=pendingRcp.cb; pendingRcp=nil; acc=0
            if cb then cb(nil,"timeout") end
        end
    end)
end
function GM_RequestRecipes(target,profIdx,cb)
    pendingRcp={target=target,profIdx=profIdx,buf="",cb=cb}
    SendGuild("RCPREQ|"..target.."|"..profIdx)
end

-- ============================================================
-- Schwarzes Brett: eine Ankuendigung der Gildenleitung, Login-Popup mit Gelesen-Merker
-- ============================================================
local RefreshBoardFrame -- forward-declared, in GM_BuildBoardFrame gesetzt
local function CanPostBoard()
    if IsGM() then return true end
    if not GuildMarketDB or not GuildMarketDB.config then return true end
    return playerRankIndex<=(GuildMarketDB.config.boardRank or 9)
end
-- Chunks wie beim Event-Roster: F = einzige Nachricht, B/M/E = Beginn/Mitte/Ende
local function BroadcastBoard()
    local b=GuildMarketDB and GuildMarketDB.board
    if not b or not b.text or b.text=="" then return end
    local text=b.text
    local chunks={}
    while #text>0 do
        chunks[#chunks+1]=text:sub(1,170); text=text:sub(171)
    end
    for i,c in ipairs(chunks) do
        local flag=(#chunks==1 and "F") or (i==1 and "B") or (i==#chunks and "E") or "M"
        SendGuild("BRDPOST|"..(b.ts or 0).."|"..(b.author or "?").."|"..flag.."|"..c)
    end
end
local function PostBoard(text)
    if not CanPostBoard() then print(R.."[GuildMarkt]"..X.." "..L.BRD_NORANK); return end
    text=(text or ""):gsub("|",""):sub(1,600)
    GuildMarketDB.board={text=text,author=UnitName("player"),ts=time()}
    GuildMarketDB.boardRead=GuildMarketDB.board.ts -- eigene Ankuendigung gilt als gelesen
    BroadcastBoard()
    print(T.."[GuildMarkt]"..X.." "..L.BRD_POSTED)
end
-- Login-Popup: ungelesene Ankuendigung anzeigen
local boardPopup
local function ShowBoardPopup()
    local b=GuildMarketDB and GuildMarketDB.board
    if not b or not b.text or b.text=="" then return end
    if (b.ts or 0)<=(GuildMarketDB.boardRead or 0) then return end
    if boardPopup then boardPopup:Hide(); boardPopup=nil end
    local f=CreateFrame("Frame","GuildMarketBoardPopup",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(420,240); f:SetPoint("CENTER",UIParent,"CENTER",0,120)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(40)
    f.TitleBg:SetHeight(26)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,1); titleFS:SetText(G..L.BRD_TITLE..X)
    local meta=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    meta:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-8)
    meta:SetText(Dg..L.BRD_BY.." "..X..W..(b.author or "?")..X..Dg.." — "..date("%d.%m.%Y %H:%M",b.ts or 0)..X)
    local sfB=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sfB:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-26); sfB:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-28,36)
    local scB=CreateFrame("Frame",nil,sfB); scB:SetWidth(360); scB:SetHeight(20); sfB:SetScrollChild(scB)
    local txt=scB:CreateFontString(nil,"OVERLAY","GameFontNormal")
    txt:SetPoint("TOPLEFT",scB,"TOPLEFT",4,-4); txt:SetWidth(350); txt:SetJustifyH("LEFT"); txt:SetJustifyV("TOP")
    txt:SetText(W..b.text..X); scB:SetHeight(math.max(20,txt:GetStringHeight()+10))
    local okBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); okBtn:SetSize(120,24)
    okBtn:SetPoint("BOTTOM",f.InsetBg,"BOTTOM",0,6); okBtn:SetText(L.BRD_OK)
    okBtn:SetScript("OnClick",function()
        GuildMarketDB.boardRead=b.ts or time()
        f:Hide(); boardPopup=nil
    end)
    boardPopup=f; f:Show()
end

-- Shop-Button-Highlight: zeigt Anzahl offener Kaeufe, die ich bestaetigen kann
function GM_UpdateMerchButton()
    if not merchBtn_ref then return end
    local n=CountPendingForMe()
    merchBtn_ref:SetText(n>0 and (G.."Shop ("..n..")"..X) or "Shop")
end
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
function GM_GetDraggedItem()
    local iType,itemId=GetCursorInfo(); if iType=="item" and itemId then return GetItemInfo(itemId) end
end

-- ============================================================
-- Backdrop-Hilfsfunktion  (vor GM_BuildInfoFrame benoetigt)
-- ============================================================
function GM_MakeBg(parent,r,g2,b,a,er,eg2,eb)
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

function GM_BuildInfoFrame()
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

    local contBg=GM_MakeBg(f,0.05,0.05,0.12,0.95,0.2,0.2,0.45)
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
        f:Hide(); infoFrame=nil; GM_BuildInfoFrame()
    end)

    infoFrame=f
end

-- ============================================================
-- Config-Frame
-- ============================================================
function GM_BuildConfigFrame()
    if configFrame then configFrame:Show(); return end
    local f=CreateFrame("Frame","GuildMarketConfigFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(700,560); f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(20); f:Hide()
    f.TitleBg:SetHeight(26)
    local title=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    title:SetPoint("CENTER",f.TitleBg,"CENTER",0,1); title:SetText(G.."GuildMarket "..X..Dg.."Einstellungen"..X)
    local hint=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hint:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-8); hint:SetWidth(600)
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
    local ddP=RankDD("Post",8,-34,function() return GuildMarketDB.config.postRank end,function(v) GuildMarketDB.config.postRank=v end,G..L.CFG_POSTRANK..X)
    local ddD=RankDD("Del",8,-96,function() return GuildMarketDB.config.deleteRank end,function(v) GuildMarketDB.config.deleteRank=v end,G..L.CFG_DELRANK..X)
    local ddE=RankDD("Evt",8,-158,function() return GuildMarketDB.config.eventRank or 1 end,function(v) GuildMarketDB.config.eventRank=v end,G..L.CFG_EVTRANK..X)
    local ddED=RankDD("EvtDel",350,-34,function() return GuildMarketDB.config.eventDeleteRank or 9 end,function(v) GuildMarketDB.config.eventDeleteRank=v end,G..L.CFG_EVTDELRANK..X)
    local ddC=RankDD("Conf",350,-96,function() return GuildMarketDB.config.eventConfirmRank or 1 end,function(v) GuildMarketDB.config.eventConfirmRank=v end,G..L.CFG_CONFRANK..X)
    local ddGE=RankDD("GEvt",350,-158,function() return GuildMarketDB.config.guildEventRank or 1 end,function(v) GuildMarketDB.config.guildEventRank=v end,G..L.CFG_GEVTRANK..X)
    -- "Rechte aendern ab" darf nur der GM selbst umstellen (sonst koennte man sich Rechte erweitern)
    local ddCFG=RankDD("Cfg",8,-220,function() return GuildMarketDB.config.configRank or 0 end,function(v) GuildMarketDB.config.configRank=v end,G..L.CFG_CFGRANK..X)
    local ddA=RankDD("Auc",350,-220,function() return GuildMarketDB.config.auctionRank or 9 end,function(v) GuildMarketDB.config.auctionRank=v end,G..L.CFG_AUCRANK..X)
    local ddDA=RankDD("DkpAdj",8,-282,function() return GuildMarketDB.config.dkpAdjustRank or 9 end,function(v) GuildMarketDB.config.dkpAdjustRank=v end,G..L.CFG_DKPADJRANK..X)
    local ddM=RankDD("Merch",350,-282,function() return GuildMarketDB.config.merchRank or 9 end,function(v) GuildMarketDB.config.merchRank=v end,G..L.CFG_MERCHRANK..X)
    local ddB=RankDD("Board",350,-344,function() return GuildMarketDB.config.boardRank or 9 end,function(v) GuildMarketDB.config.boardRank=v end,G..L.CFG_BRDRANK..X)
    local lbDkp=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbDkp:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-348); lbDkp:SetText(G..L.CFG_DKPPER..X)
    local ebDkp=CreateFrame("EditBox","GuildMarketCfgDkpBox",f,"InputBoxTemplate")
    ebDkp:SetSize(60,22); ebDkp:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",200,-344)
    ebDkp:SetAutoFocus(false); ebDkp:SetMaxLetters(4); ebDkp:SetNumeric(true)
    ebDkp:SetScript("OnTextChanged",function(self)
        local v=tonumber(self:GetText()); if v then GuildMarketDB.config.dkpPerEvent=v end
    end)
    -- DKP-Verfall: Prozent (0=aus) + Intervall in Tagen; ausgefuehrt vom GM-Client beim Login
    local lbDecP=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbDecP:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-410); lbDecP:SetText(G..L.CFG_DECAYPCT..X)
    local ebDecP=CreateFrame("EditBox","GuildMarketCfgDecayPctBox",f,"InputBoxTemplate")
    ebDecP:SetSize(50,22); ebDecP:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",200,-406)
    ebDecP:SetAutoFocus(false); ebDecP:SetMaxLetters(2); ebDecP:SetNumeric(true)
    ebDecP:SetScript("OnTextChanged",function(self)
        local v=tonumber(self:GetText()); if v then GuildMarketDB.config.dkpDecayPercent=v end
    end)
    local lbDecD=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbDecD:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",350,-410); lbDecD:SetText(G..L.CFG_DECAYDAYS..X)
    local ebDecD=CreateFrame("EditBox","GuildMarketCfgDecayDaysBox",f,"InputBoxTemplate")
    ebDecD:SetSize(50,22); ebDecD:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",542,-406)
    ebDecD:SetAutoFocus(false); ebDecD:SetMaxLetters(3); ebDecD:SetNumeric(true)
    ebDecD:SetScript("OnTextChanged",function(self)
        local v=tonumber(self:GetText()); if v and v>=1 then GuildMarketDB.config.dkpDecayDays=v end
    end)
    local i2=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); i2:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",270,18); i2:SetText(Dg.."Rang 0 = Gildenmeister  (niedrigere Zahl = hoehere Position)"..X)
    local sB=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); sB:SetSize(160,26); sB:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,12); sB:SetText("Speichern & Sync")
    sB:SetScript("OnClick",function() if not CanEditConfig() then print(R.."[GuildMarkt]"..X.." "..L.CFG_NOEDIT); return end; BroadcastConfig(); print(T.."[GuildMarkt]"..X.." Gespeichert."); f:Hide() end)
    local cB=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); cB:SetSize(80,26); cB:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",176,12); cB:SetText("Schliessen"); cB:SetScript("OnClick",function() f:Hide() end)
    f:SetScript("OnShow",function()
        local canEdit=CanEditConfig()
        if not canEdit then sB:Disable(); hint:SetText(R..L.CFG_NOEDIT..X)
        else sB:Enable(); hint:SetText(Dg.."Einstellungen werden per Sync verteilt."..X) end
        ddP:Refresh(); ddD:Refresh(); ddE:Refresh(); ddED:Refresh(); ddC:Refresh(); ddGE:Refresh(); ddCFG:Refresh(); ddA:Refresh(); ddDA:Refresh(); ddM:Refresh(); ddB:Refresh()
        for _,dd in ipairs({ddP,ddD,ddE,ddED,ddC,ddGE,ddA,ddDA,ddM,ddB}) do
            if canEdit then UIDropDownMenu_EnableDropDown(dd) else UIDropDownMenu_DisableDropDown(dd) end
        end
        if IsGM() then UIDropDownMenu_EnableDropDown(ddCFG) else UIDropDownMenu_DisableDropDown(ddCFG) end
        ebDkp:SetText(tostring(GuildMarketDB.config.dkpPerEvent or 10))
        ebDecP:SetText(tostring(GuildMarketDB.config.dkpDecayPercent or 0))
        ebDecD:SetText(tostring(GuildMarketDB.config.dkpDecayDays or 7))
        for _,eb in ipairs({ebDkp,ebDecP,ebDecD}) do
            eb:EnableMouse(canEdit); if not canEdit then eb:ClearFocus() end
        end
    end)
    configFrame=f; f:Show()
end

-- ============================================================
-- Zeilen-Rendering
-- ============================================================
local function GetExtraW() if not listContent then return 0 end; return math.max(0,listContent:GetWidth()-ROW_W) end

local function RefreshPostButton()
    if not postBtn_ref then return end
    if GM_CanPost() then postBtn_ref:Enable(); postBtn_ref:SetText("Eintrag posten")
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

function GM_RefreshList()
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
            row.del:Show(); row.del:SetScript("OnClick",function() GM_DeleteListing(id); GM_RefreshList() end)
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
-- Kalender: GM_RefreshCalendar + Event-Detail-Popup
-- ============================================================
local eventDetailFrame = nil
local CAL_COLS, CAL_ROWS = 7, 6
local calCells = {}

local function BuildCalendarCells()
    if #calCells>0 then return end
    for i=1,CAL_ROWS*CAL_COLS do
        local cell=CreateFrame("Button",nil,calContent,"BackdropTemplate")
        cell:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=6,
            insets={left=1,right=1,top=1,bottom=1}})
        local dayFS=cell:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        dayFS:SetPoint("TOPLEFT",cell,"TOPLEFT",5,-3); cell.dayFS=dayFS
        local moreFS=cell:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        moreFS:SetPoint("BOTTOMRIGHT",cell,"BOTTOMRIGHT",-4,3); cell.moreFS=moreFS
        local addBtn=CreateFrame("Button",nil,cell,"UIPanelButtonTemplate")
        addBtn:SetSize(16,16); addBtn:SetPoint("TOPRIGHT",cell,"TOPRIGHT",-2,-2); addBtn:SetText("+")
        addBtn:Hide(); cell.addBtn=addBtn
        cell.pips={}
        for p=1,2 do
            local pip=CreateFrame("Button",nil,cell,"BackdropTemplate")
            pip:SetHeight(13); pip:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8"})
            local pipFS=pip:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            pipFS:SetPoint("LEFT",pip,"LEFT",2,0); pipFS:SetJustifyH("LEFT"); pip.fs=pipFS
            pip:Hide(); cell.pips[p]=pip
        end
        cell:Hide()
        calCells[i]=cell
    end
end

function GM_RefreshCalendar()
    if not calContent then return end
    BuildCalendarCells()
    if calMonthLbl then calMonthLbl:SetText(G..MONTH_NAMES[calViewMonth].." "..calViewYear..X) end
    local me=UnitName("player"); local today=GM_TodayTs()
    local dim=DaysInMonth(calViewYear,calViewMonth)
    local firstWd=FirstWeekdayMon(calViewYear,calViewMonth)
    local prevMonth=calViewMonth==1 and 12 or calViewMonth-1
    local prevYear=calViewMonth==1 and calViewYear-1 or calViewYear
    local nextMonth=calViewMonth==12 and 1 or calViewMonth+1
    local nextYear=calViewMonth==12 and calViewYear+1 or calViewYear
    local prevDim=DaysInMonth(prevYear,prevMonth)

    local byDay={}
    if GuildMarketDB and GuildMarketDB.events then
        for id,ev in pairs(GuildMarketDB.events) do
            local d=ev.datets or 0
            byDay[d]=byDay[d] or {}; byDay[d][#byDay[d]+1]={id=id,ev=ev}
        end
    end
    for _,list in pairs(byDay) do table.sort(list,function(a,b) return (a.ev.tstr or "")<(b.ev.tstr or "") end) end

    local cw=math.floor(calContent:GetWidth()/CAL_COLS)
    local ch=math.floor(calContent:GetHeight()/CAL_ROWS)
    for d=1,7 do
        local fs=calWeekFS[d]
        fs:ClearAllPoints(); fs:SetPoint("BOTTOMLEFT",calContent,"TOPLEFT",(d-1)*cw,2); fs:SetSize(cw,14)
    end
    for i=1,CAL_ROWS*CAL_COLS do
        local cell=calCells[i]
        local idx=i-1
        local col=idx%CAL_COLS; local row=math.floor(idx/CAL_COLS)
        cell:ClearAllPoints()
        cell:SetPoint("TOPLEFT",calContent,"TOPLEFT",col*cw,-row*ch)
        cell:SetSize(cw-1,ch-1)

        local dayNum, inMonth, cellYear, cellMonth
        if idx<firstWd then
            dayNum=prevDim-(firstWd-idx-1); inMonth=false; cellMonth=prevMonth; cellYear=prevYear
        elseif idx>=firstWd+dim then
            dayNum=idx-firstWd-dim+1; inMonth=false; cellMonth=nextMonth; cellYear=nextYear
        else
            dayNum=idx-firstWd+1; inMonth=true; cellMonth=calViewMonth; cellYear=calViewYear
        end
        local cellTs=time({year=cellYear,month=cellMonth,day=dayNum,hour=0,min=0,sec=0})
        local isToday=cellTs==today; local isPast=cellTs<today

        if isToday then cell:SetBackdropColor(0.06,0.14,0.06,0.95); cell:SetBackdropBorderColor(0.25,0.75,0.2,1)
        elseif not inMonth then cell:SetBackdropColor(0.04,0.04,0.04,0.55); cell:SetBackdropBorderColor(0.15,0.15,0.15,0.35)
        elseif isPast then cell:SetBackdropColor(0.06,0.06,0.06,0.75); cell:SetBackdropBorderColor(0.18,0.18,0.18,0.5)
        else cell:SetBackdropColor(0.05,0.05,0.11,0.85); cell:SetBackdropBorderColor(0.2,0.2,0.45,0.6) end
        cell.dayFS:SetText(not inMonth and Dg..dayNum..X or (isToday and Gr..dayNum..X or (isPast and Dg..dayNum..X or W..dayNum..X)))

        local dayEvents=byDay[cellTs] or {}
        for p,pip in ipairs(cell.pips) do
            local entry=dayEvents[p]
            pip:ClearAllPoints()
            pip:SetPoint("TOPLEFT",cell,"TOPLEFT",3,-16-(p-1)*14); pip:SetPoint("TOPRIGHT",cell,"TOPRIGHT",-3,-16-(p-1)*14)
            if entry then
                local id,ev=entry.id,entry.ev
                local signedUp=(ev.signups or {})[me]~=nil
                local isGuildEvt=ev.etype=="GUILD"
                if signedUp then pip:SetBackdropColor(0.1,0.3,0.14,0.9)
                elseif isGuildEvt then pip:SetBackdropColor(0.28,0.22,0.05,0.9)
                else pip:SetBackdropColor(0.16,0.16,0.16,0.9) end
                pip.fs:SetText((signedUp and Gr or (isGuildEvt and G or W))..(ev.tstr or "").." "..(ev.title or "")..X)
                pip:SetScript("OnClick",function() BuildEventDetailPopup(id) end)
                pip:SetScript("OnEnter",function(self)
                    GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                    GameTooltip:AddLine(G..(ev.title or "")..X); GameTooltip:AddLine(T..ev.tstr..X)
                    GameTooltip:Show()
                end)
                pip:SetScript("OnLeave",function() GameTooltip:Hide() end)
                pip:Show()
            else pip:Hide() end
        end
        if #dayEvents>2 then cell.moreFS:SetText(Dg.."+"..(#dayEvents-2)..X); cell.moreFS:Show()
        else cell.moreFS:Hide() end

        if inMonth and GM_CanCreateEvent() then
            cell.addBtn:Show()
            cell.addBtn:SetScript("OnClick",function() if calSetDateField then calSetDateField(date("%d.%m.%Y",cellTs)) end end)
        else cell.addBtn:Hide() end

        cell:SetScript("OnClick",function()
            if #dayEvents==1 then BuildEventDetailPopup(dayEvents[1].id)
            elseif #dayEvents==0 and inMonth and GM_CanCreateEvent() and calSetDateField then
                calSetDateField(date("%d.%m.%Y",cellTs))
            end
        end)
        cell:SetScript("OnEnter",function(self) self:SetBackdropBorderColor(0.4,0.8,1,0.9) end)
        cell:SetScript("OnLeave",function(self)
            if isToday then self:SetBackdropBorderColor(0.25,0.75,0.2,1)
            elseif not inMonth then self:SetBackdropBorderColor(0.15,0.15,0.15,0.35)
            elseif isPast then self:SetBackdropBorderColor(0.18,0.18,0.18,0.5)
            else self:SetBackdropBorderColor(0.2,0.2,0.45,0.6) end
        end)
        cell:Show()
    end
end

function BuildEventDetailPopup(eventId)
    local ev=GuildMarketDB.events and GuildMarketDB.events[eventId]; if not ev then return end
    if eventDetailFrame then eventDetailFrame:Hide(); eventDetailFrame=nil end
    local f=CreateFrame("Frame","GuildMarketEventDetail",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(490,460); f:SetPoint("CENTER",UIParent,"CENTER",80,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(30)
    f.TitleBg:SetHeight(28)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,2); titleFS:SetText(G..(ev.title or "")..X)

    local statusByName,counts=GetEventStatus(ev)
    local function RoleCountTxt(role)
        local c=counts[role]; local capTxt=c.cap>0 and ("/"..c.cap) or "/∞"
        return ROLE_COLOR[role]..ROLE_LABEL[role]..X.." "..G..c.signed..capTxt..X
    end
    local info=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    info:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-8); info:SetWidth(460); info:SetJustifyH("LEFT")
    info:SetText(T..FormatEventDate(ev.datets).."  "..ev.tstr..X
        .."    "..Dg..L.CAL_CREATOR..X..W..(ev.creator or "")..X
        ..((ev.dungeon or "")~="" and ("    "..Dg.."Dungeon: "..X..W..ev.dungeon..X) or "")
        ..(ev.etype=="GUILD" and ("    "..G..L.ETYPE_GUILD.." · "..L.CAL_POINTS.." "..(ev.points or 0)..X) or "")
        ..((ev.minlvl or 0)>0 and ("    "..Dg..L.CAL_MINLVL.." "..X..W..ev.minlvl..X) or "")
        ..((ev.repeatDays or 0)>0 and ("  "..Dg..L.REP_HINT..X) or ""))
    local infoRoles=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    infoRoles:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-24); infoRoles:SetWidth(460); infoRoles:SetJustifyH("LEFT")
    infoRoles:SetText(RoleCountTxt("TANK").."    "..RoleCountTxt("HEAL").."    "..RoleCountTxt("DPS"))

    local yOff=-42
    if (ev.desc or "")~="" then
        local desc=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        desc:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,yOff); desc:SetWidth(460); desc:SetJustifyH("LEFT")
        desc:SetText(W..ev.desc..X); yOff=yOff-20
    end
    local sep=f:CreateTexture(nil,"BACKGROUND"); sep:SetHeight(1)
    sep:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,yOff-4); sep:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,yOff-4)
    sep:SetColorTexture(0.3,0.5,0.8,0.7); yOff=yOff-12
    local lbSig=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbSig:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,yOff); lbSig:SetText(G..L.CAL_SIGNUPS..X); yOff=yOff-22
    local sf2=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sf2:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,yOff); sf2:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-26,64)
    local sc=CreateFrame("Frame",nil,sf2); sc:SetWidth(430); sc:SetHeight(20); sf2:SetScrollChild(sc)
    local sorted={}; for name in pairs(ev.signups or {}) do sorted[#sorted+1]=name end
    table.sort(sorted,function(a,b)
        local ra=statusByName[a]=="reserve" and 1 or 0; local rb=statusByName[b]=="reserve" and 1 or 0
        if ra~=rb then return ra<rb end
        local ao=IsOnline(a) and 1 or 0; local bo=IsOnline(b) and 1 or 0
        if ao~=bo then return ao>bo end; return a<b
    end)
    local ry=0; local shownReserveHdr=false
    for _,name in ipairs(sorted) do
        local isReserve=statusByName[name]=="reserve"
        if isReserve and not shownReserveHdr then
            local hdr=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            hdr:SetPoint("TOPLEFT",sc,"TOPLEFT",4,-ry-2); hdr:SetText(Dg.."— "..(isDE and "Ersatzbank" or "Reserve").." —"..X)
            ry=ry+16; shownReserveHdr=true
        end
        local online=IsOnline(name)
        local s=ev.signups[name] or {}
        local rbg=sc:CreateTexture(nil,"BACKGROUND"); rbg:SetHeight(22)
        rbg:SetPoint("TOPLEFT",sc,"TOPLEFT",0,-ry); rbg:SetPoint("TOPRIGHT",sc,"TOPRIGHT",0,-ry)
        if (ry/22)%2==0 then rbg:SetColorTexture(0.08,0.08,0.18,0.7) else rbg:SetColorTexture(0.05,0.05,0.12,0.5) end
        local dot=sc:CreateTexture(nil,"OVERLAY"); dot:SetSize(14,14); dot:SetPoint("TOPLEFT",sc,"TOPLEFT",4,-ry-4)
        dot:SetTexture(online and "Interface\\FriendsFrame\\StatusIcon-Online" or "Interface\\FriendsFrame\\StatusIcon-Offline")
        dot:SetVertexColor(1,1,1,online and 1 or 0.35)
        local lbN=sc:CreateFontString(nil,"OVERLAY","GameFontNormal")
        lbN:SetPoint("TOPLEFT",sc,"TOPLEFT",22,-ry-4); lbN:SetText(online and W..name..X or Dg..name..X); lbN:SetSize(108,14)
        local lbRole=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbRole:SetPoint("TOPLEFT",sc,"TOPLEFT",134,-ry-4); lbRole:SetText((ROLE_COLOR[s.role] or W)..(ROLE_LABEL[s.role] or "?")..X); lbRole:SetSize(46,14)
        local lbClass=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbClass:SetPoint("TOPLEFT",sc,"TOPLEFT",184,-ry-4); lbClass:SetText(ClassColorCode(s.class)..ClassName(s.class)..X); lbClass:SetSize(84,14)
        if s.confirmed then
            local confTex=sc:CreateTexture(nil,"OVERLAY"); confTex:SetSize(16,16)
            confTex:SetPoint("TOPLEFT",sc,"TOPLEFT",278,-ry-3)
            confTex:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
        elseif ev.etype=="GUILD" and CanConfirmAttendance(ev) then
            local cfBtn=CreateFrame("Button",nil,sc,"UIPanelButtonTemplate"); cfBtn:SetSize(40,18)
            cfBtn:SetPoint("TOPLEFT",sc,"TOPLEFT",268,-ry-2); cfBtn:SetText("+P")
            cfBtn:SetScript("OnEnter",function(self)
                GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:ClearLines()
                GameTooltip:AddLine(L.DKP_CONFIRM.." (+"..(tonumber(ev.points) or 0).." "..L.DKP_TITLE..")")
                GameTooltip:Show()
            end)
            cfBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
            cfBtn:SetScript("OnClick",function()
                ConfirmAttendance(eventId,name)
                print(T.."[GuildMarkt]"..X.." "..Gr..name..X.." "..L.DKP_CONFIRMED.." ("..G..GetDKP(name)..X..")")
                BuildEventDetailPopup(eventId)
            end)
        end
        if online then
            local wb=CreateFrame("Button",nil,sc,"UIPanelButtonTemplate"); wb:SetSize(80,18)
            wb:SetPoint("TOPLEFT",sc,"TOPLEFT",342,-ry-2); wb:SetText(L.INFO_WHISPER)
            wb:SetScript("OnClick",function() OpenWhisper(name) end)
        end
        ry=ry+22; sc:SetHeight(ry)
    end
    if #sorted==0 then
        local hint=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        hint:SetPoint("TOPLEFT",sc,"TOPLEFT",8,-6); hint:SetText(Dg..L.CAL_NOSIGNUP..X); sc:SetHeight(26)
    end
    local closeBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); closeBtn:SetSize(100,22)
    closeBtn:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-8,6); closeBtn:SetText(isDE and "Schliessen" or "Close")
    closeBtn:SetScript("OnClick",function() f:Hide() end)
    local me=UnitName("player"); local mySignup=(ev.signups or {})[me]
    local sigBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); sigBtn:SetSize(110,22)
    sigBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,6)

    -- Rolle+Klasse-Dropdowns (Neuanmeldung UND nachtraeglicher Wechsel)
    local _,myClassToken=UnitClass("player")
    local pendingRole=(mySignup and mySignup.role) or "DPS"
    local pendingClass=(mySignup and mySignup.class) or myClassToken

    local ddSignRole=CreateFrame("Frame",nil,f,"UIDropDownMenuTemplate")
    ddSignRole:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",-6,26)
    UIDropDownMenu_SetWidth(ddSignRole,64)
    local ddSignClass=CreateFrame("Frame",nil,f,"UIDropDownMenuTemplate")
    ddSignClass:SetPoint("LEFT",ddSignRole,"RIGHT",-6,0)
    UIDropDownMenu_SetWidth(ddSignClass,100)

    UIDropDownMenu_Initialize(ddSignRole,function(_,level)
        for _,role in ipairs(ROLE_TOKENS) do
            local ddInfo=UIDropDownMenu_CreateInfo(); ddInfo.text=ROLE_LABEL[role]; ddInfo.value=role; ddInfo.checked=(pendingRole==role)
            ddInfo.func=function(btn) pendingRole=btn.value; UIDropDownMenu_SetSelectedValue(ddSignRole,btn.value); UIDropDownMenu_SetText(ddSignRole,btn.text) end
            UIDropDownMenu_AddButton(ddInfo,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddSignRole,pendingRole); UIDropDownMenu_SetText(ddSignRole,ROLE_LABEL[pendingRole])

    UIDropDownMenu_Initialize(ddSignClass,function(_,level)
        for _,tok in ipairs(CLASS_TOKENS) do
            local ddInfo=UIDropDownMenu_CreateInfo(); ddInfo.text=ClassName(tok); ddInfo.value=tok; ddInfo.checked=(pendingClass==tok)
            ddInfo.func=function(btn) pendingClass=btn.value; UIDropDownMenu_SetSelectedValue(ddSignClass,btn.value); UIDropDownMenu_SetText(ddSignClass,btn.text) end
            UIDropDownMenu_AddButton(ddInfo,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddSignClass,pendingClass); UIDropDownMenu_SetText(ddSignClass,ClassName(pendingClass))

    if mySignup then
        sigBtn:SetText(L.CAL_LEAVE)
        sigBtn:SetScript("OnClick",function() UnsignEvent(eventId); GM_RefreshCalendar(); f:Hide() end)
        local changeBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); changeBtn:SetSize(90,22)
        changeBtn:SetPoint("LEFT",ddSignClass,"RIGHT",-8,2); changeBtn:SetText(L.CAL_CHANGE)
        changeBtn:SetScript("OnClick",function()
            if pendingRole==mySignup.role and pendingClass==mySignup.class then f:Hide(); return end
            if pendingRole~=mySignup.role then
                local c=counts[pendingRole]
                if c.cap>0 and c.signed>=c.cap then print(R.."[GuildMarkt]"..X.." "..L.CAL_ROLEFULL); return end
            end
            SignEvent(eventId,pendingRole,pendingClass); GM_RefreshCalendar()
            print(T.."[GuildMarkt]"..X.." "..L.CAL_CHANGED)
            BuildEventDetailPopup(eventId)
        end)
        local mine=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        mine:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",12,54)
        mine:SetText(Dg..(isDE and "Du: " or "You: ")..X..(ROLE_COLOR[mySignup.role] or W)..(ROLE_LABEL[mySignup.role] or "?")..X
            .." "..ClassColorCode(mySignup.class)..ClassName(mySignup.class)..X
            ..(statusByName[me]=="reserve" and ("  "..Dg.."("..(isDE and "Ersatzbank" or "Reserve")..")"..X) or ""))
    else
        sigBtn:SetText(L.CAL_SIGNUP)
        if (ev.minlvl or 0)>(UnitLevel("player") or 0) then
            sigBtn:Disable()
            sigBtn:SetScript("OnEnter",function(self)
                GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:ClearLines()
                GameTooltip:AddLine(R..string.format(L.CAL_LOWLEVEL,ev.minlvl)..X)
                GameTooltip:Show()
            end)
            sigBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
        else
            sigBtn:SetScript("OnClick",function() SignEvent(eventId,pendingRole,pendingClass); GM_RefreshCalendar(); f:Hide() end)
        end
    end
    -- Loeschen-Button (Ersteller oder per Config-Rang berechtigte)
    if CanRemoveEvent(ev) then
        local delBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); delBtn:SetSize(90,22)
        delBtn:SetPoint("RIGHT",closeBtn,"LEFT",-6,0); delBtn:SetText(R..L.CAL_DELETE..X)
        delBtn:SetScript("OnClick",function()
            DeleteEvent(eventId); GM_RefreshCalendar(); f:Hide()
            print(T.."[GuildMarkt]"..X.." "..L.CAL_DELETED)
        end)
    end
    -- "Alle einladen"-Button (nur für Ersteller oder GM/Offizier)
    if ev.creator==me or CanDeleteOthers() then
        local invBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); invBtn:SetSize(130,22)
        invBtn:SetPoint("LEFT",sigBtn,"RIGHT",6,0)
        invBtn:SetText(isDE and "Alle einladen" or "Invite all")
        invBtn:SetScript("OnClick",function()
            local invited=0
            for name in pairs(ev.signups or {}) do
                if name~=me then InviteUnit(name); invited=invited+1 end
            end
            print(T.."[GuildMarkt]"..X.." "..(isDE and "Eingeladen: " or "Invited: ")..G..invited..X..(isDE and " Spieler." or " players."))
        end)
        invBtn:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:ClearLines()
            GameTooltip:AddLine(isDE and "Alle angemeldeten Spieler in die Gruppe/Raid einladen." or "Invite all signed-up players to group/raid.")
            GameTooltip:Show()
        end)
        invBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    end
    eventDetailFrame=f; f:Show()
end

-- ============================================================
-- DKP-Punkteliste
-- ============================================================
local dkpFrame=nil; local dkpAdjLast="10"; local dkpSearch=""; local dkpOnlineOnly=false
function GM_BuildDKPFrame()
    if dkpFrame then dkpFrame:Hide(); dkpFrame=nil end
    local f=CreateFrame("Frame","GuildMarketDKPFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(340,480); f:SetPoint("CENTER",UIParent,"CENTER",-120,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(25)
    f.TitleBg:SetHeight(28)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,2); titleFS:SetText(G..L.DKP_TITLE..X)
    local me=UnitName("player")
    local mine=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    mine:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-8)
    mine:SetText(Dg..L.DKP_YOURS.." "..X..G..GetDKP(me)..X)

    -- Suche + Online-Filter (skaliert auch bei 500 Mitgliedern)
    local ebSearchD=CreateFrame("EditBox","GuildMarketDkpSearchBox",f,"InputBoxTemplate")
    ebSearchD:SetSize(150,20); ebSearchD:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",12,-26)
    ebSearchD:SetAutoFocus(false); ebSearchD:SetMaxLetters(20); ebSearchD:SetText(dkpSearch)
    local cbOnline=CreateFrame("CheckButton","GuildMarketDkpOnlineCB",f,"UICheckButtonTemplate")
    cbOnline:SetSize(24,24); cbOnline:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",172,-24)
    cbOnline:SetChecked(dkpOnlineOnly)
    local cbLbl=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    cbLbl:SetPoint("LEFT",cbOnline,"RIGHT",0,0); cbLbl:SetText(Dg..L.DKP_ONLINE..X)

    local sep=f:CreateTexture(nil,"BACKGROUND"); sep:SetHeight(1)
    sep:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-52); sep:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-52)
    sep:SetColorTexture(0.3,0.5,0.8,0.7)

    -- Manuelle Punkte-Anpassung: eigener konfigurierbarer Rang (GM immer)
    local canAdjust=IsGM() or playerRankIndex<=((GuildMarketDB.config and GuildMarketDB.config.dkpAdjustRank) or 9)
    local ebAdj
    local listBottom=10
    if canAdjust then
        local lbAdj=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbAdj:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,14); lbAdj:SetText(Dg..L.DKP_ADJ..X)
        ebAdj=CreateFrame("EditBox","GuildMarketDkpAdjBox",f,"InputBoxTemplate")
        ebAdj:SetSize(50,20); ebAdj:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",80,12)
        ebAdj:SetAutoFocus(false); ebAdj:SetMaxLetters(4); ebAdj:SetNumeric(true); ebAdj:SetText(dkpAdjLast)
        listBottom=38
    end

    -- Mini-Spaltenkoepfe: Events (Anwesenheit) | Punkte
    local hdrA=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hdrA:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",canAdjust and -120 or -74,-56); hdrA:SetText(Dg..L.DKP_ATT_HDR..X)
    local hdrP=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hdrP:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",canAdjust and -72 or -26,-56); hdrP:SetText(Dg.."DKP"..X)

    local sfD=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sfD:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,-72); sfD:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-26,listBottom)
    local sc

    local RefreshDkpList  -- forward fuer AdjustDKP
    local function AdjustDKP(name,sign)
        local amt=tonumber(ebAdj and ebAdj:GetText()) or 0
        if amt<=0 then return end
        dkpAdjLast=tostring(amt)
        local ts=time(); local nb=GetDKP(name)+sign*amt
        ApplyDKP(name,nb,ts)
        SendGuild("DKPSYNC|"..name..":"..nb..":"..ts)
        print(T.."[GuildMarkt]"..X.." "..L.DKP_ADJUSTED.." "..W..name..X.." "..(sign>0 and Gr.."+" or R.."-")..amt..X.." ("..G..nb..X..")")
        mine:SetText(Dg..L.DKP_YOURS.." "..X..G..GetDKP(me)..X)
        RefreshDkpList()
    end

    RefreshDkpList=function()
        if sc then sc:Hide() end
        sc=CreateFrame("Frame",nil,sfD); sc:SetWidth(280); sc:SetHeight(20); sfD:SetScrollChild(sc)
        local st=dkpSearch:lower()
        local list={}
        for name,d in pairs(GuildMarketDB.dkp or {}) do
            local match=(st=="" or name:lower():find(st,1,true)) and (not dkpOnlineOnly or IsOnline(name))
            if match then list[#list+1]={name=name,bal=d.bal or 0} end
        end
        table.sort(list,function(a,b) if a.bal~=b.bal then return a.bal>b.bal end; return a.name<b.name end)
        local ry=0
        for i,entry in ipairs(list) do
            local rbg=sc:CreateTexture(nil,"BACKGROUND"); rbg:SetHeight(20)
            rbg:SetPoint("TOPLEFT",sc,"TOPLEFT",0,-ry); rbg:SetPoint("TOPRIGHT",sc,"TOPRIGHT",0,-ry)
            if entry.name==me then rbg:SetColorTexture(0.10,0.18,0.10,0.8)
            elseif i%2==1 then rbg:SetColorTexture(0.08,0.08,0.18,0.7) else rbg:SetColorTexture(0.05,0.05,0.12,0.5) end
            local online=IsOnline(entry.name)
            local lbRank=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            lbRank:SetPoint("TOPLEFT",sc,"TOPLEFT",4,-ry-3); lbRank:SetText(Dg..i.."."..X); lbRank:SetSize(24,14)
            local lbN=sc:CreateFontString(nil,"OVERLAY","GameFontNormal")
            lbN:SetPoint("TOPLEFT",sc,"TOPLEFT",30,-ry-3); lbN:SetSize(130,14); lbN:SetJustifyH("LEFT")
            lbN:SetText(online and W..entry.name..X or Dg..entry.name..X)
            -- Anwesenheits-Spalte (bestaetigte Event-Teilnahmen)
            local lbA=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            lbA:SetPoint("TOPRIGHT",sc,"TOPRIGHT",canAdjust and -100 or -54,-ry-3); lbA:SetSize(36,14); lbA:SetJustifyH("RIGHT")
            lbA:SetText(T..((GuildMarketDB.attendance and GuildMarketDB.attendance[entry.name]) or 0)..X)
            local lbB=sc:CreateFontString(nil,"OVERLAY","GameFontNormal")
            lbB:SetPoint("TOPRIGHT",sc,"TOPRIGHT",canAdjust and -52 or -6,-ry-3); lbB:SetSize(44,14); lbB:SetJustifyH("RIGHT")
            lbB:SetText(G..entry.bal..X)
            if canAdjust then
                local name=entry.name
                local plusBtn=CreateFrame("Button",nil,sc,"UIPanelButtonTemplate"); plusBtn:SetSize(20,17)
                plusBtn:SetPoint("TOPRIGHT",sc,"TOPRIGHT",-26,-ry-1); plusBtn:SetText("+")
                plusBtn:SetScript("OnClick",function() AdjustDKP(name,1) end)
                local minusBtn=CreateFrame("Button",nil,sc,"UIPanelButtonTemplate"); minusBtn:SetSize(20,17)
                minusBtn:SetPoint("TOPRIGHT",sc,"TOPRIGHT",-4,-ry-1); minusBtn:SetText("-")
                minusBtn:SetScript("OnClick",function() AdjustDKP(name,-1) end)
            end
            ry=ry+20; sc:SetHeight(ry)
        end
        if #list==0 then
            local hint=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            hint:SetPoint("TOPLEFT",sc,"TOPLEFT",8,-6); hint:SetText(Dg..L.DKP_EMPTY..X); sc:SetHeight(26)
        end
    end

    ebSearchD:SetScript("OnTextChanged",function(self,user)
        if user then dkpSearch=self:GetText(); RefreshDkpList() end
    end)
    cbOnline:SetScript("OnClick",function(self)
        dkpOnlineOnly=self:GetChecked() and true or false; RefreshDkpList()
    end)
    RefreshDkpList()
    dkpFrame=f; f:Show()
end

-- ============================================================
-- Loot-Auktions-Fenster
-- ============================================================
local lootFrame=nil
local function FormatTimeLeft(sec)
    if sec<=0 then return R..L.AUC_EXPIRED..X end
    if sec>=3600 then return T..math.floor(sec/3600).."h "..math.floor((sec%3600)/60).."m"..X end
    return T..math.floor(sec/60)..":"..string.format("%02d",sec%60)..X
end
function GM_BuildLootFrame()
    if lootFrame then lootFrame:Hide(); lootFrame=nil end
    local f=CreateFrame("Frame","GuildMarketLootFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(540,540); f:SetPoint("CENTER",UIParent,"CENTER",100,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(25)
    f.TitleBg:SetHeight(28)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,2); titleFS:SetText(G..L.AUC_TITLE..X)
    local me=UnitName("player")
    local listTop=-8

    -- ── Erstellen-Sektion (rang-beschraenkt) ──
    if CanCreateAuction() then
        local lbItem=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbItem:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-10); lbItem:SetText(Dg..L.AUC_ITEM..X)
        local ebAucItem=CreateFrame("EditBox","GuildMarketAucItemBox",f,"InputBoxTemplate")
        ebAucItem:SetSize(320,22); ebAucItem:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",160,-6)
        ebAucItem:SetAutoFocus(false); ebAucItem:SetMaxLetters(40); ebAucItem.itemLink=nil
        ebAucItem:SetScript("OnReceiveDrag",function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
        ebAucItem:SetScript("OnMouseDown",  function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
        local lbMin=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbMin:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-40); lbMin:SetText(Dg..L.AUC_MINBID..X)
        local ebAucMin=CreateFrame("EditBox","GuildMarketAucMinBox",f,"InputBoxTemplate")
        ebAucMin:SetSize(50,22); ebAucMin:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",160,-36)
        ebAucMin:SetAutoFocus(false); ebAucMin:SetMaxLetters(4); ebAucMin:SetNumeric(true); ebAucMin:SetText("1")
        local lbDur=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbDur:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",240,-40); lbDur:SetText(Dg..L.AUC_DUR..X)
        local ebAucDur=CreateFrame("EditBox","GuildMarketAucDurBox",f,"InputBoxTemplate")
        ebAucDur:SetSize(44,22); ebAucDur:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",340,-36)
        ebAucDur:SetAutoFocus(false); ebAucDur:SetMaxLetters(3); ebAucDur:SetNumeric(true); ebAucDur:SetText("10")
        local startBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
        startBtn:SetSize(120,24); startBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-8,-34)
        startBtn:SetText(L.AUC_START)
        startBtn:SetScript("OnClick",function()
            if not CanCreateAuction() then print(R.."[GuildMarkt]"..X.." "..L.AUC_NORANK); return end
            local name=ebAucItem:GetText()
            if name=="" then print(R.."[GuildMarkt]"..X.." "..L.AUC_NOITEM); return end
            local link=ebAucItem.itemLink
            local itemId=link and tonumber(link:match("|Hitem:(%d+)"))
            local minBid=math.max(1,tonumber(ebAucMin:GetText()) or 1)
            local dur=math.max(1,tonumber(ebAucDur:GetText()) or 10)
            PostAuction(name,itemId,link,minBid,dur)
            print(T.."[GuildMarkt]"..X.." "..L.AUC_CREATED.." "..W..name..X)
            ebAucItem:SetText(""); ebAucItem.itemLink=nil
            GM_BuildLootFrame()
        end)
        local sep=f:CreateTexture(nil,"BACKGROUND"); sep:SetHeight(1)
        sep:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-66); sep:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-66)
        sep:SetColorTexture(0.3,0.5,0.8,0.7)
        listTop=-72
    end

    -- ── Auktionsliste ──
    local sfA=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sfA:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,listTop); sfA:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-26,30)
    local sc=CreateFrame("Frame",nil,sfA); sc:SetWidth(480); sc:SetHeight(20); sfA:SetScrollChild(sc)

    local open,done={},{}
    for id,a in pairs(GuildMarketDB.auctions or {}) do
        if a.closed then done[#done+1]={id=id,a=a} else open[#open+1]={id=id,a=a} end
    end
    table.sort(open,function(x,y) return (x.a.endts or 0)<(y.a.endts or 0) end)
    table.sort(done,function(x,y) return (x.a.closedAt or 0)>(y.a.closedAt or 0) end)

    f.timeRows={}
    local ry=0
    local function AucRow(id,a,isClosed)
        local row=CreateFrame("Frame",nil,sc,"BackdropTemplate")
        row:SetHeight(46); row:SetPoint("TOPLEFT",sc,"TOPLEFT",0,-ry); row:SetPoint("TOPRIGHT",sc,"TOPRIGHT",0,-ry)
        row:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=6,insets={left=2,right=2,top=2,bottom=2}})
        if isClosed then row:SetBackdropColor(0.06,0.06,0.06,0.6); row:SetBackdropBorderColor(0.15,0.15,0.15,0.5)
        else row:SetBackdropColor(0.05,0.05,0.11,0.9); row:SetBackdropBorderColor(0.2,0.2,0.45,0.7) end
        a.link=a.link or (a.itemId and select(2,GetItemInfo(a.itemId)))
        local itemBtn=CreateFrame("Button",nil,row)
        itemBtn:SetSize(240,16); itemBtn:SetPoint("TOPLEFT",row,"TOPLEFT",8,-6)
        local itemFS=itemBtn:CreateFontString(nil,"OVERLAY","GameFontNormal")
        itemFS:SetAllPoints(); itemFS:SetJustifyH("LEFT")
        itemFS:SetText(a.link or W..(a.item or "?")..X)
        itemBtn:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
            if a.link then GameTooltip:SetHyperlink(a.link)
            elseif a.itemId then GameTooltip:SetHyperlink("item:"..a.itemId)
            else GameTooltip:ClearLines(); GameTooltip:AddLine(a.item or "?") end
            GameTooltip:Show()
        end)
        itemBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
        local sellerFS=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        sellerFS:SetPoint("TOPLEFT",row,"TOPLEFT",260,-8); sellerFS:SetText(Dg..L.AUC_SELLER.." "..X..W..(a.seller or "?")..X)
        local timeFS=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        timeFS:SetPoint("TOPRIGHT",row,"TOPRIGHT",-8,-8)
        local top,topAmt=AuctionTopBid(a)
        if isClosed then
            timeFS:SetText(Dg..L.AUC_EXPIRED..X)
            local resFS=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            resFS:SetPoint("BOTTOMLEFT",row,"BOTTOMLEFT",8,7)
            if a.winner then resFS:SetText(Gr..a.winner..X.." "..L.AUC_WON.." ("..G..(a.winAmt or 0)..X..")")
            else resFS:SetText(Dg..L.AUC_NOBIDS..X) end
        else
            timeFS:SetText(FormatTimeLeft((a.endts or 0)-time()))
            f.timeRows[#f.timeRows+1]={fs=timeFS,endts=a.endts or 0}
            local bidFS=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            bidFS:SetPoint("BOTTOMLEFT",row,"BOTTOMLEFT",8,7)
            local myBid=a.bids and a.bids[me] and a.bids[me].amt
            bidFS:SetText((top and (Dg..L.AUC_TOPBID.." "..X..G..topAmt..X.." ("..(top==me and Gr or W)..top..X..")")
                or Dg..L.AUC_NOBIDS.." — Min: "..X..G..(a.minBid or 1)..X)
                ..(myBid and ("  "..Dg..L.AUC_YOURBID..": "..X..G..myBid..X) or ""))
            -- Bieten
            local ebBid=CreateFrame("EditBox",nil,row,"InputBoxTemplate")
            ebBid:SetSize(44,20); ebBid:SetPoint("BOTTOMRIGHT",row,"BOTTOMRIGHT",-92,5)
            ebBid:SetAutoFocus(false); ebBid:SetMaxLetters(4); ebBid:SetNumeric(true)
            ebBid:SetText(tostring(math.max((topAmt or 0)+1,a.minBid or 1)))
            local bidBtn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); bidBtn:SetSize(80,20)
            bidBtn:SetPoint("BOTTOMRIGHT",row,"BOTTOMRIGHT",-8,5); bidBtn:SetText(L.AUC_BID)
            bidBtn:SetScript("OnClick",function()
                local a2=GuildMarketDB.auctions[id]; if not a2 or a2.closed or (a2.endts or 0)<=time() then return end
                local amt=tonumber(ebBid:GetText())
                local _,curTop=AuctionTopBid(a2)
                if not amt or amt<(a2.minBid or 1) or amt<=curTop then print(R.."[GuildMarkt]"..X.." "..L.AUC_LOWBID); return end
                if amt>GetDKP(me) then print(R.."[GuildMarkt]"..X.." "..L.AUC_NOPOINTS); return end
                BidAuction(id,amt)
                print(T.."[GuildMarkt]"..X.." "..L.AUC_BIDSET.." "..G..amt..X.." — "..W..(a2.item or "?")..X)
                GM_BuildLootFrame()
            end)
            -- Verwalten (Verkaeufer/berechtigter Rang)
            if CanManageAuction(a) then
                local endBtn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); endBtn:SetSize(70,18)
                endBtn:SetPoint("TOPRIGHT",row,"TOPRIGHT",-66,-4); endBtn:SetText(L.AUC_CLOSE)
                endBtn:SetScript("OnClick",function() CloseAuction(id); GM_BuildLootFrame() end)
                local xBtn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); xBtn:SetSize(20,18)
                xBtn:SetPoint("TOPRIGHT",row,"TOPRIGHT",-42,-4); xBtn:SetText("×")
                xBtn:SetScript("OnClick",function() CancelAuction(id); GM_BuildLootFrame() end)
            end
        end
        ry=ry+48; sc:SetHeight(ry)
    end
    for _,e in ipairs(open) do AucRow(e.id,e.a,false) end
    for _,e in ipairs(done) do AucRow(e.id,e.a,true) end
    if ry==0 then
        local hint=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        hint:SetPoint("TOPLEFT",sc,"TOPLEFT",8,-8); hint:SetWidth(460); hint:SetJustifyH("LEFT")
        hint:SetText(Dg..L.AUC_EMPTY..X); sc:SetHeight(30)
    end

    -- Footer: eigener Punktestand
    local mineFS=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    mineFS:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,8)
    mineFS:SetText(Dg..L.DKP_YOURS.." "..X..G..GetDKP(me)..X)

    -- Countdown-Ticker (nur Anzeige; Auto-Abschluss macht aucTicker)
    local acc=0
    f:SetScript("OnUpdate",function(self,dt)
        acc=acc+dt; if acc<1 then return end
        acc=0; local now=time()
        for _,tr in ipairs(self.timeRows) do tr.fs:SetText(FormatTimeLeft(tr.endts-now)) end
    end)

    lootFrame=f; f:Show()
end
RefreshLootFrame=function() if lootFrame and lootFrame:IsShown() then GM_BuildLootFrame() end end

-- ============================================================
-- Merch-Shop-Fenster
-- ============================================================
local merchFrame=nil
function GM_BuildMerchFrame()
    if merchFrame then merchFrame:Hide(); merchFrame=nil end
    local f=CreateFrame("Frame","GuildMarketMerchFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(540,520); f:SetPoint("CENTER",UIParent,"CENTER",120,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(25)
    f.TitleBg:SetHeight(28)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,2); titleFS:SetText(G..L.MSH_TITLE..X)
    local me=UnitName("player")
    local listTop=-8

    -- ── Anlegen-Sektion (rang-beschraenkt, GM immer) ──
    if CanCreateMerch() then
        local lbItem=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbItem:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-10); lbItem:SetText(Dg..L.MSH_ITEM..X)
        local ebMshItem=CreateFrame("EditBox","GuildMarketMshItemBox",f,"InputBoxTemplate")
        ebMshItem:SetSize(320,22); ebMshItem:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",160,-6)
        ebMshItem:SetAutoFocus(false); ebMshItem:SetMaxLetters(40); ebMshItem.itemLink=nil
        ebMshItem:SetScript("OnReceiveDrag",function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
        ebMshItem:SetScript("OnMouseDown",  function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
        local lbPrice=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbPrice:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-40); lbPrice:SetText(Dg..L.MSH_PRICE..X)
        local ebMshPrice=CreateFrame("EditBox","GuildMarketMshPriceBox",f,"InputBoxTemplate")
        ebMshPrice:SetSize(50,22); ebMshPrice:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",160,-36)
        ebMshPrice:SetAutoFocus(false); ebMshPrice:SetMaxLetters(4); ebMshPrice:SetNumeric(true)
        local lbStock=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbStock:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",230,-40); lbStock:SetText(Dg..L.MSH_STOCK..X)
        local ebMshStock=CreateFrame("EditBox","GuildMarketMshStockBox",f,"InputBoxTemplate")
        ebMshStock:SetSize(44,22); ebMshStock:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",380,-36)
        ebMshStock:SetAutoFocus(false); ebMshStock:SetMaxLetters(3); ebMshStock:SetNumeric(true); ebMshStock:SetText("0")
        local createBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
        createBtn:SetSize(100,24); createBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-8,-34)
        createBtn:SetText(L.MSH_CREATE)
        createBtn:SetScript("OnClick",function()
            if not CanCreateMerch() then print(R.."[GuildMarkt]"..X.." "..L.MSH_NORANK); return end
            local name=ebMshItem:GetText()
            if name=="" then print(R.."[GuildMarkt]"..X.." "..L.MSH_NOITEM); return end
            local price=tonumber(ebMshPrice:GetText())
            if not price or price<1 then print(R.."[GuildMarkt]"..X.." "..L.MSH_NOPRICE); return end
            local link=ebMshItem.itemLink
            local itemId=link and tonumber(link:match("|Hitem:(%d+)"))
            PostMerch(name,itemId,link,price,tonumber(ebMshStock:GetText()) or 0)
            print(T.."[GuildMarkt]"..X.." "..L.MSH_CREATED.." "..W..name..X)
            ebMshItem:SetText(""); ebMshItem.itemLink=nil; ebMshPrice:SetText(""); ebMshStock:SetText("0")
            GM_BuildMerchFrame()
        end)
        local sep=f:CreateTexture(nil,"BACKGROUND"); sep:SetHeight(1)
        sep:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-66); sep:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-66)
        sep:SetColorTexture(0.3,0.5,0.8,0.7)
        listTop=-72
    end

    -- ── Artikel-Liste ──
    local sfM=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sfM:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,listTop); sfM:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-26,30)
    local sc=CreateFrame("Frame",nil,sfM); sc:SetWidth(480); sc:SetHeight(20); sfM:SetScrollChild(sc)

    local items={}
    for id,m in pairs(GuildMarketDB.merch or {}) do items[#items+1]={id=id,m=m} end
    table.sort(items,function(x,y) return (x.m.created or 0)>(y.m.created or 0) end)

    local myBal=GetDKP(me)
    local ry=0

    -- ── Offene Kaeufe (Gildenleitung/Verkaeufer bestaetigen die Uebergabe) ──
    local orders={}
    for oid,o in pairs(GuildMarketDB.merchOrders or {}) do
        if CanConfirmOrder(o) or o.buyer==me then orders[#orders+1]={oid=oid,o=o} end
    end
    table.sort(orders,function(x,y) return (x.o.ts or 0)<(y.o.ts or 0) end)
    if #orders>0 then
        local hdr=sc:CreateFontString(nil,"OVERLAY","GameFontNormal")
        hdr:SetPoint("TOPLEFT",sc,"TOPLEFT",4,-ry-4); hdr:SetText(G..L.MSH_ORDERS.." ("..#orders..")"..X)
        ry=ry+22
        for _,e in ipairs(orders) do
            local oid,o=e.oid,e.o
            local row=CreateFrame("Frame",nil,sc,"BackdropTemplate")
            row:SetHeight(26); row:SetPoint("TOPLEFT",sc,"TOPLEFT",0,-ry); row:SetPoint("TOPRIGHT",sc,"TOPRIGHT",0,-ry)
            row:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=6,insets={left=2,right=2,top=2,bottom=2}})
            row:SetBackdropColor(0.16,0.12,0.03,0.92); row:SetBackdropBorderColor(0.8,0.65,0.1,0.9)
            local online=IsOnline(o.buyer)
            local dot=row:CreateTexture(nil,"OVERLAY"); dot:SetSize(14,14); dot:SetPoint("LEFT",row,"LEFT",6,0)
            dot:SetTexture(online and "Interface\\FriendsFrame\\StatusIcon-Online" or "Interface\\FriendsFrame\\StatusIcon-Offline")
            dot:SetVertexColor(1,1,1,online and 1 or 0.35)
            local lbO=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            lbO:SetPoint("LEFT",row,"LEFT",24,0); lbO:SetJustifyH("LEFT"); lbO:SetWidth(270)
            lbO:SetText((online and W or Dg)..(o.buyer or "?")..X..Dg.." — "..X..W..(o.item or "?")..X.." "..G.."("..(o.price or 0)..")"..X
                ..(o.buyer==me and (" "..Dg..L.MSH_PENDING..X) or ""))
            if CanConfirmOrder(o) then
                local cfBtn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); cfBtn:SetSize(90,20)
                cfBtn:SetPoint("RIGHT",row,"RIGHT",-4,0); cfBtn:SetText(L.MSH_CONFIRM)
                cfBtn:SetScript("OnClick",function() ConfirmOrder(oid); GM_BuildMerchFrame() end)
                if online then
                    local wb=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); wb:SetSize(80,20)
                    wb:SetPoint("RIGHT",cfBtn,"LEFT",-4,0); wb:SetText(L.INFO_WHISPER)
                    wb:SetScript("OnClick",function() OpenWhisper(o.buyer) end)
                end
            end
            ry=ry+28; sc:SetHeight(ry)
        end
        ry=ry+6
    end
    for _,e in ipairs(items) do
        local id,m=e.id,e.m
        local soldOut=m.stock==-1
        local row=CreateFrame("Frame",nil,sc,"BackdropTemplate")
        row:SetHeight(46); row:SetPoint("TOPLEFT",sc,"TOPLEFT",0,-ry); row:SetPoint("TOPRIGHT",sc,"TOPRIGHT",0,-ry)
        row:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=6,insets={left=2,right=2,top=2,bottom=2}})
        if soldOut then row:SetBackdropColor(0.06,0.06,0.06,0.6); row:SetBackdropBorderColor(0.15,0.15,0.15,0.5)
        else row:SetBackdropColor(0.05,0.05,0.11,0.9); row:SetBackdropBorderColor(0.2,0.2,0.45,0.7) end
        m.link=m.link or (m.itemId and m.itemId>0 and select(2,GetItemInfo(m.itemId)))
        local itemBtn=CreateFrame("Button",nil,row)
        itemBtn:SetSize(240,16); itemBtn:SetPoint("TOPLEFT",row,"TOPLEFT",8,-6)
        local itemFS=itemBtn:CreateFontString(nil,"OVERLAY","GameFontNormal")
        itemFS:SetAllPoints(); itemFS:SetJustifyH("LEFT")
        itemFS:SetText(m.link or W..(m.item or "?")..X)
        itemBtn:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
            if m.link then GameTooltip:SetHyperlink(m.link)
            elseif m.itemId and m.itemId>0 then GameTooltip:SetHyperlink("item:"..m.itemId)
            else GameTooltip:ClearLines(); GameTooltip:AddLine(m.item or "?") end
            GameTooltip:Show()
        end)
        itemBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
        local sellerFS=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        sellerFS:SetPoint("TOPLEFT",row,"TOPLEFT",260,-8)
        sellerFS:SetText(Dg..L.AUC_SELLER.." "..X..W..(m.seller or "?")..X)
        local stockFS=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        stockFS:SetPoint("TOPRIGHT",row,"TOPRIGHT",-8,-8)
        if soldOut then stockFS:SetText(R..L.MSH_SOLDOUT..X)
        else stockFS:SetText(Dg..L.MSH_STOCKLBL.." "..X..W..((m.stock or 0)==0 and (isDE and "unbegrenzt" or "unlimited") or m.stock)..X) end
        local priceFS=row:CreateFontString(nil,"OVERLAY","GameFontNormal")
        priceFS:SetPoint("BOTTOMLEFT",row,"BOTTOMLEFT",8,7)
        priceFS:SetText(G..(m.price or 0)..X..Dg.." "..L.DKP_TITLE..X)
        if not soldOut then
            local buyBtn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); buyBtn:SetSize(90,20)
            buyBtn:SetPoint("BOTTOMRIGHT",row,"BOTTOMRIGHT",-8,5); buyBtn:SetText(L.MSH_BUY)
            if myBal<(m.price or 0) then buyBtn:Disable() end
            buyBtn:SetScript("OnClick",function() BuyMerch(id); GM_BuildMerchFrame() end)
        end
        if CanManageMerch(m) then
            local xBtn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate"); xBtn:SetSize(20,18)
            xBtn:SetPoint("TOPRIGHT",row,"TOPRIGHT",-8,-24); xBtn:SetText("×")
            xBtn:SetScript("OnClick",function() DeleteMerch(id); GM_BuildMerchFrame() end)
        end
        ry=ry+48; sc:SetHeight(ry)
    end
    if ry==0 then
        local hint=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        hint:SetPoint("TOPLEFT",sc,"TOPLEFT",8,-8); hint:SetText(Dg..L.MSH_EMPTY..X); sc:SetHeight(30)
    end

    local mineFS=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    mineFS:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",10,8)
    mineFS:SetText(Dg..L.DKP_YOURS.." "..X..G..GetDKP(me)..X)

    merchFrame=f; f:Show()
end
RefreshMerchFrame=function() if merchFrame and merchFrame:IsShown() then GM_BuildMerchFrame() end end

-- ============================================================
-- Berufe-Verzeichnis-Fenster
-- ============================================================
local profsFrame=nil; local profSearch=""
function GM_BuildProfsFrame()
    if profsFrame then profsFrame:Hide(); profsFrame=nil end
    local f=CreateFrame("Frame","GuildMarketProfsFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(480,460); f:SetPoint("CENTER",UIParent,"CENTER",-60,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(25)
    f.TitleBg:SetHeight(28)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,2); titleFS:SetText(G..L.PROF_TITLE..X)
    local me=UnitName("player")

    local ebSearchP=CreateFrame("EditBox","GuildMarketProfSearchBox",f,"InputBoxTemplate")
    ebSearchP:SetSize(180,20); ebSearchP:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",12,-8)
    ebSearchP:SetAutoFocus(false); ebSearchP:SetMaxLetters(24); ebSearchP:SetText(profSearch)

    local sep=f:CreateTexture(nil,"BACKGROUND"); sep:SetHeight(1)
    sep:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-34); sep:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-34)
    sep:SetColorTexture(0.3,0.5,0.8,0.7)

    local sfP=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sfP:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,-40); sfP:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-26,10)
    local sc

    local function ProfsText(p)
        local out={}
        for idx=1,#PROF_NAMES do
            local rank=p.s and p.s[idx]
            if rank then out[#out+1]=PROF_NAMES[idx].." "..rank end
        end
        return table.concat(out,", ")
    end

    local function RefreshProfList()
        if sc then sc:Hide() end
        sc=CreateFrame("Frame",nil,sfP); sc:SetWidth(420); sc:SetHeight(20); sfP:SetScrollChild(sc)
        local st=profSearch:lower()
        local list={}
        for name,p in pairs(GuildMarketDB.profs or {}) do
            local ptext=ProfsText(p)
            local match=(st=="" or name:lower():find(st,1,true) or ptext:lower():find(st,1,true))
            if match and ptext~="" then
                local hasCraft=false
                for idx in pairs(p.s or {}) do if PROF_HAS_RECIPES[idx] then hasCraft=true; break end end
                list[#list+1]={name=name,ptext=ptext,hasCraft=hasCraft}
            end
        end
        table.sort(list,function(a,b)
            if (a.name==me)~=(b.name==me) then return a.name==me end
            local ao=IsOnline(a.name) and 1 or 0; local bo=IsOnline(b.name) and 1 or 0
            if ao~=bo then return ao>bo end
            return a.name<b.name
        end)
        local ry=0
        for i,e in ipairs(list) do
            local rbg=sc:CreateTexture(nil,"BACKGROUND"); rbg:SetHeight(30)
            rbg:SetPoint("TOPLEFT",sc,"TOPLEFT",0,-ry); rbg:SetPoint("TOPRIGHT",sc,"TOPRIGHT",0,-ry)
            if e.name==me then rbg:SetColorTexture(0.10,0.18,0.10,0.8)
            elseif i%2==1 then rbg:SetColorTexture(0.08,0.08,0.18,0.7) else rbg:SetColorTexture(0.05,0.05,0.12,0.5) end
            local online=IsOnline(e.name)
            local dot=sc:CreateTexture(nil,"OVERLAY"); dot:SetSize(13,13); dot:SetPoint("TOPLEFT",sc,"TOPLEFT",4,-ry-3)
            dot:SetTexture(online and "Interface\\FriendsFrame\\StatusIcon-Online" or "Interface\\FriendsFrame\\StatusIcon-Offline")
            dot:SetVertexColor(1,1,1,online and 1 or 0.35)
            local lbN=sc:CreateFontString(nil,"OVERLAY","GameFontNormal")
            lbN:SetPoint("TOPLEFT",sc,"TOPLEFT",20,-ry-2); lbN:SetSize(120,14); lbN:SetJustifyH("LEFT")
            lbN:SetText(online and W..e.name..X or Dg..e.name..X)
            -- Rezepte-Button: bei Craft-Beruf und (online oder eigener Char); Whisper: online + fremd
            local showRcp=e.hasCraft and (online or e.name==me)
            local showWhisper=online and e.name~=me
            local rightEdge = -6
            if showWhisper then rightEdge=-90 end
            if showRcp then rightEdge=rightEdge-72 end
            local lbP=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            lbP:SetPoint("TOPLEFT",sc,"TOPLEFT",20,-ry-16); lbP:SetPoint("TOPRIGHT",sc,"TOPRIGHT",rightEdge,-ry-16)
            lbP:SetHeight(13); lbP:SetJustifyH("LEFT")
            lbP:SetText(T..e.ptext..X)
            local nm=e.name
            if showWhisper then
                local wb=CreateFrame("Button",nil,sc,"UIPanelButtonTemplate"); wb:SetSize(80,19)
                wb:SetPoint("TOPRIGHT",sc,"TOPRIGHT",-4,-ry-6); wb:SetText(L.INFO_WHISPER)
                wb:SetScript("OnClick",function() OpenWhisper(nm) end)
            end
            if showRcp then
                local rb=CreateFrame("Button",nil,sc,"UIPanelButtonTemplate"); rb:SetSize(66,19)
                rb:SetPoint("TOPRIGHT",sc,"TOPRIGHT",showWhisper and -88 or -4,-ry-6); rb:SetText(L.PROF_RECIPES)
                rb:SetScript("OnClick",function() GM_ShowRecipes(nm) end)
            end
            ry=ry+30; sc:SetHeight(ry)
        end
        if #list==0 then
            local hint=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            hint:SetPoint("TOPLEFT",sc,"TOPLEFT",8,-8); hint:SetWidth(400); hint:SetJustifyH("LEFT")
            hint:SetText(Dg..L.PROF_EMPTY..X); sc:SetHeight(40)
        end
    end
    ebSearchP:SetScript("OnTextChanged",function(self,user)
        if user then profSearch=self:GetText(); RefreshProfList() end
    end)
    RefreshProfList()
    profsFrame=f; f:Show()
end

-- ============================================================
-- Rezept-Fenster: zeigt "was kann Spieler X" pro Beruf (On-Demand geladen)
-- ============================================================
local recipeFrame=nil
function GM_ShowRecipes(playerName)
    if recipeFrame then recipeFrame:Hide(); recipeFrame=nil end
    local me=UnitName("player")
    local p=GuildMarketDB.profs and GuildMarketDB.profs[playerName]
    if not p or not p.s then return end
    -- herstellbare Berufe dieses Spielers ermitteln
    local craftIdx={}
    for idx in pairs(p.s) do if PROF_HAS_RECIPES[idx] then craftIdx[#craftIdx+1]=idx end end
    if #craftIdx==0 then return end
    table.sort(craftIdx)

    local f=CreateFrame("Frame","GuildMarketRecipeFrame",UIParent,"BasicFrameTemplateWithInset")
    f:SetSize(400,480); f:SetPoint("CENTER",UIParent,"CENTER",200,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(30)
    f.TitleBg:SetHeight(28)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,2)
    titleFS:SetText(G..L.PROF_RECIPES..": "..X..(IsOnline(playerName) and W or Dg)..playerName..X)

    -- Berufs-Auswahlknoepfe oben
    local selIdx=craftIdx[1]
    local profBtns={}
    local bx=10
    for _,idx in ipairs(craftIdx) do
        local b=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
        local label=PROF_NAMES[idx]
        b:SetSize(math.min(120,28+#label*6),22); b:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",bx,-8)
        b:SetText(label); bx=bx+b:GetWidth()+4
        b.idx=idx; profBtns[idx]=b
    end

    local sep=f:CreateTexture(nil,"BACKGROUND"); sep:SetHeight(1)
    sep:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-34); sep:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-34)
    sep:SetColorTexture(0.3,0.5,0.8,0.7)

    local searchR=""
    local ebSearchR=CreateFrame("EditBox","GuildMarketRcpSearchBox",f,"InputBoxTemplate")
    ebSearchR:SetSize(160,20); ebSearchR:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",12,-40)
    ebSearchR:SetAutoFocus(false); ebSearchR:SetMaxLetters(24)

    local status=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    status:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",180,-44); status:SetJustifyH("LEFT"); status:SetWidth(200)

    local sfR=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sfR:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,-64); sfR:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-26,10)
    local sc
    local curNames=nil  -- aktuell geladene Rezeptliste (oder nil = laedt/keine)

    local function DrawList()
        if sc then sc:Hide() end
        sc=CreateFrame("Frame",nil,sfR); sc:SetWidth(350); sc:SetHeight(20); sfR:SetScrollChild(sc)
        if not curNames then return end
        local st=searchR:lower()
        local ry=0
        for _,e in ipairs(curNames) do
            local nm=type(e)=="table" and e.n or e
            local id=type(e)=="table" and e.i or nil
            if nm and (st=="" or nm:lower():find(st,1,true)) then
                -- Klickbare Zeile: Hover zeigt den Item-Tooltip, Shift-Klick verlinkt ins Chatfenster
                local row=CreateFrame("Button",nil,sc)
                row:SetSize(338,15); row:SetPoint("TOPLEFT",sc,"TOPLEFT",6,-ry)
                local fsL=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                fsL:SetAllPoints(); fsL:SetJustifyH("LEFT"); fsL:SetText(W..nm..X)
                if id then
                    row:SetScript("OnEnter",function(self)
                        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
                        GameTooltip:SetHyperlink("item:"..id); GameTooltip:Show()
                    end)
                    row:SetScript("OnClick",function()
                        if IsShiftKeyDown() then
                            local _,lnk=GetItemInfo(id)
                            if lnk then ChatEdit_InsertLink(lnk) end
                        end
                    end)
                else
                    row:SetScript("OnEnter",function(self)
                        GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:ClearLines()
                        GameTooltip:AddLine(nm,1,1,1); GameTooltip:Show()
                    end)
                end
                row:SetScript("OnLeave",function() GameTooltip:Hide() end)
                ry=ry+15; sc:SetHeight(ry)
            end
        end
        if ry==0 then
            local h=sc:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            h:SetPoint("TOPLEFT",sc,"TOPLEFT",6,-2); h:SetText(Dg..L.PROF_RCP_EMPTY..X); sc:SetHeight(20)
        end
    end

    local function LoadProf(idx)
        selIdx=idx; curNames=nil; searchR=""; ebSearchR:SetText("")
        for i,b in pairs(profBtns) do if i==idx then b:LockHighlight() else b:UnlockHighlight() end end
        DrawList()
        if playerName==me then
            -- eigene Rezepte direkt aus dem Cache
            local rec=GuildMarketDB.myRecipes and GuildMarketDB.myRecipes[idx]
            if rec and rec.r then curNames=rec.r; status:SetText(Dg..#rec.r.." "..L.PROF_RECIPES..X)
            else status:SetText(R..string.format(L.PROF_RCP_NONE,playerName)..X) end
            DrawList(); return
        end
        status:SetText(T..L.PROF_RCP_LOADING..X)
        GM_RequestRecipes(playerName,idx,function(names,reason)
            if not f:IsShown() or selIdx~=idx then return end
            if names then curNames=names; status:SetText(Dg..#names.." "..L.PROF_RECIPES..X); DrawList()
            elseif reason=="none" then status:SetText(R..string.format(L.PROF_RCP_NONE,playerName)..X)
            else status:SetText(R..L.PROF_RCP_TIMEOUT..X) end
        end)
    end
    for idx,b in pairs(profBtns) do b:SetScript("OnClick",function(self) LoadProf(self.idx) end) end
    ebSearchR:SetScript("OnTextChanged",function(self,user) if user then searchR=self:GetText(); DrawList() end end)

    recipeFrame=f; f:Show()
    LoadProf(selIdx)
end

-- ============================================================
-- Schwarzes-Brett-Fenster (Ansicht + Verfassen fuer Berechtigte)
-- ============================================================
local boardFrame=nil
function GM_BuildBoardFrame()
    if boardFrame then boardFrame:Hide(); boardFrame=nil end
    local f=CreateFrame("Frame","GuildMarketBoardFrame",UIParent,"BasicFrameTemplateWithInset")
    local canPost=CanPostBoard()
    f:SetSize(460,canPost and 430 or 300); f:SetPoint("CENTER",UIParent,"CENTER",60,0)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG"); f:SetFrameLevel(25)
    f.TitleBg:SetHeight(28)
    local titleFS=f:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    titleFS:SetPoint("CENTER",f.TitleBg,"CENTER",0,2); titleFS:SetText(G..L.BRD_TITLE..X)

    -- Aktuelle Ankuendigung
    local b=GuildMarketDB.board
    local meta=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    meta:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-8)
    if b and b.text and b.text~="" then
        meta:SetText(Dg..L.BRD_BY.." "..X..W..(b.author or "?")..X..Dg.." — "..date("%d.%m.%Y %H:%M",b.ts or 0)..X)
    else
        meta:SetText(Dg..L.BRD_EMPTY..X)
    end
    local sfB=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
    sfB:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",8,-26)
    sfB:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-28,canPost and 170 or 10)
    local scB=CreateFrame("Frame",nil,sfB); scB:SetWidth(400); scB:SetHeight(20); sfB:SetScrollChild(scB)
    local txt=scB:CreateFontString(nil,"OVERLAY","GameFontNormal")
    txt:SetPoint("TOPLEFT",scB,"TOPLEFT",4,-4); txt:SetWidth(390); txt:SetJustifyH("LEFT"); txt:SetJustifyV("TOP")
    txt:SetText(W..((b and b.text) or "")..X); scB:SetHeight(math.max(20,txt:GetStringHeight()+10))

    -- Verfassen (nur Berechtigte)
    if canPost then
        local sep=f:CreateTexture(nil,"BACKGROUND"); sep:SetHeight(1)
        sep:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,164); sep:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,164)
        sep:SetColorTexture(0.3,0.5,0.8,0.7)
        local editBg=GM_MakeBg(f,0.04,0.04,0.08,0.9,0.25,0.25,0.45)
        editBg:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",6,40)
        editBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-6,40); editBg:SetHeight(118)
        local sfE=CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
        sfE:SetPoint("TOPLEFT",editBg,"TOPLEFT",8,-6); sfE:SetPoint("BOTTOMRIGHT",editBg,"BOTTOMRIGHT",-26,6)
        local eb=CreateFrame("EditBox","GuildMarketBoardEditBox",sfE)
        eb:SetMultiLine(true); eb:SetMaxLetters(600); eb:SetAutoFocus(false)
        eb:SetFontObject("GameFontNormal"); eb:SetWidth(370)
        eb:SetText((b and b.author==UnitName("player") and b.text) or "")
        eb:SetScript("OnEscapePressed",function(self) self:ClearFocus() end)
        sfE:SetScrollChild(eb)
        editBg:SetScript("OnMouseDown",function() eb:SetFocus() end)
        local postBtnB=CreateFrame("Button",nil,f,"UIPanelButtonTemplate"); postBtnB:SetSize(160,24)
        postBtnB:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,8); postBtnB:SetText(L.BRD_SAVE)
        postBtnB:SetScript("OnClick",function()
            local t=eb:GetText() or ""
            if t=="" then return end
            PostBoard(t)
            GM_BuildBoardFrame()
        end)
    end
    boardFrame=f; f:Show()
end
RefreshBoardFrame=function() if boardFrame and boardFrame:IsShown() then GM_BuildBoardFrame() end end

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
    cfgBtn:SetText("cfg"); cfgBtn:SetScript("OnClick",GM_BuildConfigFrame)

    local lootBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    lootBtn:SetSize(44,20); lootBtn:SetPoint("RIGHT",cfgBtn,"LEFT",-4,0)
    lootBtn:SetText("Loot")
    lootBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_BOTTOM"); GameTooltip:ClearLines(); GameTooltip:AddLine(G..L.AUC_TITLE..X); GameTooltip:Show() end)
    lootBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    lootBtn:SetScript("OnClick",GM_BuildLootFrame)

    local merchBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    merchBtn:SetSize(68,20); merchBtn:SetPoint("RIGHT",lootBtn,"LEFT",-4,0)
    merchBtn:SetText("Shop")
    merchBtn:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_BOTTOM"); GameTooltip:ClearLines()
        GameTooltip:AddLine(G..L.MSH_TITLE..X)
        local n=CountPendingForMe()
        if n>0 then GameTooltip:AddLine(Gr..n.." "..L.MSH_ORDERS..X) end
        GameTooltip:Show()
    end)
    merchBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    merchBtn:SetScript("OnClick",GM_BuildMerchFrame)
    merchBtn_ref=merchBtn; GM_UpdateMerchButton()

    local profsBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    profsBtn:SetSize(52,20); profsBtn:SetPoint("RIGHT",merchBtn,"LEFT",-4,0)
    profsBtn:SetText(L.PROF_BTN)
    profsBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_BOTTOM"); GameTooltip:ClearLines(); GameTooltip:AddLine(G..L.PROF_TITLE..X); GameTooltip:Show() end)
    profsBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    profsBtn:SetScript("OnClick",GM_BuildProfsFrame)

    local boardBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    boardBtn:SetSize(46,20); boardBtn:SetPoint("RIGHT",profsBtn,"LEFT",-4,0)
    boardBtn:SetText(L.BRD_BTN)
    boardBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_BOTTOM"); GameTooltip:ClearLines(); GameTooltip:AddLine(G..L.BRD_TITLE..X); GameTooltip:Show() end)
    boardBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    boardBtn:SetScript("OnClick",GM_BuildBoardFrame)

    local infoBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    infoBtn:SetSize(22,20); infoBtn:SetPoint("RIGHT",boardBtn,"LEFT",-4,0)
    infoBtn:SetText("?")
    infoBtn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_BOTTOM"); GameTooltip:ClearLines(); GameTooltip:AddLine(G.."Marktplatz-Regeln & Kontakt"..X); GameTooltip:Show() end)
    infoBtn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    infoBtn:SetScript("OnClick",GM_BuildInfoFrame)

    local grip=CreateFrame("Button",nil,f); grip:SetSize(16,16); grip:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-2,2)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown",function(self,btn) if btn=="LeftButton" then f:StartSizing("BOTTOMRIGHT") end end)
    grip:SetScript("OnMouseUp",function() f:StopMovingOrSizing() end)

    -- ══ Tab-Leiste ══
    local tabBg=GM_MakeBg(f,0.06,0.06,0.12,0.9,0.2,0.2,0.4)
    tabBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-20)
    tabBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-20); tabBg:SetHeight(28)

    local ActivateListMode, ActivateCalendarMode  -- forward-declared; defined after all frames are built

    local function Tab(label,filter,x,w,calTab)
        local b=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
        b:SetSize(w or 80,22); b:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",x,-24); b:SetText(label)
        b:SetScript("OnClick",function()
            if calTab then ActivateCalendarMode()
            else currentFilter=filter; ActivateListMode() end
        end)
    end
    Tab(L.TAB_ALL,"ALL",8,70); Tab(L.TAB_WTB,"SUCHE",82,70); Tab(L.TAB_WTS,"BIETE",156,70); Tab(L.TAB_SVC,"DIENST",230,70)
    Tab(L.CAL_TAB,"CALENDAR",308,88,true)

    countText=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    countText:SetPoint("LEFT",f.InsetBg,"TOPLEFT",310,-32)

    userCountText=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    userCountText:SetPoint("RIGHT",f.InsetBg,"TOPRIGHT",-42,-32)
    GM_UpdateUserCount()

    local syncBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    syncBtn:SetSize(80,22); syncBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-38,-24)
    syncBtn:SetText(L.BTN_SYNC); syncBtn:SetScript("OnClick",function() if GuildRoster then GuildRoster() end; GM_RequestSync(); print(T.."[GuildMarkt]"..X.." "..L.MSG_SYNC) end)

    -- ══ Such-Leiste ══
    local searchBg=GM_MakeBg(f,0.04,0.04,0.10,0.9,0.2,0.4,0.6)
    searchBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-52)
    searchBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-52); searchBg:SetHeight(26)

    local searchIcon=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    searchIcon:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",10,-58); searchIcon:SetText(Dg..L.TT_SEARCH..X)

    local ebSearch=CreateFrame("EditBox","GuildMarketSearchBox",f,"InputBoxTemplate")
    ebSearch:SetSize(350,18); ebSearch:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",58,-58)
    ebSearch:SetAutoFocus(false); ebSearch:SetMaxLetters(40)
    ebSearch:SetScript("OnTextChanged",function(self) searchText=self:GetText(); GM_RefreshList() end)
    ebSearch:SetScript("OnEscapePressed",function(self) self:SetText(""); searchText=""; GM_RefreshList() end)

    local clearSearch=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    clearSearch:SetSize(50,18); clearSearch:SetPoint("LEFT",ebSearch,"RIGHT",4,0)
    clearSearch:SetText("X"); clearSearch:SetScript("OnClick",function() ebSearch:SetText(""); searchText=""; GM_RefreshList() end)

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
    sf:SetScript("OnSizeChanged",function(self) local nw=math.max(self:GetWidth()-18,ROW_W); listContent:SetWidth(nw); if mainFrame and mainFrame:IsShown() then GM_RefreshList() end end)

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
        for id,e in pairs(GuildMarketDB.listings) do if e.contact==me2 then GM_DeleteListing(id); n=n+1 end end
        GM_RefreshList(); print(T.."[GuildMarkt]"..X.." "..n.." "..L.MSG_DELETED)
    end)

    -- ── Notiz ────────────────────────────────── bg y=76..116
    local notizBg=GM_MakeBg(f,0.04,0.04,0.10,0.92,0.15,0.15,0.35)
    notizBg:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT",4, 101)
    notizBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,101); notizBg:SetHeight(40)
    local lbNote=notizBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbNote:SetPoint("TOPLEFT",notizBg,"TOPLEFT",6,-6); lbNote:SetText(Dg..L.LBL_NOTE..X)
    local ebNote=CreateFrame("EditBox","GuildMarketNoteBox",f,"InputBoxTemplate")
    ebNote:SetPoint("BOTTOMLEFT", f.InsetBg,"BOTTOMLEFT",116, 105)
    ebNote:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT", -10, 105)
    ebNote:SetHeight(22); ebNote:SetAutoFocus(false); ebNote:SetMaxLetters(55)

    -- ── Preis ────────────────────────────────── bg y=116..166
    local preisBg=GM_MakeBg(f,0.06,0.05,0.08,0.95,0.38,0.28,0.08)
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
    local itemBg=GM_MakeBg(f,0.05,0.05,0.14,0.95,0.18,0.28,0.50)
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
    ebItem:SetScript("OnReceiveDrag",function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebItem:SetScript("OnMouseDown",  function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
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
    ebLeist:SetScript("OnReceiveDrag",function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)
    ebLeist:SetScript("OnMouseDown",  function(self) local n,l=GM_GetDraggedItem(); if n then self:SetText(n); self.itemLink=l; ClearCursor() end end)

    -- Dungeon-Dropdown (nur bei Ziehdienst sichtbar)
    local ddDungeon=CreateFrame("Frame","GuildMarketDDDungeon",sD,"UIDropDownMenuTemplate")
    ddDungeon:SetPoint("TOPLEFT",sD,"TOPLEFT",272,-14)
    UIDropDownMenu_SetWidth(ddDungeon,326)  -- button ≈ 352px, passt auf ebLeist-Breite
    ddDungeon:Hide()

    local function RefreshDungeonDD()
        local plvl=UnitLevel("player") or 70
        local function PickDungeon(btn)
            postDungeon=btn.value
            UIDropDownMenu_SetSelectedValue(ddDungeon,btn.value); UIDropDownMenu_SetText(ddDungeon,btn.value)
            CloseDropDownMenus()
        end
        UIDropDownMenu_Initialize(ddDungeon,function(_,level,menuList)
            if level==2 then
                local cont=menuList and menuList:sub(8)
                for i=2,#DUNGEONS do
                    local d=DUNGEONS[i]
                    if d[4]==cont and plvl>=d[2] and DungeonFitsFaction(d) then
                        local info=UIDropDownMenu_CreateInfo(); info.text=d[1]; info.value=d[1]
                        info.checked=(postDungeon==d[1])
                        info.func=PickDungeon
                        UIDropDownMenu_AddButton(info,level)
                    end
                end
                return
            end
            -- Wunsch-Dungeon (Freitext-Eintrag) + Kontinent-Untermenues
            local info=UIDropDownMenu_CreateInfo(); info.text=DUNGEONS[1][1]; info.value=DUNGEONS[1][1]
            info.checked=(postDungeon==DUNGEONS[1][1]); info.func=PickDungeon
            UIDropDownMenu_AddButton(info,level)
            for _,sub in ipairs({{t=L.CONT_EK,m="ZD_DNG_EK"},{t=L.CONT_KAL,m="ZD_DNG_KAL"},{t=L.CONT_TBC,m="ZD_DNG_TBC"}}) do
                local subD=UIDropDownMenu_CreateInfo()
                subD.text=sub.t; subD.hasArrow=true; subD.notCheckable=true; subD.menuList=sub.m; subD.keepShownOnClick=true
                UIDropDownMenu_AddButton(subD,level)
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
    ShowSection(postType)

    -- ══════════════════════════════════════════════════════════
    -- KALENDER-UI (versteckt beim Start)
    -- ══════════════════════════════════════════════════════════

    -- Kalender-Grid (gleiche Position wie sf, ohne Scrollbar)
    local calSf=CreateFrame("Frame",nil,f)
    calSf:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-114)
    calSf:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,288)
    calContent=calSf; calSf:Hide()

    -- Kalender-Trennlinie (gleiche Position wie div)
    local calDiv=f:CreateTexture(nil,"BACKGROUND")
    calDiv:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,286); calDiv:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,286)
    calDiv:SetHeight(2); calDiv:SetColorTexture(0.2,0.5,0.3,0.8); calDiv:Hide()

    -- Monats-Navigation (Vor/Zurueck/Heute + Monatslabel)
    local calHdrBg=f:CreateTexture(nil,"BACKGROUND")
    calHdrBg:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-80); calHdrBg:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-80)
    calHdrBg:SetHeight(20); calHdrBg:SetColorTexture(0.08,0.14,0.10,1); calHdrBg:Hide()
    local calPrevBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    calPrevBtn:SetSize(22,20); calPrevBtn:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",6,-80); calPrevBtn:SetText("<"); calPrevBtn:Hide()
    local calNextBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    calNextBtn:SetSize(22,20); calNextBtn:SetPoint("LEFT",calPrevBtn,"RIGHT",2,0); calNextBtn:SetText(">"); calNextBtn:Hide()
    local calTodayBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    calTodayBtn:SetSize(70,20); calTodayBtn:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-6,-80)
    calTodayBtn:SetText(isDE and "Heute" or "Today"); calTodayBtn:Hide()
    local calDkpBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    calDkpBtn:SetSize(60,20); calDkpBtn:SetPoint("RIGHT",calTodayBtn,"LEFT",-4,0)
    calDkpBtn:SetText(isDE and "Punkte" or "Points"); calDkpBtn:Hide()
    calDkpBtn:SetScript("OnClick",GM_BuildDKPFrame)
    calMonthLbl=f:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    calMonthLbl:SetPoint("TOP",calHdrBg,"TOP",0,-3); calMonthLbl:Hide()
    calPrevBtn:SetScript("OnClick",function()
        calViewMonth=calViewMonth-1; if calViewMonth<1 then calViewMonth=12; calViewYear=calViewYear-1 end
        GM_RefreshCalendar()
    end)
    calNextBtn:SetScript("OnClick",function()
        calViewMonth=calViewMonth+1; if calViewMonth>12 then calViewMonth=1; calViewYear=calViewYear+1 end
        GM_RefreshCalendar()
    end)
    calTodayBtn:SetScript("OnClick",function()
        local t=date("*t"); calViewYear,calViewMonth=t.year,t.month; GM_RefreshCalendar()
    end)

    -- Wochentag-Header
    local calHdrLine=f:CreateTexture(nil,"BACKGROUND")
    calHdrLine:SetPoint("TOPLEFT",f.InsetBg,"TOPLEFT",4,-113); calHdrLine:SetPoint("TOPRIGHT",f.InsetBg,"TOPRIGHT",-4,-113)
    calHdrLine:SetHeight(1); calHdrLine:SetColorTexture(0.2,0.5,0.3,0.5); calHdrLine:Hide()
    for d=1,7 do
        local fs=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetJustifyH("CENTER"); fs:SetText(Dg..WEEKDAY_SHORT[d]..X); fs:Hide()
        calWeekFS[d]=fs
    end

    -- ── Kalender-Formular (gleiche Y-Positionen wie Listing-Formular) ──

    -- calItemBg: y=191, h=95 → Titel-Sektion
    local calItemBg=GM_MakeBg(f,0.04,0.08,0.06,0.95,0.15,0.35,0.20)
    calItemBg:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,191)
    calItemBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,191); calItemBg:SetHeight(95); calItemBg:Hide()
    local newEvtLbl=calItemBg:CreateFontString(nil,"OVERLAY","GameFontNormal")
    newEvtLbl:SetPoint("TOPLEFT",calItemBg,"TOPLEFT",8,-8); newEvtLbl:SetText(Gr..L.CAL_NEW..X)

    -- Event-Typ (Dungeon = ohne Punkte, Gilden-Event = mit Punkten, rang-beschraenkt)
    local calEvtType="DUNGEON"
    local UpdateCalPtsVisibility  -- forward-declared, definiert nach den Punkte-Widgets
    local ddEvtType=CreateFrame("Frame","GuildMarketEvtTypeDD",f,"UIDropDownMenuTemplate")
    ddEvtType:SetPoint("TOPLEFT",calItemBg,"TOPLEFT",140,-2)
    UIDropDownMenu_SetWidth(ddEvtType,130); ddEvtType:Hide()
    UIDropDownMenu_Initialize(ddEvtType,function(_,level)
        local opts={{v="DUNGEON",t=L.ETYPE_DUNGEON},{v="GUILD",t=L.ETYPE_GUILD}}
        for _,o in ipairs(opts) do
            local ddInfo=UIDropDownMenu_CreateInfo(); ddInfo.text=o.t; ddInfo.value=o.v; ddInfo.checked=(calEvtType==o.v)
            if o.v=="GUILD" and not GM_CanCreateGuildEvent() then ddInfo.disabled=true end
            ddInfo.func=function(btn)
                calEvtType=btn.value; UIDropDownMenu_SetSelectedValue(ddEvtType,btn.value)
                UIDropDownMenu_SetText(ddEvtType,btn.value=="GUILD" and (G..L.ETYPE_GUILD..X) or L.ETYPE_DUNGEON)
                if UpdateCalPtsVisibility then UpdateCalPtsVisibility() end
            end
            UIDropDownMenu_AddButton(ddInfo,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddEvtType,"DUNGEON"); UIDropDownMenu_SetText(ddEvtType,L.ETYPE_DUNGEON)
    local lbCalTitle=calItemBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbCalTitle:SetPoint("TOPLEFT",calItemBg,"TOPLEFT",8,-26); lbCalTitle:SetText(Dg..L.CAL_TITLE..X)
    local ebCalTitle=CreateFrame("EditBox","GuildMarketCalTitleBox",f,"InputBoxTemplate")
    ebCalTitle:SetSize(330,22); ebCalTitle:SetPoint("TOPLEFT",calItemBg,"TOPLEFT",56,-38)
    ebCalTitle:SetAutoFocus(false); ebCalTitle:SetMaxLetters(50); ebCalTitle:Hide()
    local lbCalDungeon=calItemBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbCalDungeon:SetPoint("TOPLEFT",calItemBg,"TOPLEFT",396,-26); lbCalDungeon:SetText(Dg..(isDE and "Dungeon/Raid:" or "Dungeon/Raid:")..X); lbCalDungeon:Hide()
    local NONE_DUNGEON = isDE and "Keine Instanz" or "No instance"
    local calDungeonSel = NONE_DUNGEON
    local ApplyRaidPreset  -- forward-declared, nach den Rollen-Feldern definiert
    local ddCalDungeon=CreateFrame("Frame","GuildMarketCalDungeonDD",f,"UIDropDownMenuTemplate")
    ddCalDungeon:SetPoint("TOPLEFT",calItemBg,"TOPLEFT",386,-40)
    UIDropDownMenu_SetWidth(ddCalDungeon,110); ddCalDungeon:Hide()
    local function SelectInstance(name,raidSize)
        calDungeonSel=name
        UIDropDownMenu_SetSelectedValue(ddCalDungeon,name); UIDropDownMenu_SetText(ddCalDungeon,name)
        if raidSize and ApplyRaidPreset then ApplyRaidPreset(raidSize) end
        CloseDropDownMenus()
    end
    UIDropDownMenu_Initialize(ddCalDungeon,function(_,level,menuList)
        if level==2 then
            -- Dungeons nach Kontinent (haelt jede Teilliste bildschirmtauglich kurz)
            if menuList=="GM_DNG_EK" or menuList=="GM_DNG_KAL" or menuList=="GM_DNG_TBC" then
                local cont=menuList:sub(8) -- "EK"/"KAL"/"TBC"
                for i=2,#DUNGEONS do
                    local d=DUNGEONS[i]
                    if d[4]==cont and DungeonFitsFaction(d) then
                        local name=d[1]
                        local ddInfo=UIDropDownMenu_CreateInfo()
                        ddInfo.text=name.." "..Dg..d[2].."+"..X; ddInfo.value=name; ddInfo.checked=(calDungeonSel==name)
                        ddInfo.func=function(btn) SelectInstance(btn.value) end
                        UIDropDownMenu_AddButton(ddInfo,level)
                    end
                end
            elseif menuList=="GM_RAIDS" then
                for i=1,#RAIDS do
                    local name,size=RAIDS[i][1],RAIDS[i][2]
                    local ddInfo=UIDropDownMenu_CreateInfo()
                    ddInfo.text=name.." "..Dg.."("..size..")"..X; ddInfo.value=name; ddInfo.checked=(calDungeonSel==name)
                    ddInfo.func=function(btn) SelectInstance(btn.value,size) end
                    UIDropDownMenu_AddButton(ddInfo,level)
                end
            end
            return
        end
        local ddInfo=UIDropDownMenu_CreateInfo(); ddInfo.text=NONE_DUNGEON; ddInfo.value=NONE_DUNGEON; ddInfo.checked=(calDungeonSel==NONE_DUNGEON)
        ddInfo.func=function(btn) SelectInstance(btn.value) end
        UIDropDownMenu_AddButton(ddInfo,level)
        for _,sub in ipairs({{t=L.CONT_EK,m="GM_DNG_EK"},{t=L.CONT_KAL,m="GM_DNG_KAL"},{t=L.CONT_TBC,m="GM_DNG_TBC"}}) do
            local subD=UIDropDownMenu_CreateInfo()
            subD.text=sub.t; subD.hasArrow=true; subD.notCheckable=true; subD.menuList=sub.m; subD.keepShownOnClick=true
            UIDropDownMenu_AddButton(subD,level)
        end
        local subR=UIDropDownMenu_CreateInfo()
        subR.text=G..(isDE and "Raids" or "Raids")..X; subR.hasArrow=true; subR.notCheckable=true; subR.menuList="GM_RAIDS"; subR.keepShownOnClick=true
        UIDropDownMenu_AddButton(subR,level)
    end)
    UIDropDownMenu_SetSelectedValue(ddCalDungeon,NONE_DUNGEON); UIDropDownMenu_SetText(ddCalDungeon,NONE_DUNGEON)

    -- calPreisBg: y=141, h=50 → Datum + Zeit + Rollen-Plaetze
    local calPreisBg=GM_MakeBg(f,0.06,0.08,0.06,0.95,0.20,0.35,0.20)
    calPreisBg:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,141)
    calPreisBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,141); calPreisBg:SetHeight(50); calPreisBg:Hide()
    local lbCalDate=calPreisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbCalDate:SetPoint("TOPLEFT",calPreisBg,"TOPLEFT",6,-6); lbCalDate:SetText(Dg..L.CAL_DATE..X)
    local ebCalDate=CreateFrame("EditBox","GuildMarketCalDateBox",f,"InputBoxTemplate")
    ebCalDate:SetSize(130,22); ebCalDate:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",6,145)
    ebCalDate:SetAutoFocus(false); ebCalDate:SetMaxLetters(10); ebCalDate:Hide()
    local lbCalTime=calPreisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbCalTime:SetPoint("TOPLEFT",calPreisBg,"TOPLEFT",160,-6); lbCalTime:SetText(Dg..L.CAL_TIME..X)
    local ebCalTime=CreateFrame("EditBox","GuildMarketCalTimeBox",f,"InputBoxTemplate")
    ebCalTime:SetSize(70,22); ebCalTime:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",240,145)
    ebCalTime:SetAutoFocus(false); ebCalTime:SetMaxLetters(5); ebCalTime:Hide()
    local lbCalRoles=calPreisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbCalRoles:SetPoint("TOPLEFT",calPreisBg,"TOPLEFT",326,-6); lbCalRoles:SetText(Dg..(isDE and "Plaetze (0=frei):" or "Slots (0=open):")..X)
    local lbRoleTankGlyph=calPreisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbRoleTankGlyph:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",326,148); lbRoleTankGlyph:SetText(ROLE_COLOR.TANK.."T"..X)
    local ebRoleTank=CreateFrame("EditBox","GuildMarketRoleTankBox",f,"InputBoxTemplate")
    ebRoleTank:SetSize(34,22); ebRoleTank:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",338,145)
    ebRoleTank:SetAutoFocus(false); ebRoleTank:SetMaxLetters(2); ebRoleTank:SetNumeric(true); ebRoleTank:Hide()
    local lbRoleHealGlyph=calPreisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbRoleHealGlyph:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",378,148); lbRoleHealGlyph:SetText(ROLE_COLOR.HEAL.."H"..X)
    local ebRoleHeal=CreateFrame("EditBox","GuildMarketRoleHealBox",f,"InputBoxTemplate")
    ebRoleHeal:SetSize(34,22); ebRoleHeal:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",390,145)
    ebRoleHeal:SetAutoFocus(false); ebRoleHeal:SetMaxLetters(2); ebRoleHeal:SetNumeric(true); ebRoleHeal:Hide()
    local lbRoleDpsGlyph=calPreisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbRoleDpsGlyph:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",430,148); lbRoleDpsGlyph:SetText(ROLE_COLOR.DPS.."D"..X)
    local ebRoleDps=CreateFrame("EditBox","GuildMarketRoleDpsBox",f,"InputBoxTemplate")
    ebRoleDps:SetSize(34,22); ebRoleDps:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",442,145)
    ebRoleDps:SetAutoFocus(false); ebRoleDps:SetMaxLetters(2); ebRoleDps:SetNumeric(true); ebRoleDps:Hide()
    -- Punkte-Feld (nur Gilden-Events)
    local lbCalPts=calPreisBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbCalPts:SetPoint("TOPLEFT",calPreisBg,"TOPLEFT",492,-6); lbCalPts:SetText(G..L.CAL_POINTS..X); lbCalPts:Hide()
    local ebCalPts=CreateFrame("EditBox","GuildMarketCalPtsBox",f,"InputBoxTemplate")
    ebCalPts:SetSize(44,22); ebCalPts:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",504,145)
    ebCalPts:SetAutoFocus(false); ebCalPts:SetMaxLetters(4); ebCalPts:SetNumeric(true); ebCalPts:Hide()
    UpdateCalPtsVisibility=function()
        if currentMode=="CALENDAR" and calEvtType=="GUILD" then
            lbCalPts:Show(); ebCalPts:Show()
            if ebCalPts:GetText()=="" then ebCalPts:SetText(tostring(GuildMarketDB.config.dkpPerEvent or 10)) end
        else lbCalPts:Hide(); ebCalPts:Hide() end
    end
    ApplyRaidPreset=function(size)
        local p=RAID_PRESETS[size]; if not p then return end
        ebRoleTank:SetText(tostring(p[1])); ebRoleHeal:SetText(tostring(p[2])); ebRoleDps:SetText(tostring(p[3]))
    end

    -- calNotizBg: y=101, h=40 → Beschreibung
    local calNotizBg=GM_MakeBg(f,0.04,0.06,0.04,0.92,0.12,0.28,0.15)
    calNotizBg:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",4,101)
    calNotizBg:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-4,101); calNotizBg:SetHeight(40); calNotizBg:Hide()
    local lbCalDesc=calNotizBg:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbCalDesc:SetPoint("TOPLEFT",calNotizBg,"TOPLEFT",6,-6); lbCalDesc:SetText(Dg..L.CAL_DESC..X)
    local ebCalDesc=CreateFrame("EditBox","GuildMarketCalDescBox",f,"InputBoxTemplate")
    ebCalDesc:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",166,105)
    ebCalDesc:SetPoint("BOTTOMRIGHT",f.InsetBg,"BOTTOMRIGHT",-10,105)
    ebCalDesc:SetHeight(22); ebCalDesc:SetAutoFocus(false); ebCalDesc:SetMaxLetters(60); ebCalDesc:Hide()

    -- "Event erstellen"-Button (y=44)
    local createEvtBtn=CreateFrame("Button",nil,f,"UIPanelButtonTemplate")
    createEvtBtn:SetSize(160,28); createEvtBtn:SetPoint("BOTTOMLEFT",f.InsetBg,"BOTTOMLEFT",8,44)
    createEvtBtn:SetText(L.CAL_CREATE); createEvtBtn:Hide()

    -- Haken: Event-Erstellung + 1h-Erinnerung im Gildenchat ankuendigen (nur Ersteller-Client postet)
    local calAnnounce=false
    local cbAnnounce=CreateFrame("CheckButton","GuildMarketCalAnnounceCB",f,"UICheckButtonTemplate")
    cbAnnounce:SetSize(26,26); cbAnnounce:SetPoint("LEFT",createEvtBtn,"RIGHT",8,0); cbAnnounce:Hide()
    cbAnnounce:SetScript("OnClick",function(self) calAnnounce=self:GetChecked() and true or false end)
    local lbAnnounce=f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbAnnounce:SetPoint("LEFT",cbAnnounce,"RIGHT",2,0); lbAnnounce:SetText(Dg..L.CAL_ANNOUNCE..X); lbAnnounce:Hide()

    -- Wiederholung: Einmalig / Woechentlich / Alle 2 Wochen (nur Ersteller-Client legt Folgetermine an)
    local calRepeat=0
    local ddRepeat=CreateFrame("Frame","GuildMarketCalRepeatDD",f,"UIDropDownMenuTemplate")
    ddRepeat:SetPoint("LEFT",lbAnnounce,"RIGHT",-4,-2); ddRepeat:Hide()
    UIDropDownMenu_SetWidth(ddRepeat,110)
    UIDropDownMenu_Initialize(ddRepeat,function(_,level)
        local opts={{v=0,t=L.REP_NONE},{v=7,t=L.REP_WEEKLY},{v=14,t=L.REP_BIWEEKLY}}
        for _,o in ipairs(opts) do
            local ddInfo=UIDropDownMenu_CreateInfo(); ddInfo.text=o.t; ddInfo.value=o.v; ddInfo.checked=(calRepeat==o.v)
            ddInfo.func=function(btn)
                calRepeat=btn.value
                UIDropDownMenu_SetSelectedValue(ddRepeat,btn.value); UIDropDownMenu_SetText(ddRepeat,btn.text)
            end
            UIDropDownMenu_AddButton(ddInfo,level)
        end
    end)
    UIDropDownMenu_SetSelectedValue(ddRepeat,0); UIDropDownMenu_SetText(ddRepeat,L.REP_NONE)

    calSetDateField = function(dateStr)
        ebCalDate:SetText(dateStr); ebCalTitle:SetFocus()
    end
    createEvtBtn:SetScript("OnClick",function()
        if not GM_CanCreateEvent() then print(R.."[GuildMarkt]"..X.." "..L.CAL_NORANKC); return end
        local title=ebCalTitle:GetText()
        -- Kein Titel? Gewaehlte Instanz als Titel uebernehmen
        if title=="" and calDungeonSel~=NONE_DUNGEON then title=calDungeonSel end
        if title=="" then print(R.."[GuildMarkt]"..X.." "..L.CAL_NOTITLE); return end
        local datets=GM_ParseEventDate(ebCalDate:GetText())
        if not datets then print(R.."[GuildMarkt]"..X.." "..L.CAL_NODATE); return end
        if datets<GM_TodayTs() then print(R.."[GuildMarkt]"..X.." "..L.CAL_PAST); return end
        local tstr=ebCalTime:GetText()
        if not tstr:match("^%d%d:%d%d$") then print(R.."[GuildMarkt]"..X.." "..L.CAL_NOTIME); return end
        local roles={TANK=tonumber(ebRoleTank:GetText()) or 0, HEAL=tonumber(ebRoleHeal:GetText()) or 0, DPS=tonumber(ebRoleDps:GetText()) or 0}
        local dungeon = calDungeonSel~=NONE_DUNGEON and calDungeonSel or ""
        if calEvtType=="GUILD" and not GM_CanCreateGuildEvent() then print(R.."[GuildMarkt]"..X.." "..L.CAL_NORANKG); return end
        local pts = calEvtType=="GUILD" and (tonumber(ebCalPts:GetText()) or (GuildMarketDB.config.dkpPerEvent or 10)) or 0
        local newId=GM_PostEvent(title,datets,tstr,roles,ebCalDesc:GetText(),dungeon,calEvtType,pts,GM_InstanceMinLevel(dungeon))
        print(T.."[GuildMarkt]"..X.." "..L.CAL_CREATED.." "..Gr..title..X)
        local nev=GuildMarketDB.events[newId]
        if nev and calRepeat>0 then nev.repeatDays=calRepeat end
        if calAnnounce then
            if nev then nev.announce=true end
            if IsInGuild() then
                local inst=(dungeon~="" and dungeon~=title) and (" ["..dungeon.."]") or ""
                SendChatMessage("[GuildMarkt] "..string.format(L.CAL_CHAT_NEW,title,date("%d.%m.%Y",datets),tstr,inst),"GUILD")
            end
        end
        ebCalTitle:SetText(""); ebCalDate:SetText(""); ebCalTime:SetText("")
        ebRoleTank:SetText(""); ebRoleHeal:SetText(""); ebRoleDps:SetText(""); ebCalDesc:SetText(""); ebCalPts:SetText("")
        calDungeonSel=NONE_DUNGEON; UIDropDownMenu_SetSelectedValue(ddCalDungeon,NONE_DUNGEON); UIDropDownMenu_SetText(ddCalDungeon,NONE_DUNGEON)
        calEvtType="DUNGEON"; UIDropDownMenu_SetSelectedValue(ddEvtType,"DUNGEON"); UIDropDownMenu_SetText(ddEvtType,L.ETYPE_DUNGEON)
        UpdateCalPtsVisibility()
        GM_RefreshCalendar()
        BuildEventDetailPopup(newId)
    end)

    -- ══ Mode-Switching ══════════════════════════════════════════

    ActivateListMode = function()
        currentMode="LIST"
        sf:Show(); div:Show()
        searchBg:Show(); searchIcon:Show(); ebSearch:Show(); clearSearch:Show()
        notizBg:Show(); ebNote:Show()
        preisBg:Show(); ebGold:Show(); ebSilber:Show(); ebKupfer:Show(); freeBtn:Show(); ddPType:Show()
        itemBg:Show(); ddType:Show()
        postBtn:Show(); clearBtn:Show()
        hBg:Show(); hLine:Show()
        for _,fs in pairs(hdrFS) do fs:Show() end
        -- Kalender ausblenden
        calSf:Hide(); calDiv:Hide(); calHdrBg:Hide(); calHdrLine:Hide()
        calPrevBtn:Hide(); calNextBtn:Hide(); calTodayBtn:Hide(); calDkpBtn:Hide(); calMonthLbl:Hide()
        for _,fs in ipairs(calWeekFS) do fs:Hide() end
        calItemBg:Hide(); ebCalTitle:Hide(); lbCalDungeon:Hide(); ddCalDungeon:Hide(); ddEvtType:Hide()
        calPreisBg:Hide(); ebCalDate:Hide(); ebCalTime:Hide()
        ebRoleTank:Hide(); ebRoleHeal:Hide(); ebRoleDps:Hide()
        lbCalPts:Hide(); ebCalPts:Hide()
        calNotizBg:Hide(); ebCalDesc:Hide()
        createEvtBtn:Hide(); cbAnnounce:Hide(); lbAnnounce:Hide(); ddRepeat:Hide()
        ShowSection(postType); GM_RefreshList()
    end

    ActivateCalendarMode = function()
        currentMode="CALENDAR"
        sf:Hide(); div:Hide()
        searchBg:Hide(); searchIcon:Hide(); ebSearch:Hide(); clearSearch:Hide()
        notizBg:Hide(); ebNote:Hide()
        preisBg:Hide(); ebGold:Hide(); ebSilber:Hide(); ebKupfer:Hide(); freeBtn:Hide(); ddPType:Hide()
        itemBg:Hide(); ddType:Hide()
        postBtn:Hide(); clearBtn:Hide()
        hBg:Hide(); hLine:Hide()
        for _,fs in pairs(hdrFS) do fs:Hide() end
        secNormal:Hide(); secDienst:Hide(); sMats:Hide()
        -- Kalender einblenden
        calSf:Show(); calDiv:Show(); calHdrBg:Show(); calHdrLine:Show()
        calPrevBtn:Show(); calNextBtn:Show(); calTodayBtn:Show(); calDkpBtn:Show(); calMonthLbl:Show()
        for _,fs in ipairs(calWeekFS) do fs:Show() end
        calItemBg:Show(); ebCalTitle:Show(); lbCalDungeon:Show(); ddCalDungeon:Show(); ddEvtType:Show()
        calPreisBg:Show(); ebCalDate:Show(); ebCalTime:Show()
        ebRoleTank:Show(); ebRoleHeal:Show(); ebRoleDps:Show()
        UpdateCalPtsVisibility()
        calNotizBg:Show(); ebCalDesc:Show()
        createEvtBtn:Show(); cbAnnounce:Show(); lbAnnounce:Show(); ddRepeat:Show()
        cbAnnounce:SetChecked(calAnnounce)
        if GM_CanCreateEvent() then createEvtBtn:Enable() else createEvtBtn:Disable() end
        GM_RefreshCalendar()
    end
    GM_ActivateCalendarMode=ActivateCalendarMode -- global fuer Minimap-Button

    -- ── Post-Button ──────────────────────────────────────────
    postBtn:SetScript("OnClick",function()
        if not GM_CanPost() then print(R.."[GuildMarkt]"..X.." "..L.MSG_NO_ACCESS); return end
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
        GM_PostListing(postType,name,amount,ebNote:GetText(),link,pg,ps,pk,postFree and "1" or "0",postPriceType,beruf,mats)
        ebItem:SetText(""); ebItem.itemLink=nil; ebLeist:SetText(""); ebLeist.itemLink=nil
        postDungeon=DUNGEONS[1][1]
        ebGold:SetText(""); ebSilber:SetText(""); ebKupfer:SetText("")
        ebAmt:SetText(""); ebNote:SetText(""); ebMats:SetText("")
        postFree=false; freeBtn:SetText(L.BTN_FREE_N); ebGold:Enable(); ebSilber:Enable(); ebKupfer:Enable()
        GM_RefreshList(); print(T.."[GuildMarkt]"..X.." "..L.MSG_POSTED.." "..Clr(postType).." "..W..name..X)
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

-- ============================================================
-- Minimap-Button (Links: Markt, Rechts: Kalender; ziehbar am Minimap-Rand)
-- ============================================================
local function CreateMinimapButton()
    if GuildMarketMinimapBtn then return end
    local btn=CreateFrame("Button","GuildMarketMinimapBtn",Minimap)
    btn:SetSize(32,32); btn:SetFrameStrata("MEDIUM"); btn:SetFrameLevel(8)
    btn:RegisterForClicks("LeftButtonUp","RightButtonUp")
    btn:RegisterForDrag("LeftButton")
    btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    local overlay=btn:CreateTexture(nil,"OVERLAY")
    overlay:SetSize(53,53); overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT")
    local icon=btn:CreateTexture(nil,"BACKGROUND")
    icon:SetSize(20,20); icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_02")
    icon:SetTexCoord(0.07,0.93,0.07,0.93); icon:SetPoint("CENTER",-1,1)
    local function UpdatePos()
        local angle=math.rad(GuildMarketDB.minimapPos or 210)
        btn:ClearAllPoints()
        btn:SetPoint("CENTER",Minimap,"CENTER",80*math.cos(angle),80*math.sin(angle))
    end
    btn:SetScript("OnDragStart",function(self)
        self:SetScript("OnUpdate",function()
            local mx,my=Minimap:GetCenter()
            local cx,cy=GetCursorPosition()
            local scale=Minimap:GetEffectiveScale()
            GuildMarketDB.minimapPos=math.deg(math.atan2(cy/scale-my,cx/scale-mx))
            UpdatePos()
        end)
    end)
    btn:SetScript("OnDragStop",function(self) self:SetScript("OnUpdate",nil) end)
    btn:SetScript("OnClick",function(_,button)
        if button=="RightButton" then GM_OpenCalendar() else GM_Toggle() end
    end)
    btn:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_LEFT"); GameTooltip:ClearLines()
        GameTooltip:AddLine(G.."GuildMarket"..X)
        GameTooltip:AddLine(Dg..L.MM_LEFT..X)
        GameTooltip:AddLine(Dg..L.MM_RIGHT..X)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    UpdatePos()
end

-- Gildenchat-Erinnerung ~1h vor eigenen angekuendigten Events (postet nur der Ersteller, genau einmal)
local evtRemindTicker=CreateFrame("Frame",nil,UIParent)
do
    local acc=0
    evtRemindTicker:SetScript("OnUpdate",function(_,dt)
        acc=acc+dt; if acc<30 then return end
        acc=0
        if not GuildMarketDB or not GuildMarketDB.events or not IsInGuild() then return end
        local me=UnitName("player"); local now=time()
        local toCreate=nil -- {evt} — Anlage ausserhalb der Schleife (pairs + insert vermeiden)
        for _,evt in pairs(GuildMarketDB.events) do
            if evt.creator==me then
                local hh,mm=(evt.tstr or ""):match("^(%d+):(%d+)$")
                local evTime=hh and ((evt.datets or 0)+tonumber(hh)*3600+tonumber(mm)*60) or nil
                -- 1h-Erinnerung im Gildenchat (einmalig)
                if evt.announce and not evt.reminded and evTime and evTime>now and evTime-now<=3600 then
                    evt.reminded=true
                    local sigCount=0
                    for _,s in pairs(evt.signups or {}) do if type(s)=="table" then sigCount=sigCount+1 end end
                    SendChatMessage("[GuildMarkt] "..string.format(L.CAL_CHAT_REM,evt.title or "?",evt.tstr or "?",sigCount),"GUILD")
                end
                -- Wiederkehrend: 1h nach Eventstart den Folgetermin anlegen (einmalig)
                if (evt.repeatDays or 0)>0 and not evt.repeatDone and evTime and now>=evTime+3600 then
                    evt.repeatDone=true
                    toCreate=toCreate or {}
                    toCreate[#toCreate+1]=evt
                end
            end
        end
        if toCreate then
            for _,old in ipairs(toCreate) do
                local newDate=(old.datets or 0)+old.repeatDays*86400
                local roles={TANK=(old.roles and old.roles.TANK) or 0,HEAL=(old.roles and old.roles.HEAL) or 0,DPS=(old.roles and old.roles.DPS) or 0}
                local newId=GM_PostEvent(old.title,newDate,old.tstr,roles,old.desc or "",old.dungeon or "",old.etype,old.points,old.minlvl)
                local nev=GuildMarketDB.events[newId]
                if nev then nev.repeatDays=old.repeatDays; nev.announce=old.announce end
                print(T.."[GuildMarkt]"..X.." "..L.REP_CREATED.." "..Gr..(old.title or "?")..X.." — "..W..date("%d.%m.%Y",newDate).." "..(old.tstr or "")..X)
                if old.announce and IsInGuild() then
                    local inst=((old.dungeon or "")~="" and old.dungeon~=old.title) and (" ["..old.dungeon.."]") or ""
                    SendChatMessage("[GuildMarkt] "..string.format(L.CAL_CHAT_NEW,old.title or "?",date("%d.%m.%Y",newDate),old.tstr or "?",inst),"GUILD")
                end
            end
            if mainFrame and mainFrame:IsShown() and currentMode=="CALENDAR" then GM_RefreshCalendar() end
        end
    end)
end

-- Login-Erinnerung: heutige Events im Chat auflisten
local function PrintTodaysEvents()
    if not GuildMarketDB or not GuildMarketDB.events then return end
    local me=UnitName("player"); local today=GM_TodayTs()
    local list={}
    for _,evt in pairs(GuildMarketDB.events) do
        if evt.datets==today then list[#list+1]=evt end
    end
    table.sort(list,function(a,b) return (a.tstr or "")<(b.tstr or "") end)
    for _,evt in ipairs(list) do
        local mine=evt.signups and evt.signups[me]
        print(T.."[GuildMarkt]"..X.." "..G..L.REMIND_TODAY..X.." "..W..(evt.tstr or "").." "..(evt.title or "")..X
            ..(mine and (" "..Gr..L.REMIND_SIGNED..X) or ""))
    end
end

local rosStaging={}  -- EVTROS-Chunks pro Absender/Event bis zum Commit
local brdStaging={}  -- BRDPOST-Chunks pro Absender bis zum Commit
local lastHiSent=0   -- HI-Antworten drosseln (eine Antwort deckt mehrere HELLOs ab)
local ev=CreateFrame("Frame","GuildMarketEventFrame",UIParent)
ev:RegisterEvent("PLAYER_LOGIN"); ev:RegisterEvent("CHAT_MSG_ADDON"); ev:RegisterEvent("GUILD_ROSTER_UPDATE")
ev:SetScript("OnEvent",function(self,event,...)
    if event=="PLAYER_LOGIN" then
        InitDB(); PruneExpired(); PruneExpiredEvents(); PruneAuctions(); PruneMerchOrders(); PruneProfs(); if GuildRoster then GuildRoster() end
        local me=UnitName("player"); if me then MarkAddonUser(me) end
        LoadKnownAddonUsers(); GM_UpdateUserCount()
        DelayCall(6,function() SendGuild("HELLO"); BroadcastMine(); GM_RequestSync(); BroadcastEvents(); SendGuild("EVTREQ"); SendGuild("DKPREQ"); SendGuild("AUCREQ"); SendGuild("MSHREQ"); SendGuild("PROFREQ"); SendGuild("BRDREQ") end)
        CreateMinimapButton()
        DelayCall(8,ScanOwnProfs)
        DelayCall(20,RemindUnscannedProfs)
        DelayCall(12,PrintTodaysEvents)
        DelayCall(14,ShowBoardPopup)
        DelayCall(15,CheckDkpDecay)
        print(T.."[GuildMarkt]"..X.." "..L.MSG_LOADED.." — "..G.."/gmarkt"..X.." | "..Dg..(GetGuildInfo("player") or "")..X)
    elseif event=="GUILD_ROSTER_UPDATE" then
        UpdateRoster(); if mainFrame and mainFrame:IsShown() then GM_RefreshList() end
    elseif event=="CHAT_MSG_ADDON" then
        local prefix,msg,_,sender=...
        if prefix~=MSG_PREFIX then return end
        local sn=sender:match("^([^%-]+)") or sender; MarkAddonUser(sn); GM_UpdateUserCount()
        -- Eigene Nachrichten ueberspringen: lokal wurde bereits alles angewendet
        -- (verhindert u.a. doppelten Bestand-Abzug beim Merch-Kauf und Antworten auf eigene REQs)
        if sn==UnitName("player") then return end
        -- Presence-Handshake: HELLO beim Login, Empfaenger melden sich mit HI zurueck
        -- (gedrosselt, damit ein Login-Schwung nicht n*n Antworten ausloest)
        if msg=="HELLO" then
            if time()-lastHiSent>60 then lastHiSent=time(); SendGuild("HI") end
            return
        end
        if msg=="HI" then return end
        if msg=="REQ" then BroadcastMine(); return end
        if msg:sub(1,3)=="CFG" then
            -- Nur akzeptieren, wenn der Absender laut Roster GM oder freigegebener Config-Rang ist
            local srRank=GetMemberRank(sn)
            if srRank==nil or (srRank~=0 and srRank>(GuildMarketDB.config.configRank or 0)) then return end
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            if p[2] and p[3] then GuildMarketDB.config.postRank=tonumber(p[2]) or 9; GuildMarketDB.config.deleteRank=tonumber(p[3]) or 1
                if p[4] then GuildMarketDB.config.eventRank=tonumber(p[4]) or 9 end
                if p[5] then GuildMarketDB.config.eventDeleteRank=tonumber(p[5]) or 9 end
                if p[6] then GuildMarketDB.config.dkpPerEvent=tonumber(p[6]) or 10 end
                if p[7] then GuildMarketDB.config.eventConfirmRank=tonumber(p[7]) or 9 end
                if p[8] then GuildMarketDB.config.guildEventRank=tonumber(p[8]) or 9 end
                if p[9] then GuildMarketDB.config.configRank=tonumber(p[9]) or 0 end
                if p[10] then GuildMarketDB.config.auctionRank=tonumber(p[10]) or 9 end
                if p[11] then GuildMarketDB.config.dkpAdjustRank=tonumber(p[11]) or 9 end
                if p[12] then GuildMarketDB.config.merchRank=tonumber(p[12]) or 9 end
                if p[13] then GuildMarketDB.config.boardRank=tonumber(p[13]) or 9 end
                if p[14] then GuildMarketDB.config.dkpDecayPercent=tonumber(p[14]) or 0 end
                if p[15] then GuildMarketDB.config.dkpDecayDays=tonumber(p[15]) or 7 end
                if p[16] then GuildMarketDB.config.dkpLastDecay=tonumber(p[16]) or GuildMarketDB.config.dkpLastDecay end
                print(T.."[GuildMarkt]"..X.." "..L.MSG_SETTINGS); if mainFrame and mainFrame:IsShown() then GM_RefreshList() end end; return
        end
        if msg:sub(1,3)=="DEL" then
            local id=msg:sub(5)
            if id and GuildMarketDB.listings[id] then local sN=sender:match("^([^%-]+)") or sender
                if GuildMarketDB.listings[id].contact==sN then GuildMarketDB.listings[id]=nil; if mainFrame and mainFrame:IsShown() then GM_RefreshList() end end end; return
        end
        -- ── Berufe-Protokoll ────────────────────────────────────
        if msg=="PROFREQ" then BroadcastMyProfs(); return end
        if msg:sub(1,7)=="PROFSET" then
            local skills={}
            for seg in msg:sub(9):gmatch("([^|]+)") do
                local idx,rank=seg:match("^(%d+):(%d+)$")
                if idx then skills[tonumber(idx)]=tonumber(rank) end
            end
            if next(skills) then
                GuildMarketDB.profs[sn]={s=skills,ts=time()}
            end; return
        end
        -- ── Rezept-Protokoll (On-Demand) ────────────────────────
        if msg:sub(1,6)=="RCPREQ" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local target,profIdx=p[2],tonumber(p[3])
            if target==UnitName("player") and profIdx then AnswerRecipeRequest(profIdx) end
            return
        end
        if msg:sub(1,7)=="RCPNONE" then
            local profIdx=tonumber(msg:sub(9))
            if pendingRcp and pendingRcp.target==sn and pendingRcp.profIdx==profIdx then
                local cb=pendingRcp.cb; pendingRcp=nil; if cb then cb(nil,"none") end
            end; return
        end
        if msg:sub(1,7)=="RCPLIST" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local profIdx,flag=tonumber(p[2]),p[3]
            if pendingRcp and pendingRcp.target==sn and pendingRcp.profIdx==profIdx and flag then
                if flag=="B" or flag=="F" then pendingRcp.buf="" end
                pendingRcp.buf=(pendingRcp.buf or "")..(p[4] or "")
                if flag=="E" or flag=="F" then
                    local names={}
                    for seg in (pendingRcp.buf.."\t"):gmatch("([^\t]+)\t") do
                        local ids,nm=seg:match("^(%d*):(.*)$")
                        if nm and nm~="" then names[#names+1]={n=nm,i=(ids~="" and tonumber(ids) or nil)}
                        else names[#names+1]={n=seg} end
                    end
                    local cb=pendingRcp.cb; pendingRcp=nil
                    if cb then cb(names) end
                end
            end; return
        end
        -- ── Schwarzes-Brett-Protokoll ───────────────────────────
        if msg=="BRDREQ" then
            -- nur senden, wenn ich selbst berechtigt bin (Empfaenger prueft den Absender-Rang)
            if CanPostBoard() then BroadcastBoard() end
            return
        end
        if msg:sub(1,7)=="BRDPOST" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local bts,author,flag=tonumber(p[2]),p[3],p[4]
            if not bts or not flag then return end
            -- Absender muss laut Roster berechtigt sein (auch Relays)
            local r=GetMemberRank(sn)
            if r==nil or (r~=0 and r>((GuildMarketDB.config and GuildMarketDB.config.boardRank) or 9)) then return end
            brdStaging[sn]=brdStaging[sn] or {}
            if flag=="B" or flag=="F" then brdStaging[sn]={ts=bts,author=author,text=""} end
            local st=brdStaging[sn]
            if st and st.ts==bts then
                st.text=(st.text or "")..(p[5] or "")
                if flag=="E" or flag=="F" then
                    if bts>((GuildMarketDB.board and GuildMarketDB.board.ts) or 0) then
                        GuildMarketDB.board={text=st.text,author=author,ts=bts}
                        if RefreshBoardFrame then RefreshBoardFrame() end
                    end
                    brdStaging[sn]=nil
                end
            end; return
        end
        -- ── Merch-Shop-Protokoll ────────────────────────────────
        if msg=="MSHREQ" then BroadcastMerch(); return end
        if msg:sub(1,7)=="MSHPOST" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local mid=p[2]
            if mid then
                local itemId=tonumber(p[3])
                GuildMarketDB.merch[mid]={item=p[6] or "?",itemId=itemId,
                    link=itemId and itemId>0 and select(2,GetItemInfo(itemId)) or nil,
                    price=tonumber(p[4]) or 1,stock=tonumber(p[5]) or 0,seller=sn}
                if RefreshMerchFrame then RefreshMerchFrame() end
            end; return
        end
        if msg:sub(1,6)=="MSHBUY" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local mid,nb,bts,oid=p[2],tonumber(p[3]),tonumber(p[4]),p[5]
            local m=mid and GuildMarketDB.merch[mid]
            if m and m.stock~=-1 then
                ApplyMerchPurchase(m)
                if nb and bts then ApplyDKP(sn,nb,bts) end
                if oid and oid~="" and not GuildMarketDB.merchDone[oid] then
                    GuildMarketDB.merchOrders[oid]={mid=mid,item=m.item,buyer=sn,seller=m.seller,price=m.price,ts=bts or time()}
                end
                print(T.."[GuildMarkt]"..X.." "..Gr..sn..X.." "..L.MSH_BOUGHT.." "..W..(m.item or "?")..X.." ("..G..(m.price or 0)..X..") "..L.MSH_FROM.." "..W..(m.seller or "?")..X)
                if GM_UpdateMerchButton then GM_UpdateMerchButton() end
                if RefreshMerchFrame then RefreshMerchFrame() end
            end; return
        end
        if msg:sub(1,7)=="MSHCONF" then
            local oid=msg:sub(9)
            local o=oid and GuildMarketDB.merchOrders[oid]
            if o then
                -- Bestaetigen darf: Verkaeufer des Artikels oder merchRank/GM laut Roster
                local r=GetMemberRank(sn)
                local ok=o.seller==sn or (r~=nil and (r==0 or r<=((GuildMarketDB.config and GuildMarketDB.config.merchRank) or 9)))
                if ok then
                    GuildMarketDB.merchOrders[oid]=nil; GuildMarketDB.merchDone[oid]=time()
                    if GM_UpdateMerchButton then GM_UpdateMerchButton() end
                    if RefreshMerchFrame then RefreshMerchFrame() end
                end
            end; return
        end
        if msg:sub(1,6)=="MSHORD" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local oid=p[2]
            if oid and oid~="" then
                if GuildMarketDB.merchDone[oid] then
                    -- bereits uebergeben: dem Kaeufer Bescheid geben (nur wenn selbst berechtigt)
                    local meN=UnitName("player")
                    local sellerN=p[6] or "?"
                    if sellerN==meN or CanCreateMerch() then SendGuild("MSHCONF|"..oid) end
                elseif not GuildMarketDB.merchOrders[oid] then
                    GuildMarketDB.merchOrders[oid]={mid=p[3],price=tonumber(p[4]) or 0,ts=tonumber(p[5]) or time(),
                        seller=p[6] or "?",item=p[7] or "?",buyer=sn}
                    if GM_UpdateMerchButton then GM_UpdateMerchButton() end
                    if RefreshMerchFrame then RefreshMerchFrame() end
                end
            end; return
        end
        if msg:sub(1,6)=="MSHDEL" then
            local mid=msg:sub(8)
            local m=mid and GuildMarketDB.merch[mid]
            if m and IsMerchSenderAuthorized(m,sn) then
                GuildMarketDB.merch[mid]=nil
                if RefreshMerchFrame then RefreshMerchFrame() end
            end; return
        end
        -- ── Auktions-Protokoll ──────────────────────────────────
        if msg=="AUCREQ" then BroadcastAuctions(); return end
        if msg:sub(1,7)=="AUCPOST" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local aid=p[2]
            if aid and not (GuildMarketDB.auctions[aid] and GuildMarketDB.auctions[aid].closed) then
                local itemId=tonumber(p[3])
                local old=GuildMarketDB.auctions[aid]
                GuildMarketDB.auctions[aid]={item=p[6] or "?",itemId=itemId,
                    link=itemId and select(2,GetItemInfo(itemId)) or nil,
                    minBid=tonumber(p[4]) or 1,endts=tonumber(p[5]) or 0,seller=sn,
                    bids=(old and old.bids) or {}}
                if RefreshLootFrame then RefreshLootFrame() end
            end; return
        end
        if msg:sub(1,7)=="AUCBIDR" then
            -- Gebots-Relay: nur vom Verkaeufer der Auktion akzeptieren
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local aid=p[2]
            local a=aid and GuildMarketDB.auctions[aid]
            if a and not a.closed and a.seller==sn then
                a.bids=a.bids or {}
                for i=3,#p do
                    local name,amt,bts=p[i]:match("^([^:]+):(%d+):(%d+)$")
                    if name then
                        amt=tonumber(amt); bts=tonumber(bts)
                        local old=a.bids[name]
                        if not old or amt>(old.amt or 0) then a.bids[name]={amt=amt,ts=bts} end
                    end
                end
                if RefreshLootFrame then RefreshLootFrame() end
            end; return
        end
        if msg:sub(1,6)=="AUCBID" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local aid,amt,bts=p[2],tonumber(p[3]),tonumber(p[4])
            local a=aid and GuildMarketDB.auctions[aid]
            if a and not a.closed and amt then
                a.bids=a.bids or {}
                local old=a.bids[sn]
                if not old or amt>(old.amt or 0) then a.bids[sn]={amt=amt,ts=bts or time()} end
                if RefreshLootFrame then RefreshLootFrame() end
            end; return
        end
        if msg:sub(1,6)=="AUCEND" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local aid,winner,amt,nb,ets=p[2],p[3],tonumber(p[4]),tonumber(p[5]),tonumber(p[6])
            local a=aid and GuildMarketDB.auctions[aid]
            if a and not a.closed and IsAucSenderAuthorized(a,sn) then
                a.closed=true; a.closedAt=time()
                if winner and winner~="-" then
                    a.winner=winner; a.winAmt=amt or 0
                    if nb and ets then ApplyDKP(winner,nb,ets) end
                    print(T.."[GuildMarkt]"..X.." "..Gr..winner..X.." "..L.AUC_WON..": "..W..(a.item or "?")..X.." ("..G..(amt or 0)..X..")")
                end
                if RefreshLootFrame then RefreshLootFrame() end
            end; return
        end
        if msg:sub(1,6)=="AUCDEL" then
            local aid=msg:sub(8)
            local a=aid and GuildMarketDB.auctions[aid]
            if a and IsAucSenderAuthorized(a,sn) then
                GuildMarketDB.auctions[aid]=nil
                if RefreshLootFrame then RefreshLootFrame() end
            end; return
        end
        -- ── DKP-Protokoll ───────────────────────────────────────
        if msg=="DKPREQ" then BroadcastDKP(); return end
        if msg:sub(1,7)=="DKPSYNC" then
            for seg in msg:sub(9):gmatch("([^|]+)") do
                -- 4. Feld (Anwesenheit) optional: alte Clients senden 3 Felder
                local name,bal,ts,att=seg:match("^([^:]+):(-?%d+):(%d+):?(%d*)$")
                if name then
                    ApplyDKP(name,tonumber(bal),tonumber(ts))
                    -- Anwesenheit ist monoton steigend: max() ist der korrekte Merge
                    local a=tonumber(att)
                    if a and a>((GuildMarketDB.attendance and GuildMarketDB.attendance[name]) or 0) then
                        GuildMarketDB.attendance[name]=a
                    end
                end
            end; return
        end
        if msg:sub(1,7)=="EVTCONF" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local eid,player,bal,ts=p[2],p[3],tonumber(p[4]),tonumber(p[5])
            if eid and player then
                local ev2=GuildMarketDB.events and GuildMarketDB.events[eid]
                if ev2 and ev2.signups and type(ev2.signups[player])=="table" then
                    -- Anwesenheit nur beim Uebergang unbestaetigt->bestaetigt zaehlen
                    if not ev2.signups[player].confirmed then
                        GuildMarketDB.attendance[player]=(GuildMarketDB.attendance[player] or 0)+1
                    end
                    ev2.signups[player].confirmed=true
                end
                if bal then ApplyDKP(player,bal,ts) end
            end; return
        end
        -- ── Kalender-Protokoll ──────────────────────────────────
        if msg=="EVTREQ" then BroadcastEvents(); return end
        if msg:sub(1,6)=="EVTROS" then
            -- Roster-Snapshot des Erstellers: ersetzt die lokale Teilnehmerliste komplett
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local eid,flag=p[2],p[3]
            local ev2=eid and GuildMarketDB.events and GuildMarketDB.events[eid]
            if ev2 and ev2.creator==sn and flag then
                rosStaging[sn]=rosStaging[sn] or {}
                if flag=="B" or flag=="F" then rosStaging[sn][eid]={} end
                local stage=rosStaging[sn][eid]
                if stage then
                    for i=4,#p do
                        local name,role,class,rts,conf=p[i]:match("^([^:]+):([^:]*):([^:]*):(%d+):(%d)$")
                        if name then stage[name]={role=role,class=class,ts=tonumber(rts),confirmed=(conf=="1") or nil} end
                    end
                    if flag=="E" or flag=="F" then
                        -- eigenes frisches Signup nicht verlieren (Snapshot koennte aelter sein)
                        local me2=UnitName("player")
                        local old=ev2.signups or {}
                        local mine=old[me2]
                        if type(mine)=="table" and (not stage[me2] or (mine.ts or 0)>(stage[me2].ts or 0)) then stage[me2]=mine end
                        -- confirmed ist monoton: lokal bestaetigte bleiben bestaetigt (verhindert Doppelvergabe)
                        for name,s in pairs(stage) do
                            if type(old[name])=="table" and old[name].confirmed then s.confirmed=true end
                        end
                        ev2.signups=stage; rosStaging[sn][eid]=nil
                        if mainFrame and mainFrame:IsShown() and currentMode=="CALENDAR" then GM_RefreshCalendar() end
                    end
                end
            end; return
        end
        if msg:sub(1,9)=="EVTUNSIGN" then
            local eid=msg:sub(11)
            if eid and GuildMarketDB.events and GuildMarketDB.events[eid] then
                GuildMarketDB.events[eid].signups=GuildMarketDB.events[eid].signups or {}
                GuildMarketDB.events[eid].signups[sn]=nil
                if mainFrame and mainFrame:IsShown() and currentMode=="CALENDAR" then GM_RefreshCalendar() end
            end; return
        end
        if msg:sub(1,7)=="EVTSIGN" then
            local p={}; for v in (msg.."|"):gmatch("([^|]*)|") do p[#p+1]=v end
            local eid,role,class,ts=p[2],p[3],p[4],tonumber(p[5])
            if eid and GuildMarketDB.events and GuildMarketDB.events[eid] then
                GuildMarketDB.events[eid].signups=GuildMarketDB.events[eid].signups or {}
                GuildMarketDB.events[eid].signups[sn]={role=role,class=class,ts=ts or time()}
                if mainFrame and mainFrame:IsShown() and currentMode=="CALENDAR" then GM_RefreshCalendar() end
            end; return
        end
        if msg:sub(1,7)=="EVTPOST" then
            local eid,ev2=DeserializeEvent(msg)
            if eid and ev2 then
                ev2.creator=sn
                if GuildMarketDB.events[eid] then ev2.signups=GuildMarketDB.events[eid].signups or {} end
                GuildMarketDB.events[eid]=ev2
                if mainFrame and mainFrame:IsShown() and currentMode=="CALENDAR" then GM_RefreshCalendar() end
            end; return
        end
        if msg:sub(1,6)=="EVTDEL" then
            local eid=msg:sub(8)
            local ev2=eid and GuildMarketDB.events and GuildMarketDB.events[eid]
            if ev2 then
                -- Nur Ersteller oder laut Roster berechtigter Rang darf fremde Events loeschen
                local r=GetMemberRank(sn)
                local authorized=ev2.creator==sn or (r~=nil and (r==0 or r<=((GuildMarketDB.config and GuildMarketDB.config.eventDeleteRank) or 9)))
                if authorized then
                    GuildMarketDB.events[eid]=nil
                    if mainFrame and mainFrame:IsShown() and currentMode=="CALENDAR" then GM_RefreshCalendar() end
                end
            end; return
        end
        local action,id,entry=Deserialize(msg)
        if action=="POST" and id and entry then
            entry.contact=sender:match("^([^%-]+)") or sender
            if entry.expires>time() then GuildMarketDB.listings[id]=entry; if mainFrame and mainFrame:IsShown() then GM_RefreshList() end end
        end
    end
end)

-- ============================================================
-- Toggle & Slash
-- ============================================================
function GM_Toggle()
    if not mainFrame then BuildUI() end
    if mainFrame:IsShown() then mainFrame:Hide()
    else mainFrame:ClearAllPoints(); mainFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
        if GuildRoster then GuildRoster() end; PruneExpired(); PruneExpiredEvents()
        if currentMode=="CALENDAR" then GM_RefreshCalendar() else GM_RefreshList() end
        GM_UpdateMerchButton()
        mainFrame:Show()
    end
end
function GM_OpenCalendar()
    if not mainFrame then BuildUI() end
    if not mainFrame:IsShown() then
        mainFrame:ClearAllPoints(); mainFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
        if GuildRoster then GuildRoster() end; PruneExpired(); PruneExpiredEvents()
        mainFrame:Show()
    end
    if GM_ActivateCalendarMode then GM_ActivateCalendarMode() end
end
SLASH_GUILDMARKET1="/gmarkt"; SLASH_GUILDMARKET2="/gildenmarkt"
SlashCmdList["GUILDMARKET"]=function(msg)
    if msg=="sync" then GM_RequestSync(); print(T.."[GuildMarkt]"..X.." Sync angefordert.")
    elseif msg=="config" then if not mainFrame then BuildUI() end; GM_BuildConfigFrame()
    elseif msg=="users" or msg=="nutzer" then
        -- Bekannte Addon-Nutzer mit "zuletzt gesehen" ausgeben
        local list={}
        for name,ts in pairs((GuildMarketDB and GuildMarketDB.addonUsersSeen) or {}) do list[#list+1]={name=name,ts=ts} end
        table.sort(list,function(a,b) return a.ts>b.ts end)
        print(T.."[GuildMarkt]"..X.." "..G..#list..X..Dg.." "..L.COUNT_USERS..":"..X)
        local now=time()
        for _,e in ipairs(list) do
            local d=now-e.ts; local ago
            if d<3600 then ago=(isDE and "vor " or "")..math.floor(d/60)..(isDE and " Min" or " min ago")
            elseif d<86400 then ago=(isDE and "vor " or "")..math.floor(d/3600).."h"..(isDE and "" or " ago")
            else ago=(isDE and "vor " or "")..math.floor(d/86400)..(isDE and " Tagen" or " days ago") end
            print("  "..(IsOnline(e.name) and Gr or W)..e.name..X..Dg.." — "..ago..X)
        end
    else GM_Toggle() end
end
