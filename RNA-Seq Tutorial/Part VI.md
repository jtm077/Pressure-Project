# Part VI: Sleuth (in R Studio): Statistical Analysis & Mapping
We will be comparing transcript expression levels between our treatment groups (0.1 MPa and 9.0 MPa) using sleuth.

> Sleuth an R package used for analyzing RNA-Seq data. It is specifically used for differential expression analysis. It leverages the quantification uncertainty estimates provided by Kallisto to perform more accurate comparisons between different samples. Essentially, it is a tool for exploring and statistially analyzing RNA sequences.

## File preparation
Before we can fully analyze our data, we have to prepare two different files. 

The first file we need will contain the transcript ID and gene symbols. This will be important later when we make visualizations of the data. Without it, we won't have data labels, and we won't be able to tell which genes are which just looking at them. In order to get these, we will need to take another trip to ensembl. To save you some time in figuring out that dumbass [website](), the file is bewlow. Save this to your ```DEG_Analysis``` folder:
* [ensemble.txt]()


Now, in a text editor, we will need to create a tab-separated list of treatment conditions for our samples:
```
sample	treat	path
Brain2_0.1	control	/Users/morel/OneDrive/Desktop/Pressure-Project/DEG_Analysis/quant/Brain2_0.1
Brain2_9.0	press	/Users/morel/OneDrive/Desktop/Pressure-Project/DEG_Analysis/quant/Brain2_9.0
Brain3_9.0	press	/Users/morel/OneDrive/Desktop/Pressure-Project/DEG_Analysis/quant/Brain3_9.0
Brain4_9.0	press /Users/morel/OneDrive/Desktop/Pressure-Project/DEG_Analysis/quant/Brain4_9.0
```
Save this as a text file ```ExpTable_Press_Brain.txt``` in your ```DEG_Analysis``` folder.

## Preparing RStudio
Okay, if you haven't yet, start up RStudio. Before we can start anything, let's make sure you have your working directory set to your ```DEG_Analysis``` folder. You can do that by going to the top of the window and navigating through the following tabs: Session < Set Working Directory < Choose Directory. Select your ```DEG_Analysis``` folder. 

Now, we need to install the necessary packages. To install them, run the following commands in your console:
```
if (!requireNamespace('BiocManager', quietly = TRUE))
  install.packages('BiocManager')

BiocManager::install('EnhancedVolcano')
BiocManager::install("devtools")
BiocManager::install("pachterlab/sleuth")
BiocManager::install('readr')
```

Good job. We have to load these packages:
```
library(sleuth)
library(tidyverse)  
library(EnhancedVolcano)
library(pheatmap)
library(readr)
```
## Differential gene expression analysis
Now, we will begin analysis. 

### Setting up our MetaData
```
# Read in sample tables - be sure to set the correct path
metadata <- read.table(file = "ExpTable_Press_Brain.txt", sep='\t', header=TRUE, stringsAsFactors = FALSE)

# Set up paths to the kallisto output that we will process
metadata <- dplyr::mutate(metadata,
                          path = file.path('quant', sample, 'abundance.h5'))

# Check the metadata formatting
metadata

# Read in Ensembl BioMart mapping file (this is so we can match our transcript IDs to gene names)
biomart_map <- read_delim("ensemble.txt", delim = "\t", col_names = TRUE)

# Ensure correct column names
colnames(biomart_map) <- c("gene_name", "gene_id", "target_id")
```

### Processing our data with ```sleuth```
First, we need to process our data with ```sleuth_prep```. This command will take all of the data from each sample and aggregate them.
```
so <- sleuth_prep(metadata, full_model = ~treat, target_mapping = biomart_map, extra_bootstrap_summary = TRUE, read_bootstrap_tpm = TRUE, aggregation_column = "gene_name")
```

```full_model``` tells sleuth which model we are interested in analzing. For us, that is the effect of the treatment (pressure). ```target_mapping``` will map our gene names to the transcript IDs. The bootstrap commands calculate statistics for supplemental analyses. ```aggregation_column``` sets up the dataset so we can aggregate transcripts of the same gene for our samples.

Next, we are going to fit the model and calculate the test statistics:
```
# Fit the model
so <- sleuth_fit(so)

# Print the model
models(so)

# [  full  ]
# formula:  ~treat 
# data modeled:  obs_counts 
# transform sync'ed:  TRUE 
# coefficients:
#	  (Intercept)
# 	treatpress

# Calculate the Wald test statistic for 'treatpress'
so <- sleuth_wt(so, 'treatpress')
```
The Wald test requires a coefficient of interest. We used ```'treatpress'```, which you san see is from the model coefficients. The coefficient represents the specific group that was treated with pressure.

> Cutesie and fun extra information: the Wald test is a statistical test used to determine if a coefficient (in our case, the group treated with pressure) in a fitted model is significant from zero. It will help us identify differentially expressed genes (DEGs) by comparin the estimated size of effect to its standard error (letting us detect significant changes in gene expression between the groups against the control or other groups).

Anyways, our code made the results of the test part of our sleuth object ```so```. Let's get those results:
```
# Extract the Wald test results for each gene
genes_all <- sleuth_results(so, 'treatpress', show_all = FALSE, pval_aggregate = FALSE)
```
```pval_aggregate = FALSE``` returns the transcript level comparisons and ```show_all = FALSE``` drops observations with missing data (those can cause problems later on, so we remove them).

We can take a look at our results now:
```
head(genes_all, 10)

 gene_name            gene_id            target_id
1        atp6v0d1 ENSDARG00000069090 ENSDART00000191891.1
2          ywhabl ENSDARG00000040287 ENSDART00000183920.1
3           dpp6b ENSDARG00000024744 ENSDART00000186781.1
4          azin1b ENSDARG00000035869 ENSDART00000179947.1
5          fabp7a ENSDARG00000007697 ENSDART00000149568.2
6  si:dkey-19e4.5 ENSDARG00000089886 ENSDART00000151179.2
7         atp2a2b ENSDARG00000005122 ENSDART00000167298.2
8          asap1b ENSDARG00000039729 ENSDART00000186494.1
9           prdx5 ENSDARG00000055064 ENSDART00000186550.1
10         ap2m1a ENSDARG00000002790 ENSDART00000165548.2
            pval          qval        b      se_b mean_obs  var_obs
1   0.000000e+00  0.000000e+00 8.912452 0.2097236 5.991192 19.87994
2   0.000000e+00  0.000000e+00 9.911301 0.1614201 6.802474 24.57150
3   0.000000e+00  0.000000e+00 8.467637 0.2189417 5.657580 17.93042
4   0.000000e+00  0.000000e+00 9.053202 0.1847967 6.096755 20.49136
5   0.000000e+00  0.000000e+00 9.373394 0.1690435 6.336899 21.97157
6   0.000000e+00  0.000000e+00 8.498176 0.2140975 5.680485 18.06999
7  1.158142e-292 5.357235e-289 8.827990 0.2414539 5.927861 19.51250
8  3.558592e-250 1.440340e-246 8.227552 0.2435444 5.477517 16.92370
9  1.875062e-238 6.746055e-235 8.109102 0.2459192 5.388679 16.44451
10 3.577054e-218 1.158250e-214 8.050619 0.2553472 5.344817 16.23010
       tech_var      sigma_sq smooth_sigma_sq final_sigma_sq
1  0.0004464216  0.0325415844      0.02645053     0.03254158
2  0.0025537614  0.0169885640      0.01596598     0.01698856
3  0.0024094169  0.0053875952      0.03354217     0.03354217
4  0.0010047195  0.0008547574      0.02460765     0.02460765
5  0.0004277053  0.0092279384      0.02100407     0.02100407
6  0.0013924150  0.0214692148      0.03298590     0.03298590
7  0.0017657567  0.0419592502      0.02764144     0.04195925
8  0.0061571456 -0.0053349925      0.03832828     0.03832828
9  0.0043737669  0.0033091546      0.04098342     0.04098342
10 0.0065290118  0.0339373280      0.04237264     0.04237264
```
Some notes:
* ```qval``` is a false discovery rate adjusted p-value (calculated using the Benjamini-Hochberg method if you even care).
* ```b``` is the effect size estimator of the fold change between conditions.

Okay, we only looked at the first 10, but this table actually has around 32,000 genes. We only care about the genes that are _significantly_ differentially expressed. We are going to filter out the ones that aren't by using ```qval``` in the ```dplyr``` package:
```
# Filter for significant genes (q-value <= 0.05)
genes_sig <- dplyr::filter(genes_all, qval <= 0.05)
```
This command takes us from 30,000 genes to 7,000. Even better, this is sorted by qval, which means we can even slim down this list to look at the top 50 genes that are the most significantly differentially expressed:
```
# Select the top 50 significant genes
genes_50 <- genes_sig %>% head(50)
```

### Volcano plots
A volcano plot plots each transcript on an x-axis of fold-change in expression and y-axis of p-value. The most differentially expressed genes will be found at the upper right and left corners of the plot. It is a very useful way to visualize the relative expression of all the transcripts between two conditions. We can create a volcano plot using ```EnhancedVolcano```.
```
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

```
![volcano_plot]()

### Heat Maps
We can also visualize differential gene expression with a heat map. In order to plot the map, we need to get the counts for each transcript and sample. All of this has been stored in the sleuth object ```so```. We will export it using ```kallisto_table``` command.
```
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
```
Now, before we can plot our map, we need to apply a log10 transformation and convert the dataset into a square matrix:
```
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
```
![heat_map]()

### Gene Ontology
It is great that we can see what genes are being differentially expressed when zebrafish are being exposed to high hydrostatic pressure, but what do these genes even do? To look further into what this stress could be affecting, we can look at the known functions of our enriched transcripts. 

To do this, we will be using ShinyGO. All we need to do is get a list of our DEGs' gene symbols and the list of all of the genes in the transcriptome. We are going to extract this data form our ```genes_all``` dataframe. 
```
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

#copy to clipboard and paste into ShinyGO
writeClipboard(as.character(up))

#copy to clipboard and paste into ShinyGO
writeClipboard(as.character(all))
```
There are a lot of analyses that can be viewed on ShinyGO. If you have time, explore some more. If you see something interesting, come talk to me or Dr. Mika about it! We love to yap (especially me)! Below is the gene ontology (GO) biological process enrichment for the dataset we just did! It looks like pressure seems to be affecting ribosomal proteins!

But you reached it to the end! Of the tutorial...

Click here for more >:)