# typst-glossary

Automatically create a glossary in [typst](https://typst.app/).

This typst component creates a glossary page from a given pool of potential glossary
entries using only those entries, that are marked with the `gls` function in the document.

⚠️ Typst is in beta and evolving, and this package evolves with it. As a result, no
backward compatibility is guaranteed yet. Also, the package itself is under development
and fine-tuning.

## Marking the Entries

To mark a Term to be included into the glossary, it can be marked with the `gls`
function. The simplest form is like this:

```typ
This is how to mark something for the glossary in #gls[Typst].
```

The function will render as defined with the specified show rule (see below!).


## Controlling the Show

To control, how the markers are rendered in the document, a show rule has to be defined. It usually looks like the following:

```typ
// marker display : this rule makes the glossary marker in the document visible.
#show figure.where(kind: "jkrb_glossary"): it => {it.body}
```

## Pool of Entries

The "pool of entries" is a typst dictionary. It can be read from a file, like in this
sample, or may be the result of other operations.

The pool is then given to the `make-glossary()` function. This will create a
glossary page of all referenced entries. The pool consists of a dictionary of entries. The
key of an entry is the term. Note that it is case-sensitive. Each entry itself is also a
dictionary, and its main key is `description`. This is the content for the term. There may
be other keys in an entry in the future. For now, it supports:

- description
- link

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

The glossary pool used in the sample document can be found in the file `/Global/GlossaryPool.typ`.

### Unknown Entries

If the document marks a term that is not contained in the pool, an entry will be generated
anyway, but it will be visually marked as missing. This is convenient for the workflow,
where one can mark the desired entries while writing the document, and provide missing
entries later.

There is a parameter for the `make-glossary()` function named `missing`, where a function
can be provided to format or even suppress the missing entries.

## Creating the glossary page

To create the glossary page, provide the pool of potential entries. In this example, we
read it from a file. Then we give it to the `make-glossary()` function:

```typ
#import "/Global/GlossaryPool.typ": glossary-pool

#columns(2)[
    #make-glossary(glossary-pool)
]
```

The result looks like this:

![Index page](./Global/Pics/Screenshot%20Glossary.png)

<span style="font-size:9pt">
<hr>

More usage samples are shown in the document [sample-usage.typ](./sample-usage.typ).

The resulting PDF is also available as [sample-usage.pdf](./sample-usage.pdf).

The folder `VSSpell` and the file `cSpell.json` are spell checker configuration files used
by VSCode.

</span>