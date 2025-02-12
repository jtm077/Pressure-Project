target_dir="/mnt/c/Users/morel/OneDrive/Desktop/Pressure/Tutorial/fastq_output"
output_dir="/mnt/c/Users/morel/OneDrive/Desktop/Pressure/Tutorial/fastqc_output"

mkdir -p "$output_dir"
cd "$target_dir"

fastqc --threads 4 *fastq.gz --outdir "$output_dir"

echo "#donesies"