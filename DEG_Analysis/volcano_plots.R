#### Volcano ######

# Load necessary libraries
library(dplyr)
library(readr)
library(sleuth)
library(EnhancedVolcano)

# Read in sample tables - be sure to set the correct path
metadata <- read.table(file = "ExpTable_Press_Brain.txt", sep='\t', header=TRUE, stringsAsFactors = FALSE)

# Set up paths to the kallisto output that we will process
metadata <- dplyr::mutate(metadata,
                          path = file.path('quant', sample, 'abundance.h5'))

# Check the metadata formatting
metadata

# Read in Ensembl BioMart mapping file (transcript-to-gene mapping)
biomart_map <- read_delim("ensemble.txt", delim = "\t", col_names = TRUE)

# Ensure correct column names
colnames(biomart_map) <- c("gene_name", "gene_id", "target_id")

# Use this mapping in sleuth_prep
so <- sleuth_prep(metadata, full_model = ~treat, target_mapping = biomart_map, 
                  extra_bootstrap_summary = TRUE, read_bootstrap_tpm = TRUE, 
                  aggregation_column = "gene_name")

# Fit the model
so <- sleuth_fit(so)

# Print the model
models(so)

# Calculate the Wald test statistic for 'treatpress'
so <- sleuth_wt(so, 'treatpress')

# Extract the Wald test results for each gene
genes_all <- sleuth_results(so, 'treatpress', show_all = FALSE, pval_aggregate = FALSE)

# View the top 10 results
head(genes_all, 10)

# Filter for significant genes (q-value <= 0.05)
genes_sig <- dplyr::filter(genes_all, qval <= 0.05)

# Select the top 50 significant genes
genes_50 <- genes_sig %>% head(50)

# Prepare data for the volcano plot
forVolcano <- data.frame(genes_all$gene_name, genes_all$qval, genes_all$b)

# Rename the columns
colnames(forVolcano) <- c("gene_name", "qval", "b")

# Remove NA values to ensure all genes are properly labeled
forVolcano <- na.omit(forVolcano)

# Generate the volcano plot
EnhancedVolcano(forVolcano,
                lab = forVolcano$gene,
                x = 'b',
                y = 'qval',
                xlab = "\u03B2",
                labSize = 3,
                legendPosition = "none")
