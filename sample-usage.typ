#import "./gloss-awe.typ": *

// This typst file demonstrates the usage of the glossary package.
#set text(lang: "en", font: "Arial", size: 10pt)
#show raw: it => {set text(size: 1.1em); it}

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
    #text(size: 12pt)[Version 0.1.2 (1.6.2024)]
    #linebreak() #v(.5em)
    #text(size: 10pt)[Rolf Bremer, Jutta Klebe]
    #v(4em)
]


= Sample Document to Demonstrate the Package Gloss-Awe

#grid(
    columns: (1fr, 1fr),
    [

        This package can create a glossary for a document. The glossary entries are pulled from a
        pool of entries using only entries, that are marked in the document. The package creates
        warnings for marked entries, that cannot be found in the entry pool, but this warnings can
        be suppressed with a parameter to the `make-glossary()` function.

        // Here we use the optional `showmarker` parameter to format the marked entry.
        Using the glossary package in a
        #gls(entry: "Typst", showmarker: m => text(weight: "bold", fill: teal, m), [typst])
        document consists of some simple steps:

        + Importing the package `gloss-awe`.
        + Marking the words or phrases to include in the glossary with `gls[]`.
        + Optional: Defining a showmarker for the marker.
        + Read in one or more glossary pool(s) (from file(s) or create it in the document itself).
        + Generating the glossary page by calling the `make-glossary(..glossary-pool)` function.

    ],
    [

        #figure(
            image("/Global/Pics/Screenshot Glossary.png", width: 90%),
            caption: [Glossary Page],
        )

    ]

)



== Importing the Package

The glossary package is available on GitHub
(https://github.com/RolfBremer/typst-glossary). It is still in development and may have
breaking changes in its next #gls[iteration].

```typ
    #import "./gloss-awe.typ": *
```

The package is also available via Typst's build-in Package Manager:

```typ
    #import "@preview/gloss-awe:0.1.2": *
```

Note, that the version number ("0.1.2") have to be adapted to get the wanted version.


== Marking of Entries

We have marked several words to be included in the glossary page at the end of the
document. The marked entries are shown on the glossary page.

```typ
This is a #gls[Sample] to demonstrate the 'gloss-awe' package.
```

The previous markup marks "Sample" as reference for the glossary. If "Sample" is
contained in the Glossary-Pool, it will be included into the resulting glossary page. If
the Entry in the pool has a different key word, the following marker syntax can be used:


```typ
This is a #gls(entry: "Example")[Sample] to demonstrate the 'gloss-awe' package.
```

In this case, the entry for "Example" is taken from the glossary pool, while in the
document the term "Sample" is used.

The `entry` parameter should also be used, if the entry text (display) is some rich
content, like a math expression.


=== Complex Content

To reference a Glossary entry with a complex name, like this #gls[Complex Content]
containing a whitespace, it is a good idea to use the entry parameter of the
`gls`-function, to map it to a non-complex entry in a glossary pool, or, create the pool
entry with a string as its key (see sample code!).

Other, even more complex content, may definitely need an entry text given. The entry text
controls where the entry is sorted in, and also is it used for the lookup in the glossary
pools.

```typ
#gls(entry: "Kreisfläche", $A=pi r^2$)

#gls(entry: "E=MC2", $ E=m c^2 $)

#gls(entry:"I1" ,$ I = rho^2 * sigma^3 $)
```

#v(2em)

#gls(entry: "Kreisfläche", $A=pi r^2$)

#gls(entry: "E=MC2", $ E=m c^2 $)

#gls(entry:"I1" ,[$ I = rho^2 * sigma^3 $])


=== Glossary Entries that are not visible in the Documents Content

It is also possible to reference glossary entries without having them occur in the content
of the document. They will only appear in the glossary. The function
`#gls-add[Keyword]` can be used to create such a reference.


Here we use different notations to add entries with `gls-add()`:

```typ
#gls-add[Calcium]
#gls-add("Beryllium")
#gls-add[Potassium - Hydrochloride]
#gls-add["Iron"]
```

#gls-add[Calcium]
#gls-add("Beryllium")
#gls-add[Potassium - Hydrochloride]
#gls-add["Iron"]


== Defining a showmarker

For review reasons, the marked entries can be made more visible in the resulting
document. For example like here:

// Show the marked glossary entries ...
#let my-gls = gls.with(showmarker: w => text(fill: teal, [#w]))

```typ
#let my-gls = gls.with(showmarker: w => text(fill: teal, [#w]))
```

This function can be used to mark entries that then appear colored in the
#my-gls[typst] document.

The index markers now show up in the resulting document and can easily be reviewed.
To define this behavior generally, the gls function can be redefined like this:

```typ
#let gls = gls.with(showmarker: w => text(fill: teal, [#w]))
```

== Casing

Note that the #gls(entry: "Casing")[casing] of the entries matters. It may sometimes be
desirable to just ignore the casing while generating the glossary page, but there are
cases where casing is important - especially when it comes to trademarks and logos. An
example is provided here, where "#gls[Context]" as well as "#gls[ConTeXt]" is contained in
the glossary.

Starting with version 0.1.0, gloss-awe supports custom sorting: A function can be provided
to make-glossary() to determine the sort key for the entries.

```typ
#make-glossary(global-glossary, sort: x => lower(x))
```

or shorter:

```typ
#make-glossary(global-glossary, sort: lower)
```


== Hiding entries from the glossary page

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


== The Glossary Pool(s)

The pool contains the definitions for the entries. In this sample, we read the pool(s) from
one or more files -- here from typst files. But they may also be #gls[XML]-Files or other
sources. The `make-glossary()` method can take more than one pool at once. The matching of
marked entries is done in the order the pools where given in the parameters of the method.
The first match wins.

The pools are typst dictionaries, where the key is the marked word. The entry under this
key is itself a dictionary, containing one or more entries with well known keys:

- description\
  This is the description of the marked word.

- link\
  This optional entry can contain an external link (URL).

more well known entries may come in future versions.


== The Glossary Page

To actually create the glossary page, the `make-glossary()` function has to be called. Of
course, it can be embedded into an appropriately formatted environment, like this:

```typ
#columns(2)[
    #make-glossary(glossary-pool, sort-key: lower, suppress-missing: false)
]
```

Note: the parameter `suppress-missing` is set to false (which is the default). So marked
entries that could not be found in the provided glossary pools, are marked with a
#text(red, "No glossary entry") on the glossary page.


The next sample uses two different pools: a specific pool and a global pool.
```typ
#columns(2)[
    #make-glossary(specific-pool, glossary-pool, sort-key: lower)
]
```



= Why Having a Glossary in Times of Search Functionality on the Internet?

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


= Glossary<Glossary>

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
    // Here we emit the actual glossary page; we use the lower function to sort the entries.
    #make-glossary(glossary-pool,
                   excluded: hidden-entries,
                   sort-key: lower,
                   suppress-missing: false)
]

#pagebreak(weak: true)


= Glossary (with additional local pool)

This Glossary uses an additional glossary pool file to resolve the marked entries.

#line(length: 100%, stroke: .1pt + gray)

#import "/Global/GlossaryPool.typ": glossary-pool
#import "/Global/LocalGlossaryPool.typ": local-glossary-pool
#let emptyGlossary = ()  // This is to test, if an empty glossary is ignored.

#columns(2)[
    // Here we emit the actual glossary page; we do not provide a specific function
    // to sort the entries in this case.
    #make-glossary(local-glossary-pool, glossary-pool, emptyGlossary, excluded: hidden-entries)
]
