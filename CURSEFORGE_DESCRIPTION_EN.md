# GuildMarket — Marketplace, Guild Calendar, DKP, Merch Shop & More

**GuildMarket** is the all-in-one guild toolkit for WoW TBC Classic Anniversary and Classic Era: a guild-internal marketplace, an event calendar for dungeons and raids with role signups and recurring events, a full DKP point system with attendance tracking, decay and loot auctions, a merch shop, a searchable profession directory with recipe lists, and a guild announcement board — no external server required, everything is peer-to-peer via guild addon messages.

---

## 🛒 Marketplace

- **WTB / WTS / Service listings** with a 7-day lifespan
- **Real-time sync** over the guild network — all members instantly see new entries
- **Price modes**: Fixed price (Gold/Silver/Copper), Negotiable, Free
- **Service mode**: professions with optional material lists
- **Carry Service**: dungeon dropdown (38 dungeons, level- and faction-filtered)
- **Online indicator** per listing — click to open the whisper window
- **Search bar** filters by item name, dungeon, profession, or contact

## 📅 Guild Calendar — Dungeons & Raids

- **Real month-grid calendar** with navigation, today button, and per-day event preview
- **Dungeon AND raid events**: 38 dungeons or 16 raids (Karazhan to Sunwell plus all Classic raids)
- **Recurring events**: create once as weekly or bi-weekly — the next occurrence is scheduled automatically, including role slots, points, and guild chat announcement
- **Raid presets**: selecting a raid auto-fills the role slots to match its size (10-man → 2/3/5, 25-man → 3/6/16, 40-man → 4/10/26)
- **Faction aware**: only shows the instances available to your faction
- **Role signups**: Tank / Healer / DPS with class selection — slots per role are configurable
- **Reserve bench**: once a role is full, additional signups go to the bench and move up when someone leaves
- **Guild chat announcements**: optional checkbox posts new events to guild chat, plus an automatic reminder about 1 hour before start
- **Login reminder** lists today's events; **"Invite all"** invites all signed-up players with one click

## 💰 DKP, Attendance & Loot Auction (EQdkp style)

- **Two event types**: dungeon events (no points) and guild events (rank-restricted, points set per event)
- **Attendance confirmation**: leaders/officers confirm who attended — confirmed attendees receive the event's points
- **Attendance statistics**: every confirmed participation is counted permanently — the point ledger shows an "Events" column so leadership sees who raids reliably
- **Configurable DKP decay**: optional percentage decay every X days (e.g. −10% weekly) against point hoarding — executed safely by the guild master's client only
- **Point ledger**: searchable and filterable ranking (built for large guilds), manual +/− adjustments behind a configurable rank
- **Loot auctions**: list an item via drag & drop, set minimum bid and duration — bids can never exceed your balance; highest bid wins, points are deducted automatically, auctions close on their own

## 🛍️ Merch Shop

- **Sell guild merch and services for points**: shop items with price and stock
- **Purchases are announced in guild chat** with a fun random message
- **Order management**: pending purchases highlighted on the shop button, with online status, whisper button, and delivery confirmation per order

## ⚒️ Profession Directory

- **Fully automatic**: your professions (including cooking, first aid, fishing) are detected from your skill lines at login and synced — nobody has to maintain anything
- **Searchable**: find out in seconds who can craft what ("who has Enchanting?"), with skill level, online status, and whisper button
- **Recipe lists on demand**: open a crafter's profession with one click to see exactly what they can make — the list is requested live from the player, searchable, with a full item tooltip on hover and shift-click to link an item into chat
- Your own recipes are scanned automatically when you open your profession window; a login reminder nudges you to open any window that hasn't been scanned yet
- **Language-neutral sync**: mixed German/English guilds each see profession names in their own language

## 📌 Guild Board

- **One announcement from leadership** (up to 600 characters) — unread announcements pop up once at login with a "Got it" button
- Posting rights behind a configurable rank; verified against the guild roster on the receiving side

## ⚙️ Permission System

- **Eleven individually configurable rights**: posting, deleting, event creation/deletion, attendance confirmation, guild events, auctions, point adjustments, merch, board, settings access
- **Default: everyone can do everything** — the guild master restricts by rank as needed
- **The guild master always keeps full rights** and can delegate settings access
- **Secured**: permission-relevant messages are verified against the guild roster

## 🌍 Misc

- **Minimap button**: left-click marketplace, right-click calendar
- **Addon user counter** with presence handshake and persistent list — `/gmarkt users` shows who has the addon and when they were last seen
- **Localization**: German for deDE clients, English for all others — instances and professions are transmitted language-neutrally

---

## Commands

`/gmarkt` — open/close the marketplace · `/gmarkt users` — list addon users

## Compatibility

| Client | Interface |
|---|---|
| TBC Classic Anniversary | 20506 |
| Classic Era | 11508 |

## Notes

- Only guild members with the addon installed can receive listings, events, points, and shop items
- No server, no database access — 100% addon message communication
- Beta: feedback & bug reports welcome!

---

*by MichaModus*
