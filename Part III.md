# FastQC: Quality Check
Good morning, class. Today, we will be learning and practicing the use of FastQC.
> FastQC is a  tool that assesses the quality of raw sequencing data from high throghput sequencing. It checks for problems, provides an overview on basic quality control metrics, generates a report with graphical or list data, and flags issues.

Okay, if you're joining us only now. Please go to part I to ensure you have all the necessary packages to perform the rest of this tutorial part. If you have already gone through that part, you should have all the necessary parts! We can run our quality analysis on all of our .fast.gz files using the following script:
*[fastqc.sh]()

So this is another thing that may take a bit because it will be quality checking all four of the paired reads. Here is another [video](https://www.youtube.com/watch?v=zKKKJQ51aoE).

In your output directory, you will see that a report was generated for each read.Let's go over one of the reports, and all of its sections, together. Let's use the report generated for brain4_9Mpa_1.fastq.gz(SRR15927811_1.fast.gz):

> SUGGESTION: If you have all of your FastQC files, I suggest skipping ahead to the trimming in the next part, start running that code because it will take a while! THEN, come back and do your analysis on your FastQC outputs! If you are doing this in a multi-day stretch, then ignore this message!

## FastQC Output
### Basic Statistics
(insert picture)
This section just has some simple composition statistics. I find some of the info a little irrelevant, but that's because I'm a little stinker. They're pretty useful though.
*Filename:pretty self-explanatory.
*File Type:Just tells you if the file had actual base pairs, or if it had to be converted into them.
*Encoding:Tells you what kind of code information was used for the values found inside. This was used with Illumina information/data.
*Total Sequences:The total # of sequences in the data. In this read, we have 21211208. Wowza.
*Total Bases: Another one that is pretty self-explanatory.
*Sequences flagged as poor quality: Okay.
Sequence length: I'm not even going to try.
%GC: The percentage of Guanines (G) and Cytosines (C). 

Now, here is something worth noting. The BS (lol) does not raise warnings, so you can't just look at this to make your decision to use the data or not. We have to actually look at our results. Let's move onto those.

### Per base sequence quality scores
This shows an overview of the range of quality values across all bases at each position in the FastQC file.
*BoxWhisker: The upper and lower whiskers represents the 10% and 90% points. (This is not on this plot, but for future reference, the yellow box in a BoxWhisker plot denotes the 25-75% range. The red line within that would represent the median.)
*Blue line: represents the mean quality.
*Y-axis: shows the quality scores. The higher the score, the better the base call. This axis is sub-divided by three colors:
    *Green: Very good
    *Yellow: Reasonable quality
    *Red: Poor quality

It is normal for platforms to degrade as the run progresses (remember my poor reading ability mentioned earlier), so it is very common to see your base calls falling at the end of a read. A warning will be issues if the lower quartile for any base is less than 10, or if the median for any base is less than 25. It will also raise a failure if the lower quartile for any base is less than 5 or if the median of any base is less than 20.

(insert picture)
As you can see, all of our mean quality scores (represented by the blue line), are very good in quality! Woop woop!

### Per sequence content
This report allows you to see if a subset of your sequences have universally low quality scores. It's common to see a subset of sequences with poor quality, so do not cry if you- I mean, your sequences are not perfect. But also, this should only be a small percentage.A warning will be raised if the most frequently observed mean quality score is below 27. That mean is the same as a 0.2% error rate. A failure is raised if the most frequently observed mean quality is below 20 (1% error rate).

(insert picture)
Our mean quality score is 36, which denotes very good quality!

### Per base sequence content
These plots show the proportion of each base in a file for which each of the four normal DNA bases has been called.The relative amount of each base should reflect the overall amount of these bases in your genome. They should not be hugely imbalanced by one another. If you see strong biases which change in different bases, then this is usually an indication of an over-represented sequence.A warning will be issued uf the difference between A and T, or G and C, is greater than 10% in any position. This module will fail if the difference between nucleotides is greater than 20% in any position.

(insert picture)
Okay, that's a fail, but DO NOT WORRY! It looks like the everything is stabilized after the initial fluctuation. Now, this can be fixed by trimming (spoiler alert, that is the next step). Because it's early on and stabilizes, our DEG analysis should not be heavily impacted.

### Per sequence GC content 
This measures the GC content across the whole length of each sequence in a file and compares it to a modeled normal distribution of GC content. Now, we don't know the GC content of the model, so the GC content is calculated from the observed dara and used to build a reference distribution. As per usual,an oddly shaped distribution could indicate contamination or biased subsets. A normal distribution is shifted and indicates some systemic bias which is independent of base position. If there is a systemic bias that creates a systemic bias, then it won't be flagged because the module does not know what your genome's GC content is. A warning is raised if the sum of the deviations from the normal distribution represents more than 15% of the reads. It fails if the sum of the normal distribution represents more than 15% of the reads.

(insert picture)
Our GC content, shows a normal distribution fitted to the model, so we are smoothing sail on this front.

### Per base N content
This plots out the percentage of base calls at each position for which an N was called. It is not unusual to see a very low proportion of Ns in a sequence, especially near the end. BUT, if it rises above a few percent, it could suggest that the analysis was unable to interpret data well enough to make valid calls. This module raises a warning if any position shows an N content of >5%, and it fails if any position shows an N content >20%.

(insert picture)
It looks like we have little to no Ns!

### Sequence length distribution
Now, a lot of high throughput sequencers will generate sequence fragments of uniform length, but others can have wildly varying lengths (not everyone can be tall and lengthy and that's okay). Anyways, even the uniform lengths can be trimmed to remove poor quality base calls. This module generates a graph that shows the distribution of fragment sizes in the file which was analysed. In a lot of cases, this graph will be very simple and have one peak, but there are, of course, exceptions. This will raise a warning if all sequencing are not the same length, and it will fail if any of the sequences have zero length.

(insert picture)

### Sequence Duplication Levels
This counts the degree of duplication for every sequence in the set and creates a plot showing the relative number of sequences with different degrees of duplication. Now, it does not do this for every sequence but for about the first 200,000. That's enough for you to see the profile of the whole file. Any sequence with more than 10 duplicates will be placed at the end, so it is pretty normal to see a little rise at the end. A big rise would indicate that you have A LOT of sequences with high levels of duplication. This module raises a warning if non-unique sequences make up more than 20% of the total. It will issue an error if it makes up more than 50% (as it should).

(insert picture)
About 56% of the reads are duplicates. A moderate level of duplication is expected in RNA-seq, especially for highly expressed genes. Because of this, we are going to venture on and still see what we can find from this data!

### Overrepresented sequences
This lists all of the sequences which make up more than 0.1% of the total. This, for the sake of memory, does not track each sequence. This means it is possible that something could be missed. For each over-represented sequence, the program will look for matches in the database of common contaminants and will report the best hit it finds. It doesn't necessarily mean that is the real reason of contamination, but it helps. This module will issue a warning if any sequence is found to represent more than 0.1% of the total. It fails if any sequences is found to represent more than1% of the total.

There were no over-represented sequences! Heck yea!

### Adaptor content
This displays the proportion of sequences which have an adapter sequence at a given position. This is informative in deciding whether thee is a significant amount of adapter present in the sequences and can be subjected to trimming.A high percentage of adapter sequences present could indicate a problem with library preparation. It will issue a warning if a significant percentage of reads contain adapter sequences (>5%), and it may flag a failure if the percentage is very high (>10%).

(insert picture)
There is little to no adapters present in the sequences, so we do not need any special things for adapter trimming. This means our trimming will focus on quality trimming. 


## Other FastQC Oututs
Now, we only went over one together, but I encourage you to browse through the rest and practice making inferences from the data.

That's optional though, and I am not there to force you to do it. So, you can move on if you would like.

Now that we have decided these sequences are _good enough_ for us, we can mosey on down to Part IV!