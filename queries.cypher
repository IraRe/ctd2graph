match (p:Chemical {chemicalID:'D019216'})<-[:HAS_PARENT]-(c:Chemical {chemicalName:'Zinc'})-[:CAUSES]->(i:Interaction)-->(type:InteractionType), (g:Gene)-[:INVOLVED_IN]->(i)-[:APPLIES_TO]->(o:Organism)
where type.typeName in ['activity', 'reaction'] and id(i) = 1242144
return p,c,i, type,o,g limit 30
