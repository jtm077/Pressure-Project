#!/bin/bash

# Define the paths
idx="/mnt/c/Users/morel/OneDrive/Desktop/Pressure/Tutorial/zebrafish_transcripts.idx"
output="/mnt/c/Users/morel/OneDrive/Desktop/Pressure/Tutorial/quant"
threads=4
bootstraps=50
mkdir -p "$output"
# Define the read pairs and output names
declare -A samples=(
    ["Brain2_0.1"]="SRR15927837_1_val_1.fq.gz SRR15927837_2_val_2.fq.gz"
    ["Brain4_9.0"]="SRR15927811_1_val_1.fq.gz SRR15927811_2_val_2.fq.gz"
    ["Brain3_9.0"]="SRR15927812_1_val_1.fq.gz SRR15927812_2_val_2.fq.gz"
    ["Brain2_9.0"]="SRR15927813_1_val_1.fq.gz SRR15927813_2_val_2.fq.gz"
    )

# Loop through the samples and run Kallisto
for sample in "${!samples[@]}"; do
    echo "Processing $sample..."
    kallisto quant \
        -i "$idx" \
        -o "$output/$sample" \
        -t "$threads" \
        -b "$bootstraps" \
        ${samples[$sample]}
done

echo "Banana Cream Pie!"
