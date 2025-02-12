# Kallisto: Creating an Index & Aligning Reads

On to the next _super fun_ activity: Kallisto. ._.
> Kallisto is a program that analyzes RNA sequencing data to quantify the abundance of transcripts. It's a fast tool that performs pseudoalignment to determine which transcripts are compatible with each read. We are using this because we are interested in looking at the level of gene expression within a cell or tissue. Therefore, using this tool will allow us to understand which genes are actively being transcribed and producing proteins. This will help us gain insight on cellular processes, developmental stages, responses to stimuli, whatever you want. It is pretty well-suited for what we are interested in looking at in the lab, isn't it? If you don't think so, then I don't even know.

In order to look at the expression of genes within these tissue samples, we will have to generate read counts. Kallisto will find reads that match our reference targets and generate these counts.

## Building the reference transcriptome index
The first step to a Kallisto analysis would be building a k-mer index.
> **What the fuck is a k-mer?** A k-mer is a short sequence of nucleotides or amino acids that are contiguous and of a fixed length. It is a sequence of "k" characters (kinda like letters in a word) taken from a larger string. Like, imagine my name was Greg, and I split my name into two substrings where k=2. Then, I have two k-mers: "Gr" and "eg". Just like how we break up words to analyze pronunciation, we can break up nucleotide sequences to analyze DNA samples. Okay, tangent over. 

I could give you the index, but also this did not take long to do, so I am forcing you to learn it. It's okay, we love learning new things. In order to build an index, we need transcripts. We will get our transcripts from [here](https://ftp.ensembl.org/pub/release-113/fasta/danio_rerio/cdna/). Download the 'Danio_rerio.GRCz11.cdna.all.fa.gz'. Now, we can run the following command:

```
kallisto index -i zebrafish_transcripts.idx Danio_rerio.GRCz11.cdna.all.fa.gz

```
This command will output a file called ```zebrafish_transcripts.idx```, which we will use for the next step!

## Pesudoalignment and quantification with Kallisto
We are ready to pseudoalign and count transcripts! We quanitfy counts using the following command:

```
kallisto quant \
        -i "$idx" \
        -o "$output/$sample" \
        -t "$threads" \
        -b "$bootstraps" \
        ${samples[$sample]}
```
* ```quant``` is the command that will run quanitification. 
* ```-i``` specifies the index
* ```-o``` sets the output directory
* ```-t``` sets the number of CPUs
* ```-b``` sets the number of bootstrap repetitions that are used to calculate measurement variance used in the downstream analyses.

So, we will have to repeat this entire analysis on each sample. At the bottom of the ```quant``` command, you will notice a block of code: ```${samples[$sample]}```. That will insert our samples, and one by ne, run the ```quant``` analyses. We will achieve this feat using the following script:
* [kallisto_quant.sh](https://github.com/jtm077/Pressure-Project/blob/main/RNA-Seq%20Tutorial/scripts/kallisto_quant.sh)

Now, the output includes read counts and measurement variances, which will all be stored in the output folder. You will want to move this folder into the folder you will conduct your R analyses in. For simplicity's sake, I suggest just creating a folder called ```DEG_Analysis```.

Now that we have that all set, we can move on to our analyses in RStudio! On to [Part VI](https://github.com/jtm077/Pressure-Project/blob/main/RNA-Seq%20Tutorial/Part%20VI.md)!