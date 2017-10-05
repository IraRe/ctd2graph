CREATE INDEX ON :Gene(geneSymbol);
CREATE INDEX ON :Inference(pubMedIDs);

USING PERIODIC COMMIT 500

CALL apoc.periodic.iterate(
    "CALL apoc.load.csv(
        'file:///home/irare/projects/odsc/gene-data/CTD_chemicals_diseases_with_header.csv',
        {})
        YIELD lineNo, map RETURN lineNo, map",
    "CREATE (i:Inference {lineNo : lineNo})
        SET i.chemicalID = map.ChemicalID
        SET i.diseaseID = map.DiseaseID
        SET i.geneSymbol = map.InferenceGeneSymbol
        SET i.score = map.InferenceScore
        SET i.evidences = split(map.DirectEvidence, '|')
        SET i.omimIDs = split(map.OmimIDs, '|')
        SET i.pubMedIDs = split(map.PubMedIDs, '|')",
    {batchSize:1000, iterateList:true}
    )

CALL apoc.periodic.iterate(
    'MATCH (i:Inference) WHERE exists(i.chemicalID) RETURN i',
    'MERGE (c:Chemical {chemicalID:i.chemicalID}) CREATE (i)-[:COMPRISES]->(c)',
    {batchSize:10000, iterateList:true})

CALL apoc.periodic.commit(
    'MATCH (i:Inference) WHERE exists(i.diseaseID) WITH i LIMIT {limit} MERGE (d:Disease {diseaseID:i.diseaseID}) CREATE (i)-[:COMPRISES]->(d)',
    {limit:1000})

CALL apoc.periodic.iterate(
    'MATCH (i:Inference) WHERE exists(i.geneSymbol) RETURN i',
    'MERGE (g:Gene {geneSymbol:i.geneSymbol}) CREATE (i)-[:COMPRISES]->(g)',
    {batchSize:10000, iterateList:true})
