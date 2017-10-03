CREATE INDEX ON :InteractionType(typeName);
CREATE INDEX ON :InteractionType(code);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS
    FROM "file:///home/irare/projects/odsc/gene-data/CTD_chem_gene_ixn_types_with_header.csv" AS line
    MERGE (t:InteractionType {typeName : line.TypeName})
        SET t.code = line.Code
        SET t.description = line.Description
        SET t.parentCode = line.ParentCode

MATCH (t:InteractionType) WHERE exists(t.parentCode)
MERGE (p:InteractionType {code: t.parentCode})
MERGE (t)-[:HAS_PARENT]->(p)
REMOVE t.parentCode

MATCH (i:Interaction) WHERE exists(i.actions)
UNWIND i.actions as action
MERGE (t:InteractionType {typeName : last(split(action, '^'))})
MERGE (i)-[r:EFFECTS]-(t)
    SET r.type = head(split(action, '^'))
