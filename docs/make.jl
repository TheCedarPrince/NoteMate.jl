using NoteMate 
using Documenter

makedocs(;
    modules = [NoteMate],
    authors = "Jacob Zelko (aka TheCedarPrince) <jacobszelko@gmail.com> and contributors",
    repo = "https://github.com/TheCedarPrince/NoteMate/blob/{commit}{path}#L{line}",
    sitename = "NoteMate.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        assets = String[],
        edit_link = "dev",
	footer = "Created by [Jacob Zelko](https://jacobzelko.com). [License](https://github.com/TheCedarPrince/NoteMate/blob/main/LICENSE)"
    ),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo = "github.com/TheCedarPrince/NoteMate",
    push_preview = true,
    devbranch = "main",
)
