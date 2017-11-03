USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///../CTD_diseases_pathways.csv" AS line
MATCH (d:Disease {diseaseID: line.DiseaseID})
MATCH (p:Pathway {pathwayID : line.PathwayID})
MATCH (g:Gene {geneSymbol : line.InferenceGeneSymbol})
MERGE (p)<-[:ASSOCIATED_WITH]-(d)-[:ASSOCIATED_WITH]->(g)
