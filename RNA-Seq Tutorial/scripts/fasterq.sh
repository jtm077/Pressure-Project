#!/bin/bash

# Set number of threads
THREADS=4

# Set output directory (modify as needed)
OUTPUT_DIR="./fastq_output"
mkdir -p "$OUTPUT_DIR"

# Loop through all SRR accession numbers found in the directory
for SRR in $(ls | grep -oE "SRR[0-9]+"); do
    echo "Processing $SRR..."
    
    # Run fasterq-dump
    fasterq-dump --threads $THREADS --split-files --outdir "$OUTPUT_DIR" "$SRR"
    
    # Compress output (optional but recommended)
    pigz "$OUTPUT_DIR/$SRR"*.fastq
done

echo "All files processed!"
