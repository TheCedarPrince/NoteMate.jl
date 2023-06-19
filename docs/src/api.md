# API

This is a list of documentation associated with every single **exported** function or object from `NoteMate.jl`.
There are a few different sections with a brief explanation of what these sections are followed by relevant functions.

```@contents
Pages = ["api.md"]
```

## Structs 

These are the core objects used to represent various note species within `NoteMate.jl`.
They are designed to be extended or parsed as needed:

```@docs
FranklinNote
Note
```

## Parsing

These functions are built to parse different sorts of files into `NoteMate.jl` objects (i.e. [structs](#structs)).
Multiple sections exist to denote what markup languages are able to be parsed as of now:

### Markdown

The parsing for `NoteMate.jl` supports Markdown -- specifically, [CommonMark Markdown](https://commonmark.org/help/) is supported but support for other variants could be added in the future:

```@docs
find_citation_groups
create_inline_citations
create_references
find_markdown_links
create_relative_links
get_headers
get_sections
get_title_section
```

## Targeting

After [parsing](#parsing) a note into a `NoteMate.jl` object, these functions support translating each object into a specified target output.
These targets are designed to quickly translate one's note to a publishable artifact for the internet (or other future supported platforms).
The following sections denote functions that support a given target: 

### Franklin 

[`Franklin.jl`](https://franklinjl.org) is a static site generator written in the Julia programming language.
It uses its own variant of markdown called "Franklin Markdown" to assist in publishing content to the web:

```@docs
create_franklin_note
generate_franklin_template
generate_note_summary
generate_bibliography
generate_citation
generate_references
generate_comments
generate_table_of_contents
```

## Miscellaneous

These functions are mostly for occasional use or do not fit cleanly into anyone section yet.

```@docs
sync_file
```
