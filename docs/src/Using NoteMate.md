# Transforming Markdown Notes To a Given Target

<!--TODO: Add that we are targeting Franklin.jl-->

This workflow explains how one could parse a Markdown note to a NoteMate target and utilize the full suite of tools within NoteMate.
It is an implementation suggestion that one does not have to follow strictly but serves as a starting point in developing one's own workflow. 

## Requirements

<!--TODO: Refactor this and turn it into a separate repository that can be cloned within one's own computer for simplicity.-->

To follow this tutorial, create a separate project directory -- I will refer to it as `projdir` going forward -- on your computer, activate Julia, and add the following packages to your project:

```
TODO: we may not need CSV and DataFrames; finish tutorial and review.
pkg> add CSV@0.10.8
pkg> add Dates
pkg> add DataFrames@1.4.4
pkg> add Markdown
```

For this example, we will also be using the following sample note:

```markdown
# How Big Is a Chunk?

**Date:** January 07 2023

**Summary:** An interesting foundation for the notion of "chunking" in memory and education research

**Keywords:** #chunk #memory #bit #unit ##bibliography #archive

## Bibliography

H. A. Simon, "How Big Is a Chunk? By combining data from several experiments, a basic human memory unit can be identified and measured.," Science, vol. 183, no. 4124, pp. 482–488, 1974.

## Notes

### Reading Motivation

In reading a piece by Michael Nielsen on using spaced repetition to process mathematics [@nielsenUsingSpacedRepetition2019], he referenced a concept called "chunking".
I hadn't encountered this notion in education research before and thought it sounded interesting. 
So, thus reading the paper.

### What Are Chunks?

Loosely based on [@miller1956magical], chunks are constructs which organize and group together units of information input into memory.
These inputs can be of any form and the basic units could be things like phonemes in words, moves in chess, etc. that can then be recalled at once (a Bible verse, a Sicilian Defense, etc.).
The material stored in a chunk is independent of how many chunks can be generated.

### Benefits of Chunk Generation

The memory span seems to be constrained by a fixed number of chunks (although this number varies wildly in the paper). 
However, we can increase the information stored in memory by increasing the number of units belonging to each chunk.
[@miller1956magical]

As regaled by Simon, an example of chunking in action is this:

> I tried to recall after one reading the following list of words: Lincoln, milky, criminal, differential, address, way, lawyer, calculus, Gettysburg. I had no success whatsoever. I should not have expected success, for the list exceeded my span of six or seven words. Then I rearranged the list a bit, as follows:
> 
> - Lincoln's Gettysburg Address
> - Milky Way 
> - Criminal Lawyer 
> - Differential Calculus
>
> I had no difficulty at all

The variance between chunks and memory can be attributed to larger chunk sizes based on one's expertise with a material. [@chase1973mind, @simon1973american]

## References:

```

Save this note inside of `projdir` as `note.md` and we are ready to build our workflow.

## Pre-Processing of a Markdown Note

To process this note into a NoteMate understandable object, NoteMate provides a series of tools to make some of the rudimentary parsing easier.
To get started, we will read this file as a `String`:

```julia
note = read("note.md", String)
```

The reason why we read this as a `String` is so that we can do pattern matching to apply various transformations to the raw representation of the note.

### Generating Citations

Let's first extract and replace the citation keys present within this note with their correct inline citations:

```julia
# See Steps 1 & 2
citation_keys = find_citation_groups(note) 

# See Steps 3 & 4
inline_citations_dict = create_inline_citations(citation_keys, "refs.bib", "ieee.csl")

# See Step 5
note = replace(note, inline_citations_dict...)
```

Here is what this code block does: 

1. Find all the citation groups within the `String` using [`find_citation_groups()`](@ref).
This returns a vector with all the unique citation groups found within the `String`.
2. Store this result in the `citation_keys` variable.
3. Define the actual inline reference representation for the found citation keys using [`create_inline_citations()`](@ref).
This function utilizes `refs.bib` to map the citation keys found in the `String` to the correct reference information.
Once each key's reference information was found, the `ieee.csl` file defines how the inline citation should appear within the final note.
4. Store this mapping within `inline_citations_dict` 
5. Now, we replace all respective citation groups with their appropriate inline citation.

> **NOTE: What Will Inline Citations Look Like?** As we are using the IEEE CSL format, citation groups that look like this: `[@chase1973mind, @simon1973american]` will be rendered to look something like this in the document `[3, 4]`.

### Updating Link Paths

Next, let's scan the document for any links and see which one are relative links.

> **NOTE: What Is a Relative Link?** These are links that are made within a document that references another note or object within the same directory as the initial document. 
> We want to preserve these relationships as they are transformed so as to not lose this information in an eventual deployment.

To do this, we will use the following code snippet:

```julia
# See Steps 1 & 2
markdown_links = find_markdown_links(note, group_links = true)

# See Steps 3 & 4
relative_links_dict = create_relative_links(markdown_links["relative_links"]; prefix="https://jacobzelko.com/")

# See Steps 5
note = replace(note, relative_links_dict...)
```

To accomplish this, we will use the following process:

1. Find all markdown links in a `String` using [`find_markdown_links()`](@ref).
By setting the keyword argument, `group_links = true`, a dictionary of vectors is returned that defines web links (links that link to somewhere on the internet), anchor links (links that jumps to a specific place in a document) or relative links.

2. Store links within `markdown_links`.

<!--TODO: Add in a prefix for this tutorial-->
3. Using `markdown_links`, we can use the [`create_relative_links()`](@ref), to update or finalize relative links that were found before deployment to a target output.

4. Store this mapping within `relative_links_dict`.

5. Finally, we replace all relative links with their newly updated path.

## Processing an OKM Note by Each Component

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

