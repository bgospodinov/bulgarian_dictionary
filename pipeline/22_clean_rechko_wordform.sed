# removes beginning of insert queries
s/INSERT INTO.*VALUES //
# splits insert statements into one insert per csv row
s/\(([0-9]{1,7}(,'[^']*'|,NULL|,[0-9]*){11})\)[,;]/\1\n/g p