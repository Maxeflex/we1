#import "../../Template/hszg.typ": *

= Zusammenfassung

== Schichtmodell

#slide(align: horizon)[
  #table(
    columns: (1fr, 1fr, 1fr),
    table.header(
      [Schicht], [Technologie], [Verantwortung]
    ),
    [*Inhalt*], [HTML], [was etwas ist],
    [*Darstellung*], [CSS], [wie es aussieht],
    [*Verhalten*], [JavaScript], [was es tut]
  )

  *Warum Schichten trennen?*
  - Wartbarkeit
  - Caching
  - Einfachere Teamarbeit
]
