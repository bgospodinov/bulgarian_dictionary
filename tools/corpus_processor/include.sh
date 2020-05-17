#!/bin/bash
set -e
set -o pipefail
export PATH_TO_CORPUS=$(realpath --relative-to=. "${BASH_SOURCE%/*}/../../corpora/chitanka/")
export MODEL_PATH=$(realpath --relative-to=. "${BASH_SOURCE%/*}/models")
mkdir -p "$MODEL_PATH"
