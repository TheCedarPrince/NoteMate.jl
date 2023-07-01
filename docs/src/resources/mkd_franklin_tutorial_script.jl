using Dates
using NoteMate

import Markdown:
    Header,
    plain

note = read("note.md", String)

citation_keys = find_citation_groups(note) 
inline_citations_dict = create_inline_citations(citation_keys, "refs.bib", "ieee.csl")
note = replace(note, inline_citations_dict...)

markdown_links = find_markdown_links(note, group_links = true)
relative_links_dict = create_relative_links(markdown_links["relative_links"])
note = replace(note, relative_links_dict...)

parsed_note = Markdown.parse(note)

note_headers = get_headers(parsed_note.content)
title_header = filter(x -> typeof(x) <: Header{1}, note_headers)
section_headers = filter(x -> typeof(x) <: Header{2}, note_headers)

sections = get_sections(parsed_note.content, section_headers; name_sections=true)
title_section = get_title_section(parsed_note.content, title_header; name_sections=true)
references_section = create_references(citation_keys, "refs.bib", "ieee.csl")
note_sections = merge!(sections, title_section)
note_sections["References"] = (note_sections["References"][1] |> plain) * "\n" * references_section |> Markdown.parse |> x -> x.content

title_section = note_sections["Title"]
bibliography_section = note_sections["Bibliography"][2] |> plain
notes_section = note_sections["Notes"][2:end] |> plain
references_section = note_sections["References"] |> plain

title = title_section[1].text[1] |> x -> replace(x, "\"" => "'")
date = title_section[2].content[2] |> strip
summary = title_section[3].content[2] |> strip |> x -> replace(x, "\"" => "'")
keywords = title_section[4].content[2] |> strip

note = Note(title, date, summary, keywords, bibliography_section, references_section, notes_section, basename("notes.md"), "notes.md", "ieee.csl", "refs.bib")

franklin_note_raw = create_franklin_note(note)

franklin_note = ""
franklin_note = franklin_note * generate_franklin_template(title=franklin_note_raw.title, slug=franklin_note_raw.slug, tags=franklin_note_raw.tags, description=franklin_note_raw.description, rss_title=franklin_note_raw.rss_title, rss_description=franklin_note_raw.rss_description, rss_pubdate=franklin_note_raw.rss_pubdate)

franklin_note = franklin_note * generate_note_summary(franklin_note_raw)
franklin_note = franklin_note * generate_bibliography(franklin_note_raw)
franklin_note = franklin_note * generate_table_of_contents()
franklin_note = franklin_note * franklin_note_raw.notes
franklin_note = franklin_note * generate_references(franklin_note_raw)

write("franklin_note.md", franklin_note)
