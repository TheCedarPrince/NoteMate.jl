import Markdown:
    Header,
    parse,
    plain
using pandoc_jll
using NoteMate

#################################################################
# List Constants
#################################################################

file_path = "/home/src/Knowledgebase/Zettelkasten/01202021043643-mobility-network-models.md"
csl_path = "/home/cedarprince/.pandoc/ieee.csl"
bibtex_path = "/home/src/Knowledgebase/Zettelkasten/zettel.bib"

#################################################################
# Read in file
#################################################################

file = read(file_path, String)

######################################################################################
# Creating references note component
######################################################################################

#################################################################
# Check file for pandoc references 
#################################################################

citation_keys = join(collect(eachmatch(r"\[(@.*?)\]", file)) .|> x -> x.match, "\n")

#################################################################
# Replace pandoc references with inline citations in file
#################################################################

if !isempty(citation_keys)
    yaml_header = """---\nsuppress-bibliography: true\n---\n\n"""

    citation_values = pandoc() do pandoc_bin
        read(pipeline(`echo $(yaml_header * citation_keys)`, `$(pandoc_bin) --citeproc --bibliography=$(bibtex_path) -f markdown -t plain --wrap=preserve --csl=$(csl_path)`), String)
    end

    citation_dict = Dict(split(citation_keys, "\n") .=> split(citation_values, "\n")[1:end-1])

    file = replace(file, citation_dict...)
end

#################################################################
# Build note references section
#################################################################

if !isempty(citation_keys)
    raw_references = pandoc() do pandoc_bin
        read(pipeline(`echo $(citation_keys)`, `$(pandoc_bin) --citeproc --bibliography=$(bibtex_path) -f markdown -t plain --wrap=preserve --csl=$(csl_path)`), String)
    end
    references = split(raw_references, "\n\n")[2:end] |> x -> x .* "\n" |> x -> join(x, "\n")
else 
    references = missing
end

#################################################################
# Find all markdown links in file
#################################################################

markdown_link_keys= collect(eachmatch(r"\[([^\[]+)\](\(.*\))", file)) 

#################################################################
# Create proper relative links to other webpages
#################################################################

if !isempty(markdown_link_keys)

    markdown_link_values = []
    for link in markdown_link_keys
        link_content = "[$(link.captures[1])]"
        link_url = "(/" * link.captures[2][2:end-4] * ")"
        website_link = link_content * link_url
        push!(markdown_link_values, website_link)
    end

    markdown_links_dict = Dict((markdown_link_keys .|> x -> x.match) .=> markdown_link_values)

    file = replace(file, markdown_links_dict...)

end

#################################################################
# Parse file contents back into Markdown object
#################################################################

parsed_file = parse(file)

######################################################################################
# Parsing note markdown to Julia objects
######################################################################################

#################################################################
# Get note headers
#################################################################

function getheaders(contents)
    filter(x -> typeof(x) <: Header, contents)
end

file_headers = getheaders(parsed_file.content) |> x -> filter(y -> typeof(y) <: Header{2} || typeof(y) <: Header{1}, x)

#################################################################
# Get note sections
#################################################################

function getsections(contents, headers)
    sections = []
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
    end

    return sections

end

file_sections = getsections(parsed_file.content, file_headers)

#################################################################
# Parsing to specific note sections
#################################################################

title_section = file_sections[1]
bibliography_section = file_sections[2][2] |> plain
notes_section = file_sections[3] |> plain
references_section = file_sections[4] |> plain

######################################################################################
# Getting Title, Date, Summary, and Keywords from title section
######################################################################################

#################################################################
# Find title 
#################################################################

title = title_section[1].text[1]

#################################################################
# Find date 
#################################################################

date = title_section[2].content[2] |> strip

#################################################################
# Find summary
#################################################################

summary = title_section[3].content[2] |> strip

#################################################################
# Find keywords
#################################################################

keywords = title_section[4].content[2] |> strip

######################################################################################
# Build Note object for file
######################################################################################

test_note = Note(title, date, summary, keywords, bibliography_section, references, notes_section, basename(file_path), file_path, csl_path, bibtex_path)
