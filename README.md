# Welcome to `NoteMate.jl`! 📝

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jacobzelko.com/NoteMate.jl/dev/)
[![Test Coverage](https://codecov.io/gh/TheCedarPrince/NoteMate.jl/branch/main/graph/badge.svg)](https://app.codecov.io/gh/TheCedarPrince/NoteMate.jl)
[![Build Status](https://github.com/TheCedarPrince/NoteMate.jl/workflows/CI/badge.svg)](https://github.com/TheCedarPrince/NoteMate.jl/actions)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

<!--TODO: Add Zulip reference-->

> The perfect companion for working with your notes 📚

`NoteMate.jl` is a programmatic transformation tool used to parse and manipulate notes whose structure follows the [Open Knowledge Model (OKM)](https://jacobzelko.com/04172022033744-open-knowledge-standard/index.html).
The goal of `NoteMate.jl` is to enable one to focus only on writing without worry of needing to add any special markup to your note *while* having the benefits of quickly sharing thoughts.
In fact, sharing your thoughts, whether locally or on the internet, is never far away as `NoteMate.jl` provides tools to enable your thoughts to be published on [digital gardens](https://www.lekoarts.de/garden/what-is-a-digital-garden).
Finally, due to the way `NoteMate.jl` parses documents, `NoteMate.jl` can transform notes following the OKM and express them in different outputs irrespective of the implementation.

# Installation

To install `NoteMate.jl` currently, one needs to run the following command in their Julia REPL:

```
pkg> add NoteMate
```

# Current Capabilities

Currently, these are some of the high level capabilities `NoteMate.jl` can perform:

- Ingest supported filetypes following OKM layout:

  - Markdown

- Parsing of a OKM "Note" object to different support outputs:

  - [`Franklin.jl`](https://franklinjl.org) Markdown

- Static site deployment workflows supported for rapid [digital garden](https://www.lekoarts.de/garden/what-is-a-digital-garden) creation:

  - [`Franklin.jl`](https://franklinjl.org) Support 

- Custom citation rendering and creation via `pandoc`, `bibtex`, and `CSL` 

# Websites Using `NoteMate.jl`

Here are some websites that use `NoteMate.jl` to manage their website

- [TheCedarPrince's Personal Website](https://jacobzelko.com) - a [Franklin.jl](https://franklinjl.org)-based website that hosts a blog, note archive, and their research endeavors.

# Contributors

`NoteMate.jl` would not be possible if not for the help and support from our contributors here: 

|       |       |       |       |
| :---: | :---: | :---: | :---: |
| <img width="50" src="https://avatars2.githubusercontent.com/u/74614227?s=96&v=4"/></br>[SevorisDoe](https://github.com/SevorisDoe) |  |  |  |
