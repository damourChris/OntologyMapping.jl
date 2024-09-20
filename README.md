# OntologyMapping

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://damourChris.github.io/OntologyMapping.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://damourChris.github.io/OntologyMapping.jl/dev/)
[![Build Status](https://github.com/damourChris/OntologyMapping.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/damourChris/OntologyMapping.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/damourChris/OntologyMapping.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/damourChris/OntologyMapping.jl)

A Julia package for mapping IDs between ontologies. The main entry point is the map_to_ontology function, which maps a list of IDs to a ontology. 

For now, it intends to map human annotation to a ontology. Namely, the original purpose was to map cell type annotation to the Cell Line Ontology (CLO). However, it can (remains to be tested) be used to map any annotation to any ontology.

## Installation
!!! note
    This package is part of the SysBioRegistry. If this is your first time instaling a package from this registry make sure to first  run the following command in the Julia REPL:
    ```julia
    using Pkg
    Pkg.Registry.add(RegistrySpec(url = "https://github.com/damourChris/SysBioRegistry.jl"))
    ```
    This is not required if you wish to install the package from the GitHub repository.

You can install the package by running the following command in the Julia REPL:
```julia
using Pkg
Pkg.add("OntologyMapping")
```

Or alternatively, you can install the package from the GitHub repository by running the following command in the Julia REPL:
```julia
using Pkg
Pkg.add(url="https://github.com/damourChris/OntologyMapping.jl")
```

## Usage

```julia
julia> using ExpressionData
julia> using OntologyMapping
julia>
julia> ids_to_map = ["T cell", "B cells", "NK cell"]
julia> replacements = ("cells" => "cell")
julia> rand_eset = rand(ExpressionSet, 10, 3)
julia> rand_eset.phenotype_data[!, :cell_types] = ids_to_map
julia>
julia> mapped_eset = map_to_ontology(rand_eset, "cl"; ontology_col="cell_types", replacements=replacements, target_col="mapped_cell_types")
julia> phenotype_data(mapped_eset)
3×3 DataFrame
 Row │ sample_names  cell_types  mapped_cell_types 
     │ String        String      String            
─────┼─────────────────────────────────────────────
   1 │ sample_1      T cell      CL_0000084
   2 │ sample_2      B cell      CL_0000236
   3 │ sample_3      NK cell     CL_0000623
```

## Documentation

For more information, check the [documentation](https://damourChris.github.io/OntologyMapping.jl/stable/).





