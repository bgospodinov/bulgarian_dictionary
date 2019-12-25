/^INSERT INTO `word`/ {
	s/^.*VALUES //
	s/;$//
	# split inserts into newlines
	s/([0-9]+(,'.*'){5})\),\(/\1\n/g
	# split inserts into newlines
	s/,NULL\),\(/\n/g
	/^$/ d
	p
}
