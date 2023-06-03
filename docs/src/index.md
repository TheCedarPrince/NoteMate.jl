# Welcome to the `NoteMate.jl` Docs! 👋

> The perfect companion for working with your notes 

NoteMate is a programmatic transformation tool used to parse and manipulate files whose heading structure and contents follow [the Open Knowledge Model](https://jacobzelko.com/04172022033744-open-knowledge-standard/index.html). Due to the way NoteMate internally represents documents, it is possible to transform notes from different structures to the Open Knowledge Model standard, and to express the standard in different output formats.

NoteMate helps build [digital gardens](https://www.lekoarts.de/garden/what-is-a-digital-garden) for the sharing of ideas, insights and information synthesis. It works with files that empathize native human readability and manipulation without dependency on complex machine-readable metadata linkages in the frontend. Citations are inspired by academic standards and can be natively copied and pasted from the notes with no further interpretation needed. This makes it a good choice for building digital gardens that can be grown with a high-quality, low-tech evidence chain. 

## Capabilities
- Ingest Common Markdown files following OKM layout
- Translate from OKM layout markdown to `franklin.jil` webpage markdown
- Batch synchronization of markdown workspace to `franklin.jil` webpage basis and static site generation in one workflow


# The vision
Since NoteMate follows a modular standard, we think it can be expanded to allow ingestion and translation between many different file formats with different inner-file structures and even the assembly of notes from multiple source nodes using the ontology of a note system. 

This mapping may also be bidirectoinal - going from standard-formated web pages and other outputs back to various intermediate and the original formats. 

### Connected Digital Gardens
Since NoteMate.jil enforces a common document format with certain information always present, sufficent standardization is present to consider having digital gardens interlink on the web. Different webpages might reference one another in such ways that they can build off each other, letting people seamlessly jump between different people's ideas and then incorporate them into their own. 