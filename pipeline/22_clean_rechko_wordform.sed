# removes beginning of insert queries
s/^INSERT INTO `derivative_form` VALUES //
# splits insert statements into one insert per csv row
s/\(([0-9]{1}[^)]+)\)[,;]/\1\n/g p