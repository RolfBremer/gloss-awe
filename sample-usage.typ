#import "./glossary.typ": *

// This typst file demonstrates the usage of the glossary package.
#set text(lang: "en", font: "Arial", size: 10pt)
#show raw: it => {set text(size: 11pt); it}

// glossary-marker display : this rule makes the glossary marker in the document visible.
// #show figure.where(kind: "jkrb_glossary"): it => {it.body}

// glossary-marker display : this rule makes the glossary marker visible
// and adds a hyperlink to the Glossar.
#show figure.where(kind: "jkrb_glossary"): it => [#link(<Glossar>)[#it.body]]

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
    #text(size: 12pt)[Version 0.2 (12. Mai 2023)]
    #linebreak() #v(.5em)
    #text(size: 10pt)[Rolf Bremer, Jutta Klebe]
    #v(4em)
]


= Sample Document to Demonstrate the Typst-Glossary

This package can create a glossary for a document. The glossary entries are pulled from a
pool of entries using only entries, that are marked in the document. The package creates
warnings for marked entries, that cannot be found in the entry pool.

Using the glossary package in a #gls(entry: "Typst")[typst] document consists of some simple steps:

+ Importing the package `glossary.typ`.
+ Marking the words or phrases to include in the glossary with `gls[]`.
+ Defining the show rule for the marker.
+ Read in the glossary pool (from a file or elsewhere).
+ Generating the glossary page by calling the `make-glossary(glossary-pool)` function.


== Importing the Package

The glossary package is currently available on GitHub
(https://github.com/RolfBremer/typst-glossary). It is still in development and may have
breaking changes in its next #gls[iteration].

```typ
#import "./glossary.typ": *
```


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

== The Glossary Page

To actually create the glossary page, the `make-glossary()` function has to be called. Of course,
it can be embedded into an appropriately formatted environment, like this:

```typ
#columns(2)[
    #make-glossary()
]
```

= Why Having a Glossary in Times of Search Functionality?

A well-defined Glossary can be very helpful in documents where very specific meanings of
certain Terms are used. For example, the term "#gls[Context]". In a specific document it
may refer not to the general context, but may be used for a specific data structure in a
system. In another document it may refer to a typesetting system with the name "#gls[ConTeXt]".
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

<Glossar>

To create the glossary page, we load the #gls(entry: "Glossary Pool")[glossary pool] from
a file and call the `make-glossary()` function with it.

Here we generate the glossary page with referenced entries in two columns:

#line(length: 100%, stroke: .1pt + gray)

#import "/Global/GlossaryPool.typ": glossary-pool

#columns(2)[
    #make-glossary(glossary-pool)
]
