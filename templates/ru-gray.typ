#let word_list = sys.inputs.at("word-list", default: "words.csv")
#let words = csv(word_list)


#let writing_lines = 4

#set page(margin: (x: 0.4cm, y: 0.5cm))

#show table.cell.where(x: 0): set text(font: "Bad Script", size: 12pt)

#set table(
  fill: (x, y) => {
    if y == 0 { rgb("efefef") } else { white }
  },
  stroke: none,
)

#set table.hline(stroke: (
  paint: rgb("777777"),
  thickness: 0.6pt,
  dash: "dashed",
))

#for (ru, de) in words {
  // Create a table for each entry in word list
  // The words
  let rows = (
    ru,
    de,
  )
  // Empty lines with a line for practice writing
  for _ in range(writing_lines) {
    rows.push([#box(height: 1em)])
    rows.push([])
    rows.push(table.hline())
  }
  // Table with added space at the bottom
  pad(bottom: 20pt, block(breakable: false)[
    #table(
      columns: (1fr, 2fr),
      inset: 10pt,
      align: horizon,
      ..rows
    )
  ])
}
