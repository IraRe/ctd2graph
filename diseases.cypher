CREATE INDEX ON :Disease(diseaseID)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///../CTD_diseases_with_header.csv" AS line
MERGE (d:Disease {diseaseID: line.DiseaseID})
    SET d.diseaseName = line.DiseaseName
    SET d.definition = line.Definition
    SET d.alternativeIdentifiers = split(line.AltDiseaseIDs, '|')
    SET d.treeNumbers = split(line.TreeNumbers,'|')
    SET d.parentTreeNumbers = split(line.ParentTreeNumbers, '|')
    SET d.synonyms = split(line.Synonyms, '|')
    SET d.parentIDs = split(line.ParentIDs, '|')
    SET d.categories = split(line.SlimMappings, '|')

MATCH (d:Disease) where exists(d.parentIDs)
    UNWIND d.parentIDs as parentID
    MERGE (parent:Disease {diseaseID:parentID})
    MERGE (d)-[:HAS_PARENT]->(parent)
    REMOVE d.parentIDs;

MATCH (d:Disease) where exists(d.categories)
    UNWIND d.categories as category
    MERGE (c:Category {name:category})
    MERGE (d)-[:IN_CATEGORY]->(c)
    REMOVE d.categories
