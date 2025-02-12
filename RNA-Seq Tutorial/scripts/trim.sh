#!/bin/bash
target_dir="/mnt/c/Users/morel/OneDrive/Desktop/Pressure/Tutorial/fastq_output"
output_dir="/mnt/c/Users/morel/OneDrive/Desktop/Pressure/Tutorial/trimmed_fastq_output"
threads=4

declare -a PAIRS=(
    "SRR15927811_1.fastq.gz SRR15927811_2.fastq.gz"
    "SRR15927812_1.fastq.gz SRR15927812_2.fastq.gz"
    "SRR15927813_1.fastq.gz SRR15927813_2.fastq.gz"
    "SRR15927837_1.fastq.gz SRR15927837_2.fastq.gz"
)
mkdir -p "$output_dir"
cd "$target_dir" || { echo "are you dumb? that directory does not exist!"; exit 1; }

for pair in "${PAIRS[@]}"; do
    set -- $pair
    read1=$1
    read2=$2

    echo "trimming $read1 and $read2 with $threads threads..."
    
    trim_galore --paired --gzip --cores "$THREADS" "$READ1" "$READ2" --output_dir "$TARGET_DIR"
done

echo "We fucking did it."
