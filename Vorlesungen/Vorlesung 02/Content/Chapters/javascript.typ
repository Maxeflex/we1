#import "../../Template/hszg.typ": *

= JavaScript

== JavaScript & DOM

#slide(align: horizon)[
  ```html
    <script src="app.js" defer></script>
  ```

  - Callback zum Parsing: klassisches `<script>`-Tag blockiert den Parser
  - `defer` wird nach dem Parser ausgeführt (Reihenfolge wie im Dokument geschrieben)
  - `async` wird parallel geladen und ausgeführt sobald es fertig ist

  *Faustregel*: `defer` im `<head>`, wenn Reihenfolge wichtig ist
]

#slide(align: horizon)[
  ```js
    // Auswahl durch CSS-Selektoren
    const card = document.querySelector(".card");
    const allElements = document.querySelectorAll("nav a");

    // Erstellen und hinzufügen von neuen Elementen
    const newElement = document.createElement("p");
    newElement.textContent = "New JavaScript element";
    document.body.append(newElement);

    // Verändern und Entfernen von Elementen
    card.classList.add("highlight");
    card.remove();
  ```
]

#slide(align: horizon)[
  ```html
    <a id="link" href="https://hszg.de">HSZG</a>
  ```

  ```js
    link.getAttribute("href"); // Quelltext String
    link.href; // Property
    link.href = "https://...";
  ```

  - Attribute: Zustand im Quelltext
  - Properties: der lebende Zustand des Objekts

  Deshalb: `input.value` Property ändert sich beim tippen. `value` Attribut bleibt dem Quelltext treu
]

#slide(align: horizon)[
  ```js
    const button = document.querySelector("button");

    button.addEventListener("click", (event) => {
      console.log(event.target); // wo es passiert ist
      console.log(event.currentTarget); // wer zuhört
    });
  ```

  - *Capturing*: Event wandert nach unten $arrow$ Target $arrow$ Bubbling: nach *oben*
  - *Event-Delegation*: Ein Listener am Elternteil verwaltet viele Kinder

  ```js
    document.querySelector("ul").addEventListener("click", (e) => {
      if (e.target.matches("li")) e.target.classList
    })
  ```
]
