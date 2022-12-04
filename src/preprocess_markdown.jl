import Markdown:
    Header,
    parse,
    plain
using pandoc_jll
using NoteMate

file_path = "/home/src/Knowledgebase/Zettelkasten/05252020211350-hard-on-self.md"
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

######################################################################################
# Converting markdown links to website links
######################################################################################

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
