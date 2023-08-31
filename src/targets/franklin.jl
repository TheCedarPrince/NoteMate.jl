"""
    create_franklin_note(note::Note; date_format::String = "U d y")

Transform a generic `Note` into a `[FranklinNote](@ref)` data structure with special metadata from `Note` content.

# Arguments 

- `note`: a `Note` object that will be used for conversion

# Keyword Arguments 

- `date_format`: a `String` that accepts a date format; default "U d y" (see: `Dates.format` for options)

# Return 

- A newly prepared `FranklinNote` object
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

Generates a template for a Franklin markdown page.

# Keyword Arguments

- `title`: Page title. Default is `nothing`
- `slug`: Specifies web page url path (after base path). Default is `nothing` 
- `tags`: Keywords or tags associated with page. Default is `nothing` 
- `description`: Description of page contents. Default is `nothing` 
- `rss_title`: Page title that shows up on RSS feeds. Default is `nothing` 
- `rss_description`: Description that goes along with RSS updates. Default is `nothing` 
- `rss_pubdate`: Publication date for RSS feed. Default is `nothing`

These kwargs are "page variables" that come directly from `Franklin.jl`'s documentation.
For more specific details, please see [Page Variables](https://franklinjl.org/syntax/page-variables/) 

# Return

- A `String` object that contains a valid Franklin template that can then be modified further

# Example 

If the following call is made: `generate_franklin_template(; title = "All-Payer Claims Database", tags = ["apcd", "claims", "database"])`, the following string will be returned:
```
+++

title = "All-Payer Claims Database"

tags = ["zettel", "apcd", "claims", "database", "archive"]

+++

```
This can then be edited or formatted further as needed.

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
    generate_comments()

Generates a Fraklin page macro to embed a comments section into a page.

# Return 

- A string containing a Franklin macro to add comments to a Franklin page. See [Franklin Utils](https://franklinjl.org/syntax/utils/) for more information.
"""
function generate_comments()
    """
    ## Discussion: 

    {{ addcomments }}
    """
end

"""
    generate_table_of_contents()

Generate a hyperlinked *Table of Contents* for a Franklin page.

# Return 

- A string containing a Franklin macro to add a table of contents to a Franklin page. See [Table of Contents](https://franklinjl.org/syntax/markdown/index.html#table_of_contents) for more information.
"""
function generate_table_of_contents()
    """
    \nTable of Contents\n=========\n\n\\toc\n
    """
end

"""
    generate_bibliography

Generate a bibliography section for a Franklin page. 

# Arguments

- `note`: a `FranklinNote` struct whose bibliography string will be included in the output

# Return 
- a string starting with a Fraklin section header, followed after a double newline by the bibliography string stored in the note struct. 

"""
function generate_bibliography(note::FranklinNote)
    "\nBibliography\n==========\n\n" * note.bibliography
end

"""
    generate_note_summary

Generate a note summary section using note title, publishing date, rss summary and any keywords.

# Arguments

- `note`: a `FranklinNote` struct whose information is formated for the note summary section

# Return
- a string formated according to the Open Knowledge Model standard for Franklin, starting with a note title, followed by the Date in `monthname day year` form, the RSS summary of the note, and comma-separated keywords for the note.
An example formating: 
```
Example title:
=========

**Date:** May 12 2020

**Summary:** This is the summary of an example note

**Keywords:** example files, demonstration, documentation
```

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
    generate_references

Returns the references string for the note. 

# Arguments

- `note`: a `FranklinNote` struct whose references string will be included in the output

# Return 
- the note references string as is, without further formating

"""
function generate_references(note::FranklinNote)
    note.references
end

"""
    generate_citation()

Generate the citation string that can be used to reference the page of this document. 

# Arguments

- `note`: a `FranklinNote` struct whose information will be used to format the citation strings

# Keyword Arguments
- `citations` : TODO clarify type and structure here 

# Return
Return string always begin with `## How to Cite\\n\\n` followed by either:
- if the citation argument is empty, returns a standard citation string with primary author name, note title, homepage link and `monthname day year` date.
- if the citation argument is non-empty, will generate a longer citation string with list of all authors before note title, homepage link and `monthname day year` date.


FIXME: This is currently hardcoded for my own personal website. We need to adjust this to not be that way.
"""
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
