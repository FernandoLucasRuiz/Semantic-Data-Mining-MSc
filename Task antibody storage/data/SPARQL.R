library(SPARQL)

endpoint <- "http://34.69.252.26:3031/blazegraph/namespace/AntibodyStorage/sparql"

#Query 1
query1 <- "PREFIX rdfs: 	<http://www.w3.org/2000/01/rdf-schema#> 
PREFIX mionto:	<https://dayhoff.inf.um.es/ontologies/anticuerpos#> 
PREFIX up:		<http://purl.uniprot.org/core/> 
PREFIX uniprot:	<https://www.uniprot.org/uniprotkb/> 

SELECT ?protein ?proteinID ?antibody
WHERE {
	?proteinID rdf:type up:Protein.
?proteinID rdfs:label ?protein.
?o mionto:detects_antigen ?proteinID .
?o rdfs:label ?antibody
}"

resq1<- SPARQL(endpoint,query1)
resq1$results

#Query 2
query2 <- "PREFIX owl: 	<http://www.w3.org/2002/07/owl#> 
PREFIX rdfs: 	<http://www.w3.org/2000/01/rdf-schema#> 
PREFIX obo:		<http://purl.obolibrary.org/obo/> 
PREFIX mionto:	<https://dayhoff.inf.um.es/ontologies/anticuerpos#> 

SELECT ?Antibodyname ?Cell ?Host ?AntibodyID
WHERE {
	{?ab  rdf:type mionto:Antibody.
?ab rdfs:label ?Antibodyname .
?ab owl:sameAs ?AntibodyID .
?ab mionto:host ?h .
?h rdfs:label ?Host .
?ab  mionto:detects_antigen ?protein.
?protein obo:RO_0001025 obo:CL_0000129.
obo:CL_0000129 rdfs:label ?Cell}
UNION
{?ab  rdf:type mionto:Antibody.
?ab rdfs:label ?Antibodyname .
?ab owl:sameAs ?AntibodyID .
?ab mionto:host ?h .
?h rdfs:label ?Host .
?ab  mionto:detects_antigen ?protein.
?protein obo:RO_0001025 obo:CL_0000127.
obo:CL_0000127 rdfs:label ?Cell}
UNION
{?ab  rdf:type mionto:Antibody.
?ab rdfs:label ?Antibodyname .
?ab owl:sameAs ?AntibodyID .
?ab mionto:host ?h .
?h rdfs:label ?Host .
?ab  mionto:detects_antigen ?protein.
?protein obo:RO_0001025 obo:CL_0000636 .
obo:CL_0000636  rdfs:label ?Cell}
}"

resq2<- SPARQL(endpoint,query2)
resq2$results


#Query 3
query3 <- "PREFIX rdfs: 	<http://www.w3.org/2000/01/rdf-schema#> 
PREFIX obo:		<http://purl.obolibrary.org/obo/> 
PREFIX mionto:	<https://dayhoff.inf.um.es/ontologies/anticuerpos#> 

SELECT ?protein ?host ?clonality ?reactivity ?dilution ?storage
WHERE {
	?s rdf:type mionto:Antibody .
?s mionto:applies_to mionto:FlowCitometry . # applies to Flow citometry
?s mionto:detects_antigen ?p .
?p rdfs:label ?protein .
?p obo:RO_0001025 obo:GO_0005634 . # located_in nucleus
?s mionto:host ?h .
?h rdfs:label ?host .
?s mionto:has_clonality ?clo .
?clo rdfs:label ?clonality .
?s mionto:reactivity_in obo:VTO_0014661 . # reactivity in mouse
obo:VTO_0014661 rdfs:label ?reactivity .
?s rdfs:comment ?dilution .
?s mionto:storaged_in ?sto .
?sto rdfs:label ?storage
}"

resq3<- SPARQL(endpoint,query3)
resq3$results


#Query 4
query4 <- "PREFIX rdfs: 	<http://www.w3.org/2000/01/rdf-schema#> 
PREFIX mionto:	<https://dayhoff.inf.um.es/ontologies/anticuerpos#> 

SELECT ?protein (MAX(?c) AS ?MAXcitaciones) (xsd:integer(AVG(?c)) AS ?mediacitas) (COUNT(?s) AS ?anticuerpos_proteina)
WHERE {
?s rdf:type mionto:Antibody .
?s mionto:citations ?c .
?s mionto:detects_antigen ?prot .
?prot rdfs:label ?protein .
}

GROUP BY ?protein
HAVING (xsd:integer(COUNT(?s)) >= 2)
ORDER BY DESC(?MAXcitaciones)"

resq4<- SPARQL(endpoint,query4)
resq4$results


#Query 5
query5 <- "PREFIX rdfs: 	<http://www.w3.org/2000/01/rdf-schema#> 
PREFIX up:		<http://purl.uniprot.org/core/> 


SELECT DISTINCT ?protein ?nombre ?mnemonic ?review ?fechamodificacion ?seq (COUNT(?GO) AS ?numeroGO) 
WHERE {
?protein rdf:type up:Protein .
?protein rdfs:label 'MLKL protein'
  
SERVICE <https://sparql.uniprot.org/> {
	?protein rdfs:label ?nombre .
 	?protein up:mnemonic ?mnemonic. 
     		?protein up:reviewed ?review .
    		?protein up:modified ?fechamodificacion .
    		?protein up:sequence ?seq .
    		?protein up:classifiedWith ?i .
    		?i rdfs:label ?GO 
  }
}
GROUP BY ?protein ?nombre ?mnemonic ?review ?fechamodificacion ?seq"

resq5<- SPARQL(endpoint,query5)
resq5$results
