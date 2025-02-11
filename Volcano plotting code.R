#### Volcano ######

#read in sample tables - be sure to set correct path 

metadata <- read.table(file = "ExpTable_Press_Brain.txt", sep='\t', header=TRUE, stringsAsFactors = FALSE)

#this command sets up paths to the kallisto output that we will process in the following steps

metadata <- dplyr::mutate(metadata,
                          path = file.path('quant', sample, 'abundance.h5'))

#then we check the metadata to ensure it is in correct formatting
>metadata


#Read in headers for the transcripts that we aligned to with kallisto
#These will be mapped in the sleuth_prep command below

ttn<-read_delim("Press_headers.txt", col_names = FALSE)

colnames(ttn)<-c("target_id","gene")

#sleuth_prep:
so <- sleuth_prep(metadata, full_model = ~treat, target_mapping = ttn, extra_bootstrap_summary = TRUE, read_bootstrap_tpm = TRUE, aggregation_column = "gene")

#fitted model and stats
#fit model specified above
so <- sleuth_fit(so)

#print the model
models(so)

#calculate the Wald test statistic for 'beta' coefficient on every transcript 
so <- sleuth_wt(so, 'treatPress')

Next we will recover the results:
  #extract the wald test results for each transcript 
  transcripts_all <- sleuth_results(so, 'treatPress', show_all = FALSE, pval_aggregate = FALSE)

We can look at our data:
  > head(transcripts_all, 10)

Now we can filter by significance:
  #filtered by significance 
  transcripts_sig <- dplyr::filter(transcripts_all, qval <= 0.05)

Now we will select the top 50 significant transcripts, do not be alarmed if there are not 50 that just means we have less than 50 significant genes.

transcripts_50 <- dplyr::filter(transcripts_all, qval <= 0.05) %>%
  head(50)

In case we have multiple significant transcripts for the same gene, you can aggregate these transcripts and calculate gene-level tests. To do this we can set pval_aggregate = TRUE. 
genes_all <- sleuth_results(so, 'treatTTC', show_all = FALSE, pval_aggregate = TRUE)

> head(genes_all, 10)

#plot
#extract the gene symbols, qval, and b values from the Wlad test results
forVolacano<-data.frame(transcripts_all$gene, transcripts_all$qval, transcripts_all$b)

#rename the columns of the dataframe
colnames(forVolacano)<-c("gene","qval","b")

#plot
EnhancedVolcano(forVolacano,
                lab = forVolacano$gene,
                x = 'b',
                y = 'qval',
                xlab = "\u03B2",
                labSize = 3,
                legendPosition = "none")