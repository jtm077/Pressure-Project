#!/bin/bash

# Define the target directory for input and output
TARGET_DIR="/mnt/c/Users/morel/OneDrive/Desktop/Pressure/Tutorial/fastq_output"

# Set number of threads
THREADS=4

# List of file pairs to trim
declare -a PAIRS=(
    "SRR15927811_1.fastq.gz SRR15927811_2.fastq.gz"
    "SRR15927812_1.fastq.gz SRR15927812_2.fastq.gz"
    "SRR15927813_1.fastq.gz SRR15927813_2.fastq.gz"
    "SRR15927837_1.fastq.gz SRR15927837_2.fastq.gz"
)

# Move into the target directory
cd "$TARGET_DIR" || { echo "Error: Target directory not found!"; exit 1; }

# Loop through each pair
for pair in "${PAIRS[@]}"; do
    set -- $pair
    READ1=$1
    READ2=$2

    echo "Trimming $READ1 and $READ2 with $THREADS threads..."
    
    # Run trim_galore in paired-end mode with multi-threading
    trim_galore --paired --gzip --fastqc --cores "$THREADS" "$READ1" "$READ2" --output_dir "$TARGET_DIR"
done

echo "We fucking did it."
