BEGIN TRANSACTION;

-- join all wordforms from the morphological dictionary (slovnik_wordform table)
-- with their corresponding lemmata and stresses from the RBE dictionary (lemma table)
CREATE TABLE IF NOT EXISTS wordform AS
SELECT
	wordform,
	slovnik_lemma,
	wordform_stress,
	lemma_id,
	is_lemma,
	tag,
	num_syllables
FROM
	(
		SELECT 
			s.wordform as wordform,
			s.lemma as slovnik_lemma,
			r.lemma_with_stress as lemma_stress,
			s.is_lemma as is_lemma,
			r.rowid as lemma_id,
			CASE WHEN is_lemma = 1 THEN r.lemma_with_stress ELSE NULL END AS wordform_stress,
			s.tag as tag,
			s.num_syllables as num_syllables
		FROM
			slovnik_wordform s
		-- because RBE doesnt have tag information, we have to redundantly join all combinations of wordforms and tags onto the lemma in the RBE dictionary
		LEFT JOIN
			lemma r
		ON
			s.lemma = r.lemma
	) q;
END TRANSACTION;
