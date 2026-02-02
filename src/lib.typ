#import "devices.typ": dev-format
#import "themes.typ": themes

// 2-column table with alternating row colors
// Table width is reduced
#let table-alternate(words, theme, links: true) = {
  set table(
    fill: (_, y) => {
      if calc.even(y) { theme.background-alt } else { theme.background }
    },
    stroke: none,
  )

  let cells = words
    .enumerate()
    .map(((i, (left, right))) => (
      table.cell(colspan: 2)[#if links {
        link(label("writing-" + str(i)), [#grid(
          columns: (1fr, 1fr),
          inset: 1em,
          align: horizon,
          left, right,
        )])
      } else {
        grid(
          columns: (1fr, 1fr),
          inset: 1em,
          align: horizon,
          left, right,
        )
      }]
    ))
    .flatten()

  block(inset: (x: 2em))[
    #table(
      columns: (1fr, 1fr),
      inset: 0pt,
      align: horizon,
      ..cells,
    )
  ]
}

#let words-masked(words, mask: none) = {
  words
    .enumerate()
    .map(((i, (a, b))) => {
      if mask == "right" {
        (a, "")
      } else if mask == "left" {
        ("", b)
      } else {
        (a, b)
      }
    })
}

// Create a page with a table and both columns filled
#let table-full(words, theme, links: true) = {
  table-alternate(words-masked(words), theme, links: links)
}

// Create a page with a table with only the left column
#let table-left(words, theme, links: true) = {
  table-alternate(words-masked(words, mask: "right"), theme, links: links)
}

// Create a page with a table with only the right column
#let table-right(words, theme, links: true) = {
  table-alternate(words-masked(words, mask: "left"), theme, links: links)
}

// Table for writing practice
// First row is highlighted and contains the word pair.
// Left word is shifted to the right.
// Variable number of writing lines with dotted underlines.
// The table is not allowed to break and span across pages.
#let writing-table(index, word-pair, num_lines: 4, theme, labels: true) = {
  set table(
    fill: (_, y) => {
      if y == 0 { theme.accent } else { theme.background }
    },
    stroke: none,
  )

  let (word, translation) = word-pair
  let lines = (
    [#h(1em) #word #if labels { label("writing-" + str(index)) }],
    translation,
  )

  for _ in range(num_lines) {
    lines.push(
      table.cell(colspan: 2, stroke: (
        bottom: (paint: theme.separator, thickness: 0.1em, dash: "dotted"),
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
  ])
}

// For each word pair, create a writing practice table
#let tables-writing(words, num-writing-lines, theme, labels: true) = {
  for (i, word-pair) in words.enumerate() {
    writing-table(
      i,
      word-pair,
      num_lines: num-writing-lines,
      theme,
      labels: labels,
    )
  }
}

#let shuffle-words(words, seed) = {
  let seed = datetime.today().day() * decimal(seed)
  let shuffled = words
  for i in range(shuffled.len() - 1, 0, step: -1) {
    let j = calc.rem(calc.floor(seed / (i + 1)), i + 1)
    (shuffled.at(i), shuffled.at(j)) = (shuffled.at(j), shuffled.at(i))
  }
  shuffled
}
