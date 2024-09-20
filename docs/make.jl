using OntologyMapping
using Documenter

DocMeta.setdocmeta!(OntologyMapping, :DocTestSetup, :(using OntologyMapping); recursive=true)

makedocs(;
    modules=[OntologyMapping],
    authors="Chris Damour",
    sitename="OntologyMapping.jl",
    format=Documenter.HTML(;
        canonical="https://damourChris.github.io/OntologyMapping.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/damourChris/OntologyMapping.jl",
    devbranch="main",
)
