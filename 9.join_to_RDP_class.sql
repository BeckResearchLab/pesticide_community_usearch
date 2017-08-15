DROP TABLE IF EXISTS final_zotus_classifications_flat;
CREATE TABLE final_zotus_classifications_flat
SELECT otus.OTUId, 
		d.name AS domain, d.confidence AS domain_confidence, 
		p.name AS phylum, p.confidence AS phylum_confidence, 
		c.name AS class, c.confidence AS class_confidence, 
		o.name AS order_, o.confidence AS order_confidence, 
		f.name AS family, f.confidence AS family_confidence, 
		g.name AS genus, g.confidence AS genus_confidence, 
		s.name AS species, s.confidence AS species_confidence
	FROM (SELECT DISTINCT OTUId FROM final_zotus_classifications) AS otus
		LEFT JOIN final_zotus_classifications AS d ON otus.OTUId = d.OTUId AND d.rank = "domain"
		LEFT JOIN final_zotus_classifications AS p ON otus.OTUId = p.OTUId AND p.rank = "phylum"
		LEFT JOIN final_zotus_classifications AS c ON otus.OTUId = c.OTUId AND c.rank = "class"
		LEFT JOIN final_zotus_classifications AS o ON otus.OTUId = o.OTUId AND o.rank = "order"
		LEFT JOIN final_zotus_classifications AS f ON otus.OTUId = f.OTUId AND f.rank = "family"
		LEFT JOIN final_zotus_classifications AS g ON otus.OTUId = g.OTUId AND g.rank = "genus"
		LEFT JOIN final_zotus_classifications AS s ON otus.OTUId = s.OTUId AND s.rank = "species"
;

SELECT ot.OTUId,
		ConD0R12 AS "ConD0R12",
		ConD0R21 AS "ConD0R21",
		ConD56R21 AS "ConD56R21",
		ConD7R21 AS "ConD7R21",
		CX1D56R21 AS "CX1D56R21",
		CX1D7R21 AS "CX1D7R21",
		CX4D56R21 AS "CX4D56R21",
		CX4D7R21 AS "CX4D7R21",
		YX1D56R21 AS "YX1D56R21",
		YX1D7R21 AS "YX1D7R21",
		YX4D56R21 AS "YX4D56R21",
		YX4D7R21 AS "YX4D7R21",
		ConD56R12 AS "ConD56R12",
		ConD7R11 AS "ConD7R11",
		CX1D56R11 AS "CX1D56R11",
		CX1D7R11 AS "CX1D7R11",
		CX4D56R11 AS "CX4D56R11",
		CX4D7R11 AS "CX4D7R11",
		DConD0R1 AS "DConD0R1",
		DConD0R2 AS "DConD0R2",
		YX1D56R11 AS "YX1D56R11",
		YX1D7R11 AS "YX1D7R11",
		YX4D56R11 AS "YX4D56R11",
		YX4D7R11 AS "YX4D7R11",
		domain, domain_confidence, phylum, phylum_confidence, class, class_confidence,
			order_, order_confidence, family, family_confidence, genus, genus_confidence, species, species_confidence,
		sequence
	FROM final_zotus AS ot
		INNER JOIN final_zotus_classifications_flat AS cf ON ot.OTUId = cf.OTUId
		INNER JOIN final_zotus_sequences AS st ON ot.OTUId = st.otu
	ORDER BY ( 0
			+ ConD0R12
			+ ConD0R21
			+ ConD56R21
			+ ConD7R21
			+ CX1D56R21
			+ CX1D7R21
			+ CX4D56R21
			+ CX4D7R21
			+ YX1D56R21
			+ YX1D7R21
			+ YX4D56R21
			+ YX4D7R21
			+ ConD56R12
			+ ConD7R11
			+ CX1D56R11
			+ CX1D7R11
			+ CX4D56R11
			+ CX4D7R11
			+ DConD0R1
			+ DConD0R2
			+ YX1D56R11
			+ YX1D7R11
			+ YX4D56R11
			+ YX4D7R11
		) DESC
;
