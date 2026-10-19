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
    const func = asnyc () => {

    }
    await func();
  ```
]

== Interpretiert oder kompiliert?

#slide(align: horizon)[
  - Häufige Vereinfachung _JavaScript ist interpretiert_ stimmt nur bedingt
  - Engines wie V8 nutzen JIT-Kompilierung (Just-In-Time)
    - Schnelle interpretation in Bytecode
    - Häufiger genutzter Code wird in Maschinencode übersetzt
  
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

== Microtasks vor Macrotasks

#slide(align: horizon)[
  - Promise-Callbacks (`.then`, `async/await`) werden immer vor `setTimeout`-Callbacks abgearbeitet
]

== Dynamische und schwache Typisierung

#slide(align: horizon)[
  *Dynamisch*: der Typ einer Variable wird zur Laufzeit bestimmt und kann sich ändern

  #pause

  ```javascript
    let x = 5; x = "fünf"; //gültig
  ```

  #pause
  
  *Schwach typisiert*: Operatoren erwingen implizite Typumwandlung zwischen unterschiedlichen Typen
  
  #pause

  ```javascript
    "5" + 1 // "51"
    "5" - 1 // 4
  ```
]

== Prototypenbasierte Objektorientierung

#slide(align: horizon)[
  - Anders als Java nutzt JavaScript *Prototypen*
    - Jedes Objekt hat interne Verknüpfung zu einem anderen Objekt
    - Anderes Objekt vererbt Eigenschaften
    - `[[Prototype]]`, zugreifbar über `__proto__` oder `Object.getPrototypeOf()`
  - `class`-Syntax ist nur syntaktischer Zucker Prototypen
  - Vererbung in JS ist Objekt-zu-Objekt nicht Klasse-zu-Klasse
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
  
  - *Alles, was kein Primitive ist, ist ein Objekt*: Arrays, Funktionen, sogar `null` (historisch fälschlich als "object" typisiert)
  
  #pause
  
  - *Prototypenbasierte Vererbung statt Klassenhierarchie*: Sehr flexibel aber ungewohnt mit typischem OOP-Hintergrund
  
  #pause
  
  - *Single-Threaded mit kooperativem Event Loop*: Bewusster Design-Trade-off für Einfachheit im Browser (Vermeidung von Race-Conditions)
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
