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

function label_notes(notes::DataFrame)
    labels = []
    for row in eachrow(notes)
        if row.creation_date >= row.edit_time 
            push!(labels, "N")
        else 
            push!(labels, "U")
        end
    end
    notes.labels = labels

    return notes 
end

function summarize_note(note::Note)

end

function summarize_note(note; output = :markdown, time_axis = :edit_time)
    date_format = dateformat"u d Y"
    if output == :markdown
        summarization = """
        - **$(note.title)**. ($(Dates.format(note[time_axis], date_format))) $(note.summary)
        """
        return strip(summarization)
    end
end
