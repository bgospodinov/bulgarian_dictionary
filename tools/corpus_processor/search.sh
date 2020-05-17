#!/bin/bash
source "${BASH_SOURCE%/*}/include.sh"
grep -Eriwn --color=always "$1" "$PATH_TO_CORPUS" | less -N
