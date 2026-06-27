# Changelog

## [0.4.0-alpha] - 2026-06-27

### Added
- Online-Status Spalte: gruener Punkt (online) / grauer Kreis (offline) pro Eintrag
- Klick auf gruenen Punkt oeffnet direkt den Fluestern-Chat
- Online-Eintraege werden in der Liste nach oben sortiert
- Resizable Frame — Griff unten rechts, Minimum 470x560
- Eintragsanzahl-Anzeige (gesamt / Biete / Suche)
- Item-Qualitaetsfarbe in der Liste (gruen/blau/lila/orange)
- Dynamischer Gildenname via GetGuildInfo("player") — kein Hardcode mehr
- Konsistente Spaltenausrichtung Header + Zeilen via COL-Konstanten
- Hover-Rahmen-Effekt auf Zeilen
- Fenster zentriert sich bei jedem Oeffnen auf UIParent

### Fixed
- GuildRoster() existiert nicht in TBC Classic — sicherer nil-Check
- Frame-Position (SetPoint CENTER wird beim Oeffnen neu gesetzt)
- SendAddonMessage nil — Kompatibilitaets-Wrapper fuer C_ChatInfo

## [0.1.0-alpha] - 2026-06-27

### Added
- Initial alpha release
- Guild-wide WTB/WTS listings via SendAddonMessage sync
- WoW-style UI with scrollable listing table
- Filter tabs: Alle / Suche / Biete
- Post form: Typ, Item, Menge, Notiz
- Tooltip on hover shows full note and contact
- Delete own listings with ✕ button
- Auto-broadcast own listings on login (6s delay)
- Sync-on-demand via "↻ Sync" button or `/gmarkt sync`
- Entries expire automatically after 7 days
- Supports TBC Classic Anniversary (20505) and Classic Era (11508)
- Slash commands: `/gmarkt`, `/gildenmarkt`
