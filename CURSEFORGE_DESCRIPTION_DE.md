# GuildMarket — Marktplatz, Gilden-Kalender, DKP, Merch-Shop & mehr

**GuildMarket** ist die Komplett-Lösung für das Gildenleben in WoW TBC Classic Anniversary und Classic Era: gildeninterner Marktplatz, Event-Kalender für Dungeons und Raids mit Rollen-Anmeldung und wiederkehrenden Terminen, ein vollwertiges DKP-System mit Anwesenheits-Statistik, Punkteverfall und Loot-Auktionen, ein Merch-Shop, ein Berufe-Verzeichnis und ein Schwarzes Brett — ganz ohne externen Server, alles peer-to-peer via Gildenchat.

---

## 🛒 Marktplatz

- **WTB / WTS / Dienst-Inserate** mit Laufzeit von 7 Tagen
- **Echtzeit-Sync** über das Gildennetz — alle Mitglieder sehen sofort neue Einträge
- **Preistypen**: Festpreis (Gold/Silber/Kupfer), Verhandlungsbasis, kostenlos
- **DIENST-Modus**: Berufe mit optionalen Materiallisten
- **Ziehdienst**: Dungeon-Dropdown (38 Dungeons, level- und fraktionsgefiltert)
- **Online-Indikator** pro Eintrag — ein Klick öffnet das Flüster-Fenster
- **Suchleiste** filtert nach Item-Name, Dungeon, Beruf, Kontakt

## 📅 Gilden-Kalender — Dungeons & Raids

- **Echter Monatskalender** mit Navigation, Heute-Button und Event-Vorschau pro Tag
- **Dungeon- UND Raid-Events**: 38 Dungeons oder 16 Raids (Karazhan bis Sonnenbrunnen plus alle Classic-Raids)
- **Wiederkehrende Events**: einmal als wöchentlich oder 14-tägig anlegen — der Folgetermin wird automatisch erstellt, inklusive Rollen-Plätzen, Punkten und Gildenchat-Ankündigung
- **Raid-Vorlagen**: Bei Raid-Auswahl werden die Rollen-Plätze automatisch passend zur Raid-Größe vorbefüllt (10er → 2/3/5, 25er → 3/6/16, 40er → 4/10/26)
- **Fraktions-Erkennung**: zeigt nur die Instanzen deiner Fraktion
- **Rollen-Anmeldung**: Tank / Heiler / DPS mit Klassenwahl — Plätze pro Rolle konfigurierbar
- **Ersatzbank**: Ist eine Rolle voll, landen weitere Anmeldungen auf der Ersatzbank und rücken automatisch nach
- **Gildenchat-Ankündigung**: Optionaler Haken postet neue Events in den Gildenchat, plus automatische Erinnerung ca. 1 Stunde vor Beginn
- **Login-Erinnerung** listet die heutigen Events; **„Alle einladen"** lädt alle Angemeldeten mit einem Klick

## 💰 DKP, Anwesenheit & Loot-Auktion (EQdkp-Stil)

- **Zwei Event-Typen**: Dungeon-Events (ohne Punkte) und Gilden-Events (rang-beschränkt, Punkte pro Event festlegbar)
- **Teilnahme-Bestätigung**: Leiter/Offiziere bestätigen, wer dabei war — bestätigte Teilnehmer erhalten die Punkte
- **Anwesenheits-Statistik**: jede bestätigte Teilnahme wird dauerhaft gezählt — die Punkteliste zeigt eine „Events"-Spalte, damit die Leitung sieht, wer zuverlässig raidet
- **Konfigurierbarer DKP-Verfall**: optionaler Prozent-Verfall alle X Tage (z.B. −10% wöchentlich) gegen Punkte-Horten — sicher ausgeführt nur vom Gildenmeister-Client
- **Punktekonto**: durchsuch- und filterbare Rangliste (auch für große Gilden), manuelle +/− Anpassung hinter konfigurierbarem Rang
- **Loot-Auktionen**: Item per Drag&Drop, Mindestgebot + Laufzeit — Gebote können den eigenen Punktestand nie übersteigen; Höchstgebot gewinnt, Punkte werden automatisch abgezogen, Auktionen schließen von selbst

## 🛍️ Merch-Shop

- **Gilden-Merch und Leistungen gegen Punkte verkaufen**: Artikel mit Preis und Bestand
- **Käufe werden im Gildenchat angekündigt** — mit einem zufälligen Spaß-Spruch
- **Bestell-Verwaltung**: offene Käufe als Highlight am Shop-Button, mit Online-Status, Flüstern-Button und Übergabe-Bestätigung pro Bestellung

## ⚒️ Berufe-Verzeichnis

- **Vollautomatisch**: Deine Berufe (inkl. Kochkunst, Erste Hilfe, Angeln) werden beim Login aus den Skill-Zeilen erkannt und gesynct — niemand muss etwas pflegen
- **Durchsuchbar**: in Sekunden herausfinden, wer was craften kann („wer hat Verzauberkunst?"), mit Skill-Stand, Online-Status und Flüstern-Button
- **Sprachneutraler Sync**: gemischte DE/EN-Gilden sehen Berufsnamen jeweils in ihrer Sprache

## 📌 Schwarzes Brett

- **Eine Ankündigung der Gildenleitung** (bis 600 Zeichen) — ungelesene Ankündigungen erscheinen einmalig beim Login als Popup mit „Verstanden"-Button
- Schreibrecht hinter konfigurierbarem Rang; empfangsseitig gegen das Gilden-Roster geprüft

## ⚙️ Rechte-System

- **Elf einzeln konfigurierbare Rechte**: Posten, Löschen, Event erstellen/löschen, Teilnahme bestätigen, Gilden-Events, Auktionen, Punkte anpassen, Merch, Brett, Einstellungs-Zugriff
- **Standard: jeder darf alles** — der Gildenmeister schränkt bei Bedarf per Rang ein
- **Der Gildenmeister behält immer alle Rechte** und kann den Einstellungs-Zugriff delegieren
- **Abgesichert**: Rechte-relevante Nachrichten werden gegen das Gilden-Roster geprüft

## 🌍 Sonstiges

- **Minimap-Button**: Linksklick Marktplatz, Rechtsklick Kalender
- **Addon-Nutzer-Zähler** mit Presence-Handshake und persistenter Liste — `/gmarkt users` zeigt, wer das Addon hat und wann zuletzt gesehen
- **Lokalisierung**: Deutsch bei deutschem Client, sonst Englisch — Instanzen und Berufe werden sprachneutral übertragen

---

## Befehle

`/gmarkt` — Marktplatz öffnen/schließen · `/gmarkt users` — Addon-Nutzer auflisten

## Kompatibilität

| Client | Interface |
|---|---|
| TBC Classic Anniversary | 20506 |
| Classic Era | 11508 |

## Hinweise

- Nur Gildenmitglieder mit dem Addon können Einträge, Events, Punkte und Shop-Artikel empfangen
- Kein Server, kein Datenbankzugriff — 100% Addon-Kommunikation
- Beta: Feedback & Bug-Reports willkommen!

---

*by MichaModus*
