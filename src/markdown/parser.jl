import Markdown:
    plain, 
    Header
using pandoc_jll

"""
Given text and a regular expression that matches a citation group (e.g. pandoc, etc.), extract and return a vector of citation groups from within that text.

## Arguments

- `text::String` - text to be processed

## Keyword Arguments

- `key_regex::Regex` - regular expression to capture citation groups; default captures citation key groups of the form, `[@citation]` or `[@citation_1; @citation_2]`

## Returns

- Vector of strings with captured citation key groups

"""
function find_citation_groups(text::String; key_regex::Regex=r"\[(@.*?)\]")
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
        read(pipeline(`echo $(yaml_header * join(citation_groups, "\n"))`, `$(pandoc_bin) --citeproc --bibliography=$(bibtex_path) -f markdown -t plain --wrap=preserve --csl=$(csl_path)`), String) |> strip
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

- `key_regex::Regex` - regular expression to capture markdown links; default captures markdown links of the form, `[linked text](https:://duckduckgo.com)`

- `group_links::Bool` - a boolean that determines if the function should try to determine what kind of link a markdown link is (e.g. a website link, a relative file link, etc.) and returns a dictionary instead of a vector with only the links

## Returns

- Vector of strings with captured markdown links 
"""
function find_markdown_links(text::String; key_regex::Regex=r"\[([^\[]+)\](\(.*\))", group_links=false)
    markdown_links = join(collect(eachmatch(key_regex, text)) .|> x -> x.match, "\n")

    if group_links
        web_links = filter!(x -> contains(x, "http"), markdown_links)
        anchor_links = filter!(x -> contains(x, "](#"), markdown_links)
        relative_links = markdown_links
        return Dict("web_links" => web_links, "anchor_links" => anchor_links, "relative_links" => relative_links)
    else
        return split(markdown_links, "\n")
    end
end

"""
Given a list of strings denoting a markdown link of the form `[text](link)`, update the link to a relative link format.

## Arguments

- `link_strings::Vector` - markdown links to be processed

## Keyword Arguments

- `prefix::String` - a prefix to add to each link; default is `""`

## Returns

- Dict with keys as the original markdown links and values as their corresponding revised relative links 
"""
function create_relative_links(link_strings; prefix = "")
    revised_links = []
    for link in link_strings
        replace(link, "](" => "]($prefix") |> 
        text -> push!(revised_links, text)
    end
    return Dict(link_strings .=> revised_links)
end

function get_headers(contents)
    filter(x -> typeof(x) <: Header, contents)
end

function get_sections(contents, headers; name_sections = true)
    sections = []
    section_names = []
    for header in headers
        record = false
        section = []
        for item in contents
            if record == true && typeof(item) <: Header{2}
                break
            elseif record == true
                push!(section, item)
            elseif item == header
                push!(section, header)
                record = true
            end
        end
        push!(sections, section)
        push!(section_names, header)
    end
    if name_sections
        section_names = section_names .|> x -> replace(x |> plain, r"[^a-zA-Z\d\s]" => "") |> strip |> split |> first
        return Dict(section_names .=> sections)
    else
        return sections
    end
end

function get_title_section(contents, title_header; name_sections = true)
    sections = []
    section_names = []
    for header in title_header
        record = false
        section = []
        for item in contents
            if record == true && typeof(item) <: Header{2}
                break
            elseif record == true
                push!(section, item)
            elseif item == header
                push!(section, header)
                record = true
            end
        end
        push!(sections, section)
        push!(section_names, header)
    end
    if name_sections
        return Dict("Title" => sections[1])
    else
        return sections
    end
end

export find_citation_groups, create_inline_citations, create_references, find_markdown_links, create_relative_links, get_headers, get_sections, get_title_section
