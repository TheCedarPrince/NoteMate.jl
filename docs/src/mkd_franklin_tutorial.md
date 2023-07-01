# Transforming Markdown Notes To a Given Target ⚗️

This workflow explains how one could parse a Markdown note to a NoteMate target and utilize the full suite of tools within NoteMate.
In this tutorial, we will take a Markdown note to a Franklin.jl target output note.
It is an implementation suggestion that one does not have to follow strictly but serves as a starting point in developing one's own workflow. 

## Requirements 🚨

To follow this tutorial, create a separate project directory -- I will refer to it as `projdir` going forward -- on your computer, activate Julia, and add the following packages to your project:

```
pkg> add Dates
pkg> add Markdown
pkg> add NoteMate
```

Now, we need to copy four files into `projdir` from the [Appendix](#Appendix):

- [Sample Note](#Sample-Note) - copy the content in this file and put it into a file called `note.md` within `projdir`.

- [IEEE CSL](#IEEE-CSL) - copy the content in this file and put it into a file called `ieee.csl` within `projdir`.

- [BibTeX References](#BibTeX-References) - copy the content in this file and put it into a file called `refs.bib` within `projdir`.

- [Processing Script](#Full-Script) - copy the content in this file and put it into a file called `script.jl` within `projdir`.

Once you have copied these files into the `projdir`, we are ready to go!
The following steps will guide you through different pieces of `script.jl` and how NoteMate works in supporting note processing workflows. 
At any point, you can run the full script within `projdir` to test it out.

## Pre-Processing of a Markdown Note 🚧

To process this note into a NoteMate understandable object, NoteMate provides a series of tools to make some of the rudimentary parsing easier.
To get started, we will read this file as a `String`:

```julia
note = read("note.md", String)
```

The reason why we read this as a `String` is so that we can do pattern matching to apply various transformations to the raw representation of the note.

### Generating Citations 📚

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

### Updating Link Paths 🏔️

Next, let's scan the document for any links and see which one are relative links.

> **NOTE: What Is a Relative Link?** These are links that are made within a document that references another note or object within the same directory as the initial document. 
> We want to preserve these relationships as they are transformed so as to not lose this information in an eventual deployment.

To do this, we will use the following code snippet:

```julia
# See Steps 1 & 2
markdown_links = find_markdown_links(note, group_links = true)

# See Steps 3 & 4
relative_links_dict = create_relative_links(markdown_links["relative_links"])

# See Steps 5
note = replace(note, relative_links_dict...)
```

To accomplish this, we will use the following process:

1. Find all markdown links in a `String` using [`find_markdown_links()`](@ref).
By setting the keyword argument, `group_links = true`, a dictionary of vectors is returned that defines web links (links that link to somewhere on the internet), anchor links (links that jumps to a specific place in a document) or relative links.

2. Store links within `markdown_links`.

3. Using `markdown_links`, we can use the [`create_relative_links()`](@ref), to update or finalize relative links that were found before deployment to a target output.

4. Store this mapping within `relative_links_dict`.

5. Finally, we replace all relative links with their newly updated path.

## Processing an OKM Note by Each Component 🛠️

With pre-processing complete, we can now start ingesting the specifics of the note into OKM components.
In particular, we will ingest the following components:

- **Title Block** - this is a unique block that begins with the name of the note followed by three required subcomponents:

	- **Date** - the date the note was created

	- **Summary** - a brief, single sentence summary of what this note is about

	- **Keywords** - keywords that can be used to find or associated with the content of this note

- **Bibliography Block** - this contains the bibliographic information that is associated with the specific note 

- **Notes** - where one's notes go on the note subject in whatever format one so chooses

- **References** - list of references used in the note

To start, we use `Markdown.parse()` to generate a parsed representation of the `note` to turn it into a Julia-understandable Markdown representation:

```julia
parsed_note = Markdown.parse(note)
```

From there, the `note` can be parsed readily as a Julia Markdown object.
NoteMate offers some utility functions to help with this parsing as shown below:

```julia
note_headers = get_headers(parsed_note.content)
title_header = filter(x -> typeof(x) <: Header{1}, note_headers)
section_headers = filter(x -> typeof(x) <: Header{2}, note_headers)

sections = get_sections(parsed_note.content, section_headers; name_sections=true)
title_section = get_title_section(parsed_note.content, title_header; name_sections=true)
references_section = create_references(citation_keys, bibtex_path, csl_path)
note_sections = merge!(sections, title_section)
note_sections["References"] = (note_sections["References"][1] |> plain) * "\n" * references_section |> parse |> x -> x.content

title_section = note_sections["Title"]
bibliography_section = note_sections["Bibliography"][2] |> plain
notes_section = note_sections["Notes"][2:end] |> plain
references_section = note_sections["References"] |> plain

title = title_section[1].text[1] |> x -> replace(x, "\"" => "'")
date = title_section[2].content[2] |> strip
summary = title_section[3].content[2] |> strip |> x -> replace(x, "\"" => "'")
keywords = title_section[4].content[2] |> strip
```

In lieu of explaining all particulars here, here is the general process in how this code block works:

- [`get_headers()`](@ref) finds all the Markdown headers in the `parsed_note` structure.

- [`get_sections()`](@ref) will further parse available headers and cut the document apart with all text between each heading isolated as one section.

- [`get_title_section()`](@ref), gets the single section under the first `Header{1}` and allows it to be parsed into multiple OKM components. 

- [`create_references()`](@ref) uses the function to generate full references for a note's reference component using the `citation_keys` variable generated earlier. 

- A combination of various filters are then used to do additional component splitting and parsing to ingest all needed information into the required OKM components.

Then, we can create a NoteMate [`Note`](@ref) object:

```julia
note = Note(title, date, summary, keywords, bibliography_section, references_section, notes_section, basename("notes.md"), "notes.md", "ieee.csl", "refs.bib")
```

> **NOTE: Note parsing seems too fragile?** If you noticed that parsing this note into each component seemed brittle or too fragile, this is both a strength and a weakness of the OKM.
> The OKM is flexible enough to allow one to implement the OKM however way they want which gives a lot of flexibility to usage.
> However, it comes at the cost that any implementation will need to be parsed according to the way it was implemented into a NoteMate [`Note](@ref)`.

## Targeting Franklin.jl as an Output Target 🎯

With the note parsed into an OKM [`Note`](@ref) object, we can now use NoteMate tools to create a Franklin.jl compliant output. 
We use [`create_franklin_note()`](@ref) to created a [`FranklinNote`](@ref) object that is used by NoteMate and [`generate_franklin_template()`](@ref) to generate the initial page set-up with necessary Franklin specific syntax mark-up:

```julia
franklin_note_raw = create_franklin_note(note)

franklin_note = ""
franklin_note = franklin_note * generate_franklin_template(title=franklin_note_raw.title, slug=franklin_note_raw.slug, tags=franklin_note_raw.tags, description=franklin_note_raw.description, rss_title=franklin_note_raw.rss_title, rss_description=franklin_note_raw.rss_description, rss_pubdate=franklin_note_raw.rss_pubdate)
```

From here, NoteMate provides a variety of tools that accept a `FranklinNote` to generate content for a note written using Franklin markup. 
Here is an example of how this is done: 

```julia
# Generate summary section
franklin_note = franklin_note * generate_note_summary(franklin_note_raw)

# Generate bibliography section
franklin_note = franklin_note * generate_bibliography(franklin_note_raw)

# Generate a Franklin Table of Contents
franklin_note = franklin_note * generate_table_of_contents()

# Add note content into the Franklin page
franklin_note = franklin_note * franklin_note_raw.notes

# Generate a references output section
franklin_note = franklin_note * generate_references(franklin_note_raw)

# Write the final note to a file
write("franklin_note.md", franklin_note)
```

## Congratulations! You Just Converted Your First Note! 🥳 

Congratulations! 
This illustrates a potential workflow using NoteMate to go from OKM-compliant Markdown notes to a Franklin note!
The final Franklin note then could be directly added to a Franklin-based website deployment and rendered on the internet.
This example workflow shows a potential path one could take using NoteMate to ingest an OKM-compliant note and produce an output.
Additional functionality could be added to a workflow to, for example, iterate through one's entire note base, add custom sections to a specific output one would want, or swap citation styles on the fly.
With the scripting ability enabled by NoteMate to iteratively build notes, the possibilities are numerous.

## Appendix 🔍

### Sample Note

````@eval
using Markdown 

Markdown.parse("""
```markdown
$(read("./resources/note.txt", String))
```
""")
````

### IEEE CSL

````@eval
using Markdown 

Markdown.parse("""
```text
$(read("./resources/ieee.csl", String))
```
""")
````

### BibTeX References

````@eval
using Markdown 

Markdown.parse("""
```latex
$(read("./resources/refs.bib", String))
```
""")
````

### Full Script

Here was the full script that was developed in the course of this tutorial:

````@eval
using Markdown 

Markdown.parse("""
```julia
$(read("./resources/mkd_franklin_tutorial_script.jl", String))
```
""")
````

