#!/bin/bash

if [[ ! -f "accessions.txt" ]]; then
  exit 1
fi

total=$(wc -l < "accessions.txt")
counter=0

while IFS= read -r accession; do
    ((counter++))
    printf "Processing $accession ($counter of $total)\n"
    fasterq-dump $accession --outdir . --split-files --gzip | pv -n > /dev/null
done < "accessions.txt"
