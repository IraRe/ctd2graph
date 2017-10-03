CREATE INDEX ON :Chemical(chemicalID)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///home/irare/projects/odsc/gene-data/CTD_chemicals_with_header.csv" AS line
MERGE (c:Chemical {chemicalID: line.ChemicalID})
    SET c.chemicalName = line.ChemicalName
    SET c.casRN = line.CasRN
    SET c.definition = line.Definition
    SET c.treeNumbers = split(line.TreeNumbers,'|')
    SET c.parentTreeNumbers = split(line.ParentTreeNumbers, '|')
    SET c.synonyms = split(line.Synonyms, '|')
    SET c.drugBankIDs = line.DrugBankIDs
    SET c.parentIDs = split(line.ParentIDs, '|')

MATCH (c:Chemical) where exists(c.parentIDs)
    UNWIND c.parentIDs as parentID
    MERGE (parent:Chemical {chemicalID:parentID})
    MERGE (c)-[:HAS_PARENT]->(parent)
    REMOVE c.parentIDs;

MATCH (c:Chemical) where c.chemicalID STARTS WITH 'MESH:'
    SET c.chemicalID = substring(c.chemicalID, 5)
    SET c.idType = 'MESH'
