// Guide
// ===========

// Single line comment

/*
multiline comment
*/

/*
Highlight:
#hl("text")

OR for a block:
#hl()[
  BLOCK OF TEXT or LIST or whatever
]

TODO
#todo("TODO_text")

*/


// Imports
#import "template.typ": *

// Definitions
#let hl(text) = {
  highlight(text, fill: rgb(255, 255, 0))
}

#let todo(t) = {
  highlight(text(fill: white, weight: "bold", t), fill: rgb(255, 0, 0))
}





// Call modified IEEE template
#show: ieee.with(
  title: "Title",
  abstract: [
    Blablabla

    //Linebreak needed for template
    #linebreak()
  ],
  //Non-Anonymized Author Info
  authors: ( 
    ( 
      name: "Author 1",
      department: [Institute for Interactive Technologies],
      organization: [University of Applied Sciences and Arts Northwestern Switzerland],
      location: [Windisch, Switzerland],
      email: "xx@fhnw.ch"
    ),
    (
      name: "Author 2",
      department: [Institute for Interactive Technologies],
      organization: [University of Applied Sciences and Arts Northwestern Switzerland],
      location: [Windisch, Switzerland],
      email: "yy@fhnw.ch"
    ),
  ),
  index-terms: ("Point Clouds", "Data Selection", "Exploratory Data Analysis", "XR", "Hand-tracking"),
  bibliography-file: "refs.bib",
  //Optional header image
  /*header-image: figure(
    image("figures/header_image.png", width: 60%),
    caption: "A box shaped selection volume being placed inside a point cloud. Points inside the selection volume are highlighted in real-time."
  )
  */
)



= Introduction <chapter_intro>


= Related Work <chapter_related_work>


= Our Prototype


= User Experiment


= Results <chapter_results>


= Discussion


= Conclusion and outlook
