#import "../../Template/hszg.typ": *

= JSON

== JSON

#slide(align: horizon)[
  *JSON (JavaScript Object Notation)*
  - Textbasiertes, sprachunabhängiges Datenformat zum Austausch strukturierter Daten
  - Trotz des Namens heute unabhängig von JavaScript
  - Nutzbar in jeder Programmiersprache

  ```json
    {
      "name": "Alex",
      "age": 25,
      "hobbies": ["Lesen", "Programmieren"],
      "address": {
        "city": "Görlitz"
      }
    }
  ```
]

#slide(align: horizon)[
  === Erlaubte Datentypen

  #table(
    columns: (auto, 1fr),
    table.header(
      [Typ], [Beschreibung]
    ),
    [String], [immer in doppelten Anführungszeichen, einfache Anführungszeichen sind ungültig],
    [Number], [kein Unterschied zwischen Integer und Float],
    [Boolean], [`true`/`false`],
    [null], [],
    [Object], [`{ }`, Key immer als String],
    [Array], [`[ ]`]
  )
]

#slide(align: horizon)[
  === Feste Regeln
  - Keys müssen in doppelten Anführungszeichen stehen 
  - `{name: "x"}` ist #text(fill: red, weight: "bold")[ungültig]
  - `{"name": "x"}` ist *gültig*
  - Kein Trailing Komma nach dem letzten Eintrag `[1, 2, 3,]` ist ungültig
  - Keine Kommentare erlaubt, anders als JavaScript-Objektliterale
  - Kein `undefined`, kein `Date`-Typ, keine Funktionen, nur die sechs vorherigen Typen
]

== JSON vs. JavaScript-Objekte

#slide(align: horizon)[

  - JavaScript-Objektliteral (`{ name: "Alex" }`) ist Code, keine Daten 
  - JSON ist immer ein String der geparst wird
  - Zwei Methoden in JavaScript

  ```javascript
    const obj = { name: "Alex", age: 25 };
    const jsonString = JSON.stringify(obj);
    // '{"name":"Alex","age":25}'
    const parsedObj = JSON.parse(jsonString);
    // {name: "Alex", age: 25}
  ```

  - `JSON.stringify()`: JavaScript-Wert $arrow$ JSON-String (nötig, um Daten z.B. per `fetch` zu versenden)
  - `JSON.parse()`: JSON-String $arrow$ JavaScript-Wert (nötig, um eine empfangene API-Antwort zu nutzen)
]

== JSON und `fetch` zusammen

#slide(align: horizon)[
  ```javascript
    // Senden
    fetch("/api/users", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: "Alex", age: 25 }),
    });

    // Empfangen
    const response = await fetch("/api/users/1");
    const data = await response.json(); // parst die Response automatisch
  ```
]
