/^INSERT INTO `word`/ {
	s/^.*VALUES //
	s/;$//
	/^$/ d
	# split inserts into newlines
	s/,NULL\),\(/\n/g
	# split inserts into newlines
	# split rows with non-null 6th column
	s/\),\(/\n/g
	p
}
