#!/bin/bash
set -e
set -o pipefail
export PATH_TO_CORPUS=../../corpora/chitanka/
export MODEL_PATH=models

mkdir -p $MODEL_PATH
