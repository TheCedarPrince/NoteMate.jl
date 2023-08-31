module NoteMate

import Dates:
    DateFormat,
    DateTime,
    Date,
    day,
    year,
    monthname,
    yearmonthday
import Markdown:
    plain,
    Header,
    parse
using pandoc_jll

"""
    sync_file

On a unix system, copy a source file to a target file if the modification times of the files are not equal. 

Requires the `cp -p` command to run successfully.

# Arguments
- `src`: the source file to copy from
- `tgt`: the target file to copy to
"""
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
include("markdown/parser.jl")
include("targets/franklin.jl")

end
