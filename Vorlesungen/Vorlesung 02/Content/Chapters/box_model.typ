#import "../../Template/hszg.typ": *

= Box Model

== Aufbau

#slide(align: horizon)[
  #figure(
    image("../../Images/box_model.png", height: 70%)
  )

  - `padding`: Innenabstand
  - `margin`: Außenabstand
  - Farbige Darstellung in den DevTools
]

// == display

// #slide(align: horizon)[
//   #table(
//     columns: (1fr, 1fr, 1fr, 1fr),
//     table.header(
//       [Wert], [Verhalten], [Beispiele], [width/height?]
//     ),
//     [`block`], [volle Breite, neue Zeile], [`div`, `p`, `h1`], []
//   )
// ]
// 

== Flexbox

#slide(align: horizon)[
  - Lösen eines typischen Problems des Box-Modells: Elemente flexibel in Reihe oder Spalte anordnen, verteilen oder ausrichten
  - Zwei Rollen:
    - *Flex-Container*: Das Parentelement #raw("display: flex", lang: "css")
    - *Flex-Items*: Die Children, die automatisch zu Flex-Items werden, wenn der Parent ein Flex-Container ist
]

== Flexboxen Achsen

#slide(align: horizon)[
  - Es existieren Haut- und Querachse
  ```css
    .container { 
      display: flex;
      flex-direction: row; /* Hauptachse horizontal, Querachse ist vertikal */  
    }
  ```
  - `justify-content` betrifft immer die Hauptachse
  - `align-items` betrifft immer Querachse
]

== Flexboxen Beispiele

#slide(align: horizon)[
  === Ausrichtung entlang der Hauptachse

  ```css
    .container {
      display: flex;
      justify-content: flex-start; /* Standard, alles am Anfang */
      justify-content: center; /* mittig */
      justify-content: space-between; /* erstes/letztes Element am Rand, Rest gleichmäßig verteilt */
      justify-content: space-around; /* gleicher Abstand um jedes Element */
      justify-content: space-evenly; /* exakt gleicher Abstand überall, inkl. Rändern */
    }
  ```
]

#slide(align: horizon)[
  === Ausrichtung entlang der Querachse

  ```css
    .container {
      display: flex;
      align-items: stretch; /* Standard, Items füllen die Container-Höhe */
      align-items: center; /* vertikal zentriert bei row */
      align-items: flex-start; /* oben */
      align-items: flex-end; /* unten */
    }
  ```
]

#slide(align: horizon)[
  === Umbruchverhalten

  ```css
    .container {
      display: flex;
      flex-wrap: nowrap; /* Standard: alles in eine Reihe quetschen */
      flex-wrap: wrap; /* Umbruch in neue Zeile, wenn kein Platz mehr ist */
    }
  ```
]

#slide(align: horizon)[
  === Abstände zwischen Items
  ```css
    .container {
      display: flex;
      gap: 1rem;
    }
  ```
]

#slide(align: horizon)[
  === Verhalten einzelner Items
  ```css
    .item {
      flex-grow: 0;   /* Standard: wächst nicht, auch wenn Platz frei ist */
      flex-shrink: 1; /* Standard: darf schrumpfen, wenn zu wenig Platz ist */
      flex-basis: auto; /* Startgröße vor Verteilung des freien Platzes */
    }

    .item {
      flex: 1; /* entspricht flex-grow: 1; flex-shrink: 1; flex-basis: 0; */
    }
  ```
]

== Flexbox vs. Grid

#slide(align: horizon)[
  - *Flexbox* ist eindimensional
    - Eine Reihe oder eine Spalte
    - Umbruch ist Nebeneffekt
    - Kein echtes 2D-Raster
    - *Use Case*: Navbars, Button-Gruppen, Card-Reihen

  - *Grid* ist zweidimensional
    - Zeilen und Spalten werden gleichzeitig geplant
    - *Use Case*: Komplettes Seitenlayout
]
