BEGIN TRANSACTION;

-- deletes duplicate names
DELETE FROM lemma WHERE ROWID IN (
	SELECT ROWID FROM (
		SELECT ROWID, ROW_NUMBER() OVER(PARTITION BY lemma, pos) AS rownum FROM lemma WHERE pos = 'H'
	)
	WHERE rownum > 1
);

END TRANSACTION;