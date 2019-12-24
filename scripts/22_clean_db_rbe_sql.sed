# remove last column from sql inserts
s/([0-9]+(,'.*'){4}),'.*'$/\1/
