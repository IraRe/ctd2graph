CREATE INDEX ON :Pathway(pathwayID)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///home/irare/projects/odsc/gene-data/CTD_pathways.csv" AS line
MERGE (p:Pathway {pathwayID : line.PathwayID})
    SET p.pathwayName = line.PathwayName
