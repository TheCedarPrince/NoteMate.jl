function create_franklin_note(note::Note; date_format::String = "U d y")
    title = note.title
    description = note.summary
    tags = note.keywords |> x -> replace(x, "#" => "") |> split .|> String
    bibliography = note.bibliography
    references = note.references
    notes = note.notes
    slug = note.filename |> splitext |> x -> x[1]
    rss_title = title
    rss_description = description |> String |> x -> replace(x, "\"" => "'")
    rss_pubdate = note.date |> x -> DateTime(x, DateFormat(date_format)) |> yearmonthday
    keywords = note.keywords
    csl = note.csl
    bibtex = note.bibtex
    filepath = note.filepath
    FranklinNote(
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
end

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

function generate_comments()
"""
## Discussion: 

{{ addcomments }}
"""
end

function generate_table_of_contents()
"""
\nTable of Contents\n=========\n\n\\toc\n
"""
end

function generate_bibliography(note::FranklinNote)
    "\nBibliography\n==========\n\n" * note.bibliography
end

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

function generate_references(note::FranklinNote)
    "\n## References\n\n" * note.references 
end

export create_franklin_note, generate_franklin_template, generate_bibliography, generate_comments, generate_table_of_contents, generate_note_summary, generate_references
