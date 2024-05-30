// Copyright 2023 Rolf Bremer, Jutta Klebe


// Extracts (nested) content or text to content
#let content-as-text( element, sep: "" ) = {
    if type(element) == "content" {
        if element.has("text") {
            element.text
        } else if element.has("children") {
            element.children.map(text).join(sep)
        } else if element.has("child") {
            content-as-text(element.child)
        } else if element.has("body") {
            content-as-text(element.body)
        } else {
            element
        }
    } else if type(element) in ("array", "dictionary") {
        return ""
    }
    else if element == none {
        return element
    }
    else {
        str(element)
    }
}

// gls[term]: Marks a term in the document as referenced.
// gls(glossary-term)[term]: Marks a term in the document as referenced with a
// different expression ("glossary-term") in the glossary.
#let gls(entry: none, showmarker: m => m, display) = locate(loc => [
    #showmarker(display)
    #metadata((
        location: loc.position(),
        entry: content-as-text(entry),
        display: display
    ))<jkrb-gloss-awe>
])

// Add a keyword to the glossary, even if it is not in the documents content.
#let gls-add(entry) = locate(loc => [
    #metadata((
        location: loc.position(),
        entry: content-as-text(entry),
    ))<jkrb-gloss-awe>
])


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

    // The glossary data.
    ..glossaries

    ) = {

    let get-title(glossmeta) = {
        return if glossmeta.value.entry == none { glossmeta.value.display.text } else { glossmeta.value.entry }
    }

    let lookup(key, glossaries) = {
        let entry = none
        for glossary in glossaries.pos() {
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
            if get-title(e) not in excluded {
                elements.push(e)
            }
        }

        // extract the titles
        let titles = elements.map(e => get-title(e)).sorted(key: sort-key)
        for t in titles {
            if words.contains(t) { continue }
            words.push(t)
            heading(t)
            let e = lookup(t, glossaries)
            if e != none {
                e.description
                if e.keys().contains("link") {
                    e.link
                }
            } else {
                missing
            }
        }
    })
}

