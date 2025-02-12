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

# Calculate the Wald test statistic for 'treatpress'
so <- sleuth_wt(so, 'treatpress')
```