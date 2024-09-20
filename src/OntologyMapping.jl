module OntologyMapping

using ExpressionData
using OntologyLookup

include(joinpath(@__DIR__, "utils.jl"))

export map_to_ontology, get_ontology_mapping

"""
    map_to_ontology(eset::ExpressionSet, ontology::String;
                    ontology_col::String,
                    target_col::String="ontology_ids",
                    replacements::NTuple{K,Pair{String,String}}) where {K}

Maps cell types in an `ExpressionSet` to a specified ontology and adds the mapping to the `ExpressionSet`.

# Arguments
- `eset::ExpressionSet`: The expression set containing the data to be mapped.
- `ontology::String`: The ontology to map the cell types to.
- `ontology_col::String`: The column in the phenotype data that contains the cell types to be mapped.
- `target_col::String="ontology_ids"`: The column name where the ontology IDs will be stored in the phenotype data. Defaults to "ontology_ids".
- `replacements::NTuple{K,Pair{String,String}}`: A tuple of string pairs for replacing substrings in the cell types to improve mapping accuracy.
"""
function map_to_ontology(eset::ExpressionSet, ontology::String;
                         ontology_col::String,
                         target_col::String="ontology_ids",
                         replacements::NTuple{K,Pair{String,String}}) where {K}
    # Check if the ontology column is in the names of the phenotype_data
    if ontology_col ∉ names(phenotype_data(eset))
        throw(ArgumentError("The ontology column '$ontology_col' is not present in the phenoData"))
    end

    # Get the cell types from the eset                         
    cell_types_raw = phenotype_data(eset)[!, ontology_col]

    # Format the cell types
    # -> the ontology search is quite fragile in term of dealing with plurals
    #   so naturally lets introduce a equally fragile function to deal with that
    cell_types = format_cell_types(cell_types_raw, replacements)

    # Get the ontology mapping
    mapping = get_ontology_mapping(cell_types, ontology)

    # Add the ontology mapping to the eset
    new_eset = deepcopy(eset)
    add_pheno_column!(new_eset, target_col, [mapping[cell] for cell in cell_types])

    return new_eset
end

"""
    get_ontology_mapping(to_map_ids::Vector{String}, ontology::String;
                         field::Symbol=:short_form)

Get a mapping of cell types to an ontology. This performs a search for each cell type in the ontology and returns the mapping.                         
"""
function get_ontology_mapping(to_map_ids::Vector{String}, ontology::String;
                              field::Symbol=:short_form)
    search_result = search.(to_map_ids; ontogy_id=ontology, exact=true, rows=1)

    mapping = Dict()

    for (index, cell) in enumerate(to_map_ids)
        if isempty(search_result[index])
            @warn "No match found for $cell"
            mapping[cell] = missing
        end

        result = search_result[index]
        label = result[!, :label][1]

        # Notify if there is a mismatch between the cell type and the ontology
        if !is_loosely_the_same(cell, label)
            @warn "Mismatch between input and ontology: $cell != $label"
        end

        mapping[cell] = first(result[!, field])
    end
    return mapping
end

end
