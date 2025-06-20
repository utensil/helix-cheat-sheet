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

#let base-text = 11pt
#let small-text = 5pt
#set text(font: "Fira Sans", size: base-text)
#show math.equation: set text(font: "Fira Math")
#show raw: set text(font: "Fira Code", size: 10pt)

#show link: it => {
  set text(blue)
  it
}

#show: cram-snap.with(
  title: [*Helix Cheat Sheet*],
  subtitle: [mini v0.4], // A Post-Modern Text Editor
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

#let keydef(key, def, dir: ltr, size: base-text)=[
  #set text(size: size)
  #stack(dir: dir, spacing: 1pt,
    box(align(center + horizon, text(size: 2em, weight: "bold", key)), inset: 0pt),
    box(height: 3em, width: 3.5em, align(center + horizon, text(size: 0.7em, def)), inset: 0pt),
  )
]

#let arrow(pos, dir, ..keydefs, fill: rgb("947cc3").lighten(80%), size: base-text)=(
  node(pos, stack(dir: dir, spacing: 1pt, ..(
    keydefs.pos().map(kd => { keydef(kd.first(), kd.last(), dir: dir, size: size)})
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
#let fn-shift=text(fill: gray)[●]
#let fn-replace=text(fill: gray)[●]
#let fn-hjkl=text(fill: gray)[●]
#let fn(content)=super(size: 1em, content)

#layout(size => [
  #set align(center)
  #block(width: 90% * size.width)[

  #table(
    theader[Basic],
    ..keyrow([Install], [ #link("https://docs.helix-editor.com/package-managers.html")[with package managers] or #link("https://docs.helix-editor.com/building-from-source.html")[from source]], colspans: (1, 3)),
    ..keyrow([#hint("$") *hx*], [open current directory in Helix], colspans: evendef), // \ #hint[as a workspace]
    ..keyrow([#hint("$") *hx* #arg[file]], [open #arg[file] in Helix], colspans: evendef),
    herorow[#hint[buffer = opened file, shown as *tabs*]],
    ..keyrow(cmd[n#hint("ew")], [create a #strong[n]ew buffer]),
    ..keyrow(cmd[w#hint("rite")], [#strong[w]rite buffer to disk\ #hint[(save file)]]),
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
      No more #op[dd], #op[yy], see their #link(<counterparts>)[counterparts] in Helix
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
        *select (extend)* mode - like Vim's #mode[*v*]isual mode\
        #hint[see also in #link(<v-mode>)[#mov[Move]/#sel[Select]]]
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
      [#mode[⌃w\ #mode[␣w]]],
      [*window* mode]
    ),
  )


  #table(
    theader[Pick],
    ..keyrow([#mode[␣]f\ #hint[␣F]], [open *file* picker in workspace/#hint[current directory]], colspans: longdef),
    ..keyrow([#mode[␣]b], [open *buﬀer* #hint[(tab)] picker], colspans: longdef),
    ..keyrow([#mode[␣]j], [open *jump* picker], colspans: longdef),
    ..keyrow([#mode[␣]s], [open *symbol* picker #needlsp], colspans: longdef),
    ..keyrow([#mode[␣]?], [open *command* palette], colspans: longdef),
  )

  #table(
    theader[Search & replace <replace>],
    ..keyrow([/#hint[\<regex\>]↵\ #hint[?\<regex\>↵]], [search for #hint[\<regex\>] in current buffer (forward/#hint[backward])], colspans: evendef, align: (center, left)),
    ..keyrow([N], [prev match]),
    ..keyrow([n], [#strong[n]ext match]),
    ..keyrow([\*], [search for current #sel[selection]\ #hint[(e.g. \*n for next match)]], colspans: evendef, align: (center, left)),
    ..keyrow([s#hint[\<regex\>]↵c#hint[\<replacement\>]], [replace #hint[\<regex\>] with #hint[\<replacement\>] in #sel[selection] #fn[#fn-replace] \ #hint[(e.g. % to select the whole file)]], colspans: evendef, align: (center, left)),
    ..keyrow([#mode[␣]/#hint[\<regex\>]↵], [search for  #hint[\<regex\>]  in workspace], colspans: evendef, align: (center, left)),
    ..keyrow([#text(weight: "regular")[#link("https://github.com/chmln/sd")[sd] (CLI) #link("https://github.com/thomasschafer/scooter?tab=readme-ov-file#helix")[scooter] (TUI)]], [search & replace in workspace], colspans: evendef, align: (center, left)),
  )

  #fn-replace see #link(<multicursor>)[Multi-cursor #sel[#strong[s]elect]] in and #op[c]hange in #link(<operate>)[Operate].

  #table(
    theader[Look around],
    ..keyrow([#mode[g]p], [#mode[g]oto #strong[p]rev buffer #hint[(tab)]]),
    ..keyrow([#mode[g]n], [#mode[g]oto #strong[n]ext buffer #hint[(tab)]]),
    ..keyrow([#mode[g]f], [#mode[g]oto #strong[f]ile under cursor]),
    ..keyrow([#mode[g]d], [#mode[g]oto #strong[d]efinition #needlsp]),
    ..keyrow([^o], [jump #strong[o]ut #hint[(backward)]]),
    ..keyrow([^i], [jump #strong[i]n #hint[(forward)]]),
  )

  #table(
    theader[Mess around],
    ..keyrow([u], [#strong[u]ndo]),
    ..keyrow([U], [redo]),
    ..keyrow([<], [unindent]),
    ..keyrow([>], [indent]),
    ..keyrow([^c], [toggle *comment*]),
    ..keyrow([C], [vertical #link(<multicursor>)[multi-cursor]]),
  )

  #needlsp requires an active language server for the file, see #link(<lsp>)[LSP].
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
    [escape from *#link(<multicursor>)[multi-cursor #sel[selection]]*\ (i.e. keep only primary selection)],
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
    [select *current line* #hint[(repeatable)]],
    align: (center, left)
  ),
  ..keyrow(
    sel[%],
    [select *entire file*],
    align: (center, left)
  ),
  herorow[
    // #set text(size: 11pt)
    #diagram(
      arrow((0, -1), btt,
          ([#mov[k]#pin("k")], [prev line]),
          ([#mode[g]#mov[g]], [first line])
      ),
      node((0.5,-1.1), [
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
      arrow((-0.22 + 0.7, 2 - 2.6), rtl, fill: gray.lighten(80%),
          ([ ], [ ]),
      ),
      arrow((0 + 0.7, 2 - 2.6), ltr, fill: gray.lighten(80%),
          ([#mode[m]i#pair[x]], [select #strong[i]nside\ #link(<surround>)[pair] #pair[x]]),
      ),
      arrow((0.6 + 0.7, 2 - 2.6), ltr, fill: gray.lighten(80%),
          ([#mode[m]a#pair[x]], [select #strong[a]round\ #link(<surround>)[pair] #pair[x]]),
      ),
      arrow((0.7 - 1.3, 2 - 2.6 - 0.5), ttb, fill: gray.lighten(80%), size: small-text,
          ([ ], [ ]),
      ),
      arrow((0.7 - 1.3, 2 - 2.6 - 0.7), btt, fill: gray.lighten(80%), size: small-text,
          ([⌃u], [move ½ page #strong[u]p]),
          ([⌃b], [move page up (#strong[b]ack)]),
      ),
      arrow((0.7 - 1.3, 2 - 2.6 - 0.1), ttb, fill: gray.lighten(80%), size: small-text,
          ([⌃d], [move ½ page #strong[d]own]),
          ([⌃f], [move page down (#strong[f]orward)])
      ),
      node((0,0))[
  #pin("H")#kbd("H")#pin("J")#kbd("J")#pin("K")#kbd("K")#pin("L")#kbd("L")#fn[#fn-hjkl]<move>
      ]
    )
  ]
)

#fn-hjkl #link("https://en.wikipedia.org/wiki/Arrow_keys#HJKL_keys")[HJKL keys] on the home row of keyboard

#pinit-highlight("cursor-begin", "cursor-end")
#pinit-highlight("select-begin", "select-end")
#pinit-highlight("reselect-begin", "reselect-end")
#pinit-arrow("J", "j", start-dx: 10pt, start-dy: 7pt, end-dx: 3pt, end-dy: -15pt)
#pinit-arrow("K", "k", start-dx: 8pt, start-dy: -15pt, end-dx: -5pt, end-dy: 15pt)
#pinit-arrow("H", "h", start-dx: -5pt, start-dy: 9pt, end-dx: 22pt, end-dy: 9pt)
#pinit-arrow("L", "l", start-dx: 25pt, start-dy: -5pt, end-dx: -5pt, end-dy: 9pt)

#table(
  theader(colspan: 4)[#op[Operate] - enter *#mode[insert] mode* to edit <operate>],
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
        #stack(dir: ltr, spacing: 1%,
          keydef([#op[r]], [replace character], dir: ltr),
          stack(dir: ttb, spacing: 1%,
            keydef([#op[c]], [#hint[yank and]\ #op[c]hange selection], dir: ltr),
            keydef([#hint[⌥c]], [#hint[no yanking]], dir: ltr),
          ),
          stack(dir: ttb, spacing: 1%,
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
  ..keyrow([#op[R]\ #hint[␣R]], [#strong[r]eplace selections by yanked/#hint[clipboard] contents], colspans: longdef),
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

    #table(
      theader(colspan: 4)[Multi-cursor #sel[select]<multicursor>],
      ..keyrow(
        [C\ #hint[⌥C]],
        [copy selection onto next/#hint[prev] line #hint[(repeatable)]\ #hint[a.k.a *vertical selection* or *block selection*]],
        colspans: longdef,
        align: (center, left)
      ),
      ..keyrow(
        [#mode[v]\ #sel[w]...],
        [*extend* all selections towards the next #link(<move>)[#mov[move]]],
        colspans: longdef,
        align: (center, left)
      ), 
      ..keyrow(
        sel[,],
        [escape from *multi-cursor #sel[selection]*\ (i.e. keep only primary selection)],
        colspans: longdef,
        align: (center, left)
      ),
      ..keyrow([s#hint[\<regex\>]↵], [#strong[s]elect all #hint[\<regex\>] matches inside selections\ #hint[(useful in #link(<replace>)[Search & replace])]], colspans: evendef, align: (center, left)),
      ..keyrow([S#hint[\<regex\>]↵], [#strong[s]plit selection on #hint[\<regex\>] matches], colspans: evendef, align: (center, left)),
    )

    #table(
      theader(colspan: 4)[Multi-cursor #op[operate]],
      ..keyrow([#op[c] #op[d] #op[i] #op[a] #op[o] #op[O] #op[R] ... ], [same as in #link(<operate>)[#op[Operate]]], colspans: evendef),
      ..keyrow([&], [align selection in columns], colspans: evendef),
    )
  ]
])

#colbreak()

// TODO

<register>

#table(
  theader(colspan: 4)[Register],
)

<counterparts>

#table(
  theader(colspan: 4)[Counterparts],
)

<lsp>

#table(
  theader(colspan: 4)[LSP],
)

#table(
  theader[Special key],
  ..keyrow([⎋], [escape]),
  ..keyrow([⌥], [option #hint[or] Alt]),
  ..keyrow([^], [control]),
  ..keyrow([⌘], [command]),
  ..keyrow([⇧], [shift #hint[( `⇧w` = `W`, `⇧/` = `?`... )]], colspans: longdef),
  ..keyrow([␣], [space]),
  ..keyrow([↵], [enter]),
)

#layout(size => [
  #set align(right)
  #box[
  #set align(center)
  #set text(fill: gray)
  Helix Cheat Sheet v0.1\
  Typst source: #link("https://github.com/utensil/helix-cheat-sheet/blob/main/mini.typ")[mini] / #link("https://github.com/utensil/helix-cheat-sheet")[full] \
  Utensil Song 2025-06-20\
  Helix 25.01.1 (e7ac2fcd)\
  #text(size: 6em)[#cc-by-sa-badge]\
  Inspired by Steve Hoy's\
  #link("https://github.com/stevenhoy/helix-cheat-sheet/tree/c07d3f699050a4c03e7ec5653c8baa8cbddaacff")[Helix Cheat Sheet v1.1]
  ]
])
