using Dates 
using DataFrames 
using CSV

"""
TODO: Add docstring!
"""
function note_date_range(records_path::String; start_date = Dates.now() - Day(3), end_date = Dates.now(), time_axis = :edit_time)
    records = CSV.read(records_path, DataFrame)
    filter!(row -> start_date <= row[time_axis] <= end_date, records)

    return records
end

"""
An inclusive filter
"""
function note_date_range(records::DataFrame; start_date = Dates.now() - Day(3), end_date = Dates.now(), time_axis = :edit_time)
    return filter(row -> start_date <= row[time_axis] <= end_date, records)
end

"""
TODO: Add docstring!
"""
function summarize_note(note; prefix = "", output = :markdown, time_axis = :edit_time)
    date_format = dateformat"u d Y"
    if output == :markdown
        summarization = """
        - [**$(note.title)**]($(joinpath(prefix, splitext(note.filename)[1]))) ($(Dates.format(note[time_axis], date_format))) $(note.summary)
        """
        return strip(summarization)
    end
end
