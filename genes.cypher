CREATE INDEX ON :Gene(geneID)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///../CTD_genes_with_header.csv" AS line
MERGE (g:Gene {geneID: line.GeneID})
    SET g.geneName = line.GeneName
    SET g.geneSymbol = line.GeneSymbol
    SET g.alternativeIdentifiers = line.AltGeneIDs
    SET g.synonyms = split(line.Synonyms, '|')
    SET g.bioGRIDIDs = split(line.BioGRIDIDs, '|')
    SET g.pharmGKBIDs = split(line.PharmGKBIDs, '|')
    SET g.uniprotIDs = split(line.UniprotIDs, '|')
