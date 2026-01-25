#let word_list = sys.inputs.at("word-list", default: "words.csv")
#let words = csv(word_list)


#set page(height: 239.6mm, width: 179.7mm, margin: (x: 1cm, y: 1cm))

#show table.cell.where(x: 0): set text(font: "Bad Script", size: 12pt)

#set table(
  fill: (x, y) => {
    if calc.even(y) { rgb("efefef") } else { white }
  },
  stroke: none,
)

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  ..words.flatten()
)
