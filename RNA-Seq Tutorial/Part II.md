# SRA Toolkit: Downloading the Sequence Data

## Downloading the SRA Toolkit
So, the SRA toolkit is a real neat thing. Using this, we can fetch the sequencing data we want using its accession numbers rather than be an absolute boomer who downloads files to their Downloads folder. To do this, you will want to run the following commands:

```
sudo apt install sra-toolkit
```

Good job. You did it.

## Fetching specific accession numbers and fastq
Here is where we finally get closer to the data. Now that we have the SRA toolkit, you can download some data.

First, we will get the following accession numbers:
| Accession #   | Tissue#_Press |
| ------------- | ------------- |
| SRX12217975   | T2_0.1MPa     |
| SRX12217956   | T4_9MPa       |
| SRX12217955   | T3_9MPa       |
| SRX12217954   | T2_9MPa       |

These accession numbers include three different samples of brain tissue from zebrafish put under 9MPa (90 atm). You may have noticed that we are downloading one that experienced 0.1MPa (10 atm). This experience is much closer to around the actual pressure exerted for shallow-water fish (such as zebrafish). Because of that, we can use that as our control for when we run our differential expressed gene (DEG) analysis later on this tutorial! Yay science!

Now, in order to get these numbers from NCBI, we are going to use the following script:
```
put something here
```

Yay, data has been retrieved! But slow down tiger, we got more preparation before we can mess with it. These are srr files, but we need them in fastq files to play around with them. Unfortunately for us, srr files are the compressed version of our files. Our next step is to extract the raw sequencing data from these files using "fasterq-dump". We can do this using the following script.
* [fasterq.sh](https://github.com/jtm077/Pressure-Project/blob/main/RNA-Seq%20Tutorial/scripts/fasterq.sh)

This script is doing all of the extraction, AND it is zipping our files so they don't take up so much space. It will take a bit, so go for a walk, do some other work, or watch something. May I suggest: [this](https://www.youtube.com/watch?v=9FqwhW0B3tY).

Okay, I promise we are almost done preparing our files. Just a couple more steps (at least I think so, I am typing this as I am running through this tutorial myself because I wanted to make sure it was #tested). Anyways, what I like to do after all of this is to rename my files because why would I want to remember all those gosh darn numbers. You can, but I like (for the sake of simplicity) to rename my files. If you would like, here is the command to rename them:
``` 
mv SRR15927811_1.fastq.gz brain4_9Mpa_1.fastq.gz
mv SRR15927811_2.fastq.gz brain4_9Mpa_2.fastq.gz
mv SRR15927812_1.fastq.gz brain3_9Mpa_1.fastq.gz
mv SRR15927812_2.fastq.gz brain3_9Mpa_2.fastq.gz
mv SRR15927813_1.fastq.gz brain2_9Mpa_1.fastq.gz
mv SRR15927813_2.fastq.gz brain2_9Mpa_2.fastq.gz
mv SRR15927837_1.fastq.gz brain2_0.1Mpa_1.fastq.gz
mv SRR15927837_2.fastq.gz brain2_0.1Mpa_2.fastq.gz
```
Now, let's make them all read-only, so we don't mess anything up.
```
chmod 444 *.fast.gz
```

Thank you for putting up with me! :) Now, it's time to start doing stuff with the data! Yay! Let's move on to [Part III](https://github.com/jtm077/Pressure-Project/blob/main/RNA-Seq%20Tutorial/Part%20III.md)!