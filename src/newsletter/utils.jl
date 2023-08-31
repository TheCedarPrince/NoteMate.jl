"""
    note_date_range(records_path::String; start_date = now() - Day(3), end_date = now(), time_axis = :edit_time)

Get notes over a date range from a records file.

# Arguments

- `records_path::String`: The path to the records file containing note information.

# Keyword Arguments

- `start_date`: The start date of the date range to filter notes. Default is three days ago from the current date.
- `end_date`: The end date of the date range to filter notes. Default is the current date.
- `time_axis`: The time axis to consider when filtering notes. Options include:
  - `:edit_time`: The time when the note was last edited.
  - `:creation_date`: When the note was first created.

# Returns

- A `DataFrame` representing notes available over the requested date range.
"""
function note_date_range(records_path::String; start_date = now() - Day(3), end_date = now(), time_axis = :edit_time)
    records = CSV.read(records_path, DataFrame)
    filter!(row -> start_date <= row[time_axis] <= end_date, records)

    return records
end

"""
    note_date_range(records::DataFrame; start_date = now() - Day(3), end_date = now(), time_axis = :edit_time)

Get notes over a date range from a records `DataFrame`.

# Arguments

- `records::DataFrame`: `DataFrame` object containing note information for a knowledge base

# Keyword Arguments

- `start_date`: The start date of the date range to filter notes. Default is three days ago from the current date.
- `end_date`: The end date of the date range to filter notes. Default is the current date.
- `time_axis`: The time axis to consider when filtering notes. Options include:
  - `:edit_time`: The time when the note was last edited.
  - `:creation_date`: When the note was first created.

# Returns

- A `DataFrame` representing notes available over the requested date range.
"""
function note_date_range(records::DataFrame; start_date = now() - Day(3), end_date = now(), time_axis = :edit_time)
    return filter(row -> start_date <= row[time_axis] <= end_date, records)
end

"""
    summarize_note(note; prefix = "", output = :markdown, time_axis = :edit_time, date_format = dateformat"u d Y")

Create a single line note summary.

# Arguments

- `note`: The note to summarize; currently a row from the note records file.

# Keyword Arguments

- `prefix`: A prefix to prepend to a note's URL. Default is an empty string.
- `output`: The output format of the summary. Default is `:markdown`.
- `time_axis`: The time axis to consider when summarizing the note. Default is `:edit_time`.
- `date_format`: The format of the date to use in the summary. Default is `dateformat"u d Y"`.

# Returns

- A summarized version of the note as a single line string, based on the specified arguments.

# Example

Here is an example call: 

```
newsletter = newsletter * summarize_note(note, time_axis = :edit_time, prefix = "https://jacobzelko.com")
```

and an example of the expected output:

```
- [**Open Network Studies**](https://jacobzelko.com/05302023183944-open-network-studies) (May 30 2023) An overview of the different types of network studies that exist
```

"""
function summarize_note(note; prefix = "", output = :markdown, time_axis = :edit_time, date_format = dateformat"u d Y")
    if output == :markdown
        summarization = """
        - [**$(note.title)**]($(joinpath(prefix, splitext(note.filename)[1]))) ($(format(note[time_axis], date_format))) $(note.summary)
        """
        return strip(summarization)
    end
end

export note_date_range, summarize_note
