using Markdown
import Markdown: 
    Header,
    parse,
    plain
using NoteMate
using Test

@testset "Markdown parser test suite" begin

    csl_path = "./assets/ieee.csl"
    bibtex_path = "./assets/zettel.bib"
    test_note = read("./assets/test_note.md", String)
    parsed_note = Markdown.parse(test_note)

    # Testset for finding bibliography reference and generating citations
    @testset "find_citation_groups" begin
        expected = ["[@gorgolewskiBrainImagingData2016]"]
        @test unique(find_citation_groups(test_note)) == expected
    end

    # Testset for generating inline markdown references
    @testset "create_inline_citations" begin
        expected = Dict("[@gorgolewskiBrainImagingData2016]" => "[1]")
        citation_keys = find_citation_groups(test_note)
        inline_citations_dict = create_inline_citations(citation_keys, bibtex_path, csl_path)
        @test inline_citations_dict == expected
    end

    #= 

    # Testset to find links in markdown files
    # BUG: Use the "how I anki note" to see that not all the links are pulled properly.
    @testset "find_markdown_links" begin
        expected = ["[link](https://example.com)", "[relative link](othernote.md)"]
        text = "Here is a [link](https://example.com). Here is another [relative link](othernote.md)"
        @test find_markdown_links(text) == expected
    end

    # Test suite for `create_relative_links`
    @testset "create_relative_links" begin
        link_strings = ["[link](https://example.com)", "[relative link](othernote.md)"]
        prefix = "https://jacobzelko.com/"
        expected = Dict(
            "[link](https://example.com)" => "[link](https://example.com/)",
            "[relative link](othernote.md)" => "[relative link](othernote)"
        )
        @test create_relative_links(link_strings; prefix = prefix) == expected
    end

    =#

    #= 
    # Test suite for pulling apart sections of a note
    @testset "get_headers" begin
        file_headers = get_headers(parsed_file.content)

        header_1 = filter(x -> typeof(x) <: Header{1}, file_headers)
        header_2 = filter(x -> typeof(x) <: Header{2}, file_headers)

        expected = Vector[
            Header{1}(Any["Brain Imaging Data Structure (BIDS)"]),
            Header{2}(Any["Bibliography"]),
            Header{2}(Any["Note Linked From:"]),
            Header{2}(Any["Notes"]),
            Header{3}(Any["Purpose"]),
            Header{3}(Any["Specific data specifications:"]),
            Header{3}(Any["Topics"]),
            Header{2}(Any["References"])
        ]
        expected = convert(Vector{Any}, expected)

        @test sum.([typeof.(file_headers) .== typeof.(expected)])[1] == 8

        sections = get_sections(parsed_file.content, section_headers; name_sections=true)

        # TODO: Pick up from here
        expected_title_section = Dict{String, Vector{Any}}("Title" => [Header{1}(Any["Brain Imaging Data Structure (BIDS)"]), Markdown.Paragraph(Any[Markdown.Bold(Any["Date:"]), " November 5 2020 "]), Markdown.Paragraph(Any[Markdown.Bold(Any["Summary:"]), " An overview of the BIDS style for Brain Imaging Data. "]), Markdown.Paragraph(Any[Markdown.Bold(Any["Keywords:"]), " ##zettel #bids #neuroscience #brain #imaging #archive"])])

        title_header = filter(x -> typeof(x) <: Header{1}, file_headers)
        title_section = get_title_section(parsed_file.content, title_header; name_sections=true)

        @test title_section == expected_title_section


        section_headers = filter(x -> typeof(x) <: Header{2}, file_headers)


    end

    =# 

end
