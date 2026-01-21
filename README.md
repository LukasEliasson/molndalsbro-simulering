# Simulering av personflöde på Mölndals bro

Detta projekt är en digital simulering i spelmotorn Godot av knutpunkten **Mölndals resecentrum**, med fokus på personflöden och trängsel på Mölndals bro. Syftet är att visualisera hur människor rör sig genom stationen vid olika belastningar samt identifiera potentiella flaskhalsar.

Simuleringen är utvecklad som en del av ett gymnasiearbete och är tänkt som ett verktyg för att på ett överskådligt sätt studera flöden i kollektivtrafikens knutpunkter.

---

## 🎯 Syfte

- Undersöka hur personflöden uppstår och utvecklas i en knutpunkt i kollektivtrafiken  
- Identifiera områden med hög belastning och trängsel
- Visualisera hur förändringar i belastning påverkar stationens funktion

---

## 🧠 Metod

Projektet bygger på **agentbaserad modellering**, där varje person i simuleringen representeras av en självständig agent. Agenterna rör sig genom stationsmiljön med hjälp av pathfinding och reagerar på hinder, andra agenter samt begränsade resurser såsom trappor.

Köteori används som teoretisk grund för att förstå hur köer och flaskhalsar uppstår i systemet.

Områdets modellering har gjorts med hjälp av ritningar och skisser försedda av Mölndals stad.

---

## 🛠 Mjukvara

- **Godot Engine** – Spelmotor för simulering och visualisering  
- **GDScript** – Skriptspråk för agentbeteende och logik  

---

## 📊 Funktioner

- Simulering av personflöden i stationsmiljön  
- Justerbara belastningsnivåer vid olika delar av stationen (inte tillgängligt än, planerat)  
- Enkel statistik, såsom:
  - Genomsnittligt personflöde  
  - Max antal personer på en specifik plats  
- Visuell representation av trängsel och rörelsemönster  

---

## ⚠ Avgränsningar

- Fordonstrafik (bussar och tåg) simuleras inte i detalj  
- Rörelsemönster och beteenden är förenklade och baseras delvis på antaganden  
- Fokus ligger på översiktlig analys snarare än detaljerad optimering  

---

## 📌 Status

Projektet är färdigutvecklat inom ramen för gymnasiearbetet men kan vidareutvecklas med:
- Mer avancerad statistik
- Förbättrad pathfinding
- Stöd för fler stationsmiljöer

---

## 📄 Licens

Detta projekt är skapat i utbildningssyfte.
