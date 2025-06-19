#import table: cell
#import "@preview/cram-snap:0.2.2": cram-snap, theader
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *
#import "@preview/keyle:0.2.0"
#import "@preview/ccicons:1.0.1": *

#let kbd = keyle.config(theme: keyle.themes.biolinum, delim: keyle.biolinum-key.delim_plus)

// // https://www.radix-ui.com/themes/playground#kbd
// #let radix_kdb(content) = box(
//   rect(
//     inset: (x: 0.5em),
//     outset: (y:0.05em),
//     stroke: rgb("#1c2024") + 0.3pt,
//     radius: 0.35em,
//     fill: rgb("#fcfcfd"),
//     text(fill: black, font: (
//       "Roboto",
//       "Helvetica Neue",
//     ), content),
//   ),
//   inset: 0.1em
// )
// #let kbd = keyle.config(theme: radix_kdb)

#set page(
  paper: "a2",
  flipped: true,
  margin: 0.5cm,
)

#set text(font: "Fira Sans", size: 11pt)
#show math.equation: set text(font: "Fira Math")
#show raw: set text(font: "Fira Code", size: 10pt)

#show link: it => {
  set text(blue)
  it
}

#show: cram-snap.with(
  title: [*Helix Cheat Sheet*],
  subtitle: [mini v0.1], // A Post-Modern Text Editor
  icon: image("helix-logo.svg"),
  column-number: 4,
  // fill-color: rgb("#947cc3").lighten(85%)  // helix brand color: blue 99dbe8 purple 947cc3
)

#set table(columns: (1fr, 3fr, 1fr, 3fr))

#let strong(content)=(
  text(weight: "bold", content)
)

#let vitalkey(key) = (
  return text(size: 1.5em, kbd(strong(key)))
)

#let herorow(content)=(
  cell(colspan: 4, align: center, inset: 10pt, content)
)

#let shortdef = (1, 1)
#let longdef = (1, 3)
#let evendef = (2, 2)

#let keyrow(key, def, colspans: shortdef, align: (left, left))=(
  return (
    cell(colspan: colspans.first(), align: align.first(), strong(key)),
    cell(colspan: colspans.last(), align: align.last(), def),
  )
)

#let keydef(key, def, dir: ltr)=(
  return stack(dir: dir, spacing: 1%,
    box(align(center + horizon, text(size: 2em, weight: "bold", key)), inset: 2%),
    box(height: 3em, width: 3.5em, align(center + horizon, text(size: 0.7em, def)), inset: 1%),
  )
)

#let arrow(pos, dir, ..keydefs, fill: rgb("947cc3").lighten(80%))=(
  node(pos, stack(dir: dir, spacing: 1%, ..(
    keydefs.pos().map(kd => { keydef(kd.first(), kd.last(), dir: dir)})
  )), fill: fill, extrude: (0.7em,0.7em), shape: fletcher.shapes.chevron.with(dir: dir.end()))
)

#let hint(content) = text(content, fill: gray.darken(35%)) //, style: "italic"
#let arg(argname) = hint[<#argname>]
#let mode(it) = strong(text(it, fill: green.darken(50%)))
#let cnt(it) = strong(text(it, fill: red))
#let mov(it) = strong(text(it, fill: black.lighten(40%)))
#let sel(it) = strong(text(it, fill: purple))
#let op(it) = strong(text(it, fill: blue))
#let sem(it) = strong(text(it, fill: orange))
#let pair(it) = strong(text(it, fill: yellow.darken(40%)))
#let cmd(content)=[#mode[:]#content]
#let needlsp=text(fill: green)[●]
#let needtree=text(fill: maroon)[●]

#layout(size => [
  #set align(center)
  #block(width: 90% * size.width)[

  #table(
    theader[Basic],
    ..keyrow([Install], [ #link("https://docs.helix-editor.com/package-managers.html")[with package managers] or #link("https://docs.helix-editor.com/building-from-source.html")[from source]], colspans: (1, 3)),
    ..keyrow([#hint("$") *hx*], [open current directory in Helix], colspans: evendef),
    ..keyrow([#hint("$") *hx* #arg[file]], [open #arg[file] in Helix], colspans: evendef),
    herorow[#hint[buffer = opened file, shown as *tabs*]],
    ..keyrow(cmd[n#hint("ew")], [create a #strong[n]ew buffer]),
    ..keyrow(cmd[w#hint("rite")], [#strong[w]rite/save buffer\ to disk]),
    ..keyrow(cmd[bc#hint("lose")], [#strong[c]lose current buffer]),
    ..keyrow(cmd[bc!], [force #strong[c]lose\ #hint[(no save)]]),
    ..keyrow(cmd[q#hint("uit")], [#strong[q]uit current widow]),
    ..keyrow(cmd[q!], [force-#strong[q]uit\ #hint[(no save)]]),
    ..keyrow(cmd[tutor], [open #strong[tutor]ial]),
  )
  
  #table(
    theader[Motion],
    herorow[
  unlike Vim (#op[operate] on #sel[selection] e.g. #op[d]#sel[w]) \
  #text(size: 1.5em, weight: "bold")[In Helix: #sel[select] first, then #op[operate]]
  ],
    herorow[#text(size: 1.8em)[
        #hint[$underbrace(
          #mode[[mode]]
          #cnt[[count]]
        , #[optional])$]
        #sel[[select]]
        #op[[operate]]
      ]
  
      e.g. #strong[#mode[v]#cnt[3]#sel[w]#op[d]] will make #cnt[3] #sel[#strong[w]ords] #op[#strong[d]eleted]\
      No more #op[dd], #op[yy], see their counterparts#footnote[TODO] in Helix
    ]
  )
  
  #table(
    theader[#mode[Mode]],
    ..keyrow(
      [#mode[⎋]],
      [*normal* mode]
    ),
    ..keyrow(
      [#mode[i]],
      [*#mode[i]nsert* mode]
    ),
    ..keyrow(
      [#mode[g]],
      [*#mode[g]oto* mode]
    ),
    ..keyrow(
      [#mode[m]],
      [*#mode[m]atch* mode]
    ),
    ..keyrow(
      [#mode[v]],
      [
        *select (extend)* mode - like Vim's #mode[*v*]isual mode\ see also in #link(<v-mode>)[#mov[Move]/#sel[Select]]
      ],
      colspans: longdef
    ),
    ..keyrow(
      [#mode[:]],
      [*command* mode]
    ),
    ..keyrow(
      [#mode[␣]],
      [*space* mode]
    ),
    ..keyrow(
      [#mode[z]],
      [*view* mode]
    ),
    // ..keyrow(
    //   [#mode[Z]],
    //   [*sticky view* mode]
    // ),
    ..keyrow(
      [#mode[⌃w]],
      [*window* mode ( #mode[␣w] works too )]
    ),
  )


  #table(
    theader[Pickers],
    ..keyrow([#mode[␣]f\ #hint[␣F]], [open *file* picker (in workspace)\ #hint[open *file* picker (in current working directory)]], colspans: longdef),
    ..keyrow([#mode[␣]/], [open full-text *search* picker (in workspace)], colspans: longdef),
    ..keyrow([#mode[␣]b], [open *buﬀer* #hint[(tab)] picker], colspans: longdef),
    ..keyrow([#mode[␣]j], [open *jump* picker], colspans: longdef),
    ..keyrow([#mode[␣]s], [open *symbol* picker #needlsp], colspans: longdef),
    ..keyrow([#mode[␣]?], [open *command* palette], colspans: longdef),
  )

  #needlsp requires an active language server for the file

  #table(
    theader[Look around],
    ..keyrow([#mode[g]p], [#mode[g]oto #strong[p]rev buffer #hint[(tab)]]),
    ..keyrow([#mode[g]n], [#mode[g]oto #strong[n]ext buffer #hint[(tab)]]),
    ..keyrow([#mode[g]f], [#mode[g]oto #strong[f]ile under cursor]),
    ..keyrow([#mode[g]d], [#mode[g]oto #strong[d]efinition #needlsp]),
    ..keyrow([^o], [zoom #strong[o]ut\ #hint[(jump backward)]]),
    ..keyrow([^i], [zoom #strong[i]n\ #hint[(jump forward)]]),
  )

  #table(
    theader[Mess around],
    ..keyrow([u], [#strong[u]ndo]),
    ..keyrow([U], [redo]),
    ..keyrow([<], [unindent]),
    ..keyrow([>], [indent]),
    ..keyrow([^c], [toggle *comment*]),
  )

  #table(
    theader[Special key],
    ..keyrow([⎋], [escape]),
    ..keyrow([⌥], [option #hint[or] Alt]),
    ..keyrow([^], [control]),
    ..keyrow([⌘], [command]),
    ..keyrow([␣], [space]),
    ..keyrow([⇧], [shift#footnote[We don't use shift but its result, e.g. `⇧w` becomes `W`, `⇧/` becomes `?`]])
  )
  
]
])

#colbreak()

#table(
  theader[#mov[Move]/#sel[Select]],
  herorow[
      #text(size: 1.5em, weight: "bold")[
        In Helix, many #mov[move]ments will #sel[select]\ 
      ]
      from *current cursor* to *destination*\
      (_replacing_ current selection)\
      e.g. "lo#pin("cursor-begin")o#pin("cursor-end")ooog words" becomes "lo#pin("select-begin")oooog #pin("select-end")words" by #sel[w]\
      it becomes "looooog #pin("reselect-begin")words#pin("reselect-end")" by #sel[w] again
    ],
  ..keyrow(
    mode[v],
    [*extend* current selection to next movement, rather than _replacing_ it<v-mode>],
    colspans: longdef,
    align: (center, left)
  ), 
  ..keyrow(
    sel[,],
    [escape from *#link(<multicursor>)[multi cursor] #sel[selection]*\ (i.e. keep only primary selection)],
    colspans: longdef,
    align: (center, left)
  ),
  ..keyrow(
    sel[;],
    [escape from *#sel[selection]* (i.e. collapse selection to single cursor)],
    colspans: longdef,
    align: (center, left)
  ),
  ..keyrow(
    sel[x],
    [select *current line* (repeatable)],
    align: (center, left)
  ),
  ..keyrow(
    sel[%],
    [select *entire file*],
    align: (center, left)
  ),
  herorow[#diagram(
      arrow((0, -1), btt,
          ([#mov[k]#pin("k")], [prev line]),
          ([#mode[g]#mov[g]], [first line])
      ),
      node((-0.5,-1.1), [
        #cnt[n]#mode[g]#mov[g] #hint[or] #cnt[n]#mov[G] #hint[or] #cmd[#cnt[n]]\
        jump to line #cnt[n]
      ]),
      arrow((0, 1), ttb,
          ([#pin("j")#mov[j]], [next line]),
          ([#mode[g]#mov[e]], [last line])
      ),
      arrow((-0.97, 0), rtl,
          ([#pin("h")#mov[h]], [prev char]),
          (sel[b\ B], [#sel[b]ack to prev word/WORD start]),
          ([#mode[g]#mov[s]\ #mode[g]#mov[h]], [#mode[g]oto\ 1st char/\ line start]),
      ),
      arrow((0.97, 0), ltr,
          ([#pin("l")#mov[l]], [next char]),
          (sel[w\ W], [next #sel[w]ord/#sel[W]ORD start]),
          (sel[e\ E], [next word/WORD\ #sel[e]nd]),
          ([#mode[g]#mov[l]], [#mode[g]oto\ line end])
      ),
      arrow((-0.8, 0.6), rtl, fill: gray.lighten(80%),
          ([#sel[T]x], [find '#sel[t]il prev char #strong[x]]),
          ([#sel[F]x], [#sel[f]ind prev char #strong[x]]),
      ),
      arrow((0.7, 0.6), ltr, fill: gray.lighten(80%),
          ([#sel[t]x], [find '#sel[t]il next char #strong[x]]),
          ([#sel[f]x], [#sel[f]ind next char #strong[x]]),
      ),
      arrow((-0.8, 1.2), rtl, fill: gray.lighten(80%),
          ([#sel[\[]#sem[x]], [select to prev #link(<unimpaired>)[semantic] #sem[x]]),
      ),
      arrow((0.7, 1.2), ltr, fill: gray.lighten(80%),
          ([#sel[\]]#sem[x]], [select to next #link(<unimpaired>)[semantic] #sem[x]]),
      ),
      arrow((-0.25 + 0.7, 2 - 2.6), rtl, fill: gray.lighten(80%),
          ([ ], [ ]),
      ),
      arrow((0 + 0.7, 2 - 2.6), ltr, fill: gray.lighten(80%),
          ([#mode[m]i#pair[x]], [select #strong[i]nside\ #link(<surround>)[pair] #pair[x]]),
      ),
      arrow((0.6 + 0.7, 2 - 2.6), ltr, fill: gray.lighten(80%),
          ([#mode[m]a#pair[x]], [select #strong[a]round\ #link(<surround>)[pair] #pair[x]]),
      ),
      
      node((0,0))[
        #pin("H")#kbd("H")#pin("J")#kbd("J")#pin("K")#kbd("K")#pin("L")#kbd("L")
        #text(size: 4em)[ ]#footnote[#link("https://en.wikipedia.org/wiki/Arrow_keys#HJKL_keys")[HJKL keys] on the home row of keyboard]
      ]
    )
  ]
)

#pinit-highlight("cursor-begin", "cursor-end")
#pinit-highlight("select-begin", "select-end")
#pinit-highlight("reselect-begin", "reselect-end")
#pinit-arrow("J", "j", start-dx: 10pt, start-dy: 7pt, end-dx: 3pt, end-dy: -15pt)
#pinit-arrow("K", "k", start-dx: 8pt, start-dy: -15pt, end-dx: -5pt, end-dy: 15pt)
#pinit-arrow("H", "h", start-dx: -5pt, start-dy: 9pt, end-dx: 22pt, end-dy: 9pt)
#pinit-arrow("L", "l", start-dx: 25pt, start-dy: -5pt, end-dx: -5pt, end-dy: 9pt)

#table(
  theader(colspan: 4)[#op[Operate] - enter *#mode[insert] mode* to edit],
  herorow[In Helix, insert point is relative to #sel[selection], not cursor.],
  herorow[
    #diagram(
      arrow((0, -0.95), btt, fill: blue.lighten(95%),
          ([#op[O]], [#op[o]pen on prev line]),
      ),
      arrow((0, 0.95), ttb, fill: blue.lighten(95%),
          ([#op[o]], [#op[o]pen on next line]),
      ),
      arrow((-0.95, 0), rtl, fill: blue.lighten(95%),
          ([#op[i]], [#op[i]nsert before selection]),
          ([#op[I]], [#op[i]nsert to end of\ line]),
      ),
      arrow((0.95, 0), ltr, fill: blue.lighten(95%),
          ([#op[a]], [#op[a]ppend to selection]),
          ([#op[A]], [#op[a]ppend to end of\ line]),
      ),
      node((0,0))[
        #stack(dir: ttb, spacing: 1%,
          stack(dir: ltr, spacing: 1%,
            keydef([#op[c]], [#hint[yank and]\ #op[c]hange selection], dir: ltr),
            keydef([#hint[⌥c]], [#hint[no yanking]], dir: ltr),
          ),
          stack(dir: ltr, spacing: 1%,
            keydef([#op[d]], [#hint[yank and]\ #op[d]elete selection], dir: ltr),
            keydef([#hint[⌥d]], [#hint[no yanking]], dir: ltr),
            // keydef([#hint[⌥]], [#hint[without yanking]], dir: ltr),
          ),
        )
      ]
    )
  ]
)

#table(
  theader(colspan: 4)[#op[Operate] - yank (copy) & pasting],
  ..keyrow(op[y], [*#op[y]ank* selections\ in Helix (see #link(<register>)[register])]),
  ..keyrow([#op[p]\ #op[#hint[P]]], [*#op[p]aste* after/#hint[before] selection]),
  ..keyrow([#mode[␣]#op[y]\ #op[#hint[␣Y]]], [*#op[y]ank* selections/#hint[primary selction] to clipboard]),
  ..keyrow([#mode[␣]#op[p]\ #op[#hint[␣P]]], [*paste* from clipboard\ after/#hint[before] selection]),
)

#colbreak()

#layout(size => [
  #set align(right)
  #block(width: 85% * size.width)[
  
  #table(
    theader(colspan: 4)[#sel[Select] to semantic (#link("https://github.com/tpope/vim-unimpaired")[unimpaired] style) <unimpaired>],
    ..keyrow([ #sel[\[]#sem[x]], [prev semantic #sem[x]]),
    ..keyrow([ #sel[\]]#sem[x]], [next semantic #sem[x]]),
    herorow[where #sem[x] could be],
    ..keyrow([#sem[f]], [#sem[f]unction #needtree]),
    ..keyrow([#sem[t]], [#sem[t]ype definition #needtree]),
    ..keyrow([#sem[a]], [#sem[a]rgument #needtree]),
    ..keyrow([#sem[c]], [#sem[c]omment #needtree]),
    ..keyrow([#sem[T]], [#sem[T]est #needtree]),
    ..keyrow([#sem[p]], [#sem[p]aragraph]),
  )
  
  #needtree requires a tree-sitter grammar for the file type
  
  #table(
    theader(colspan: 4)[#mov[Move] to (#link("https://github.com/tpope/vim-unimpaired")[unimpaired] style) <unimpaired-move>],
    ..keyrow([ #mov[\[]#sem[x]], [prev #sem[x]]),
    ..keyrow([ #mov[\]]#sem[x]], [next #sem[x]]),
    herorow[where #sem[x] could be],
    ..keyrow([#sem[g]\ #sem[#hint[G]]], [chan#sem[g]e\ #hint[first/last chan#strong[g]e]]),
    ..keyrow([#sem[d]\ #sem[#hint[D]]], [#sem[d]iagnostic #needlsp\ #hint[first/last #strong[d]iagnostic] ]),
    ..keyrow([#sem[␣]], [create new line above/below]),
    [],[],
  )
  
    #needlsp requires an active language server for the file

    #table(
      theader(colspan: 4)[#sel[Select] inside/around #pair[pair] (#link("https://github.com/tpope/vim-surround")[surround] style) <surround>],
      ..keyrow([#mode[m]i#pair[x]], [select #strong[i]nside\ pair #pair[x]]),
      ..keyrow([#mode[m]a#pair[x]], [select #strong[a]round\ pair #pair[x]]),
      herorow[where #pair[x] could be],
      ..keyrow(text(font: "Fira Code")[\( \) \[ \] \{ \} \' \"], [any characters acting as a pair],
        colspans: evendef,
      ),
      ..keyrow([#pair[m]], [nearest pair of the above],
        colspans: evendef,
      ),
      ..keyrow([#sem[f] #sem[t] #sem[a] #sem[c] #sem[p] #sem[T]], [same as in #link(<unimpaired>)[#sel[Select] to semantic]],
        colspans: evendef,
      ),
      ..keyrow([#sel[w]\ #hint[W]], [#sel[w]ord\ #hint[#strong[W]ORD]],
        colspans: evendef,
      ),
    )
  ]
])


// TODO

<register>

#colbreak()

<multicursor>

#layout(size => [
  #set align(right)
  #box[
  #set align(center)
  #set text(fill: gray)
  Helix Cheat Sheet v0.1\
  Typst source: #link("")[mini] / #link("")[full] \
  Utensil Song 2025-06-20\
  Helix 25.01.1 (e7ac2fcd)\
  #text(size: 6em)[#cc-by-sa-badge]\
  Inspired by Steve Hoy's\
  #link("https://github.com/stevenhoy/helix-cheat-sheet/tree/c07d3f699050a4c03e7ec5653c8baa8cbddaacff")[Helix Cheat Sheet v1.1]
  ]
])
