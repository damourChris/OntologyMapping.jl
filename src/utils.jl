function is_loosely_the_same(str1::AbstractString, str2::AbstractString)::Bool
    replacements = ("-" => "_",
                    "_" => "_")

    str1_normalized = replace(lowercase(str1), replacements...)
    str2_normalized = replace(lowercase(str2), replacements...)

    # Compare normalized strings
    return str1_normalized == str2_normalized
end

function add_pheno_column!(eset::ExpressionSet, col_name::AbstractString,
                           col_data)::ExpressionSet
    eset.phenotype_data[!, col_name] = col_data
    return eset
end

function format_cell_types(cell_types::Vector{String},
                           replacements::NTuple{K,Pair{String,String}})::Vector{String} where {K}
    return [replace(cell, replacements...) for cell in cell_types]
end