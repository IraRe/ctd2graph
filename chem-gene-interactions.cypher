CREATE INDEX ON :Organism(organismID);
CREATE INDEX ON :Interaction(description);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///home/irare/projects/odsc/gene-data/CTD_chem_gene_ixns.csv" AS line
MATCH (c:Chemical {chemicalID : line.ChemicalID})
MATCH (g:Gene {geneID : line.GeneID})
    SET g.geneForms = split(line.GeneForms, '|')
MERGE (o:Organism {organismID : coalesce(toInteger(line.OrganismID), 0)})
MERGE (i:Interaction {description : line.Interaction})
    SET i.actions = split(line.InteractionActions, '|')
    SET i.pubMedIDs = split(line.PubMedIDs, '|');


USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///home/irare/projects/odsc/gene-data/CTD_chem_gene_ixns.csv" AS line
MERGE (o:Organism {organismID : coalesce(toInteger(line.OrganismID), 0)})
    SET o.organismName = line.Organism


USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///home/irare/projects/odsc/gene-data/CTD_chem_gene_ixns.csv" AS line
MATCH (c:Chemical {chemicalID : line.ChemicalID})
MATCH (g:Gene {geneID : line.GeneID})
MATCH (o:Organism {organismID : coalesce(toInteger(line.OrganismID), 0)})
MATCH (i:Interaction {description : line.Interaction})
MERGE (g)-[:INVOLVED_IN]->(i)
MERGE (c)-[:CAUSES]->(i)
MERGE (g)-[:PART_OF]->(o)
MERGE (i)-[:APPLIES_TO]->(o)
