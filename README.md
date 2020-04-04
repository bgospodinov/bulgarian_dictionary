This repository contains code that produces a dictionary of 200 000 Bulgarian lemmata and 2 million wordforms along with their stress patterns, morphosyntactic properties and pronunciation. It is meant to be used as a dictionary to assist with translating or writing metric and rhymed poetry in Bulgarian. It is based on previous Bulgarian linguistic resources such as Slovnik, RBE and Rechko.

The build script requires a Linux distribution, although the resulting artifact is a platform-independent SQLite file. Recommended RAM > 2GB. The script uses as many cores as possible when parallelization is feasible.

For best results mount /tmp to main memory as tmpfs or ramfs.

The Slovnik dictionary is encrypted as it is not intended for public use. Add option --no-slovnik to skip augmenting Slovnik into the final artifact. If you want to gain access to Slovnik, contact a BTB member at http://bultreebank.org. Afterwards, I will provide you with the password to decrypt Slovnik.

If you find any mistakes in the scripts or the dictionary itself, please raise an issue or contact the maintainer: b g o s p o d i n o v at pr ot on m ail dot c o m.