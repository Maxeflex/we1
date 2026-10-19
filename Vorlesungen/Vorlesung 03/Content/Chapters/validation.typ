#import "../../Template/hszg.typ": *

= Validation

== Überblick

#slide(align: horizon)[
  *Warum validieren?*
  - Mehr UX als wirkliche Sicherheit
  - *Nutzerfreundlichkeit*: Sofortiges Feedback, bevor eine Anfrage überhaupt den Server erreicht, spart Wartezeit und Frustration
  - *Datenqualität am Frontend*: Offensichtliche Fehler (leeres Pflichtfeld, falsches E-Mail-Format) frühzeitig abfangen

  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Warum keine Sicherheitsvorkehrung?*

    #pause

    Jede Client-seitige Prüfung lässt sich mit DevTools, deaktiviertem JavaScript, direkten Requests mit `curl`/Postman usw. umgangen werden. 
    Verbindliche Validierung muss immer zusätzlich Server-side geschehen.
  ]
]

#slide(align: horizon)[
  #rect(stroke: hszg-green + 2pt, width: 100%, inset: 15pt, fill: hszg-green.lighten(90%))[
    *Merksatz*: Client-Validierung ist ein Komfort-Layer, Server-Validierung ist die Wahrheit.
  ]
]

== HTML-Validierung

#slide(align: horizon)[
  Einfachster Ansatz: Validierung über HTML-Attribute ohne JavaScript

  ```html
    <form>
      <input type="email" required>
      <input type="number" min="1" max="100">
      <input type="text" pattern="[A-Za-z]{3,}" minlength="3" maxlength="20">
      <input type="url">
      <input type="tel" pattern="[0-9]{10,15}">
      <button type="submit">Absenden</button>
    </form>
  ```
]

#slide(align: horizon)[
  ```html
    <input type="email" required>
  ```
  - `required`: Feld darf nicht leer sein
  ```html
    <input type="number" min="1" max="100">
  ```
  - `type="number"`: Eingebaute Formatprüfung je nach Typ
  - `min`/`max`: Wertebereich bei Zahlen/Datum
  ```html
    <input type="text" pattern="[A-Za-z]{3,}" minlength="3" maxlength="20">
  ```
  - `minlength`/`maxlength`: Textlänge
  ```html
      <input type="tel" pattern="[0-9]{10,15}">
  ```
  - `pattern`: Regex für individuelle Formate
]

#slide(align: horizon)[
  *Vorteil*:
  - Browser übernimmt UI (rote Umrandung, Tooltip-Fehlermeldung) und Logik
  *Nachteil*:
  - Standard-Fehlermeldung sind nicht anpassbar
  - Oft inkonsistent mit dem restlichen Design
  - Reicht bei großen Projekten selten aus
]

== Constraint Validation API

#slide(align: horizon)[
  Brücke zwischen HTML-Validierung und eigenem JavaScript (selten genutzt aber nützlich)

  ```javascript
    const input = document.querySelector("input[type=email]");

    input.checkValidity();
    input.validity.valueMissing;
    input.validity.typeMismatch;
    input.setCustomValidity("Enter a valid email address");
  ``` 

  - `setCustomValidity` erlaubt eigene Fehlertexte
  - Native Browser-UI bleibt erhalten
]

== Eigene JavaScript-Validierung

#slide(align: horizon)[
  - Nutzung sobald Regeln hinzukommen, die HTML nicht mehr verarbeiten kann
  - Beispiel: Passwort und Passwort-Wiederholung müssen übereinstimmen

  ```javascript
    form.addEventListener("submit", (event) => {
      const password = form.password.value;
      const confirm = form.passwordConfirm.value;

      if (password != confirm) {
        event.preventDefault(); // verhindert Absenden
        showError("Passwörter stimmen nicht überein");
      }
    })
  ```
]

== Zeitpunkt der Validierung

#slide(align: horizon)[
  Häufige Validierungszeitpunkte:
  - *Bei jedem Tastendruck*: sofortiges Feedback, aber nervig bei z.B.: E-Mail Feldern, die erst nach vollständiger Eingabe gültig sind
  - *Beim Verlassen des Feldes*: guter Kompromiss, Standard-Empfehlung für die meisten Formulare
  - *Erst beim Absenden*: am wenisten störend, aber Nutzer merken Fehler erst spät

  *Gängiges Best-Practice-Pattern*: Erstvalidierung beim `submit`, danach (sobald ein Fehler sichtbar war) live bei jedem `input`, damit der Nutzer sofort sieht, wann der Fehler behoben ist.
]

== Barrierefreiheit bei Validierungsfehlern

#slide(align: horizon)[
  - Fehlermeldungen mit `aria-invalid="true"` am betroffenen Feld markieren
  - Fehlertext über `aria-describedBy` mit dem Input verknüpfen, damit Screenreader ihn vorlesen
  - Fehler nicht nur über Farbe kommunizieren, sondern auch über Text/Icon

  ```html
    <input 
      type="email" 
      aria-invalid="true" 
      aria-describedby="email-error"
    >
    <span id="email-error">
      Bitte eine gültige E-Mail-Adresse eingeben
    </span>
  ```
]

== Visuelles Feedback mit CSS

#slide(align: horizon)[
  ```css
    input:invalid {
      border-color: red;
    }
    input:valid {
      border-color: green;
    }
    input:focus:invalid {
      outline-color: orange;
    }
  ```

  - `:invalid`/`:valid` reagieren automatisch auf die nativen HTML-Validierung
  - `:invalid` greift bereits bei leeren `required`-Feldern vor der ersten Interaktion
  - Kann über `:placeholder-shown` umgangen werden oder JS
]

== Zusammenfassung

#slide(align: horizon)[
  - Native HTML-Attribute zuerst nutzen
  - Ist kostenlos und barrierefrei vorbereitet
  - Constraint-Validation API für eigene Fehlertexte, bevor man komplett bei null anfängt
  - Eigene JavaScript Logik nur für komplexere Regeln
  - *Server-seitige Validierung niemals optional*
]
