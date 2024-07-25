# gloss-awe

Automatically create a glossary in [typst](https://typst.app/).

This typst component creates a glossary page from a given pool of potential glossary
entries using only those entries, that are marked with the `gls` or `gls-add` functions in
the document.

⚠️ Typst is in beta and evolving, and this package evolves with it. As a result, no
backward compatibility is guaranteed yet. Also, the package itself is under development
and fine-tuning.

## Table of Contents

* [Usage](#usage)
  * [Marking the Entries](#marking-the-entries)
  * [Controlling the Show](#controlling-the-show)
  * [Hiding Entries from the Glossary Page](#hiding-entries-from-the-glossary-page)
  * [Pool of Entries](#pool-of-entries)
  * [Unknown Entries](#unknown-entries)
  * [Creating the glossary page](#creating-the-glossary-page)
* [Changelog](#changelog)
  * [v0.1.5](#v015)
  * [v0.1.4](#v014)
  * [v0.1.3](#v013)
  * [v0.1.2](#v012)
  * [v0.1.1](#v011)
  * [v0.1.0](#v010)
  * [v0.0.5](#v005)
  * [v0.0.4](#v004)
  * [v0.0.3](#v003)
  * [v0.0.2](#v002)

## Usage

### Adding the package to your project

The package can either be added to your project by adding the main file `gloss-awe.typ` and
importing it, or by importing the package via the typst package manager (available from
Typst version 0.6.0 or later).

#### Importing from File

```typ
    #import "gloss-awe.typ": *
```

#### Importing via Typst Package Manager

```typ
    #import "@preview/gloss-awe:0.1.5": *
```

### Marking the Entries

To include a term into the glossary, it can be marked with the `gls` function. The
simplest form is like this:

```typ
This is how to mark something for the glossary in #gls[Typst].
```

The gls function will render in the resulting document as defined with the specified
show rule (see below!).

### Controlling the Show

To control, how the markers are rendered in the document, a function can be 
provided for the markers:

```typ
#gls(showmarker: m => [#emph(m)])[Butterscotch]
```

This sample will display the marked word as emphasized in the document.

### Hiding Entries from the Glossary Page

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

### Pool of Entries

A "pool of entries" is a typst dictionary. It can be read from a file or may be the result
of other operations.

One or more pool(s) are then given to the `make-glossary()` function. This will create a
glossary page of all referenced entries. If given more than one pool, the order pools are
searched in the order they are given to the method. The first match wins. This can be used
to have a global pool to be used in different documents, and another one for local usage
only.

The pool consists of a dictionary of definition entries. The key of an entry is the term.
Note, that it is case-sensitive. Each entry itself is also a dictionary, and its main key
is `description`. This is the content for the term. There may be other keys in an entry in
the future. For now, it supports:

* description
* link

An entry in the pool for the term "Engine" file may look like this:

```typ
    Engine: (
        description: [

            In the context of software, an engine...

        ],
        link: [

            (1) Software engine - Wikipedia.
            https://en.wikipedia.org/wiki/Software_engine
            (13.5.2023).

        ]
    ),
```

### Unknown Entries

If the document marks a term that is not contained in the pool, an entry will be generated
anyway, but it will be visually marked as missing. This is convenient for the workflow,
where one can mark the desired entries while writing the document, and provide missing
entries later.

There is a parameter for the `make-glossary()` function named `missing`, where a function
can be provided to format or even suppress the missing entries.

### Creating the Glossary Page

To create the glossary page, provide the pool of potential entries to the make-glossary
function. The following listing shows a complete sample document with a glossary. The
sample glossary pool is contained in the main document as well:

```typ
    #import "@preview/gloss-awe:0.1.5": *

    // Text settings
    #set text(font: ("Arial", "Trebuchet MS"), size: 12pt)

    // Defining the Glossary Pool with definitions.
    #let glossary-pool = (
        Cloud: (
            description: [

                Cloud computing is a model where computer resources are made available
                over the internet. Such resources can be assigned on demand in a very short
                time, and only as long as they are required by the user.

            ]
        ),

        Marker: (
            description: [

                A Marker in `gloss-awe` is a typst function to mark a word or phrase to appear
                in the documents glossary. The marker is also linked to the glossary section
                by referencing the label `<Glossary>`.

            ]
        ),

        Glossary: (
            description: [

                A glossary is a list of terms and their definitions that are specific to a
                particular subject or field. It is used to define the intended meaning of
                terms used in a document and to agree on a common definition of those terms. A
                well-defined glossary can be very helpful in documents where very specific
                meanings of certain terms are used.

            ]
        ),

        "Glossary Pool": (
            description: [

                A glossary pool is a collection of glossary entries. An automated tool can
                pull needed definitions from this pool to create the glossary pages for a
                specific context.

            ]
        ),

        REST: (
            description: [

                Representational State Transfer (abgekürzt REST) ist ein Paradigma für die
                Softwarearchitektur von verteilten Systemen, insbesondere für Webservices.
                REST ist eine Abstraktion der Struktur und des Verhaltens des World Wide
                Web. REST hat das Ziel, einen Architekturstil zu schaffen, der den
                Anforderungen des modernen Web besser genügt.

            ]
        ),

        XML: (
            description: [

                XML stands for `'eXtensible Markup Language'`.

            ],
            link: [https://www.w3.org/XML]
        ),
    )

    // Defining, how marked glossary entries in the document appear
    #show figure.where(kind: "jkrb_glossary"): it => {it.body}

    // This alternate rule, creates links to the glossary for marked entries.
    // #show figure.where(kind: "jkrb_glossary"): it => [#link(<Glossar>)[#it.body]]

    = My Sample Document with `gloss-awe`

    In this document the usage of the `gloss-awe` package is demonstrated to create a glossary
    with the help of a simple and small sample glossary pool. We have defined the pool in a
    dictionary named #gls[Glossary Pool] above. It contains the definitions the `gloss-awe`
    can use to build the glossary in the #gls[Glossary] section of this document. The pool
    could also come from external files, like #gls[JSON] or #gls[XML] or other sources. Only
    those definitions are shown in the glossary, that are marked in this document with one of
    the #gls(entry: "Marker")[marker] functions `gloss-awe` provides.

    If a Word is marked, that is not in the Glossary Pool, it gets a special markup in the
    resulting glossary, making it easy for the Author to spot the missing information an
    providing a definition. In this sample, there is no definition for "JSON" provided,
    resulting in an Entry with a red remark "#text(fill: red)[No~glossary~entry]".

    There is also a way to include Entries in the glossary for Words that are not contained in
    the documents text:

    #gls-add("Cloud")
    #gls-add("REST")


    = Glossary <Glossary>

    This section contains the generated Glossary, in a nice two-column-layout. It also bears a
    label, to enable the linking from marked words to the glossary.

    #line(length: 100%)
    #set text(font: ("Arial", "Trebuchet MS"), size: 10pt)
    #columns(2)[
        #make-glossary(glossary-pool)
    ]

```

To use more than one pool, this can be used instead:

```typ
#import "/Global/GlossaryPool.typ": glossary-pool
#import "/Global/LocalGlossaryPool.typ": local-glossary-pool

#columns(2)[
    #make-glossary(local-glossary-pool, glossary-pool)
]
```

Using this, the local pool takes precedence over the global pool, because it is the first
parameter.

More usage samples are shown in the document `sample-usage.typ` on
[gloss-awe´s GitHub]([Title](https://github.com/RolfBremer/typst-glossary)).

A more complex sample PDF is available there as well.

</span>

## Changelog

### v0.1.5

* Migrate deprecated locate to context.

### v0.1.4

* Fix a Bug introduced in 0.1.3 where glossary entries with empty entries are not shown.

### v0.1.3

* Enhance internal `as-text` function to be more robust.
* tidy up sample-usage.typ document.

### v0.1.2

* Provide a parameter to suppress "no glossary entry" messages in the glossary page.
* Support rich content in glossary titles.
* Increase robustness for different content in the entry.
* Ignore empty glossary pools without throwing an error.

### v0.1.1

* Improve display behavior of `gls()` by not emitting additional spaces.
* Clean up documentation.

### v0.1.0

* Add an optional parameter `sort: k => k` to make-glossary() to provide a method to
  determine the sort key.
* Remove the (mis-)usage of figures to mark glossary entries. This also removes the
  requirement to have a show rule for those figures defined to suppress the markers.

### v0.0.5

* Address change in `figure.caption` in typst (commit: 976abdf ).

### v0.0.4

* Breaking: Renamed the main file from `glossary.typ` to `gloss-awe.typ` to match package.
* Added support for hidden glossary entries.
* Added a Changelog to this readme.

### v0.0.3

* Added support for package manager in Typst.
* Add `gls-add[...]` function for entries that are not in the document.

### v.0.0.2

* Moved version to Github.
