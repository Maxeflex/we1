#import "Template/hszg.typ": *

#show: hszg-theme.with(
  course: "Web Engineering 1",
  course-number: "319300",
  lecturer: "M.Sc. Christopher-Manuel Hilgner",
  title: "Seminar 02",
  date: datetime(year: 2026, month: 10, day: 16),
  summary: [
    HTML, CSS und JavaScript Grundlagen.
  ]
)

#task(name: "HTML")[
  1. Erstelle eine Seminarseite mit:
    - Einer Überschrift
    - Einem Absatz 
    - Ein Bild
  2. Baue ein Kontaktformular mit Feldern für Name, E-Mail und Nachricht (achte auf korrekte `label`-Verwendung)
  3. Erstelle eine Tabelle mit dem Seminarplan (Zeit, Thema, Raum) mit `thead`, `tbody`
  4. Strukturiere eine Seite nur mit semantischen Elementen (`nav`, `article`, `section`, `aside`, `figure`)
]

#task(name: "CSS")[
  1. Style die Seminarseite: Schiftart, Textfarbe, Hintergrund und ein zentriertes Layout mit `max-width`
  2. Gib allen Überschriften im `main`-Bereich eine blaue Farbe, ohne Klassen zu verwenden
  3. Baue eine Karten-Reihe (drei nebeneinanderliegende Boxen) mit Flexbox, die auf Mobilgeräten untereinander stapelt (`@media`)
  4. Erstelle ein 2-Spalten-Layout (Sidebar + Inhalt) mit CSS Grid: `grid-template-area`, mit responsivem Umbruch auf eine Spalte
]

#task(name: "JavaScript")[
  1. Schreibe eine Funktion `greeting(name)`, die `"Hello, [name]!"` zurückgibt und das Ergebnis per `console.log` ausgibt.
  2. Ein Button soll bei jedem Klick einen Zähler um 1 erhöhen und die aktuelle Zahl auf der Seite anzeigen (DOM-Manipulation)
  3. Validiere das Kontaktformular aus Aufgabe 1.2 per JavaScript: Name und E-Mail dürfen nicht leer sein, die Email muss ein `@` enthalten. Zeige Fehlermeldungen unter den Feldern
  4. Schreibe eine Funktion `average(number)`, die den Mittelwert eines Arrays berechnet und auf 2 Nachkommastellen rundet.
  5. Erstelle eine Todo-Liste
    - Einträge hinzufügen
    - Abhaken von Einträgen
    - Löschen
    - Liste soll bei Reload mit `localStorage` erhalten bleiben
]
