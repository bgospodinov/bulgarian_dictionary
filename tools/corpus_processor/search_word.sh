#!/bin/bash
source "${BASH_SOURCE%/*}/include.sh"
PATH_TO_CORPUS=$(realpath --relative-to=. "${BASH_SOURCE%/*}/$PATH_TO_CORPUS")

grep -Eriwn --color=always "$1" "$PATH_TO_CORPUS" | less
