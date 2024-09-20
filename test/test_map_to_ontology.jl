
@testsnippet MockEset begin
    cell_types = ["Naïve CD4+ T cells", "CD8+ T cells", "Monocytes", "Macrophages",
                  "Neutrophils", "Tregs"]
    eset = rand(ExpressionSet, 10, 6)
    eset.phenotype_data[!, :cell_types] = cell_types
end

@testitem "map_to_ontology" begin
    replacements = ("cells" => "cell",
                    "Naïve" => "naive",
                    "Monocytes" => "monocyte",
                    "Macrophages" => "macrophage",
                    "Neutrophils" => "neutrophil",
                    "CD8+" => "CD8",
                    "CD4+" => "CD4",
                    "Tregs" => "Treg")
    ontology = "CL"
    ontology_col = "cell_types"
    target_col = "ontology_ids"

    new_eset = map_to_ontology(eset, ontology; ontology_col=ontology_col,
                               target_col=target_col, replacements=replacements)

    @test names(phenotype_data(new_eset)) == [:cell_types, :ontology_ids]
    @test phenotype_data(new_eset)[!, :ontology_ids] ==
          ["CL_0000898", "CL_0000625", "CL_0000576",
           "CL_0000235", "CL_0000775", "CL_0000815"]
end