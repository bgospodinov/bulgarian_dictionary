/бъд\.вр\.|мин\.неопр\.|мин\.пред\.|бъд\.пред\.|пр\.накл\.|условно накл|'—'/ d
/^\s*$/ d
# replace , with custom ^ separator
s/([0-9'L]*),([0-9'N])/\1^\2/g
s/NULL//g
# remove apostrophes
s/'\^/^/g
s/\^'/^/g