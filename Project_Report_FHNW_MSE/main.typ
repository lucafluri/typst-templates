#import "template.typ": *
#import "soa.typ"

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(    
  title: "Title",
  authors: (
    (name: "XXX", email: "xxx@fhnw.ch", affiliation: "MSE Student, FHNW", role: "Author"),
    (name: "YYY", email: "yyy@fhnw.ch", affiliation: "Advisor, FHNW", role: "Advisor"),
  ),
  abstract: "",
  // date: "August 2023",
  date: datetime.today().display("[month repr:long] [day], [year]"),
) 
 
//Footnotes 
#let footnote(n) = {
  let s = state("footnotes", ())
  s.update(arr => arr + (n,)) 
  locate(loc => super(str(s.at(loc).len())))
}

#let has_notes(loc) = {
  state("footnotes", ()).at(loc).len() > 0
}

#let print_footnotes(loc) = {
  let s = state("footnotes", ())
  enum(tight: true, ..s.at(loc).map(x => [#x]))
  s.update(())
}

#let getPageNumber() = {

}

#set page(footer: locate(loc => {
  if has_notes(loc) {
    let notes = stack(dir: ttb, line(length: 100%), v(0.5em), print_footnotes(loc), 
      )
    set text(size: 0.8em)
    style(s => {
      v(-measure(notes, s).height)
      notes
    })
  }
  // Show page number
  set align(center)
  set text(12pt)
  counter(page).display(
    "1",
    both: false,
  )
}))

// Enumerations
#set enum(indent: 1em)

// References
#set ref(supplement: none)


//Highlighted Text
#let highlight(text, color) = {
  box(rect(fill: color, radius: 0%, stroke: none, inset: 3pt, )[
    // #set align(center+horizon)
    #text
  ])
  // linebreak()
}

#let hl(text) = {
  highlight(text, rgb(255, 255, 0))
  linebreak()
}

#let todo(t) = {
  highlight(text(t, fill: white, weight: "bold"), rgb(255, 0, 0))
  linebreak()
}

#let textcolor(str, color) = {
  text(fill: color)[
    #str
  ]
}

// #let urlfootnote(url) = {
//   footnote[#link(url, url)]
// }

// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!

// = Tests
// #footnote[#link("https://www.google.com", "Google")]
// #urlfootnote("https://www.google.com")

// #hl[gugus]


#counter(page).update(1)

= Introduction <chapter_introduction>


= Related Work <chapter_related_work>


= Prototype <chapter_prototype>

= User Experiment <chapter_user_experiment>

== Experiment Design <section_user_experiment_design>

== Participants <chapter_user_experiment_participants>

= Results <chapter_results>


= Discussion <chapter_discussion>

= Conclusion <chapter_conclusion>

== Outlook and Future Work <chapter_conclusion_outlook>

#pagebreak()
#soa
 
// #pagebreak()
// #appendix


