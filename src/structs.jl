"""
Struct representing a note in Zettelkasten
"""
struct Note
    title::Any
    date::Any
    summary::Any
    keywords::Any
    bibliography::Any
    references::Any
    notes::Any
    filename::Any
    filepath::Any
    csl::Any 
    bibtex::Any
end

"""
Struct representing a `Note` to be deployed to a Franklin website
"""
struct FranklinNote
    title::Any # Note.title
    description::Any # Note.summary
    tags::Any # Note.keywords
    bibliography::Any # Note.bibliography
    references::Any # Note.references
    notes::Any # Note.notes
    slug::Any # Note.filename
    rss_title::Any # Note.title
    rss_description::Any # Note.summary
    rss_pubdate::Any # Note.date
    keywords::Any
    csl::Any #Note.csl
    bibtex::Any # Note.bibtex
    filepath::Any # Note.filepath
end

export Note, FranklinNote
