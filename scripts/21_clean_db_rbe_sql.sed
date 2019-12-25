s/^\(//1g
s/,NULL\)//1g
# remove last column from sql inserts
s/([0-9]+(,'.*'){4}),'.*'$/\1/
# remove third column from sql inserts
s/,'\w',/,/
# replace , with custom ^ separator
s/^([0-9]+),'/\1^/
s/','/^/g
s/'$//g
s/^'/^/g
