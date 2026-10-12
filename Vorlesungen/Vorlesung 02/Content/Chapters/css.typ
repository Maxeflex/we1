#import "../../Template/hszg.typ": *

= CSS

== CSS einbinden

#slide(align: horizon)[
  ```html
    <!-- 1. Inline: Antipattern -->
    <p style="color: red">...</p>

    <!-- 2. <style> im head: ok für kleine Seiten -->
    <style> p { color: red; } </style>

    <!-- 3. Extern: der empfohlene Standardweg -->
    <link rel="stylesheet" href="style.css">
  ```

  - *Inline* bekämpft die Kaskade & wiederholt sich auf jeder Seite
  - *Extern*: eine Datei kann auf vielen Seiten genutzt werden und Caching
  - `<link>` früh im `<head>` platzieren
  - CSS blockiert Rendering, nicht parsing

]

== Selektoren

#slide(align: horizon)[
  ```css
    Selektor { Eingenschaft: Wert; }
  ```

  ```css
    p { color: #333; } /* Element */
    .card { padding: 1rem; } /* Klasse */
    #navigation { top: 0; } /* ID */
  ```

  - Klassen sind der Normalfall
  - IDs sind oft zu spezifisch

  ```css
    nav a { ... } /* Nachfahre: Alle Links in nav */
    ul > li { ... } /* direktes Kind */
  ```

  - Pseudoklassen für Zustand: `:hover`, `:focus`, `:nth-child()`
  - Pseudoelemente als Teil des Inhalts: `::before`, `::after`
]

== Vererbung

#slide(align: horizon)[
  - Vererben von: `color`, `font-family`, `font-size`, `line-height`
  - Keine Vererbung von: Box- & Layout-Eigenschaften (`width`, `padding`, ...)

  ```css
    body {
      font-family: "Inter", sans-serif; /* erbt an alles */
      color: #222;
    }

    .card {
      padding: 1rem; /* wird nicht vererbt */
    }
  ```

  - Steuerung: `inherit` (erzwingen), `initial` (originaler Wert), `unset`
  - Praxistipp: Styling, dass alle Elemente nutzen werden einmal für `body` definieren
]
