DROP VIEW IF EXISTS persistent_OTUs;
CREATE VIEW persistent_OTUs AS
SELECT ot.OTUId,
		ConD0R12,
		ConD0R21,
		ConD56R21,
		ConD7R21,
		CX1D56R21,
		CX1D7R21,
		CX4D56R21,
		CX4D7R21,
		YX1D56R21,
		YX1D7R21,
		YX4D56R21,
		YX4D7R21,
		ConD56R12,
		ConD7R11,
		CX1D56R11,
		CX1D7R11,
		CX4D56R11,
		CX4D7R11,
		DConD0R1,
		DConD0R2,
		YX1D56R11,
		YX1D7R11,
		YX4D56R11,
		YX4D7R11,
		d.name AS domain, d.confidence AS domain_confidence, 
		p.name AS phylum, p.confidence AS phylum_confidence, 
		c.name AS class, c.confidence AS class_confidence, 
		o.name AS order_, o.confidence AS order_confidence, 
		f.name AS family, f.confidence AS family_confidence, 
		g.name AS genus, g.confidence AS genus_confidence, 
		s.name AS species, s.confidence AS species_confidence,
		IF(NOT(ISNULL(s.name)) && NOT(ISNULL(s.confidence)) && s.confidence > .50, s.name,
			IF(NOT(ISNULL(g.name)) && NOT(ISNULL(g.confidence)) && g.confidence > .50, g.name,
				IF(NOT(ISNULL(f.name)) && NOT(ISNULL(f.confidence)) && f.confidence > .50, f.name,
					IF(NOT(ISNULL(o.name)) && NOT(ISNULL(o.confidence)) && o.confidence > .50, o.name,
						IF(NOT(ISNULL(c.name)) && NOT(ISNULL(c.confidence)) && c.confidence > .50, c.name,
							IF(NOT(ISNULL(p.name)) && NOT(ISNULL(p.confidence)) && p.confidence > .50, p.name,
								IF(NOT(ISNULL(d.name)) && NOT(ISNULL(d.confidence)) && d.confidence > .50, d.name, "unknown"))))))) AS best_tax,
		IF(NOT(ISNULL(s.name)) && NOT(ISNULL(s.confidence)) && s.confidence > .50, s.confidence,
			IF(NOT(ISNULL(g.name)) && NOT(ISNULL(g.confidence)) && g.confidence > .50, g.confidence,
				IF(NOT(ISNULL(f.name)) && NOT(ISNULL(f.confidence)) && f.confidence > .50, f.confidence,
					IF(NOT(ISNULL(o.name)) && NOT(ISNULL(o.confidence)) && o.confidence > .50, o.confidence,
						IF(NOT(ISNULL(c.name)) && NOT(ISNULL(c.confidence)) && c.confidence > .50, c.confidence,
							IF(NOT(ISNULL(p.name)) && NOT(ISNULL(p.confidence)) && p.confidence > .50, p.confidence,
								IF(NOT(ISNULL(d.name)) && NOT(ISNULL(d.confidence)) && d.confidence > .50, d.confidence, "0"))))))) AS best_tax_confidence,
		IF(NOT(ISNULL(s.name)) && NOT(ISNULL(s.confidence)) && s.confidence > .50, "species",
			IF(NOT(ISNULL(g.name)) && NOT(ISNULL(g.confidence)) && g.confidence > .50, "genus",
				IF(NOT(ISNULL(f.name)) && NOT(ISNULL(f.confidence)) && f.confidence > .50, "family",
					IF(NOT(ISNULL(o.name)) && NOT(ISNULL(o.confidence)) && o.confidence > .50, "order",
						IF(NOT(ISNULL(c.name)) && NOT(ISNULL(c.confidence)) && c.confidence > .50, "class",
							IF(NOT(ISNULL(p.name)) && NOT(ISNULL(p.confidence)) && p.confidence > .50, "phylum",
								IF(NOT(ISNULL(d.name)) && NOT(ISNULL(d.confidence)) && d.confidence > .50, "domain", "unknown"))))))) AS best_tax_level,
		sequence
	FROM final_zotus AS ot
		INNER JOIN final_zotus_sequences AS st ON ot.OTUId = st.otu
		LEFT JOIN final_zotus_classifications AS d ON ot.OTUId = d.OTUId AND d.rank = "domain"
		LEFT JOIN final_zotus_classifications AS p ON ot.OTUId = p.OTUId AND p.rank = "phylum"
		LEFT JOIN final_zotus_classifications AS c ON ot.OTUId = c.OTUId AND c.rank = "class"
		LEFT JOIN final_zotus_classifications AS o ON ot.OTUId = o.OTUId AND o.rank = "order"
		LEFT JOIN final_zotus_classifications AS f ON ot.OTUId = f.OTUId AND f.rank = "family"
		LEFT JOIN final_zotus_classifications AS g ON ot.OTUId = g.OTUId AND g.rank = "genus"
		LEFT JOIN final_zotus_classifications AS s ON ot.OTUId = s.OTUId AND s.rank = "species"
	WHERE 0
		OR (ConD0R12 / (SELECT SUM(ConD0R12) FROM final_zotus) > 0.000000)
		OR (ConD0R21 / (SELECT SUM(ConD0R21) FROM final_zotus) > 0.000000)
		OR (ConD56R21 / (SELECT SUM(ConD56R21) FROM final_zotus) > 0.000000)
		OR (ConD7R21 / (SELECT SUM(ConD7R21) FROM final_zotus) > 0.000000)
		OR (CX1D56R21 / (SELECT SUM(CX1D56R21) FROM final_zotus) > 0.000000)
		OR (CX1D7R21 / (SELECT SUM(CX1D7R21) FROM final_zotus) > 0.000000)
		OR (CX4D56R21 / (SELECT SUM(CX4D56R21) FROM final_zotus) > 0.000000)
		OR (CX4D7R21 / (SELECT SUM(CX4D7R21) FROM final_zotus) > 0.000000)
		OR (YX1D56R21 / (SELECT SUM(YX1D56R21) FROM final_zotus) > 0.000000)
		OR (YX1D7R21 / (SELECT SUM(YX1D7R21) FROM final_zotus) > 0.000000)
		OR (YX4D56R21 / (SELECT SUM(YX4D56R21) FROM final_zotus) > 0.000000)
		OR (YX4D7R21 / (SELECT SUM(YX4D7R21) FROM final_zotus) > 0.000000)
		OR (ConD56R12 / (SELECT SUM(ConD56R12) FROM final_zotus) > 0.000000)
		OR (ConD7R11 / (SELECT SUM(ConD7R11) FROM final_zotus) > 0.000000)
		OR (CX1D56R11 / (SELECT SUM(CX1D56R11) FROM final_zotus) > 0.000000)
		OR (CX1D7R11 / (SELECT SUM(CX1D7R11) FROM final_zotus) > 0.000000)
		OR (CX4D56R11 / (SELECT SUM(CX4D56R11) FROM final_zotus) > 0.000000)
		OR (CX4D7R11 / (SELECT SUM(CX4D7R11) FROM final_zotus) > 0.000000)
		OR (DConD0R1 / (SELECT SUM(DConD0R1) FROM final_zotus) > 0.000000)
		OR (DConD0R2 / (SELECT SUM(DConD0R2) FROM final_zotus) > 0.000000)
		OR (YX1D56R11 / (SELECT SUM(YX1D56R11) FROM final_zotus) > 0.000000)
		OR (YX1D7R11 / (SELECT SUM(YX1D7R11) FROM final_zotus) > 0.000000)
		OR (YX4D56R11 / (SELECT SUM(YX4D56R11) FROM final_zotus) > 0.000000)
		OR (YX4D7R11 / (SELECT SUM(YX4D7R11) FROM final_zotus) > 0.000000)
	GROUP BY ot.OTUId
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
SELECT * FROM persistent_OTUs;
