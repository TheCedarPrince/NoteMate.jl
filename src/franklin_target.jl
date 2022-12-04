import Markdown:
    plain
using Dates
using pandoc_jll
using NoteMate

######################################################################################
# Construct `FranklinNote` from generic `Note`
######################################################################################

#################################################################
# Load `Note`
#################################################################

note = test_note

#################################################################
# Construct title
#################################################################

title = note.title

#################################################################
# Construct description
#################################################################

description = note.summary

#################################################################
# Construct tags
#################################################################

tags = note.keywords |> x -> replace(x, "#" => "") |> split .|> String

#################################################################
# Construct bibliography
#################################################################

bibliography = note.bibliography

#################################################################
# Construct references
#################################################################

references = note.references

#################################################################
# Construct notes
#################################################################

notes = note.notes

#################################################################
# Construct slug
#################################################################

slug = note.filename |> splitext |> x -> x[1]

#################################################################
# Construct rss_title
#################################################################

rss_title = title

#################################################################
# Construct rss_description
#################################################################

rss_description = description |> String |> x -> replace(x, "\"" => "'")

#################################################################
# Construct rss_pubdate
#################################################################

rss_pubdate = note.date |> x -> DateTime(x, DateFormat("U d Y")) |> yearmonthday

#################################################################
# Construct keywords
#################################################################

keywords = note.keywords

#################################################################
# Construct csl
#################################################################

csl = note.csl

#################################################################
# Construct bibtex
#################################################################

bibtex = note.bibtex

#################################################################
# Construct filepath
#################################################################

filepath = note.filepath

#################################################################
# Construct final `FranklinNote`
#################################################################

fnote = FranklinNote(
    title,
    description,
    tags,
    bibliography,
    references,
    notes,
    slug,
    rss_title,
    rss_description,
    rss_pubdate,
    keywords,
    csl,
    bibtex,
    filepath
)

######################################################################################
# Build Franklin webpage from `FranklinNote` 
######################################################################################

#################################################################
# Layout Franklin template using Franklin variables
#################################################################

function generate_franklin_template(note::FranklinNote)
"""
@def title = "$(note.title)"
@def slug = "$(note.slug)"
@def tags = $(note.tags)
@def description = "$(note.description)"

@def rss_title = "$(note.rss_title)"
@def rss_description = "$(note.rss_description)"
@def rss_pubdate = Date$(note.rss_pubdate)
"""
end

#################################################################
# Add comments service and discussion section 
#################################################################

function generate_comments()
"""
## Discussion: 

{{ addcomments }}
"""
end

#################################################################
# Generate Franklin table of contents
#################################################################

function generate_table_of_comments()
"""
\nTable of Contents\n=========\n\n\\toc\n
"""
end

#################################################################
# Generate bibliography section
#################################################################

function generate_bibliography(note::FranklinNote)
    "\nBibliography\n==========\n\n" * note.bibliography
end

#################################################################
# Generate summary section for note
#################################################################

function generate_note_summary(note::FranklinNote)
        date = Date(note.rss_pubdate...)

"""\n
$(note.title)
=========

**Date:** $(monthname(date)) $(day(date)) $(year(date))

**Summary:** $(note.rss_description)

**Keywords:** $(note.keywords)
"""
end

#################################################################
# Generate summary section for note
#################################################################

function generate_references(note::FranklinNote)
    "\n## References\n\n" * note.references 
end

#################################################################
# Franklin webpage construction
#################################################################

page = ""
page = page * generate_franklin_template(fnote)
page = page * generate_note_summary(fnote)
page = page * generate_bibliography(fnote)
page = page * generate_table_of_comments()
page = page * fnote.notes
page = page * generate_references(fnote)
page = page * generate_comments()

#################################################################
# Franklin output page
#################################################################

write(page, "$note_path/$(fnote.slug * ".md")")
