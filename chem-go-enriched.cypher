CREATE INDEX ON :Ontology(name)
CREATE INDEX ON :Term(termID)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS
    FROM "file:///home/irare/projects/odsc/gene-data/CTD_chem_go_enriched.csv" AS line
    MATCH (c:Chemical {chemicalID : line.ChemicalID})
    MERGE (o:Ontology {name : line.Ontology})
    MERGE (t:Term {termID : line.GOTermID})
        SET t.termName = line.GOTermName
        SET t.level = line.HighestGOLevel
    MERGE (t)-[:TERM_OF]->(o)
    MERGE (t)-[r:AFFECTED_BY]->(c)
        SET r.pValue = line.PValue
        SET r.correctedPValue = line.CorrectedPValue

CALL apoc.periodic.iterate(
    "CALL apoc.load.csv(
        'ile:///home/irare/projects/odsc/gene-data/CTD_chem_go_enriched.csv',
        {})
        YIELD lineNo, map RETURN lineNo, map",
    "MATCH (c:Chemical {chemicalID : line.ChemicalID})
    MERGE (o:Ontology {name : line.Ontology})
    MERGE (t:Term {termID : line.GOTermID})
        SET t.termName = line.GOTermName
        SET t.level = line.HighestGOLevel
    MERGE (c)<-[r:AFFECTED_BY]-(t)-[:TERM_OF]->(o)
        SET r.pValue = line.PValue
        SET r.correctedPValue = line.CorrectedPValue",
    {batchSize:10000, iterateList:true}
    )
