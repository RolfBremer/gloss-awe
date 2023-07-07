#import "./gloss-awe.typ": *

// This typst file demonstrates the usage of the glossary package.
#set text(lang: "en", font: "Arial", size: 10pt)
#show raw: it => {set text(size: 11pt); it}

// glossary-marker display : this rule makes the glossary marker in the document visible.
// #show figure.where(kind: "jkrb_glossary"): it => {it.body}

// glossary-marker display : this rule makes the glossary marker visible
// and adds a hyperlink to the "Glossary" label.
#show figure.where(kind: "jkrb_glossary"): it => [#link(<Glossary>)[#it.body]]

// Format headings
#set heading(numbering: none)
#show heading: it => {
    set block(above: 2em)
    set text(blue)
    [#it]
}

// Front Matter
#align(center)[
    #text(size: 23pt)[Typst-Glossary]
    #linebreak() #v(1em)
    #text(size: 16pt)[A Glossary Package for Typst]
    #linebreak() #v(.5em)
    #text(size: 12pt)[Version 0.3 (18.6.2023)]
    #linebreak() #v(.5em)
    #text(size: 10pt)[Rolf Bremer, Jutta Klebe]
    #v(4em)
]


= Sample Document to Demonstrate the Typst-Glossary

This package can create a glossary for a document. The glossary entries are pulled from a
pool of entries using only entries, that are marked in the document. The package creates
warnings for marked entries, that cannot be found in the entry pool.

Using the glossary package in a #gls(entry: "Typst")[typst] document consists of some
simple steps:

+ Importing the package `gloss-awe`.
+ Marking the words or phrases to include in the glossary with `gls[]`.
+ Defining the show rule for the marker.
+ Read in one or more glossary pool(s) (from file(s) or elsewhere).
+ Generating the glossary page by calling the `make-glossary(..glossary-pool)` function.


== Importing the Package

The glossary package is currently available on GitHub
(https://github.com/RolfBremer/typst-glossary). It is still in development and may have
breaking changes in its next #gls[iteration].

```typ
    #import "./gloss-awe.typ": *
```

The package is also available via Typst's build-in Package Manager:

```typ
    #import "@preview/gloss-awe:0.0.4": *
```

Note, that the version number ("0.0.4") have to be adapted to get the wanted version.

== Marking of Entries

We have marked several words to be included in the glossary page at the end of the
document. The markup for the entry stays visible. Its location in the text gets marked,
and later it is shown as a page reference on the glossary page.

```typ
This is a #gls[sample] to demonstrate _glossary_.
```

The previous markup marks "sample" as reference for the glossary. If "Entry Phrase" is
contained in the Glossary-Pool, it will be included into the resulting glossary page. If
the Entry in the pool has a different key word, the following marker syntax can be used:


```typ
This is a #gls(entry: "example")[sample] to demonstrate _glossary_.
```

In this case, the entry for "example" is taken from the glossary pool, while in the
document the term "sample" is used.


=== Complex Content

To reference a Glossary entry with a complex name, like this #gls[Complex Content]
containing a whitespace, it is a good idea to use the entry parameter of the
`gls`-function, to map it to a non-complex entry in a glossary pool, or, create the pool
entry with a string as its key (see sample code!).


=== Glossary Entries not in the Document Content

It is also possible to reference glossary entries without having them occur in the content
of the document. They will only appear in the glossary. The function
`#gls-add[Keyword]` can be used to create such a reference.

#gls-add[Amaranth]

=== Casing

Note that the #gls(entry: "Casing")[casing] of the entries matter. It may sometimes be
desirable to just ignore the casing while generating the glossary page, but there are
cases where casing is important - especially when it comes to trademarks and logos. An
example is provided here, where "#gls[Context]" as well as "#gls[ConTeXt]" is contained in
the glossary.


#pagebreak()


== Controlling the Show

At the start of this document, just after the `import` statements, we used
a `show` rule to define, what we want to see of the `gls` markers in the
resulting document:

```typ
// Glossary-Entry display : this rule makes the gls entries in the document visible.
#show figure.where(kind: "jkrb_glossary"): it => {it.body}
```

For review reasons, this can be changed to show up more prominently in the resulting
document. For example like here:

```typ
// Glossary-Entry: this rule makes the glossary entries in the document more visible.
#show figure.where(kind: "jkrb_glossary"): it => {
    text(fill: red)[ --> '#it.body']
}
```

The index markers now show up in the resulting document and can easily be reviewed.

#pad(left: 2em)[
    #block(
            fill: luma(230),
            inset: 12pt,
            radius: 4pt
        )[
        // Glossary-Entry: this rule makes the glossary entries in the document more visible.
        #show figure.where(kind: "jkrb_glossary"): it => {
            text(fill: red)[ --> '#it.body']
        }

        This is a #gls(entry: "Example")[sample] to demonstrate _typst-glossary_.
    ]
]


=== Hiding entries from the glossary page

It is also possible to hide entries (temporarily) from the generated glossary page without
removing any markers for them from the document.

The following sample will hide the entries for "Amaranth" and "Butterscotch" from the
glossary, even if it is marked with `gls[...]` or `gls-add[...]` somewhere in the
document.

```typ
    #let hidden-entries = (
        "Amaranth",
        "Butterscotch"
    )

    #make-glossary(glossary-pool, excluded: hidden-entries)
```

== The Glossary Pool

The pool contains the definitions for the entries. In this sample, we read the pool from
one or more files -- here from typst files. But they may also be #gls[XML]-Files or other
sources. The `make-glossary()` method can take more than one pool at once. The matching of
marked entries is done in the order the pools where given in the parameters of the method.
The first match wins.


== The Glossary Page

To actually create the glossary page, the `make-glossary()` function has to be called. Of
course, it can be embedded into an appropriately formatted environment, like this:

```typ
#columns(2)[
    #make-glossary(glossary-pool)
]
```

= Why Having a Glossary in Times of Search Functionality?

A well-defined Glossary can be very helpful in documents where very specific meanings of
certain Terms are used. For example, the term "Context". In a specific document it
may refer not to the general context, but may be used for a specific data structure in a
system. In another document it may refer to a typesetting system with the name "ConTeXt".
A Glossary can be used to define things for the document's context. It is used to agree on
a #gls(entry: "Common Definition")[common definition] of Terms used in the document.


= Test Text

In this section, we have some more sample text to have some more references for the
glossary. The rest of this section is #gls[Test Text], so it may not carry much meaning in
it. It is more like #lorem(20).

The #gls[Commit-SHA] of Git is a very nice key to identify specific versions. The term
_#gls[Supercalifragilisticexpialigetisch]_ comes to mind, if one thinks about really long
words, but that's another story.


#pagebreak()


= Glossary

<Glossary>

To create the glossary page, we load the #gls(entry: "Glossary Pool")[glossary~pool] from
a file and call the `make-glossary()` function with it.
Here we generate the glossary page with referenced entries in two columns:

#line(length: 100%, stroke: .1pt + gray)

// We hide these entries in the glossary, even if is marked in the document.
#let hidden-entries = (
    "Amaranth",
    "Artificial"
)

#import "/Global/GlossaryPool.typ": glossary-pool

#columns(2)[
    #make-glossary(glossary-pool, excluded: hidden-entries)
]

#pagebreak(weak: true)


= Glossary (with additional local pool)

This Glossary uses an additional glossary pool file to resolve the marked entries.

#line(length: 100%, stroke: .1pt + gray)

#import "/Global/GlossaryPool.typ": glossary-pool
#import "/Global/LocalGlossaryPool.typ": local-glossary-pool

#columns(2)[
    #make-glossary(local-glossary-pool, glossary-pool, excluded: hidden-entries)
]
