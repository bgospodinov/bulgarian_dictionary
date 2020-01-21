# replace parentheses from beginning and end
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
# remove row id
s/^[0-9]+\^//1g
# convert to lowercase letters
s/(([[:upper:]`]+)\^){2}/\L&/g
# fixing errors in rbe
1,3s/а`\^а/а^а`/g
# remove short hyphen character (&shy;), that is used to break words across lines
s/\xc2\xad//g
