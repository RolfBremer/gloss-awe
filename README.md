# gloss-awe

Automatically create a glossary in [typst](https://typst.app/).

This typst component creates a glossary page from a given pool of potential glossary
entries using only those entries, that are marked with the `gls` or `gls-add` functions in
the document. See sample-usage document for details.

⚠️ Typst is in beta and evolving, and this package evolves with it. As a result, no
backward compatibility is guaranteed yet. Also, the package itself is under development
and fine-tuning.

## Adding the package to your project

The package can either be added to your project by adding the main file `gloss-awe.typ` and
importing it, or by importing the package via the typst package manager (available from
Typst version 0.6.0 or later).

### Importing from File

```typ
    #import "gloss-awe.typ": *
```

### Importing via Typst Package Manager

```typ
    #import "@preview/gloss-awe:0.1.0"
```

### Generating the Glossary

To create the glossary, we call `make-glossary(glossary-pool)` and give it one (or more)
glossary pool(s). A complete typst document example can be found in the
[PackageReadme.md](./PackageReadme.md) file.

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

More usage samples are shown in the document [sample-usage.typ](./sample-usage.typ).

The resulting PDF is also available as [sample-usage.pdf](./sample-usage.pdf).

The folder `VSSpell` and the file `cSpell.json` are spell checker configuration files used
by VSCode.

</span>
