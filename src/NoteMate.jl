module NoteMate

using CSV
using DataFrames
using Dates

"""
Struct representing a note in the knowledge base
"""
struct ArchiveNote
    title::Any
    date::Any
    summary::Any
    keywords::Any
    filename::Any
    filepath::Any
end

function create_article_cache(note_path, storage_path)

    notes =
        readdir(note_path) |>
        x -> filter!(f -> f[(end - 2):end] == ".md", x) |> x -> note_path .* x

    article_cache = DataFrame()
    for note in notes
        filename = basename(note)
        edit_time = unix2datetime(mtime(note))
        push!(
            article_cache,
            Dict("filename" => filename, "edit_time" => edit_time),
            cols = :union,
        )
    end

    CSV.write(storage_path * "note_cache.csv", article_cache)

    return storage_path
end

function verify_template(filepath)
    title = false
    date = false
    summary = false
    keywords = false
    notes = false
    references = false

    open(filepath, "r") do f
        for line in readlines(f)

            try
                if length(line) >= 2 && line[1:2] == "# "
                    title = true
                end

                if length(line) >= 10 && line[1:10] == "**Date:** "
                    date = true
                end

                if length(line) >= 13 && line[1:13] == "**Summary:** "
                    summary = true
                end

                if length(line) >= 14 && line[1:14] == "**Keywords:** "
                    keywords = true
                end

                if length(line) >= 8 && line == "## Notes"
                    notes = true
                end

                if length(line) >= 13 && line == "## References"
                    references = true
                end
            catch e

            end

        end
    end

    return unique(true .== [title, date, summary, keywords, notes, references]) |> first ==
           true
end

function sync_file(src, tgt)

    if verify_template(src) == false
        println("$src does not use a valid template file - sync not performed.")
        return nothing
    elseif verify_template(tgt) == false
        println("$tgt does not use a valid template file - sync not performed.")
        return nothing
    end

    src_time = unix2datetime(mtime(src))
    tgt_time = unix2datetime(mtime(tgt))

    if src_time == tgt_time
        println("Files are synced! Nothing left to do!")
    elseif src_time != tgt_time
        println("Files out of sync.")

        recent_time = sort([src_time, tgt_time], rev = true) |> first
        old_time = sort([src_time, tgt_time], rev = true)[2]

        forward_file = recent_time == src_time ? src : tgt
        old_file = old_time == tgt_time ? tgt : src

	run(`cp -p $forward_file $old_file`)
    end

end

include("structs.jl")

end
