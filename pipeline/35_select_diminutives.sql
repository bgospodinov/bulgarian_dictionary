BEGIN TRANSACTION;

-- TODO: remove names
-- TODO: update derivative_id
UPDATE lemma 
SET derivative_type = 'diminutive' 
WHERE pos = 'N' AND
stressed = 0 AND
(
    lemma like '%че' OR
    lemma like '%це' OR
    lemma like '%йка' OR
    lemma like '%чица'
);

END TRANSACTION;