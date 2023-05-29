"""
TODO: ADD DOCS
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
TODO: ADD DOCS
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
TODO: ADD DOCS
"""
function generate_comments()
    """
    ## Discussion: 

    {{ addcomments }}
    """
end

"""
TODO: ADD DOCS
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

            page_citation = "Zelko, Jacob. _$(strip(note.title))_" * ". " * "[https://jacobzelko.com/$(note.slug)](https://jacobzelko.com/$(note.slug)). " * "$(monthname(date)) $(day(date)) $(year(date)).\n"

            return """## How To Cite\n\n $(page_citation)"""


        else

            page_citation = "Zelko, Jacob. _$(strip(note.title))_" * ". " * "[https://jacobzelko.com/$(note.slug)](https://jacobzelko.com/$(note.slug)). " * "$(monthname(date)) $(day(date)) $(year(date)).\n"

            return """## How To Cite\n\n $(page_citation)"""

        end

    end
end

export create_franklin_note, generate_franklin_template, generate_bibliography, generate_comments, generate_table_of_contents, generate_note_summary, generate_references, generate_citation
