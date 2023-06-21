# Using NoteMate

NoteMate at its heart is a toolbox first, and a workflow second. NoteMate is designed to be flexible enough so that you can adapt it to your note structure and output targets while supporting the Open Knowledge Model. 

NoteMate is made up of three major sections: parser functions, intermediate structures, and output formaters. 

## Parsing
Represented by the appropiate [`parser.jl`](@ref) file, the first step to turning your notes into another format is finding the information OKM requires from the full Markdown document. 

The first step is to select all the notes you wish to transform. This is open to you. A classical implementation may be to find all the documents in a particular folder on your system, but more elaborate selection scripts might be used. That said, it is helpful to store candidate documents in a specific folder even if your selection is more advanced, for debugging and safety purporses. 

Once you have your notes selected, use [`read(io::IO, String)`](ref) to turn your documents into String objects. 

### Pre-processing 
Raw Markdown files may want to be pre-processed in their content before they are cut apart. 

#### Pre-processing citations
Citation keys in standard OKM are defined as Markdown links with no anchor of the form:
```
[@exampleCitation]
```
The text within should match a citation key in your `.bib` file. If you want to cite multiple sources in the same link, separate them with `;`
```
[@exampleCitationa, @exampleCitationb]
```
Replacement is a two-step process. 
1. find all the citation groups in the String using [`find_citation_groups()`](@ref), and store the returned Vector for use in building your references section. 
2. use [`create_inline_citations()`](@ref) to generatu for the citation groups, simple numerical placeholders.

Then use [`replace()`](@ref) with the two data structures for processing the string with your new inserts. 

#### Pre-processing links to other documents
Links to other documents may require custom processing for the structure of your target format, especially web pages. For these cases, you have another two functions available. 

1. Find all the links in the file using [`find_markdown_links()`](@ref) to isolate a vector of aoll the markdown links in your file. By setting the `group_links` keyword argument, you can get a dictionary with vectors for web links (link target contains the `http` substring), anchor links (the link target stats with a `#`) or relative links (all other links)
2. Use the vector of all links and the `prefix` keyword argument with [`create_relative_links()`](@ref), to extend all relative links in the document with the string prefix you specify. 

Again, use [`replace()`](@ref) with the two data structures for processing the string with your new inserts. 

### Structured processing 
With pre-processing complete, you can start cutting the document apart using its Markdown structure. 

Use [`Markdown.parse()`](@ref) to generate a parsed representation of the document string you have worked with so far. 

After that, you can start processing. NoteMate offers some utility functions. 

[`get_headers()`](@ref) finds all the Markdown headers in the file structure. You can discriminate the level of the headers by checking for type: `Header{1}` is the type of a level 1 header as produced by a single `#` 

You can use filters and regex matches to create a beginning-to-end vector of headings you want to use to split the document. 

Then you can invoke [`get_sections()`](@ref). This function will take your vector and cut the document apart with all text between each heading isolated as one section. You can preserve the section titles for matching when composing the output file.

A similar function is [`get_title_section()`](@ref), which can isolate the single section under the first `Header{1}` and the subsequent text until the first next header. 

Lastly, you can create the [`create_references()`](@ref) function to consume the citation groups vector you produced during the pre-processing and generate a matching full-format references section. 

## Populate structured note
With the note processed using the parsing utility function, you can populate your [`Note`](@ref) struct with the information you have pulled from the note so far, producing the OKM-complient intermidiate format. Use filtering by string contents in section titles and other such structures you know, or your own functions, to set all the information in the struct. 

## Producing an output
With the note parsed into the OKM-complient intermediary, you can now target an OKM-compliant expression in another formating.

### `Franklin.jl` target
For formatting a `Franklin.jl`-compliant markdown, you have the functions of [`franklin.jl`](@ref). Notes are formated top to bottom. 

The foundation of a Franklin note formating is the [`FranklinNote`](@ref) struct. Generate this struct using the [`create_franklin_note()`](@ref), which will automatically derive the other information needed for a Franklin document from a normal NoteMate note struct. 

Then, start generating your page string. 

Use [`generate_franklin_template()`](@ref) to generate the initial page stup with the Franklin metadata. 

Then concatenate the rest of your page content, like so: 
```Julia
page = page * generate_note_summary(franklin_note)
page = page * generate_bibliography(franklin_note)
page = page * generate_table_of_contents()
page = page * franklin_note.notes
page = page * generate_citation(franklin_note; citations = authors)
page = page * generate_references(franklin_note)
page = page * generate_comments()

```

And write the resulting string to a markdown file at your Franklin destination path. 

