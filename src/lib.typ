// Tablet formats
#let dev-format = (
  // == Remarkable ==
  // Remarkable Paper Pro (2160 x 1620 at 229 PPI)
  rmpp: (width: 179.7mm, height: 239.6mm, bar: 13mm),
  // Remarkable Paper Pro Move (1696 x 954 at 264 PPI)
  rmpm: (width: 91.78mm, height: 163.17mm, bar: 13mm),
  // Remarkable 2 (1872 x 1404 at 226 PPI)
  rm2: (width: 157.79mm, height: 210.39mm, bar: 13mm),
  // == Apple iPad ==
  // Apple iPad 11 (2360 x 1640 at 264 PPI)
  apple_ipad_11: (width: 157.78mm, height: 227.06mm, bar: 0mm),
)

// Colors
#let voc-grey = rgb("efefef")
#let voc-white = rgb("ffffff")
#let voc-dark-grey = rgb("777777")
#let voc-blue = rgb("ddeeff")

// 2-column table with alternating row colors
// Table width is reduced
#let table-alternate(words) = {
  set table(
    fill: (_, y) => {
      if calc.even(y) { voc-grey } else { voc-white }
    },
    stroke: none,
  )

  block(inset: (x: 2em))[
    #table(
      columns: (1fr, 1fr),
      inset: 1em,
      align: horizon,
      ..words,
    )
  ]
  pagebreak()
}

#let words-masked(words, mask: none) = {
  words
    .map(((a, b)) => {
      if mask == "right" {
        (a, "")
      } else if mask == "left" {
        ("", b)
      } else {
        (a, b)
      }
    })
    .flatten()
}

// Create a page with a table and both columns filled
#let table-full(words) = {
  table-alternate(words-masked(words))
}

// Create a page with a table with only the left column
#let table-left(words) = {
  table-alternate(words-masked(words, mask: "right"))
}

// Create a page with a table with only the right column
#let table-right(words) = {
  table-alternate(words-masked(words, mask: "left"))
}

// Table for writing practice
// First row is highlighted and contains the word pair.
// Left word is shifted to the right.
// Variable number of writing lines with dotted underlines.
// The table is not allowed to break and span across pages.
#let writing-table(word-pair, num_lines: 4) = {
  set table(
    fill: (_, y) => {
      if y == 0 { voc-blue } else { white }
    },
    stroke: none,
  )

  let (word, translation) = word-pair
  let lines = ([#h(1em) #word], translation)

  for _ in range(num_lines) {
    lines.push(
      table.cell(colspan: 2, stroke: (
        bottom: (paint: voc-dark-grey, thickness: 0.1em, dash: "dotted"),
      ))[#box(height: 1em)],
    )
  }

  pad(bottom: 1em, block(breakable: false)[
    #table(
      columns: (1fr, 1fr),
      inset: 1em,
      align: horizon,
      ..lines,
    )
    // ]
  ])
}

// For each word pair, create a writing practice table
#let tables-writing(words, num_writing_lines) = {
  for word-pair in words {
    writing-table(word-pair, num_lines: num_writing_lines)
  }
}

#let shuffle-words(words, seed) = {
  let seed = decimal(seed)
  let shuffled = words
  for i in range(shuffled.len() - 1, 0, step: -1) {
    let j = calc.rem(calc.floor(seed / (i + 1)), i + 1)
    (shuffled.at(i), shuffled.at(j)) = (shuffled.at(j), shuffled.at(i))
  }
  shuffled
}
