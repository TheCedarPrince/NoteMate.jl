# Welcome to the `NoteMate.jl` Docs! 👋

> The perfect companion for working with your notes 📚

`NoteMate.jl` is a programmatic transformation tool used to parse and manipulate files whose structure follows the [Open Knowledge Model (OKM)](https://jacobzelko.com/04172022033744-open-knowledge-standard/index.html).
The goal of `NoteMate.jl` is to enable one to focus only on writing without worry of needing to add any special markup to your note *while* having the benefits of quickly sharing thoughts.
Due to the way `NoteMate.jl` parses documents, `NoteMate.jl` can transform notes following the OKM and express them in different outputs irrespective of the implementation.

# Current Capabilities

Currently, these are some of the high level capabilities `NoteMate.jl` can perform:

- Ingest supported filetypes following OKM layout:

  - Markdown

- Parsing of a OKM "Note" object to different support outputs:

  - [`Franklin.jl`](https://franklinjl.org) Markdown

- Static site deployment workflows supported for rapid [digital garden]( creation:

  - [`Franklin.jl`](https://franklinjl.org) Support 

- Citation rendering and creation via `pandoc`, `bibtex`, and `CSL` formats 

# Installation

To install `NoteMate.jl` currently, one needs to run the following command in their Julia REPL:

```
pkg> add https://github.com/TheCedarPrince/NoteMate
```

<!--TODO: Add final instructions before first release! -->

# Long Term Vision for NoteMate.jl

`NoteMate.jl` helps with constructing [digital gardens](https://www.lekoarts.de/garden/what-is-a-digital-garden) for sharing of ideas, insights and information syntheses quickly.
This makes it a good choice for building digital gardens that can be grown with a high-quality, low-tech evidence chain. 
Since `NoteMate.jl` follows a modular standard, we think it can be expanded to allow ingestion and translation between many different file formats with different inner-file structures in a bidirectional manner.
As an example, pages in a digital garden may even be able to coalesce multiple notes using the ontology of a note system into aggregate notes in the future. 

Since `NoteMate.jl` enforces a common document format with certain information always present, sufficient standardization is present to consider having digital gardens interlink on the web.
Different webpages might reference one another in such ways that they can build off each other, letting people seamlessly jump between different people's ideas and then incorporate them into their own. 
Using the approaches here within `NoteMate.jl`, users will eventually be able to also quickly analyze and understand their own knowledge base data that they can leverage to build on other connections across other knowledge bases or in the context of their own work and research.
