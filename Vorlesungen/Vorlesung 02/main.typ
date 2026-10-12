#import "Template/template.typ": *
#import "Template/hszg.typ": *

#show: hszg-theme.with(
  config-info(
    title: [Rendern einer Website],
    subsubtitle: [Vorlesung 02],
    course: [Web Engineering 1],
    coursenumber: [319300],
    author: [M.Sc. Christopher-Manuel Hilgner],
    date: datetime(day: 13, month: 10, year: 2026),
    institution: [Hochschule Zittau/Görlitz],
    contact: [christopher.hilgner\@stud.hszg.de]
  )
)

#show: frame-style(styles.boxy)

#set text(lang: "de")

#title-slide()
#include "Content/content.typ"
