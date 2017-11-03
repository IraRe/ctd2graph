USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///../CTD_genes_pathways.csv" AS line
MATCH (p:Pathway {pathwayID : line.PathwayID})
MATCH (g:Gene {geneID : line.GeneID})
    MERGE (p)-[:INVOLVES]->(g)
