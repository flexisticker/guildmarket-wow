# GuildMarket — Gildeninterner Marktplatz

**GuildMarket** verwandelt deine Gilde in einen eigenen Kleinanzeigen-Marktplatz — ganz ohne externen Server. Mitglieder können Items anbieten, Items suchen, Berufsleistungen inserieren und sogar Dungeon-Carries einstellen. Alles läuft peer-to-peer über den WoW-eigenen Guild-Kanal.

---

## Features

### Marktplatz-Liste
- **Drei Eintragtypen:** BIETE (grün) · SUCHE (gelb) · DIENST (lila)
- Item-Icons direkt in der Liste via `GetItemInfo`
- Beruf-Icons für Dienstleistungs-Einträge
- Preisanzeige in **Gold / Silber / Kupfer** mit Münzfarben (Festpreis oder VHB)
- **Online-Status** pro Eintrag — grüner Punkt = gerade online, Klick öffnet direkt den Flüster-Chat
- Online-Einträge stehen automatisch oben
- Hover-Tooltip: vollständiger Item-Tooltip + Beruf + benötigte Mats + Preis + Notiz + Kontakt + Restlaufzeit
- **Echtzeit-Suchleiste** filtert nach Item-Name, Beruf, Kontakt und Materialien
- Filter-Tabs: Alle · Suche · Biete · Dienst
- **Addon-Nutzer-Zähler** — siehst live wie viele Gildenmitglieder GuildMarket bereits nutzen
- Einträge laufen automatisch nach **7 Tagen** ab

### Eintrag erstellen
- **BIETE / SUCHE:** Item per Drag & Drop aus dem Rucksack oder Shift+Klick einfügen, Mengenangabe
- **DIENST:** Beruf-Dropdown (Alchemie, Verzauberkunst, Schmiedekunst u.v.m.) + Leistungsfeld + kommagetrennte Mats-Liste
- **Ziehdienst:** Spezieller Dienst-Typ mit eigenem Dungeon-Dropdown (35 Dungeons, Classic + TBC) — nur Dungeons die deinem Char-Level entsprechen werden angezeigt, plus „Wunsch-Dungeon" für individuelle Absprachen
- Preis-Felder: **Gold / Silber / Kupfer** separat, **Free-Toggle** (kostenlos), **Festpreis oder VHB**
- Optionales Notiz-Feld

### Marktplatz-Regeln & Kontakt (`?`-Button)
- Übersichtliche Regelseite: faire Preise, **Gildenrabatt** (günstiger als extern), **Gilde geht vor** (Mitglieder haben Vorrang), Ehrlichkeit, Meldepflicht
- **Live-Kontaktliste** der Gildenleitung: Gildenmeister und Offiziere werden direkt aus dem Gilden-Roster geladen — kein Hardcode, funktioniert mit jeder Gilde
- Online-Mitglieder stehen oben, Offline-Mitglieder sind ausgegraut
- **Flüstern-Button** direkt neben jedem Namen

### Berechtigungen
- Konfigurierbarer **Mindest-Rang zum Posten** (Standard: alle Mitglieder)
- Konfigurierbarer **Rang zum Löschen fremder Einträge** (Standard: GM + Offiziere)
- Nur der Gildenmeister kann Einstellungen ändern
- Einstellungen werden automatisch per Sync an alle Online-Mitglieder verteilt

### Technisch
- **Peer-to-Peer:** kein Server, kein Backend — Sync läuft über `SendAddonMessage("GUILDMKT", ..., "GUILD")`
- Automatischer Broadcast eigener Einträge beim Login (nach 6 Sekunden)
- Manueller Sync-Button für verpasste Einträge
- Dynamisch anpassbares Fenster (Mindestgröße 680×680px, Resize-Griff)
- Dynamische Spaltenbreiten beim Resize
- Unterstützt **TBC Classic Anniversary** (Interface 20505) und **Classic Era** (Interface 11508)

---

## Slash Commands

| Befehl | Funktion |
|---|---|
| `/gmarkt` | Marktplatz öffnen/schließen |
| `/gildenmarkt` | Alias |
| `/gmarkt sync` | Sync anfordern |
| `/gmarkt config` | Konfig-Panel öffnen |

---

## Für welche Gilden?

GuildMarket funktioniert mit **jeder Gilde** — kein Hardcode, keine manuelle Konfiguration nötig. Gildename und Kontaktpersonen werden automatisch aus dem Roster gelesen.

---

## Status

**Beta** — Alle Kernfunktionen sind stabil. Feedback und Bug-Reports willkommen!

**GitHub:** https://github.com/flexisticker/guildmarket-wow
