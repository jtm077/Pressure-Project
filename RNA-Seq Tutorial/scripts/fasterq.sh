#!/bin/bash
threads=4
ourout_dir="./fastq_output"
mkdir -p "$output_dir"

for SRR in $(ls | grep -oE "SRR[0-9]+"); do
    echo "working on $SRR..."
        fasterq-dump --threads $threads --split-files --outdir "$output_dir" "$SRR"

    pigz "$output_dir/$SRR"*.fastq
done

echo "lol, it's done!"
