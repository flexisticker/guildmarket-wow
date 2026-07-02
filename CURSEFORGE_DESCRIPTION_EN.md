# GuildMarket — Marketplace, Guild Calendar & DKP

**GuildMarket** is the all-in-one guild toolkit for WoW TBC Classic Anniversary and Classic Era: a guild-internal marketplace, an event calendar with role signups, and a full DKP point system with loot auctions — no external server required, everything is peer-to-peer via guild addon messages.

---

## 🛒 Marketplace

- **WTB / WTS / Service listings** with a 7-day lifespan
- **Real-time sync** over the guild network — all members instantly see new entries
- **Price modes**: Fixed price (Gold/Silver/Copper), Negotiable, Free
- **Service mode**: professions (Blacksmithing, Alchemy, Enchanting …) with optional material lists
- **Carry Service**: special profession option with a dungeon dropdown (35 dungeons, Classic + TBC, level-filtered)
- **Online indicator** per listing — click to open the whisper window
- **Search bar** filters by item name, profession, or contact

## 📅 Guild Calendar

- **Real month-grid calendar** with navigation, today button, and per-day event preview
- **Two event types**: dungeon events (anyone with the right) and guild events (rank-restricted, award points)
- **Role signups**: Tank / Healer / DPS with class selection — slots per role are configurable
- **Reserve bench**: once a role is full, additional signups automatically go to the bench and move up when someone leaves
- **Role switching** any time, as long as slots are available
- **Dungeon picker** from the instance list right in the event creation form
- **"Invite all"**: the event leader invites all signed-up players to the group with one click

## 💰 DKP & Loot Auction (EQdkp style)

- **Attendance confirmation**: event leaders/officers confirm who attended after the event — confirmed attendees receive the points defined for that event
- **Point ledger**: ranking of all members, automatic sync on login
- **Loot auctions**: list an item via drag & drop, set a minimum bid and duration
- **Bid with points**: your bid cannot exceed your point balance — highest bid wins, points are deducted automatically
- **Auto-close** when the timer runs out, results are announced to everyone

## ⚙️ Permission System

- **Every right individually configurable**: posting, deleting, event creation/deletion, attendance confirmation, guild events, auctions
- **Default: everyone can do everything** — the guild master restricts by rank as needed
- **Delegable**: the GM can define a rank that may also change settings (the GM always keeps full rights)
- **Secured**: settings sync is only accepted from authorized senders

## 🌍 Misc

- **Localization**: German for deDE clients, English for all others
- **Addon user counter** shows live how many guild members have the addon installed
- **Tabs**: All / WTS / WTB / Service / Calendar

---

## Commands

`
/gmarkt        — open/close the marketplace
`

---

## Compatibility

| Client | Interface |
|---|---|
| TBC Classic Anniversary | 20505 |
| Classic Era | 11508 |

---

## Notes

- Only guild members with the addon installed can receive listings, events, and points
- No server, no database access — 100% addon message communication
- Market listings expire automatically after 7 days, events 24h after their date
- Beta: feedback & bug reports welcome!

---

*by MichaModus*
