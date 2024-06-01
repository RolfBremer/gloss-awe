// Copyright 2023 Rolf Bremer, Jutta Klebe


// Extracts (nested) content or text to content
#let content-as-text( element, sep: "" ) = {
    if element == none {
        return none
    }

    let elementtype = type(element)
    if elementtype in (array, dictionary, smartquote) {
        return none
    }

    if elementtype == content {
        if element.has("text") {
            element.text
        // } else if element
        } else if element.has("children") {
            element.children.map(c => {
                content-as-text(c, sep: sep)
            }).join(sep)
        } else if element.has("body") {
            content-as-text(element.body)
        } else {
            none
        }
    } else {
        str(element)
    }
}

// gls[term]: Marks a term in the document as referenced.
// gls(glossary-term)[term]: Marks a term in the document as referenced with a
// different expression ("glossary-term") in the glossary.
#let gls(entry: none, showmarker: m => m, display) = locate(loc => {
    if showmarker != none { showmarker(display) }
    let md = metadata((
        location: loc.position(),
        entry: content-as-text(entry),
        display: display
    ))
    [#md<jkrb-gloss-awe>]
})

// Add a keyword to the glossary, even if it is not in the documents content.
#let gls-add = gls.with(showmarker: none)


// This function creates a glossary page with entries for every term
// in the document marked with `gls[term]`.
#let make-glossary(
    // Indicate missing entries.
    missing: text(fill: red, weight: "bold")[ No glossary entry ],

    // Function to format the Header of the entry.
    heading: it => { heading(level: 2, numbering: none, outlined: false, it)},

    // This array contains entry titles to exclude from the generated glossary page.
    excluded: (),

    // Function used to sort by.
    sort-key: k => k,

    // If set to true, the missing entries will be suppressed.
    suppress-missing: false,

    // The glossary data.
    ..glossaries

    ) = {

    let get-str-title(glossmeta) = {
        let val = glossmeta.value
        return if val.entry == none {
            if type(val.display) == str {
                (display: val.display, entry: val.display)
            }
            else {
                (display: val.display, entry: content-as-text(val.display))
            }
        } else {
            if type(val.entry) == str {
                (display: val.display, entry: val.entry)
            }
            else {
                (display: val.display, entry: content-as-text(val.entry))
            }
        }
    }

    let lookup(key, glossaries) = {
        let entry = none
        for glossary in glossaries.pos() {
            // Skip empty glossary pools
            if glossary == none or glossary.len() == 0 { continue }

            if glossary.keys().contains(key) {
                let entry = glossary.at(key)
                return entry
            }
        }
        return entry
    }

    locate(loc => {
        let words = ()  //empty array

        // find all marked elements
        let all-elements = query(<jkrb-gloss-awe>, loc)

        // only use the not hidden elements
        let elements = ()
        for e in all-elements {
            if get-str-title(e) not in excluded {
                elements.push(e)
            }
        }

        // extract the titles
        let titles = elements.map(e => get-str-title(e)).sorted(key: e => sort-key(e.entry))
        for t in titles {
            // Skip doubles
            if words.contains(t.entry) { continue }

            words.push(t.entry)
            heading(t.display)
            let e = lookup(t.entry, glossaries)
            if e != none {
                e.description
                if e.keys().contains("link") {
                    e.link
                }
            } else {
                if not suppress-missing { missing }
            }
        }
    })
}

