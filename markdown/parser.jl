using pandoc_jll

"""
Given text and a regular expression that matches a citation group (e.g. pandoc, etc.), extract and return a vector of citation groups from within that text.

## Arguments

- `text::String` - text to be processed

## Keyword Arguments

- `key_regex::Regex` - regular expression to capture citation groups; default: `r"\[(@.*?)\]"` which captures citation key groups of the form, `[@citation]` or `[@citation_1; @citation_2]`

## Returns

- Vector of strings with captured citation key groups

"""
function find_citation_groups(text::String; key_regex::Regex = r"\[(@.*?)\]")
        citation_groups = join(collect(eachmatch(key_regex, text)) .|> x -> x.match, "\n")
        return split(citation_groups, "\n")
end

"""
Given a list of citation key groups, create inline citations based on a given CSL and a bibliography provided in bibtex.

## Arguments

- `citation_groups::Vector{String}` - a vector of strings containing citation key groups 

- `bibtex_path::String` - path to a bibliography (`.bib` format supported)

- `csl_path::String` - path a a CSL standard (i.e. `.csl` format)

## Returns

- Dict with keys as the original citation groups and values as their corresponding inline citation
"""
function create_inline_citations(citation_groups, bibtex_path, csl_path) 
    yaml_header = """---\nsuppress-bibliography: true\n---\n\n"""

    inline_citations = pandoc() do pandoc_bin
        read(pipeline(`echo $(yaml_header * citation_groups)`, `$(pandoc_bin) --citeproc --bibliography=$(bibtex_path) -f markdown -t plain --wrap=preserve --csl=$(csl_path)`), String) |> strip
    end

    return Dict(citation_groups .=> split(inline_citations, "\n"))
end

"""
Given a list of citation key groups, create a reference list based on a given CSL and a bibtex bibliography. 

## Arguments

- `citation_groups::Vector{String}` - a vector of strings containing citation key groups 

- `bibtex_path::String` - path to a bibliography (`.bib` format supported)

- `csl_path::String` - path a a CSL standard (i.e. `.csl` format)

## Returns

- String containing an ordered reference list 
"""
function create_references(citation_groups, bibtex_path, csl_path) 
    raw_references = pandoc() do pandoc_bin
        read(pipeline(`echo $(citation_groups)`, `$(pandoc_bin) --citeproc --bibliography=$(bibtex_path) -f markdown -t plain --wrap=preserve --csl=$(csl_path)`), String)
    end
    return split(raw_references, "\n\n")[2:end] |> x -> x .* "\n" |> x -> join(x, "\n") 
end

"""
Given text and a regular expression that matches a markdown link, extract and return a vector of markdown links from within that text.

## Arguments

- `text::String` - text to be processed

## Keyword Arguments

- `key_regex::Regex` - regular expression to capture markdown links; default: `r"\[(@.*?)\]"` which captures markdown links of the form, `[linked text](https:://duckduckgo.com)`

## Returns

- Vector of strings with captured markdown links 
"""
function find_markdown_links(text::String; key_regex::Regex = r"\[([^\[]+)\](\(.*\))")
        markdown_links = join(collect(eachmatch(key_regex, text)) .|> x -> x.match, "\n")
        return split(markdown_links, "\n")
end

function create_relative_links(citation_groups, bibtex_path, csl_path) 
    raw_references = pandoc() do pandoc_bin
        read(pipeline(`echo $(citation_groups)`, `$(pandoc_bin) --citeproc --bibliography=$(bibtex_path) -f markdown -t plain --wrap=preserve --csl=$(csl_path)`), String)
    end
    return split(raw_references, "\n\n")[2:end] |> x -> x .* "\n" |> x -> join(x, "\n") 
end
