#import "../../Template/hszg.typ": *

= HTML zu DOM

== Rückblick

#slide(align: horizon)[
  *Vorlesung 1:* URL $arrow$ DNS $arrow$ HTTP-Request $arrow$ *Response-Body ist da*  
  Der Server hat HTML geschickt. *Was macht der Browser daraus?*
]

== Parsing-Pipeline

#slide(align: horizon)[
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
    align: center + top,
    [
      *Bytes* \
      Welche Kodierung?
    ], [$arrow$], [
      *Zeichen* \
      Unicode / UTF-8  
    ], [$arrow$], [
      *Tokens* \
      Tags, Attribute, Text
    ], [$arrow$], [
      *DOM-Baum* \
      lebendes Objektmodell
    ]
  )

  Jede Stufe wird durch den WHATWG HTML §13.2 Standard algorithmisch definiert.
]

== Stufe 1: Bytes $arrow$ Zeichen

#slide(align: horizon)[
  Bytes werden anhand ihrer Kodierung zu Zeichen umgewandelt \

  Woher weiß der Browser, wie er Bytes dekodieren muss?
    - *BOM* (Byte Order Mark, erste 2-2 Bytes)
    - *Prescan* der ersten 1024 Bytes nach `<meta charset="...">`
    - *HTTP-Header* `Content-Type: text/html; charset=utf-8`
    - Alternativ: Heuristik (aber unzuverlässig!)
  
  #pause

  *Faustregel: immer UTF-8 deklarieren* \
  Der Standard verlangt es und 98,9% des Webs nutzen es

  #pause

  *Fehlende Charset-Angabe* \
  München wird zu MÃ¼nchen
]

== Stufe 2: Tokenisierung

#slide(align: horizon)[
  - Tokenizer ist eine Zustandsmaschine mit \~80 möglichen Zuständen
  - Token-Typen: `DOCTYPE`, Start-Tag, End-Tag, Attribute, Kommentar, Zeichen

  ```html
    <p class="intro">Hallo</p>
  ```

  ```
    Start-Tag "p" [class="intro"] → Zeichen "Hallo" → End-Tag "p"
  ```

  Tags sind Syntax, Tokens sind strukturierte Daten
]

== Stufe 3: Baumkonstrukion

#slide(align: horizon)[
  - *Insertion Modes*: in head, in body, in table ... + Stack offener Elemente besimmten, wo ein Token landet
  - Styntax ist dabei nebensächlich
  
  ```html
    <p>Ein Absatz
    <div>Ein Block
  ```

  - `div` in `p` ist nicht erlaubt $arrow$ Parser schließt `p` automatisch
  - *Ergebnis*: Zwei Geschwister entstehen, kein Fehler
]

== Fehlerbehandlung & DOCTYPE

#slide(align: horizon)[
  - Parse-Fehler sind nie fatal: Browser produziert immer einen DOM-Baum
  - Regeln für Wiederherstellung stehen im WHATWG Standard (ca. 90 Seiten)
  - Ergebis ist für jeden Browser gleich

  === DOCTYPE
  `<!DOCTYPE html>` wählt den Rendering-Modus: Standards vs. Quirks Mode
  - Quirks Mode: anderes CSS/Layout-Verhalten
  - Fehler werden in jedem Modus korrigiert
  - Bowser validiert nichts
]

== Streaming & Zusammenfassung
 
#slide(align: horizon)[
  === Streaming
  - Parsing beginnt mit den ersten Bytes
  - Browser wartet nicht auf das ganze Dokument

  === Zusammenfassung
  - DOM ist die lebende Wahrheit - der Quelltext ist nur ein Vorschlag
  - Zwei Rollen für den DOM
    - Eingabe für das Rendering
    - API für JavaScript
]

= Was ist der DOM?

== Was ist der DOM?

#slide(align: horizon)[
  - DOM $arrow$ #text(weight: "bold")[D]ocument #text(weight: "bold")[O]bject #text(weight: "bold")[M]odel
  - Zwei Aufgaben
    - *Rendering Input*: der DOM (+CSSOM) das Layout
    - *Programmierungs-API*: Interface, dass JavaScript nutzt um mit der Seite 
  - Ein Live Modell: Zeigt den aktuellen Status, nicht die Quelle
  - DOM $eq.not$ Markup
]

== Node Model

#slide(align: horizon)[
  - *Alles* ist eine Node
  - Haupttypen: `Document`, `DocumentType`, `Element`, `Text`, `Comment`, `DocumentFragment`
  - Elemente $eq.not$ Tags: 
    - Tag ist Syntax
    - Element ist ein Runtime Objekt mit:
      - Identität
      - Namespace
      - Attributen
      - Position im Baum
]

== API Familien

#slide(align: horizon)[
  - *Auswahl*: `document.getElementById`, `querySelector` / `querySelectorAll`
  - *Traversal*: `parentNode`, `children`, `firstElementChild`
  - *Mutation*: `createElement`, `append`, `remove`, `insertAdjacentHTML`
  - *Properties vs. Attribute*: 
    - `href` (Property)
    - `getAttribute("href")` (Attribute)
  - *Content Zugriff*:
    - `textContent`
    - `innerHTML`
]

== Events (Vorschau) & Performance

#slide(align: horizon)[
  === Events
  - DOM ist auch ein Eventsystem
  - `addEventListener`
  - bubbling/capturing: Events wandern durch den Baum
  - `event.target`: wo passiert es
  - `event.currentTarget`: wer hört zu

  === Performance
  - DOM ist teuer: viele Nodes und tiefe Bäume verlangsamen Parsing
  - Scripting des DOMs führt zu Renderarbeit
  - Frameworks existieren, um direkte DOM Manipulation zu vermeiden
]

== Beispiel

#slide(align: horizon)[
  ```html
    <!DOCTYPE html>
    <html>
      <head>
        <title>Testseite</title>
      </head>
      <body>
        <h1>DOM Test</h1>
        <p>Ein <strong>wichtiger</strong> Satz.</p>
      </body>
    </html>
  ```
]

#slide(align: horizon)[

  #let rootColor = rgb("#9e00c5")
  #let elementColor = rgb("#008cff")
  #let documentTypeColor = rgb("#999999")
  #let textNodes = gray

  #figure(
    fletcher.diagram(
      node-stroke: documentTypeColor,
      node-inset: 10pt,
      node-corner-radius: 5pt,
      edge-stroke: documentTypeColor + 2pt,
      spacing: (10pt, 20pt),
      node((1.5,0), text(fill: rootColor)[\#document], stroke: rootColor, fill: rootColor.lighten(90%), name: <document>),
      node((0, 0.5), text(fill: documentTypeColor)[DOCTYPE: html], stroke: (paint: documentTypeColor, dash: "dashed"), name: <doctype>),
      node((1.5, 1), text(fill: elementColor)[`<html>`], stroke: elementColor, fill: elementColor.lighten(90%), name: <html>),
      node((0.25, 2), text(fill: elementColor)[`<head>`], stroke: elementColor, fill: elementColor.lighten(90%), name: <head>),
      node((2.25, 2), text(fill: elementColor)[`<body>`], stroke: elementColor, fill: elementColor.lighten(90%), name: <body>),
      node((0, 3), text(fill: elementColor)[`<title>`], stroke: elementColor, fill: elementColor.lighten(90%), name: <title>),
      node((1, 3), text(fill: elementColor)[`<h1>`], stroke: elementColor, fill: elementColor.lighten(90%), name: <h1>),
      node((2.75, 3), text(fill: elementColor)[`<p>`], stroke: elementColor, fill: elementColor.lighten(90%), name: <p>),
      node((2.25, 5), text(fill: elementColor)[`<strong>`], stroke: elementColor, fill: elementColor.lighten(90%), name: <strong>),

      node((0, 4), text(fill: textNodes)[`#text "Testseite"`], stroke: textNodes, fill: textNodes.lighten(90%), name: <text_title>),
      node((1, 4), text(fill: textNodes)[`#text "DOM Test"`], stroke: textNodes, fill: textNodes.lighten(90%), name: <text_dom>),
      node((0.5, 7), text(fill: textNodes)[`#text "Ein "`], stroke: textNodes, fill: textNodes.lighten(90%), name: <text_ein>),
      node((1.75, 7), text(fill: textNodes)[`#text "wichtiger"`], stroke: textNodes, fill: textNodes.lighten(90%), name: <text_wich>),
      node((3.5, 7), text(fill: textNodes)[`#text " Satz"`], stroke: textNodes, fill: textNodes.lighten(90%), name: <text_satz>),

      edge(<document>, <doctype>),
      edge(<document>, <html>),
      edge(<html>, <head>),
      edge(<html>, <body>),
      edge(<head>, <title>),
      edge(<title>, <text_title>),
      edge(<body>, <h1>),
      edge(<body>, <p>),
      edge(<h1>, <text_dom>),
      edge(<p>, <strong>),
      edge(<p>, <text_ein>),
      edge(<p>, <text_satz>),
      edge(<strong>, <text_wich>),
    )
  )
]
