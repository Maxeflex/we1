#import "../../Template/hszg.typ": *

= HTML

== Semantisches HTML

#slide(align: horizon)[
  - HTML beschreibt Bedeutung, nicht das Aussehen \
  - Browser, Screenreader, Suchmaschinen lesen Bedeutung, nicht Optik

  #textbox()[
    HTML sagt, was etwas ist und CSS sagt später, wie es aussieht
  ]

  ```html
  <!-- bedeutungslos -->
  <div class="header-top">...</div>

  <!-- bedeutungsvoll -->
  <header>...</header>
  ```
]

== Strukturelemente

#slide(align: horizon)[
  #raw(read("../../Code/structure.html"), lang: "html", block: true)

  - *Landmarks* für Screenreader-Navigation & Suchmaschinen
  - `main` nur einmal pro Seite
  - `article` als in sich geschlossener Inhalt
]

== Text

#slide(align: horizon)[
  === Überschriften-Hierarchie
  - `h1`-`h6` bilden die *Gliederung* des Dokuments
  - Große Sprünge zwischen Kategorien sollten vermieden werden
  - Überschriften nicht nach Schriftgröße wählen
  - Optik kann mit CSS geregelt werden

  === Textsemantik
  - `p`, `ul`/`ol`/`li` für Absätze und Listen
  - `strong`/`em` für Text mit Bedeutung wichtig oder betont
  - `b`/`i` nur für Darstellung
  - `img` mit `alt`-Text
  - `a` mit Linktext
]

== Barrierefreiheit

#slide(align: horizon)[
  - Screenreader navigieren über Landmarks & Überschriften
  - Gute Semantik ermöglicht Zugänglichkeit
  - `alt`-Texte beschreiben Bildinhalte
  - Bedienbarkeit über Tastatur ermöglichen
    - Markieren des fokussierten Elements über Outline
    - Springen zur nächsten Textbox/Element mit Tab
]
