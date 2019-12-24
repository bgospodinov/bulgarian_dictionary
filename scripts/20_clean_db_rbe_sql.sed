/^INSERT INTO `word`/ {
	s/^.*VALUES //
	s/;$//
	s/,NULL\),\(/\n/g
	/^$/ d
	p
}
