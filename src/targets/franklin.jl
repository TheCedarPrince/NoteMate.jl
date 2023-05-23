"""
    create_franklin_note(note::Note, date_format::String="U d y")

Transform a generic NoteMate Note into a [FranklinNote](@ref) data structure with special metadata from note content.

FranklinNote require special information used to configure properties like RSS metadata. This information can be 
derived from the information in a generic NoteMate note structure. 
"""
function create_franklin_note(note::Note; date_format::String="U d y")
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

"""
    generate_franklin_template()

Translate submitted information into a multi-line string of Fraklin `+++` [page variable declarations](https://franklinjl.org/syntax/page-variables/).

Fraklin page variables may be declared as Julia expressions between a leading and trailing `+++`. This function turns
what information is submitted into individual line statements. It will return at least an empty page variable declaration
of the form 
```
+++
+++
```
if no arguments are submitted on the call. 
"""
function generate_franklin_template(; title=nothing, slug=nothing, tags=nothing, description=nothing, rss_title=nothing, rss_description=nothing, rss_pubdate=nothing)

    franklin_header = "+++\n"

    if !isempty(title)
        franklin_header = franklin_header * "title = \"$(title)\"\n"
    end

    if !isempty(slug)
        franklin_header = franklin_header * "slug = \"$(slug)\"\n"
    end

    if !isempty(tags)
        franklin_header = franklin_header * "tags = $(tags)\n"
    end

    if !isempty(description)
        franklin_header = franklin_header * "description = \"$(description)\"\n"
    end

    if !isempty(rss_title)
        franklin_header = franklin_header * "rss_title = \"$(rss_title)\"\n"
    end

    if !isempty(rss_description)
        franklin_header = franklin_header * "rss_description = \"$(rss_description)\"\n"
    end

    if !isempty(rss_pubdate)
        franklin_header = franklin_header * "rss_pubdate = Date$(rss_pubdate)\n"
    end

    franklin_header = franklin_header * "+++\n\n"

    return franklin_header
end

"""
    generate_comments

Generates a Fraklin page macro string used to embedd a comments section utility to a page.
"""
function generate_comments()
    """
    ## Discussion: 

    {{ addcomments }}
    """
end

"""
    generate_table_of_contents

Format a "Table of contents" heading and a hyperlinked table  of contents under that heading.  
"""
function generate_table_of_contents()
    """
    \nTable of Contents\n=========\n\n\\toc\n
    """
end

"""
TODO: ADD DOCS
"""
function generate_bibliography(note::FranklinNote)
    "\nBibliography\n==========\n\n" * note.bibliography
end

"""
TODO: ADD DOCS
"""
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

"""
TODO: ADD DOCS
"""
function generate_references(note::FranklinNote)
    note.references
end

function generate_citation(note::FranklinNote; citations="")

    date = Date(note.rss_pubdate...)

    if isempty(citations)

        # FIXME remove hardcoding
        page_citation = "Zelko, Jacob. _$(strip(note.title))_" * ". " * "[https://jacobzelko.com/$(note.slug)](https://jacobzelko.com/$(note.slug)). " * "$(monthname(date)) $(day(date)) $(year(date)).\n"

        return """## How To Cite\n\n $(page_citation)"""

    end

    for citation in eachrow(citations)
        if citation.filename == note.slug * ".md" && !ismissing(citation.authors)

            author = split(citation.authors[1])
            page_citation = "$(join(author[2:end])), $(author[1]); "

            for author in authors[2:end-1]
                author = split(author)
                page_citation = page_citation * "$(join(author[2:end])), $(author[1])"
            end

            author = split(authors[end])
            page_citation = page_citation * "$(join(author[2:end])), $(author[1]). "

            # FIXME remove hardcoding
            page_citation = "Zelko, Jacob. _$(strip(note.title))_" * ". " * "[https://jacobzelko.com/$(note.slug)](https://jacobzelko.com/$(note.slug)). " * "$(monthname(date)) $(day(date)) $(year(date)).\n"

            return """## How To Cite\n\n $(page_citation)"""


        else

            # FIXME remove hardcoding
            page_citation = "Zelko, Jacob. _$(strip(note.title))_" * ". " * "[https://jacobzelko.com/$(note.slug)](https://jacobzelko.com/$(note.slug)). " * "$(monthname(date)) $(day(date)) $(year(date)).\n"

            return """## How To Cite\n\n $(page_citation)"""

        end

    end
end

export create_franklin_note, generate_franklin_template, generate_bibliography, generate_comments, generate_table_of_contents, generate_note_summary, generate_references, generate_citation
