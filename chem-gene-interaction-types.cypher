CREATE INDEX ON :InteractionType(typeName);
CREATE INDEX ON :InteractionType(code);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS
    FROM "file:///../CTD_chem_gene_ixn_types_with_header.csv" AS line
    MERGE (t:InteractionType {typeName : line.TypeName})
        SET t.code = line.Code
        SET t.description = line.Description
        SET t.parentCode = line.ParentCode

MATCH (t:InteractionType) WHERE exists(t.parentCode)
MERGE (p:InteractionType {code: t.parentCode})
MERGE (t)-[:HAS_PARENT]->(p)
REMOVE t.parentCode

CALL apoc.periodic.commit("MATCH (i:Interaction) WHERE exists(i.actions)
    with i limit {limit} UNWIND i.actions as action
    MERGE (t:InteractionType {typeName : last(split(action, '^'))})
    MERGE (i)-[r:EFFECTS]->(t) SET r.type = head(split(action, '^'))
    REMOVE i.actions RETURN count(*)",
{limit:1000})

CALL apoc.periodic.commit('MATCH ()-[r:EFFECTS]-() WITH r limit {limit} CALL apoc.refactor.setType(r, toUpper(r.type)) yield output return count(*)',{limit:1000})
