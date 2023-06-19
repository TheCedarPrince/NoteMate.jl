"""
Struct representing a note in Zettelkasten

The generic Open Knowledge Model note with its key structures, isolated as single strings and some further metadata in appropiate 
types. Within the constraints of NoteMate this is the generic type to which any note from any specific format parses down, and from 
which other note structures for representation targets are build using templating functions.
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
    FranklinNote
    
Struct representing a `Note` to be deployed to a Franklin website.

A `note` headed for expression as a Franklin markdown and then a webpage requires additional metadata demanded by Franklin to 
    execute the whole conversion, including information for the RSS feed.
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
