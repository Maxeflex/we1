#import "../../Template/hszg.typ": *

= JavaScript

== Überblick

#slide(align: horizon)[
  - Implementierung des ECMAScript-Standards
  - JavaScript ist kein formal definierter Name
  - ECMAScript ist die eigentliche Spezifikation
  - Unterschiedliche Engines implementieren sie: V8, SpiderMonkey, JavaScriptCore
  - Seit 2015 jährlicher Releasezyklus mit neuen Features (z.B.: `let/const`, Arrow Functions, `async/await`)

  ```javascript
    let num;
    const cNum = 0;
    const func = async () => {

    }
    await func();
  ```
]

== Interpretiert oder kompiliert?

#slide(align: horizon)[
  - Häufige Vereinfachung _JavaScript ist interpretiert_ stimmt nur bedingt
  - Engines wie V8 nutzen JIT-Kompilierung (Just-In-Time)
    - Schnelle interpretation in Bytecode
    - Häufiger genutzter Code wird in Maschinencode übersetzt (durch optimierten Compiler wie TurboFan)
    - Typenannahmen werden spekulativ in den Maschinencode eingebaut
    - Bei Typenänderung wird deoptimiert
  
  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Kurz*: Es gibt keinen Kompilierschritt wie bei Java. Der Code wird direkt _ausgeführt_. _Ausgeführt_ heißt hier aber mehr als reines Zeile-für-Zeile interpretieren.
  ]
]

== Single-Threaded \& der Call-Stack

#slide(align: horizon)[
  - JavaScript hat genau einen Ausführungs-Thread
  - Es kann immer nur eine Zeile ausgelesen und ausgeführt werden
  - Modell dafür: der *Call Stack*
  - Jeder Funktionsaufruf legt neuen Frame auf den Stack
  - Bei `return` wird der Frame entfernt
  - Endlose Rekursion führt zu `Maximum call stack size exceeded`

  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Konsequenz*: Eine lang laufende, synchrone Operation blockiert die komplette Seite (keine Klicks, keine Animationen)
  ]
  
  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Folgefrage*: Wie schafft es JavaScript auf eine Netzwerk Request zu warten ohne die Seite einzufrieren?
  ]
]

== Event Loop, Task Queue und Browser-APIs

#slide(align: horizon)[
  *Wichtigster Punkt für JavaScript Verständnis*

  1. JavaScript kann weder Timer noch Netzwerk-Requests. Das übernehmen Browser-APIs (z.B.: bei Node.js ist es die C++-Runtime): `setTimeout`, `fetch`, DOM-Events
  2. Nach Beendigung der async Operation wird Callback nicht sofort ausgeführt. Sie wird in Task Queue gelegt
  3. Event Loop prüft durchgehend, ob Call-Stack leer ist. Falls ja wird die nächste Aufgabe aus der Queue auf den Stack geschoben

  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Merksatz*: JavaScript ist single-threaded, aber die Browser-Umgebung drumherum ist es nicht. JS delegiert Wartezeiten nach außen und bekommt nur das fertige Ergebnis zurückgemeldet, sobald Platz im Stack ist.
  ]
]

== Promises

#slide(align: horizon)[
  === Warum Promises?

  - Asynchrone Operationen (Timer, Netzwerk, Dateien) liefern Ergebnis später
  - Früher: Callbacks, bei Abhängigkeiten entsteht schnell "Callback Hell"
  - Fehlerbehandlung muss an jeder Stelle einzeln erfolgen

  ```javascript
    getUser(1, (err, user) => {
      if (err) return handleError(err);
      getOrders(user.id, (err, orders) => {
        if (err) return handleError(err);
        // ... bis show(content)
      });
    });
  ```

  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Idee*: Ein Promise ist ein Objekt, das für ein *zukünftiges* Ergebnis steht.
  ]
]

#slide(align: horizon)[
  === Promise-Zustände

  #table(
    columns: (auto, 1fr),
    table.header(
      [Zustand], [Bedeutung]
    ),
    [pending], [Operation läuft noch],
    [fulfilled], [Erfolgreich beendet, Ergebnis liegt vor],
    [rejected], [Fehlgeschlagen, Grund (meist ein `Error`) liegt vor]
  )

  - fulfilled und rejected zusammen heißen *settled*
  - Ein Promise wechselt genau einmal den Zustand und bleibt danach unverändert
  - Ergebnis wird über `.then()`, Fehler über `.catch()` abgeholt
]

#slide(align: horizon)[
  === Beispiel
  
  ```javascript
    const wait = (ms) => new Promise((resolve, reject) => {
      setTimeout(resolve, ms);
    });

    wait(1000).then(() => console.log("Eine Sekunde vorbei"));
  ```
]

#slide(align: horizon)[
  === Verkettung und Fehlerbehandlung

  - `.then()` gibt immer ein *neues* Promise zurück, dadurch lassen sich Schritte verketten
  - Rückgabewert eines `then`-Callbacks wird zum Ergebnis des nächsten Schritts
  - Ein Fehler (`throw` oder rejected Promise) springt direkt zum nächsten `.catch()`
  - `.finally()` läuft immer, z.B. zum Ausblenden eines Ladeindikators

  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Wictig*: `fetch` lehnt nur bei Netzwerkfehlern ab, nicht bei 404 oder 500. Deshalb wird mit `response.ok` geprüft.
  ]
]

#slide(align: horizon)[
  === Beispiel

  ```javascript
  fetch("/api/users/1")
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();          // wieder ein Promise
    })
    .then((user) => console.log(user.name))
    .catch((error) => console.error(error))
    .finally(() => hideSpinner());
  ```
]

== async/await

#slide(align: horizon)[
  - Syntaktischer Zucker über Promise, der asynchronen Code wie synchronen lesbar macht
  - `async function` gibt immer einen Promise zurück (ein `throw` darin wird zu rejected)
  - `await` wartet auf einen Promise und liefert dessen Ergebnis
  - Nur in `async`-Funktionen oder in ES-Modulen (Top-Level-Await) erlaubt
  - Fehlerbehandlung mit gewohntem `try/catch/finally`
]

#slide(align: horizon)[
  === Beispiel

  ```javascript
    async function loadUser(id) {
      try {
        const response = await fetch(`/api/users/${id}`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        return await response.json();     // await nötig, damit der catch hier greift
      } catch (error) {
        console.error(error);
      } finally {
        hideSpinner();
      }
    }
  ```
]

#slide(align: horizon)[
  - `await` blockiert *nicht* den Thread, sondern pausiert nur die Funktion
  - Der Rest der Funktion wird als *Microtask* fortgesetzt, sobald der Promise gesettelt ist
  - Die Funktion gibt dem Aufrufer bis dahin die Kontrolle zurück (Verbindung zum Event Loop)
]

#slide(align: horizon)[
  ```javascript
    async function f() {
      console.log("A");
      await null;
      console.log("B");
    }
    console.log("1");
    f();
    console.log("2");
  ```

  *Ausgabe*: 1, A, 2, B \
  *Erklärung*: `f()` läuft synchron bis zum ersten `await` (`A`), danach geht es mit `2` weiter. 
  `B` kommt erst als Microtask, wenn der Call Stack leer ist.
]

== Parallele Promises

#slide(align: horizon)[
  Aufeinanderfolgende `await`s laufen *sequentiell*, auch wenn die Aufgaben unabhängig voneinander sind.

  ```javascript
    // Langsam: zweite Anfrage startet erst nach der ersten
    const user = await fetchUser();
    const orders = await fetchOrders();

    // Schneller: beide laufen gleichzeitig
    const [user, orders] = await Promise.all([fetchUser(), fetchOrders()]);
  ```
]

#slide(align: horizon)[
  #table(
    columns: (auto, 1fr),
    table.header(
      [Methode], [Verhalten]
    ),
    [`Promise.all`], [Wartet auf alle, rejected sofort bei erstem Fehler],
    [`Promise.allSettled`], [Wartet auf alle, liefert pro Promise Status und Wert/Grund],
    [`Promise.race`], [Ergebnis des ersten settled Promise (egal of Erfolg oder Fehler)],
    [`Promise.any`], [Ergebnis des ersten erfolgreichen Promsise],
  )
]

== Typische Fehler

#slide(align: horizon)[
  - `await` vergessen: Man arbeitet mit einem Promise statt einem Ergebnis (`user.name` ist dann `undefined`)
  - `forEach` mit `async`: `forEach` wartet nicht auf Callbacks

  ```javascript
    ids.forEach(async (id) => { await save(id); }); // wartet nicht
    for (const id of ids) { await save(id); } // sequentiell
    await Promise.all(ids.map(save)); // parallel
  ```

  - Kein `catch`: Eine nicht behandelte Ablehnung löst im Browser das Event `unhandledrejection` aus, in Node.js beendet sie den Prozess
  - `await` in Schleifen ohne Not: unnötig langsam, wenn die Durchläufe unabhängig sind
]

== Microtasks vor Macrotasks

#slide(align: horizon)[
  - Promise-Callbacks (`.then`, `async/await`) werden immer vor `setTimeout`-Callbacks abgearbeitet

  *Beispiel*:

  ```javascript
    console.log("1");
    setTimeout(() => console.log("2"), 0);
    Promise.resolve().then(() => console.log("3"));
    console.log("4");
  ```

  *Ausgabe*: 1, 4, 3, 2
]

== Dynamische und schwache Typisierung

#slide(align: horizon)[
  *Dynamisch*: der Typ einer Variable wird zur Laufzeit bestimmt und kann sich ändern

  #pause

  ```javascript
    let x = 5; x = "fünf"; //gültig
  ```

  #pause
  
  *Schwach typisiert*: Operatoren erzwingen implizite Typumwandlung zwischen unterschiedlichen Typen
  
  #pause

  ```javascript
    "5" + 1 // "51"
    "5" - 1 // 4
  ```
]

#slide(align: horizon)[
  === #text()[`==` vs. `===`]
  `===` vergleicht Werte und Typ, ohne Umwandlung. Sind Typen verschieden, ist das Ergebnis sofort `false` \

  `==` wandelt zuerst implizit um (coercion) und vergleicht dann.

  ```javascript
    5 === "5" // false
    5 == "5" // true

    0 == false // true
    0 === false // false

    "" == 0 // true
  ```
]

#slide(align: horizon)[
  === #text()[Vereinfachte Regeln für `==`]

  1. Gleiche Typen: verhält sich wie `===`
  2. `null == undefined` ist `true`, aber `null`/`undefined` sind mit nichts anderem `==`-gleich
  3. Zahl und String: der String wird zur Zahl
  4. Boolean und anderer Typ: der Boolean wird zuerst zur Zahl (`true` $arrow$ 1, `false` $arrow$ 0)
  5. Objekt und Primitive: das Objekt wird zum Primitiv umgewandelt
]

#slide(align: horizon)[
  === Überraschende Fälle

  ```javascript
    "0" == false; //true
    [] == false; //true
    [] == ![]; // true
    "1" == [1]; // true
    null == 0; // false
    null >= 0; //true
  ```

  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Wichtig*: `==` ist nicht transitiv. `"0" == 0` und `0 == ""` sind beide `true`, aber `"0"==""` ist `false`.
  ]
]

#slide(align: horizon)[
  === Wichtige Sonderfälle bei `===`

  ```javascript
    {} === {}              // false (Objekte werden per Referenz verglichen)
    [1] === [1]            // false
    const a = {}; a === a  // true
    +0 === -0              // true
    Object.is(+0, -0)      // false
    Object.is(NaN, NaN)    // true
  ```
]

#slide(align: horizon)[
  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Merksatz*: `===` frag: "Ist das exakt dasselbe?" und `==` fragt: "Ist das nach etwas Umwandlung irgendwie gleich?" Die zweite Frage will man so gut wie nie stellen.
  ]

  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Grundsatz*: Standardmäßig immer `===` und `!==`.
  ]
]

== Prototypenbasierte Objektorientierung

#slide(align: horizon)[
  - Anders als Java nutzt JavaScript *Prototypen*
    - Jedes Objekt hat interne Verknüpfung zu einem anderen Objekt
    - Anderes Objekt vererbt Eigenschaften
    - `[[Prototype]]`, zugreifbar über `__proto__` (veraltet) oder `Object.getPrototypeOf()`
  - `class`-Syntax ist nur syntaktischer Zucker Prototypen
  - Vererbung in JS ist Objekt-zu-Objekt nicht Klasse-zu-Klasse
]

#slide(align: horizon)[
  === Beispiel

  ```javascript
    const animal = { eat() { return "eating"; } };
    const dog = Object.create(animal);
    dog.bark = () => "Wuff";
    dog.eat(); // Gefunden über Prototypenkette in `animal`
  ```
]

== Garbage Collection

#slide(align: horizon)[
  - JS verwaltet Speicher automatisch über einen Garbage Collector (meist Mark-and-Sweep-Verfahren)
  - Objekte, die von keiner erreichbaren Referenz mehr aus dem Programm aus erreichbar sind werden freigegeben
  - Kein manuelles `malloc`/`free` wie in C
  - Nicht erreichbare Closures, vergessene Event-Listener können trotzdem zu Memory Leaks führen
]

== Execution Context & Hoisting

#slide(align: horizon)[
  Vor Codeausführung: Engine erstellt für jede Funktion/jedes Skript einen Execution Context in zwei Phasen:

  #pause

  1. *Creation Phase*: Variablen- und Funktionsdeklarationen werden im Speicher registriert (Hoisting)
    - `var`-Variablen mit `undefined`
    - `function`-Deklarationen vollständig

  #pause

  2. *Execution Phase*: Code wird Zeile für Zeile tatsächlich ausgeführt

  #pause

  Deshalb kann eine Funktion vor ihrer Definition aufgerufen werden. 
  `const`/`let` Deklarationen würden `ReferenceError` werfen.
]

== Designprinzipien Zusammenfassung

#slide(align: horizon)[
  - *Funktionen sind First-Class Citizens*: Grundlage für Callbacks, Higher-Order-Funktionen, funktionale Patterns (`map`/`filter`/`reduce`)

  #pause
  
  - *Alles, was kein Primitive ist, ist ein Objekt*: Arrays, Funktionen, sogar `null` (historischer Bug bei `typeof null === "object"`)
  
  #pause
  
  - *Prototypenbasierte Vererbung statt Klassenhierarchie*: Sehr flexibel aber ungewohnt mit typischem OOP-Hintergrund
  
  #pause
  
  - *Single-Threaded mit kooperativem Event Loop*: Bewusster Design-Trade-off für Einfachheit im Browser (Vermeidung von Race-Conditions auf gemeinsamen Speicher)
]

= JavaScript Syntax

== Variablen & Deklaration

#slide(align: horizon)[
  - `let` - blockscoped, wiederbeschreibbar
  - `const` - blockscoped, nicht neu zuweisbar (Objekte/Arrays bleiben änderbar)
  - `var` - veraltet, functionscoped, Hoisting-Probleme, sollte vermieden werden
  - Deklaration ohne Zuweisung: `let x;` $arrow$ Wert: `undefined`
]

// == Datentypen

// #slide(align: horizon)[
//   - Primitive Typen: `string`, `number`, `boolean`, `null`, `undefined`, `bigint`, `symbol`
//   - Referenztyp: `object` (inkl. Arrays und Funktionen)
//   - JavaScript ist dynamisch typisiert: Typ wird zur Laufzeit bestimmt, kann sich ändern
//   - `typeof` zur Laufzeitprüfung des Tages
// ]
