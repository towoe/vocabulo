#import "devices.typ": dev-format
#import "themes.typ": themes

// 2-column table with alternating row colors
// Table width is reduced
#let table-alternate(words, theme, links: true, set-label: none) = {
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
    )#if not set-label == none { label(set-label) }
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
#let table-full(words, theme, links-to-writing: true, set-label: false) = {
  let set-label = if set-label { "full" } else { none }
  table-alternate(
    words-masked(words),
    theme,
    links: links-to-writing,
    set-label: set-label,
  )
}

// Create a page with a table with only the left column
#let table-left(words, theme, links-to-writing: true, set-label: false) = {
  let set-label = if set-label { "left" } else { none }
  table-alternate(
    words-masked(words, mask: "right"),
    theme,
    links: links-to-writing,
    set-label: set-label,
  )
}

// Create a page with a table with only the right column
#let table-right(words, theme, links-to-writing: true, set-label: false) = {
  let set-label = if set-label { "right" } else { none }
  table-alternate(
    words-masked(words, mask: "left"),
    theme,
    links: links-to-writing,
    set-label: set-label,
  )
}

// Table for writing practice
// First row is highlighted and contains the word pair.
// Left word is shifted to the right.
// Variable number of writing lines with dotted underlines.
// The table is not allowed to break and span across pages.
#let writing-table(
  index,
  word-pair,
  num_lines: 4,
  theme,
  labels: true,
  backlinks: false,
  backlink-target: "full",
) = {
  set table(
    fill: (_, y) => {
      if y == 0 { theme.accent } else { theme.background }
    },
    stroke: none,
  )

  let (word, translation) = word-pair

  let www = if (backlinks == false) { [#translation] } else {
    [#translation #h(1fr) #link(label(backlink-target), [#sym.arrow.r.turn]) #h(
        2em,
      ) ]
  }
  let lines = (
    [#h(1em) #word #if labels { label("writing-" + str(index)) }],
    www,
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
#let tables-writing(
  words,
  num-writing-lines,
  theme,
  labels: true,
  backlinks: false,
  backlink-target: "full",
) = {
  for (i, word-pair) in words.enumerate() {
    writing-table(
      i,
      word-pair,
      num_lines: num-writing-lines,
      theme,
      labels: labels,
      backlinks: backlinks,
      backlink-target: backlink-target,
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
