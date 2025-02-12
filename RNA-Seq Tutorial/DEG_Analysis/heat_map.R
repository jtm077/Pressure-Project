##### Heat Map #####

# Extract normalized expression table from sleuth
k_table <- kallisto_table(so, normalized = TRUE)

# Join kallisto table with biomart_map to get gene names
k_table <- k_table %>%
  left_join(genes_50, by = "target_id")  # Ensure target_id matches kallisto IDs

# Aggregate transcript-level TPM values into gene-level values
k_table_gene <- k_table %>%
  group_by(gene_id, sample) %>%   # Group by gene instead of transcript
  summarise(tpm = sum(tpm, na.rm = TRUE), .groups = "drop")  # Sum TPMs per gene

# Filter to only the top 50 DEGs
k_DEG <- k_table_gene %>%
  right_join(genes_50, by = "gene_id")  # Join by gene_nam

# Remove NAs and zeros
k_DEG <- k_DEG %>% filter(tpm > 0)

# Log-transform TPM values
k_DEG_select <- k_DEG %>%
  mutate(log_tpm = log10(tpm + 1)) %>%
  dplyr::select(gene_name, sample, log_tpm) %>%
  pivot_wider(names_from = sample, values_from = log_tpm) %>%
  filter(!is.na(gene_name)) %>%
  column_to_rownames("gene_name") %>%
  as.matrix()

# Check for remaining NA or infinite values
k_DEG_select[is.na(k_DEG_select)] <- 0  # Replace remaining NA with 0

# Plot heatmap
pheatmap(k_DEG_select, cexRow = 0.4, cexCol = 0.4, scale = "row")

