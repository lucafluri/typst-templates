// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let ieee(
  // The paper's title.
  title: "Paper Title",

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),

  header-image: none,

  // The paper's abstract. Can be omitted if you don't have one.
  abstract: none,

  // A list of index terms to display after the abstract.
  index-terms: (),

  // The article's paper size. Also affects the margins.
  paper-size: "a4",

  // The path to a bibliography file if you want to cite some external
  // works.
  bibliography-file: none,

  // The paper's content.
  body
) = {
  // Set document metdata.
  set document(title: title, author: authors.map(author => author.name))

  // Set the body font.
  //set text(font: "STIX Two Text", size: 9pt)
  set text(font: "TeX Gyre Heros", size: 9pt)

  // Configure the page.
  set page(
    paper: paper-size,
    // The margins depend on the paper size.
    margin: if paper-size == "a4" {
      (x: 41.5pt, top: 80.51pt, bottom: 89.51pt)
    } else {
      (
        x: (50pt / 216mm) * 100%,
        top: (55pt / 279mm) * 100%,
        bottom: (64pt / 279mm) * 100%,
      )
    }
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "1.1.1")

    
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    
    set par(justify: true, first-line-indent: 0em)
    set text(9pt, weight: "bold", font: "TeX Gyre Heros")
    v(15pt, weak: true)
    if it.level == 1 [
      // First-level headings are centered smallcaps.
      // We don't want to number of the acknowledgment section.
      #set align(left)
      #show: smallcaps
      /*
      #if it.numbering != none{
        numbering("1.1.1", ..levels)
        h(7pt, weak: true)
      }
      */
      #block[#it]
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      /*
      #if it.numbering != none {
        numbering("1.1.1", ..levels)
      }
      */
      #block[#it]
    ] else [
      // Third level headings are run-ins too, but different.
      #set text(weight: "regular")
      /*
      #if it.level == 3 {
        numbering("1.1.1", ..levels)
      }
      */
      #block[#it]
    ]
    
    v(10pt, weak: true)
  })


 show figure: it => block(width: 100%)[#align(center)[
     #it.body
     #set text(font: "TeX Gyre Heros", size: 8pt)
     //#it.supplement // original
     //#getSupplement(it) // replacing function
     //#it.counter.display(it.numbering):
     #it.caption
 ]]



  // Display the paper's title.
  v(3pt, weak: true)
  align(center, text(14.5pt, title, font: "TeX Gyre Heros", weight: "bold"))
  v(8.35mm, weak: true)

  // Display the authors list.
  for i in range(calc.ceil(authors.len() / 3)) {
    let end = calc.min((i + 1) * 3, authors.len())
    let is-last = authors.len() == end
    let slice = authors.slice(i * 3, end)
    grid(
      columns: slice.len() * (1fr,),
      gutter: 12pt,
      ..slice.map(author => align(center, {
        text(10pt, author.name)
        footnote(numbering: "*", author.email)
        if "department" in author [
          \ #text(size: 8pt, author.department)
        ]
        if "organization" in author [
          \ #text(size: 8pt, author.organization)
        ]
        //if "location" in author [
        //  \ #author.location
        //]
        //if "email" in author [
        //  \ #link("mailto:" + author.email)
        //]
      }))
    )

    if not is-last {
      v(16pt, weak: true)
    }
  }
  v(40pt, weak: true)

  header-image

  // Start two column mode and configure paragraph properties.
  show: columns.with(2, gutter: 12pt)
  set par(justify: true, first-line-indent: 0em)
  show par: set block(spacing: 0.65em) 
  set text(font: "STIX Two Text", size: 9pt)

  // Display abstract and index terms.
  if abstract != none [
    #set text(weight: 700)
   
    #heading(level: 1, numbering: none)[
      Abstract
    ]
    //#h(1em) _Abstract_:
    #set text(weight: "regular")
    #abstract


    #set text(weight: 700)
    #if index-terms != () [
      
    #text(font: "STIX Two Text", "Index Terms"):
      #set text(weight: "regular", font: "STIX Two Text")
      #index-terms.join(" • ")
    ]
    #v(2pt)
  ]

  set par(justify: true, first-line-indent: 1em)
  // Display the paper's contents.
  body

  // Display bibliography.
  if bibliography-file != none {
    show bibliography: set text(8pt)
    bibliography(bibliography-file, title: text(10pt)[References], style: "ieee")
  }
}
