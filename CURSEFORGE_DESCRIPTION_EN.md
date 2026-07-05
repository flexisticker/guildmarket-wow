# GuildMarket — Marketplace, Guild Calendar, DKP & Merch Shop

**GuildMarket** is the all-in-one guild toolkit for WoW TBC Classic Anniversary and Classic Era: a guild-internal marketplace, an event calendar for dungeons and raids with role signups, a full DKP point system with loot auctions, and a merch shop where members spend their points — no external server required, everything is peer-to-peer via guild addon messages.

---

## 🛒 Marketplace

- **WTB / WTS / Service listings** with a 7-day lifespan
- **Real-time sync** over the guild network — all members instantly see new entries
- **Price modes**: Fixed price (Gold/Silver/Copper), Negotiable, Free
- **Service mode**: professions (Blacksmithing, Alchemy, Enchanting …) with optional material lists
- **Carry Service**: special profession option with a dungeon dropdown (38 dungeons, level- and faction-filtered)
- **Online indicator** per listing — click to open the whisper window
- **Search bar** filters by item name, dungeon, profession, or contact

## 📅 Guild Calendar — Dungeons & Raids

- **Real month-grid calendar** with navigation, today button, and per-day event preview
- **Dungeon AND raid events**: pick from 38 dungeons or 16 raids (Karazhan to Sunwell plus all Classic raids)
- **Raid presets**: selecting a raid auto-fills the role slots to match its size (10-man → 2/3/5, 25-man → 3/6/16, 40-man → 4/10/26)
- **Faction aware**: the addon detects your faction and only shows the instances available to you
- **Role signups**: Tank / Healer / DPS with class selection — slots per role are configurable
- **Reserve bench**: once a role is full, additional signups automatically go to the bench and move up when someone leaves
- **Guild chat announcements**: optional checkbox posts new events to guild chat, plus an automatic reminder about 1 hour before start
- **Login reminder** lists today's events in your chat
- **"Invite all"**: the event leader invites all signed-up players with one click

## 💰 DKP & Loot Auction (EQdkp style)

- **Two event types**: dungeon events (no points) and guild events (rank-restricted, points set per event at creation)
- **Attendance confirmation**: event leaders/officers confirm who attended — confirmed attendees receive the event's points
- **Point ledger**: searchable and filterable ranking of all members (built for large guilds), manual +/− adjustments behind a configurable rank
- **Loot auctions**: list an item via drag & drop, set a minimum bid and duration — your bid can never exceed your point balance; highest bid wins, points are deducted automatically, auctions close on their own

## 🛍️ Merch Shop

- **Sell guild merch and services for points**: create shop items (free text or item link) with price and stock
- **Purchases are announced in guild chat** with a fun random message
- **Order management**: sellers and guild leadership see pending purchases highlighted on the shop button, with online status, whisper button, and a delivery confirmation per order

## ⚙️ Permission System

- **Ten individually configurable rights**: posting, deleting, event creation/deletion, attendance confirmation, guild events, auctions, point adjustments, merch, settings access
- **Default: everyone can do everything** — the guild master restricts by rank as needed
- **The guild master always keeps full rights** and can delegate settings access to a rank of choice
- **Secured**: permission-relevant messages are verified against the guild roster on the receiving side

## 🌍 Misc

- **Minimap button**: left-click opens the marketplace, right-click the calendar
- **Localization**: German for deDE clients, English for all others — instance names are transmitted language-neutrally, so mixed DE/EN guilds see their own language
- **Addon user counter** shows live how many guild members have the addon installed

---

## Commands

`/gmarkt` — open/close the marketplace

## Compatibility

| Client | Interface |
|---|---|
| TBC Classic Anniversary | 20505 |
| Classic Era | 11508 |

## Notes

- Only guild members with the addon installed can receive listings, events, points, and shop items
- No server, no database access — 100% addon message communication
- Market listings expire automatically after 7 days, events 24h after their date
- Alpha/Beta: feedback & bug reports welcome!

---

*by MichaModus*
