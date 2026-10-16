#import "Template/hszg.typ": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

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
  // 4. Strukturiere eine Seite nur mit semantischen Elementen (`nav`, `article`, `section`, `aside`, `figure`)
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

#pagebreak()

#task(name: "JavaScript Cheatsheet", breakable: true)[

  == Variables and Types
  ```javascript
  const x = 1;          // block-scoped, no reassignment
  let y = 2;            // block-scoped, reassignable
  // avoid var (function-scoped, hoisted)

  typeof 42             // "number"
  typeof "hi"           // "string"
  typeof null           // "object" (historic quirk)
  Array.isArray([])     // true
  ```

  == Equality and Truthiness
  ```javascript
  1 === 1      // strict, use this by default
  1 == "1"     // loose, coerces types

  // Falsy: false, 0, -0, 0n, "", null, undefined, NaN
  // Everything else is truthy (including [], {}, "0")

  a ?? b       // b only if a is null/undefined
  a || b       // b if a is falsy
  a?.b?.[0]    // optional chaining
  a ??= 5      // assign if null/undefined
  ```

  == Strings

```javascript
const s = `Hello ${name}`;       // template literal
s.length; s.at(-1);
s.includes("a"); s.startsWith("H"); s.endsWith("o");
s.slice(1, 3); s.split(","); s.trim();
s.replace("a", "b"); s.replaceAll("a", "b");
s.padStart(5, "0"); s.toUpperCase();
```

== Arrays

```javascript
const a = [1, 2, 3];
a.push(4); a.pop(); a.unshift(0); a.shift();

a.map(n => n * 2);
a.filter(n => n > 1);
a.reduce((sum, n) => sum + n, 0);
a.find(n => n > 1);        a.findIndex(n => n > 1);
a.some(n => n > 2);        a.every(n => n > 0);
a.includes(2);             a.indexOf(2);
a.flat();                  a.flatMap(n => [n, n]);
a.slice(1, 3);             // non-mutating
a.splice(1, 1);            // mutating
[...a].sort((x, y) => x - y);   // copy then sort
a.toSorted(); a.toReversed();   // non-mutating (ES2023)
a.at(-1);
Array.from({ length: 3 }, (_, i) => i);   // [0, 1, 2]
```

== Objects

```javascript
const o = { a: 1, b: 2 };
o.a; o["b"];
const { a, b: renamed = 0, ...rest } = o;   // destructuring
const copy = { ...o, c: 3 };                // spread

Object.keys(o); Object.values(o); Object.entries(o);
Object.fromEntries([["a", 1]]);
Object.assign({}, o);
structuredClone(o);          // deep copy
"a" in o; delete o.a;
```

== Functions

```javascript
function add(a, b = 0) { return a + b; }
const add2 = (a, b) => a + b;
const sum = (...nums) => nums.reduce((s, n) => s + n, 0);
add(...[1, 2]);

// Closures
const counter = () => { let c = 0; return () => ++c; };
```

Arrow functions have no own `this`, `arguments`, or `new`.

== Control flow

```javascript
if (x) {} else if (y) {} else {}
cond ? a : b;
switch (v) { case 1: break; default: }

for (let i = 0; i < n; i++) {}
for (const item of iterable) {}   // values
for (const key in obj) {}         // keys (avoid on arrays)
while (cond) {}
```

== Classes

```javascript
class Animal {
  #secret = 1;                    // private field
  static count = 0;
  constructor(name) { this.name = name; }
  speak() { return `${this.name} makes a sound`; }
  get upper() { return this.name.toUpperCase(); }
}
class Dog extends Animal {
  speak() { return super.speak() + " (woof)"; }
}
```

== Modules

```javascript
export const x = 1;
export default function main() {}
import main, { x } from "./file.js";
import * as utils from "./utils.js";
const mod = await import("./lazy.js");   // dynamic
```

== Async

```javascript
const wait = ms => new Promise(r => setTimeout(r, ms));

async function load() {
  try {
    const res = await fetch("/api");
    if (!res.ok) throw new Error(res.status);
    return await res.json();
  } catch (e) {
    console.error(e);
  } finally {
    // cleanup
  }
}

await Promise.all([p1, p2]);        // fails fast
await Promise.allSettled([p1, p2]); // never rejects
await Promise.race([p1, p2]);
await Promise.any([p1, p2]);        // first success
```

Event loop order: sync code, then microtasks (promises), then macrotasks (`setTimeout`).

== Map, Set, and friends

```javascript
const m = new Map([["k", 1]]);
m.set("k2", 2); m.get("k"); m.has("k"); m.delete("k"); m.size;
const s = new Set([1, 1, 2]);   // unique values
[...new Set(arr)];              // dedupe
new WeakMap(); new WeakSet();
```

== DOM basics

```javascript
const el = document.querySelector(".cls");
document.querySelectorAll("li");
el.textContent = "hi";
el.classList.add("on"); el.classList.toggle("on");
el.setAttribute("data-x", "1"); el.dataset.x;
el.addEventListener("click", e => { e.preventDefault(); });
parent.append(child); el.remove();
```

== Useful built-ins

```javascript
JSON.stringify(obj, null, 2); JSON.parse(str);
Math.max(...a); Math.round(x); Math.floor(x); Math.random();
Number("42"); parseInt("42", 10); parseFloat("1.5");
(0.1 + 0.2).toFixed(2);
new Date().toISOString();
setTimeout(fn, 100); setInterval(fn, 100);
new URL("https://a.com?q=1").searchParams.get("q");
```
]
