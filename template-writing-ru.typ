#let word_list = sys.inputs.at("word-list", default: "words.csv")
#let words = csv(word_list)


#let writing_lines = 4

#set page(height: 239.6mm, width: 179.7mm, margin: (x: 0cm, y: 1cm))

#show table.cell.where(x: 0): set text(font: "Bad Script", size: 12pt)

#set table(
  fill: (x, y) => {
    if y == 0 { rgb("efefef") } else { white }
  },
  stroke: none,
)

#for (ru, de) in words {
  // Create a table for each entry in word list
  // The words
  let rows = (
    [],
    ru,
    de,
    [],
  )
  // A dotted line in the two middle columns for writing
  for _ in range(writing_lines) {
    rows.push([])
    rows.push(table.cell(colspan: 2, stroke: (
      bottom: (paint: rgb("777777"), thickness: 1pt, dash: "dotted"),
    ))[#box(height: 1em)])
    rows.push([])
  }
  // Table with added space at the bottom
  pad(bottom: 20pt, block(breakable: false)[
    #table(
      columns: (0.1fr, 1fr, 1fr, 0.1fr),
      inset: 10pt,
      align: horizon,
      ..rows
    )
  ])
}
