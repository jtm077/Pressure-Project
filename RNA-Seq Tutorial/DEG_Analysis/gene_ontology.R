#### Gene Ontology ####
#filter for transcripts enriched in the Press treatment
transcripts_up <- dplyr::filter(genes_all, qval <= 0.05, b > 0)

up<-transcripts_up %>%
  dplyr::select(gene_name)

#filter for transcripts depleted in the Press treatment
transcripts_down <- dplyr::filter(genes_all, qval <= 0.05, b < 0)

down<-transcripts_down %>%
  dplyr::select(gene_name)

#output the full transcript list
all<-genes_all %>%
  dplyr::select(gene_name)

#copy to clipboard and paste on ShinyGO
writeClipboard(as.character(up))

#copy to clipboard and paste into 'background' on ShinyGO
writeClipboard(as.character(all))
