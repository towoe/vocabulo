#let vocabulo(
  words,
  lang_learning,
  lang_base,
  format: "rmpp",
  flipped: false,
  num_writing_lines: 4,
  bar_position: "top",
) = {
  import "src/lib.typ": (
    dev-format, table-full, table-left, table-right, tables-writing,
  )

  // Create a page matching the device size
  let specs = dev-format.at(format)
  let (width, height) = (specs.width, specs.height)

  // No margin by default, add extra space for an optional bar
  let margin = (top: 0pt, bottom: 0pt, left: 0pt, right: 0pt)
  if bar_position != none {
    margin.insert(bar_position, specs.bar)
  }
  set page(
    width: width,
    height: height,
    margin: margin,
    flipped: flipped,
  )

  // Do not show the header, use it only for the outline
  show heading.where(level: 2): set text(size: 0pt)

  // Outline with a wider height to make following the link easier
  show outline: set text(size: 1.5em)
  show outline.entry.where(level: 2): set block(inset: 1em)
  set outline.entry(fill: none)

  // ========================
  // Outline in the center of the page
  align(horizon)[
    #outline(
      title: "",
      target: heading.where(level: 2),
    )
  ]
  pagebreak()

  // ========================
  // Start of content pages
  heading(level: 2, lang_learning)
  table-left(words)

  heading(level: 2, [#lang_learning - #lang_base])
  table-full(words)

  heading(level: 2, lang_base)
  table-right(words)

  heading(level: 2, [Writing practice])
  tables-writing(words, num_writing_lines)
}
