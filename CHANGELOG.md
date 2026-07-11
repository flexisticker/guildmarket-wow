# Changelog — GuildMarket

Alle nennenswerten Änderungen an diesem Addon.
Format: [Version] · Datum · Kurzbeschreibung

---

## [1.0.2-beta] · 2026-07-11 · Zuverlässige Addon-Nutzer-Erkennung

### Added
- **Presence-Handshake**: Beim Login sendet jeder Client ein HELLO, Empfänger antworten gedrosselt mit HI — damit sehen sich alle Addon-Nutzer gegenseitig, auch „stille" ohne eigene Einträge
- **Persistente Nutzerliste**: Erkannte Nutzer werden mit „zuletzt gesehen"-Zeitstempel in den SavedVariables gespeichert; der Zähler startet nach Relog mit allen Nutzern der letzten 14 Tage (Einträge >60 Tage werden vergessen)
- **`/gmarkt users`** (bzw. `/gmarkt nutzer`): listet alle bekannten Addon-Nutzer im Chat — grün = online, mit „vor X Min/h/Tagen"

---

## [1.0.1-beta] · 2026-07-10 · Interface-Update für WoW-Patch 2.5.6

### Changed
- TOC-Interface für TBC Classic Anniversary auf **20506** angehoben (Patch 2.5.6) — Addon wurde als „veraltet" angezeigt
- Classic Era bleibt bei 11508

---

## [1.0.0-beta] · 2026-07-05 · Beta-Promotion mit Versionssprung

Der Funktionsumfang ist komplett: Marktplatz, Gilden-Kalender (Dungeons & Raids), DKP-System, Loot-Auktion, Merch-Shop mit Bestell-Verwaltung und das volle Rechte-System — Zeit für die 1.0!

### Changed
- Inhaltlich identisch mit 0.9.12-alpha, jetzt im Beta-Channel
- `.pkgmeta`: CURSEFORGE_DESCRIPTION*.md aus dem Release-ZIP ausgeschlossen

---

## [0.9.12-alpha] · 2026-07-05 · Raids, Merch-Shop, Fraktions-Filter, Sync-Härtung, Komfort

### Added
- **Raid-Events**: Instanz-Dropdown zweistufig (Dungeons/Raids-Untermenüs); 16 Raids (Kara bis Sunwell + Classic) mit automatischer Rollen-Vorbefüllung nach Raid-Größe (10er 2/3/5, 25er 3/6/16, 40er 4/10/26)
- **Auto-Titel**: leerer Titel + gewählte Instanz → Instanzname wird Titel
- **Fraktions-Erkennung**: fraktions-exklusive Dungeons (Verlies/Flammenschlund) werden automatisch nach `UnitFactionGroup` gefiltert (Ziehdienst + Kalender)
- **Merch-Shop**: „Shop"-Button; Artikel anlegen (Freitext/Item-Drag, Preis in Punkten, Bestand, 0=unbegrenzt), Kauf mit Punkteabzug, Ausverkauft-Status
- **Kauf-Verwaltung**: Bestellungen mit Gildenchat-Ankündigung (zufällige Sprüche), Shop-Button-Highlight „Shop (N)", Offene-Käufe-Sektion mit Online-Dot, Flüstern + „Übergeben"-Bestätigung (Verkäufer/merchRank), Tombstone-Sync gegen Geister-Bestellungen
- **Event-Ankündigung**: Checkbox „Im Gildenchat ankündigen" beim Erstellen + automatische 1h-Erinnerung im Gildenchat (nur Ersteller-Client, genau einmal)
- **Minimap-Button** (Links: Markt, Rechts: Kalender, ziehbar), **Login-Erinnerung** an heutige Events, **Addon-Logo** (IconTexture)
- **DKP**: Suche + „Nur Online"-Filter in der Punkteliste (skaliert für große Gilden), manuelle +/−-Anpassung mit eigenem Rang (`dkpAdjustRank`)
- **Neue Config-Ränge**: Punkte anpassen, Merch anlegen (Config-Fenster jetzt 10 Rang-Dropdowns)
- **Sprachneutrale Instanz-Codes** im Event-Protokoll (D:i/R:i) — DE/EN-Clients sehen Instanzen in ihrer Sprache

### Fixed
- **Eigene Addon-Nachrichten werden übersprungen** — behebt doppelten Bestands-Abzug beim Merch-Kauf und doppelte Sync-Antworten beim Login
- **Sync-Härtung**: Event-Ersteller verteilt komplette Teilnehmerlisten (EVTROS-Snapshots, erfasst Offline-Anmeldungen UND -Abmeldungen); Verkäufer relayed Auktions-Gebote; Auktion-Beenden/Abbrechen durch Offiziere wird jetzt überall anerkannt; AUCEND/AUCDEL/EVTDEL mit Absender-Autorisierung; confirmed-Flag monoton (keine Doppelvergabe)
- **Deutsche Dungeon-Namen korrigiert** (Flammenschlund, Höhlen des Wehklagens, Das Verlies, Düsterbruch …), Tiefschwarze Grotte ergänzt, Mindestlevel realistisch

---

## [0.9.11-beta] · 2026-07-02 · Monatskalender, Rollen-Signup, DKP-System, Loot-Auktion

### Added
- **Monatskalender-Grid** statt Agenda-Liste: 7×6-Raster mit Monats-Navigation (◄/►), Heute-Button, Event-Vorschau pro Tag (max. 2 + „+N"-Badge), Klick auf leeren Tag füllt das Datumsfeld vor
- **Rollen-Signup**: Anmeldung mit Rolle (Tank/Heiler/DPS) + Klassenwahl; Plätze pro Rolle beim Erstellen konfigurierbar (0 = unbegrenzt)
- **Ersatzbank**: Ist eine Rolle voll, landen weitere Anmeldungen automatisch auf der Ersatzbank (deterministisch nach Anmeldezeit) und rücken nach, wenn jemand abspringt
- **Rollenwechsel**: Angemeldete können Rolle/Klasse jederzeit ändern, solange die Zielrolle frei ist; reiner Klassenwechsel behält die Warteschlangen-Position
- **Zwei Event-Typen**: Dungeon-Event (ohne Punkte) und Gilden-Event (rang-beschränkt, Punkte pro Event beim Erstellen festlegbar, golden im Kalender)
- **Dungeon-Auswahl** beim Event-Erstellen (Dropdown aus der Instanzliste)
- **Anwesenheits-Bestätigung**: Event-Leiter/berechtigter Rang bestätigt Teilnehmer per „+P"-Button; grünes Häkchen, Doppel-Gutschrift ausgeschlossen
- **DKP-Punktekonto**: `dkp[player]={bal,ts}` mit Last-Writer-Wins-Sync (DKPSYNC/DKPREQ), Punkte-Rangliste („Punkte"-Button im Kalender), Login-Abgleich
- **Loot-Auktion (EQdkp-Stil)**: eigenes Loot-Fenster (Button im Hauptframe); Item per Drag&Drop, Mindestgebot + Laufzeit; Gebote ≤ eigener Punktestand; Höchstgebot gewinnt, Punkte werden abgezogen; Auto-Abschluss per Ticker auch bei geschlossenem Fenster; 24h-Historie
- **Event löschen**: roter Löschen-Button im Detail-Popup (Ersteller + konfigurierbarer Rang)
- **Rechte-System erweitert**: 7 konfigurierbare Ränge (Posten, Löschen, Event erstellen/löschen, Bestätigen, Gilden-Event, Auktion) + „Rechte ändern ab" (delegierbar, GM immer berechtigt, nur GM stellbar); Config-Fenster zweispaltig
- **Config-Sync abgesichert**: CFG-Nachrichten werden nur von laut Roster berechtigten Absendern akzeptiert

### Changed
- Alle Rechte-Defaults auf Rang 9 („jeder"); einmalige Migration bestehender Installationen
- Event-Protokoll erweitert: `EVTPOST` mit Rollen-Slots/Dungeon/Typ/Punkten, `EVTSIGN` mit Rolle/Klasse/Timestamp, neu `EVTCONF`, `AUCPOST/AUCBID/AUCEND/AUCDEL/AUCREQ`, `DKPSYNC/DKPREQ`
- CurseForge-Beschreibungen (DE/EN) komplett überarbeitet

### Fixed
- Lua-5.1-Upvalue-Limit (max. 60) in BuildUI überschritten → 15 Hilfsfunktionen als `GM_`-Globals ausgelagert

---

## [0.9.10-beta] · 2026-06-27 · Invite-Button, offene Standardrechte

### Added
- **„Alle einladen"**-Button im Event-Detail-Popup: Ersteller, Offiziere und GM können alle angemeldeten Spieler mit einem Klick per `InviteUnit()` in die Gruppe/Raid einladen

### Changed
- Alle Standard-Rechte auf Rang 9 (jeder kann posten, löschen und Events erstellen) — GM kann per Config einschränken

---

## [0.9.9-beta] · 2026-06-27 · Gilden-Kalender mit Event-Anmeldung

### Added
- **Kalender-Tab** (5. Tab) — Events mit Datum, Uhrzeit, Beschreibung, Max-Teilnehmerzahl
- Nur Offiziere/GM können Events erstellen (konfigurierbarer `eventRank`, Standard = Rang 1)
- Alle Gildenmitglieder können sich an- und abmelden (Anmelden/Abmelden-Button pro Zeile)
- Events werden peer-to-peer via `EVTPOST|`, `EVTDEL|`, `EVTSIGN|`, `EVTUNSIGN|`, `EVTREQ` synchronisiert
- **Event-Detail-Popup**: Teilnehmerliste mit Online-Dots, Flüstern-Buttons, Anmelden/Abmelden
- Events automatisch bereinigt wenn älter als 24h nach Eventdatum (`PruneExpiredEvents`)
- Login-Sync: beim Einloggen werden eigene Events und Anmeldungen automatisch gesendet + `EVTREQ` zum Nachladen fremder Events
- `CFG_EVTRANK`-Option im Config-Frame (GM kann Event-Erstell-Rang konfigurieren)

### Fixed
- Config-Frame auf 290px Höhe vergrößert (Platz für 3. Rang-Dropdown)

---

## [0.9.8-beta] · 2026-06-27 · Lokalisierung (DE/EN), Responsives Formular

### Added
- **Vollständige Lokalisierung**: automatische Spracherkennung via `GetLocale()` — Deutsch bei deDE, sonst Englisch
- Alle UI-Labels, Buttons, Tabs, Tooltips, Fehlermeldungen und Regeln übersetzt
- Lokalisierte Berufsliste (BERUFE) und Dungeon-Namen (DUNGEONS)
- BERUF_ICONS unterstützt jetzt DE- und EN-Keys

### Fixed
- **Responsives Formular**: `ShowSection()` resized `itemBg` dynamisch (95px BIETE/SUCHE, 120px DIENST)
- Labels (`newLbl`, `lbTyp`, `lbNote`, `lbPreis`, Coin-Labels) sind jetzt Kinder ihrer Backdrop-Frames — renderten vorher verdeckt hinter dem Rahmen (WoW Z-Order: Kindframes überdecken FontStrings des Elternframes)
- Alle Formular-Interna auf TOPLEFT-Anchoring umgestellt (kein neg. y-Overflow mehr)

---

## [0.9.7-beta] · 2026-06-27 · Ziehdienst, Addon-Nutzer-Zähler, Fenster höher

### Added
- Neuer Beruf **Ziehdienst** im DIENST-Modus
- Eigenes Dungeon-Dropdown (35 Dungeons, Classic + TBC) ersetzt Leistungsfeld wenn Ziehdienst gewählt
- Dungeons werden nach Spieler-Level gefiltert (nur Dungeons für die man hoch genug ist)
- **„Wunsch-Dungeon"** immer als erste Option (für individuelle Absprachen)
- **Addon-Nutzer-Zähler** oben rechts im Fenster: zählt wie viele Gildenmitglieder das Addon nutzen (wächst live wenn jemand eine Nachricht sendet)

### Changed
- MIN_H 640 → 680px — Formular 25px höher, alle Labels klar sichtbar oberhalb ihrer Felder
- Label im DIENST-Formular wechselt dynamisch: „Leistung / Bezeichnung" ↔ „Dungeon"

---

## [0.9.6] · 2026-06-27 · Fenster höher, Labels sichtbar

### Changed
- MIN_H 640 → 680px, alle Formular-Y-Koordinaten um 25px nach oben verschoben
- „Neuer Eintrag"-Überschrift liegt jetzt klar oberhalb des Backdrop-Rahmens
- ScrollFrame-Bottom und Trennlinie angepasst (y=295/293)

### Added
- Addon-Nutzer-Zähler (FontString im Tab-Bereich, rechts)

---

## [0.9.5] · 2026-06-27 · Kontaktliste: Online-Dot größer, Offline ausgegraut

### Changed
- Online-Dot 16×16 (statt 12×12), volle Helligkeit
- Offline: Name in Grau, Dot 35% Alpha, Flüstern-Button halb-transparent
- Online-Mitglieder stehen in jeder Rang-Gruppe oben

---

## [0.9.4] · 2026-06-27 · Regeln guild-agnostisch, Kontaktliste sortiert

### Changed
- Info-Popup: Begrüßung zeigt dynamisch `GetGuildInfo("player")` statt Hardcode „Der Hohe Rat"
- Regel 2: **Gildenrabatt** — günstiger anbieten als extern
- Regel 5: **Gilde geht vor** — Mitglieder haben Vorrang
- Kontaktliste: Online-Mitglieder stehen in jeder Gruppe oben (GM / Offiziere)

---

## [0.9.3] · 2026-06-27 · MakeBg-Fix, Layout-Overlap, 680px

### Fixed
- `MakeBg` war innerhalb `BuildUI` definiert, wurde aber von `BuildInfoFrame` vor dessen Aufruf verwendet → Lua-Fehler "attempt to call global 'MakeBg' (a nil value)"; Funktion auf Modulebene verschoben
- UIDropDownMenu-Button-Überlapp mit Item-Label endgültig behoben: `SetWidth(74)` ergibt 100px sichtbaren Button (endet bei x=110), Labels + Felder starten nun bei x=120

### Changed
- MIN_W von 620 auf 680px erhöht
- Item-Editbox 418px, Mats-Editbox 516px — deutlich mehr Platz
- Coin-Felder und FP/VHB-Dropdown proportional neu positioniert

---

## [0.9.2] · 2026-06-27 · Info-Popup, Marktplatz-Regeln, Kontakt-Leiste

### Added
- Neuer **?-Button** rechts neben `cfg` öffnet Regeln-Popup
- 8 Marktplatz-Regeln (faire Preise, Ehrlichkeit, Meldepflicht etc.)
- Kontakt-Sektion im Popup: Gildenmeister (Rang 0) + Offiziere (Rang 1) werden **live aus dem Guild-Roster** gelesen — kein Hardcode
- Online-Indikator (grün/grau) pro Person
- **Flüstern-Button** direkt neben jedem Namen öffnet Whisper-Chat
- „Roster neu laden"-Button falls Sync noch aussteht

---

## [0.9.1] · 2026-06-27 · Formular-Layout-Fix

### Fixed
- Typ-Dropdown und Eingabefelder endlich auf gleicher Y-Linie (y=200 von InsetBg-Bottom)
- Kein Überlapp mehr zwischen Dropdown-Button und Item-Label
- DIENST: Beruf-Dropdown und Leistungsfeld korrekt nebeneinander
- DIENST Mats als separater Frame, erscheint nur wenn DIENST aktiv
- `ShowSection()` repositioniert ddType automatisch (BIETE/SUCHE vs. DIENST)
- Sections nutzen `BOTTOMLEFT`-Anker (statt `TOPLEFT`) für präzise Y-Kontrolle
- ScrollFrame + Separator-Linie auf neue Formularhöhe angepasst

---

## [0.9.0] · 2026-06-27 · Modernes Layout, Item-Icons, Suchleiste, 25% breiter

### Added
- **Fenster 620px** breit (25% mehr als v0.8.x)
- **Suchleiste** über der Liste: Echtzeit-Filter nach Item-Name, Beruf, Kontakt und Mats
- **Item-Icons** (16×16) vor jedem Listeneintrag via `GetItemInfo(itemId)`
- **Beruf-Icons** für DIENST-Einträge (Trade_Alchemy, Trade_Engraving etc.)
- Fragezeichen-Icon als Fallback
- Formular mit drei Backdrop-Gruppen (Eintrag / Preis / Notiz) für klare visuelle Trennung
- Formular wechselt automatisch Felder je nach Typ (BIETE/SUCHE vs. DIENST)
- Tabs: Alle / Suche / Biete / Dienst

### Changed
- Backdrop-Hilfsfunktion `MakeBg` eingeführt
- Neue Spalte `icon` im COL-System; alle rechten Spalten verschieben sich beim Resize

---

## [0.8.0] · 2026-06-27 · DIENST-Typ, Menge-Spalte zurück, FP/VHB-Fix

### Added
- Neuer Eintragtyp **DIENST** (lila) für Berufsleistungen
- Beruf-Dropdown: Alchemie, Verzauberkunst, Schneiderei, Schmiedekunst, Lederverarbeitung, Ingenieurskunst, Juwelenschleifen, Kochkunst, Kräuterkunde, Kürschnerei, Angeln, Erste Hilfe, Farmservice
- Leistungsfeld + kommagetrennte Mats-Liste
- Dienst-Tooltip listet Mats einzeln auf
- Dienst-Einträge mit **lila Zebrastreifen**
- Protokoll um `|BERUF|MATS` erweitert (rückwärtskompatibel)

### Fixed
- **Menge-Spalte** in der Liste wieder sichtbar (war seit v0.7.0 nur im Tooltip)
- **FP/VHB Dropdown-Text** verschwand nach Auswahl — Ursache: `|c`-Farbcode in `UIDropDownMenu_SetText` nicht unterstützt; Fix: nur Plain-Text-Labels

---

## [0.7.0] · 2026-06-27 · Gold/Silber/Kupfer-Felder, Formular-Redesign

### Added
- Separate Eingabefelder für **Gold / Silber / Kupfer** (statt einem Gesamt-Feld)
- **Free-Toggle**-Button
- **Festpreis / VHB**-Dropdown
- Preisanzeige in Münzfarben (Gold = gelb, Silber = grau, Kupfer = braun)
- Preis-Summe in Listenspalte

### Changed
- Komplettes Formular-Redesign mit sauberem G/S/K-Layout

---

## [0.6.0] · 2026-06-27 · Rang-Berechtigungssystem

### Added
- Konfigurierbarer **Postier-Rang** (ab welchem Rang darf gepostet werden)
- Konfigurierbarer **Lösch-Rang** (ab welchem Rang dürfen fremde Einträge gelöscht werden)
- Nur Ersteller oder berechtigte Offiziere/GM dürfen löschen
- `CFG|postRank|deleteRank`-Nachricht verteilt Einstellungen per Sync
- Config-Panel (cfg-Button oben rechts) mit Rang-Dropdowns
- Nur GM (Rang 0) darf Einstellungen speichern

---

## [0.5.0] · 2026-06-27 · Resize + Online-Status + Flüstern

### Added
- Resizable Fenster per Maus (Mindestgröße 470×560)
- **Online-Status-Icon** pro Eintrag (WoW FriendsFrame-Texturen: grün/grau)
- Online-Einträge werden oben in der Liste sortiert
- Klick auf grünen Punkt öffnet direkt Flüster-Chat (`ChatFrame_SendTell`)
- Eintragszahl-Anzeige (gesamt / Biete / Suche)
- Item-Qualitätsfarbe in der Liste
- Dynamischer Gildenname via `GetGuildInfo("player")`
- Hover-Rahmen-Effekt auf Zeilen
- Fenster zentriert sich bei jedem Öffnen neu

### Fixed
- `GuildRoster()` nil in TBC Classic → nil-Check Guard
- `SetMinResize()` nil in TBC Classic → `OnSizeChanged`-Guard
- Unicode-Symbole (●/↻) als Vierecke → ersetzt durch WoW-Texturen

---

## [0.4.0-alpha] · 2026-06-27 · Spaltenresize, Spaltenausrichtung

### Added
- Dynamische Item-Spalte expandiert beim Resize (`sf:OnSizeChanged` + `GetExtraW()`)
- Rechte Spalten verschieben sich per `ClearAllPoints` + dynamischem `SetPoint`
- Konsistente Spaltenausrichtung Header + Zeilen via `COL`-Konstanten

### Fixed
- ScrollFrame content width = 0 bei Erstellung → `ROW_W`-Konstante
- Frame-Position (SetPoint CENTER wird beim Öffnen neu gesetzt)
- `SendAddonMessage` nil → Kompatibilitäts-Wrapper für `C_ChatInfo`

---

## [0.1.0-alpha] · 2026-06-27 · Initial Release

### Added
- Gildeninterner BIETE/SUCHE-Marktplatz
- Guild-weite Sync via `SendAddonMessage("GUILDMKT", msg, "GUILD")` — kein Server
- Filter-Tabs: Alle / Suche / Biete
- Formular: Typ, Item, Menge, Notiz
- Item Drag & Drop aus Bag + Shift+Klick-Link
- Hover-Tooltip mit vollem Item-Tooltip + Kontakt + Notiz
- Eigene Einträge löschen per ×-Button
- Auto-Broadcast eigener Einträge bei Login (6s Delay)
- Sync-on-demand via „Sync"-Button oder `/gmarkt sync`
- Einträge laufen nach 7 Tagen automatisch ab
- SavedVariables: `GuildMarketDB` (listings + config)
- Unterstützt TBC Classic Anniversary (20505) und Classic Era (11508)
- Slash-Commands: `/gmarkt`, `/gildenmarkt`, `/gmarkt sync`, `/gmarkt config`
