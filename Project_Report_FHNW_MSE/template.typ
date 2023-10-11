#import "appendix.typ"

#let buildMainHeader(mainHeadingContent) = {
  [
    #align(center, smallcaps(mainHeadingContent)) 
    #line(length: 100%)
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent) = {
  [
    #smallcaps(mainHeadingContent)  #h(1fr)  #emph(secondaryHeadingContent) 
    #line(length: 100%)
  ]
}

// To know if the secondary heading appears after the main heading
#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader() = {
  locate(loc => {
    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(selector(heading).after(loc), loc).find(headIt => {
      headIt.location().page() == loc.page() and headIt.level == 1
    })
    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading.body)
    }
    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level == 1
    }).last()
    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level > 1
    })
    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {previousSecondaryHeadingArray.last()} else {none}
    // Find if the last secondary heading exists and if it's after the last main heading
    if (lastSecondaryHeading != none and isAfter(lastSecondaryHeading, lastMainHeading)) {
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body)
    }
    return buildMainHeader(lastMainHeading.body)
  })
}



// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(
  title: "",
  abstract: [],
  authors: (),
  date: none,
  body,
) = {
  
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  // set page(numbering: "I", number-align: center, margin: (x: 15%, y: 10%))
  set text(font: "STIX Two Text", lang: "en", size: 12pt)

  // Set paragraph spacing.
  show par: set block(above: 2em, below: 2em)

  set heading(numbering: "1.1")
  set par(leading: 0.75em)

  set align(center)
  image("figures/fhnwLogo.jpg", width: 80%)
  v(10%)

  // linebreak()

  // Title row.
  align(center)[
    #block(text(weight: 700, 3em, title))
    #v(10%, weak: true)
  ]
  

  // Author information.
  pad(
    top: 0.8em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center)[
        _*#author.role*_ \
        *#author.name* \
        #link("mailto:" + author.email) \        
      ]),
    ),
  )
  v(10%)
  align(center)[
    #block(text(weight: "semibold", 1.5em, "P8 Project"))
    #v(5%)
    #block(text(1.3em, "MSc in Engineering with Specialisation in Computer Science"))
    #v(10%)
    #block(text(1.3em, "Institute for Interactive Technologies"))
    #v(2.5%)
    #"Brugg-Windisch"\
    #date
    #v(2.5%)
    #image("figures/mse.svg", width: 60%)
  ]

 
  pagebreak()
  set page(numbering: "I", number-align: center, margin: (x: 15%, y: 10%))
  // Abstract.
  pad(
    x: 2em,
    top: 1em,
    bottom: 1.5em,
    align(left)[
      #heading(
        outlined: false,
        numbering: none,
        text(0.85em, smallcaps[Abstract]),
      )
      #abstract
      #v(5%)
      *Keywords*: #linebreak()
      Point Clouds • Data Selection • Exploratory Data Analysis • XR • Hand Tracking
    ],
  )

  pagebreak()



  let outline(title: "Contents", depth: none, indent: true) = {
    heading(title, numbering: none)
    locate(it => {
      // let elements = query(heading, after: it)
      let elements = query(selector(heading).after(it), it)

      for el in elements {
        if depth != none and el.level > depth { continue }
        if(el.outlined == false) { continue }
        let maybe_number = if el.numbering != none {
          numbering(el.numbering, ..counter(heading).at(el.location()))
          " "
        }
        let line = {
          if indent {
            h(1em * (el.level - 1 ))
          }

          if el.level == 1 {
            v(weak: true, 0.5em)
            set text(weight: "bold")
            maybe_number
            el.body
          } else {
            maybe_number
            el.body
          }

          // Filler dots
          box(width: 1fr, h(3pt) + box(width: 1fr, repeat[.]) + h(3pt))
          // Page number
          str(counter(page).at(el.location()).first())

          linebreak()
        }

        link(el.location(), line)
      }
    })
  }
  
  
  align(left)[
  #outline(indent: true, title: "Table of Contents")
  ]

  set page(numbering: "1", number-align: center, header: getHeader())
  // counter(page).update(1)
  // set par(first-line-indent: 20pt)

  // set page(header: getHeader())





  // Main body.
  set par(justify: true)
  align(left)[
    #body
    #bibliography("references.bib")
    #appendix 
    ////
    // SOA
    // #pagebreak()
    // #set heading(outlined: false, numbering: none)
    // = Statement of Authenticity
    // I confirm that this P8 project was written autonomously by me using only the sources, aids, and assistance stated in the report, and that any work adopted  from other sources, which was written as part of this thesis, is duly cited and referenced as such.

    // Brugg-Windisch, #date
    // #v(2em)
    // #image("figures/signature_cropped.jpeg", width: 30%)
    // Luca Fluri
    
  ]
  

}