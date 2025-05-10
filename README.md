# Final Project: Qiime2 Microbiome Analysis

## Group Members
Molly Dugan,
Alexandria Lyden, 
Phaedra Stemp 

<details> <summary><H2> Background </H2></summary>
The data for this analysis was provided by a UNH grad student studying duckweed microbiome composition. It consisted of 16s data in paired-end 250 bp reads that were amplified by Illumina HiSeq 2500. The files were made up of 20 samples from two different pond locations. Sample treatments were either taken directly from the duckweed on the pond, or from the pond water itself. There were 5 replicates taken from each of the sample treatments. With this data, we wanted to analyze the microbiome composition differences between samples. The goal was to compare and contrast the microbiomes between the replicates with the same treatment, as well as between the two different treatments.

</details></details>

<details> <summary><H2> Methods </H2></summary>
The data used in this project was provided by a grad student studying duckweed. It consisted of 250 bp paired-end reads, sequenced using Illumina HiSeq 2500. All analysis done on this data was done on RON through the University of New Hampshire. All use of RON was performed on the personal laptops of each group member. Multiple tools within RON were used to create a pipeline, and perform the following analyses.

<details> <summary><H4> Workflow Visualization </H4></summary>
  
![](https://github.com/user-attachments/assets/a49110e5-a244-420d-9625-9b9bb1743e8c)

</details>

### Source Activate qiime2-amplicon-2024.5
This command activated the qiime2 environment. This provided access to all the tools used in the following steps of the pipeline.

### Import
This tool imported our data files into the environment. It produced a metadata demux file. The output was a qza data file that stored the project data.

### Demux Summarize
This tool demultiplexed the project data. It assessed the quality of the data sequences and provided a summary visualization. The output was a histogram file and quality score graph qzv file that were used to determine where to trim the reads. The files were visualized using the Qiime2 View program available online.

### DADA2 Denoise-Paired
This tool processed the paired-end reads. It trimmed the reads where we indicated based on the visualizations from the Demux Summarize command and made three metadata qza files. The output was three metadata files, one storing the denoising statistics, one other storing the amplicon sequence variant sequences that were trimmed, and one organizing the amplicon sequence variants to put into a table when visualized.

### Metadata Tabulate
This tool took the stats metadata file from the DADA2 Denoise-Paired command and created a visualization file to make the data visible in a table. The output was a qzv file that visualized the trimmed metadata in a table. The file was visualized using the Qiime2 View program.

### Feature-Table Summarize-Plus
This tool took the amplicon sequence variants and the whole metadata and created two qza metadata files and one qzv visual file. These contained data the showed how many sequences were associated with each sample and feature, as well as some summary statistics. The visualization file provided histograms of the distributions. The visualization was done using the Qiime2 View program.

### Feature-Table Tabulate-Seqs
This tool took the amplicon sequence variants and their frequencies and created a mapping of their feature IDs to the sequences. This merged the two qza metadata files and created a qzv visualization file, which was visualized using Qiime2 View.

### Feature-Table Filter-Features
This tool filtered the feature table of amplicon sequence variants. It analyzed the data to include only those with a specified number of samples, and created a qza metadata file containing them. The output was a metadata file containing only the samples with the specified number.

### Feature-Table Filter-Seqs
This tool took the filtered table with the specified samples and used it to filter all the sequences to only those specified in the table. The output was a qza metadata file containing only the sequences that fit the criteria outlined by the filtered feature table.

### Feature-Table Summarize-Plus
This tool took the feature table file and the overall metadata and created a summary table qzv file and two qza metadata files. The metadata files contained the sample and amplicon sequence variants frequencies. The output table was a summary of the comparison of the two files, and was visualized with Qiime2 View.

### wget -O 'suboptimal-16S-rRNA-classifier.qza'
This tool was used to download a 16s rRNA classifier. The command downloaded a metadata classifier file using a URL.

### Feature-Classifier Classify-Sklearn
This tool was used to classify the amplicon sequence variants sequences. It used the previously downloaded classifier to analyze the sequences and create a classification file. The output was a qza metadata file that stored the taxonomy of the of the sequences.

### Conda Env Create
This tool was used to download the Boots tool form the internet, using a URL. The outcome was that the Boots tool was now available in its own environment for use in the pipeline.

### Source Activate q2-boots-amplicon-2025.4
This command activated the Boots environment that was previously downloaded. It allowed all the tools within the environment to be accessed for the following steps in the pipeline.

### Boots Kmer-Diversity
This tool was used to bootstrap and provide rarefication-based alpha and beta diversity analyses. It took the amplicon sequence variant sequences and metadata and created diversity metrics for the specified samples and sample depth, along with confidence intervals for these metrics. The output was a qzv scatterplot in a new directory that showed the diversity of the samples.

### Qiime Phylogeny Align-to-tree-mafft-fasttree
This tool is a pipeline that constructs a phylogenetic tree from a set of 16S rRNA marker genes. It aligns the input sequences, removes highly variable positions, builds a maximum-likelihood tree, and produces a midpoint-rooted tree.

### Qiime Empress Tree-plot
This tool generates an interactive visualization of a phylogenetic tree annotated with a taxonomy file.

### Qiime Empress Community-plot
This tool generates an interactive, multi-panel visualization that combines a phylogenetic tree and taxonomy file.

### Diversity Alpha-Rarefication
This tool took the sorted amplicon sequence variants and investigated the diversity in relation to the specified maximum sequence depth. It took the sorted amplicon sequence variants and metadata and created a qzv visual plot, showing different diversity metrics at multiple sampling depths. The output was a qzv graph showing the diversity metrics, which was visualized using Qiime2 View.

### Taxa Barplot
This tool took the amplicon sequence variants and created a bar plot of the taxonomy in them. It used the amplicon sequence variants, the total metadata, and the taxonomy metadata file to create a bar plot showing the species present in the samples. The output was a taxonomy bar plot qzv visualization file that was visualized using Qiime2 View.

### Feature-Table Filter-Samples
This tool took the amplicon sequence variants and sorted them by the different sampling types from the original data collected. It sorted the variants into a table that categorized them by the sample types. The output of this was a qza metadata table that had the sorted samples in their groups.

### Taxa Collapse
This tool took the amplicon sequence variants and sorted them into the genera groups. It took the filtered sample types file and the taxonomy file and created a table with the groups collapsed into the genera. The output was a qza metadata table containing the sorted genera groups from the sample.

### Composition ANCOM-BC
This tool applied differential abundance testing to the genera of the samples. It took the genera data and used one of the sample types as a reference to compare the abundance of the other sample to. The output was a qza metadata file that held the abundance amounts of the different sample types.

### Composition DA-Barplot
This tool took the abundance metadata file and created a visualization. It used a delimiter to sort each sample abundance and create a bar plot of abundance. The output was a qzv file that showed the relative abundance of genera in one sample compared to the other. It was visualized using Qiime2 View.

</details></details>

<details> <summary><H2> Results </H2></summary>

With the analysis above, the following can be performed:

<details> <summary><H3> Demultiplexed Sequence Counts Summary </H3></summary>

![](https://github.com/ael1083/Final-Project/blob/main/images/Demux%20Forward%20Reads.png?raw=true)

This visualization shows a bar chart comparing the number of sequences and number of samples. There is a large peak of 7 samples that consist of 300,000-400,000 sequences. This chart helped to determine where to trim the reads.

</details>

<details> <summary><H3> Taxonomy Summary </H3></summary>

![](https://github.com/ael1083/Final-Project/blob/main/images/Taxonomy%20bar%20chart.png?raw=true)

This bar chart shows the relative frequency of each species found in each sample. All samples had a high frequency of Proteobacteria and an unspecified bacteria. Water samples appear to have high frequencies of Bacteroidetes and Firmicutes as well.

</details>

<details> <summary><H3> Phylogenetic Tree </H3></summary>

![](https://github.com/ael1083/Final-Project/blob/main/images/Phylogenetic%20Tree.png?raw=true)

This tree was visualized using the qiime2view website. The tree shows that most of the bacteria from each sample come from an Unspecified bacteria. There is a large portion of the bacteria descended from Cyanobacteria and Bacteroidetes.

</details>

<details> <summary><H3> Alpha Rarefaction </H3></summary>

![](https://github.com/ael1083/Final-Project/blob/main/images/alpha_rarefication%20plot.png?raw=true)

This chart shows the diversity metrics at different sequencing depths. The duckweed samples peak at a sequencing depth of about 5000 and platau at about 750 observed features. The water samples peak at a sequencing depth of 5000 and platau at 775 observed features until a sequencing depth of 20000. At sequencing depth 20000, observed features increases to about 900.

</details>

<details> <summary><H3> kmer Scatter Plot </H3></summary>

![](https://github.com/ael1083/Final-Project/blob/main/images/kmer%20Scatter%20Plot.png?raw=true)

This scatterplot shows the duckweed and water samples on a braycurtis Axis 1 vs braycurtis Axis 2 plot. There is a grouping of water samples at approximately (0.3, -0.25) and at (0.3, 0.25). There is a grouping of duckweed samples at approximately (-0.3, -0.05) and at (-0.2, 0.075).

</details>

<details> <summary><H3> Abundant Genera </H3></summary>

![](https://github.com/ael1083/Final-Project/blob/main/images/abundant%20genera%20visualization.png?raw=true)

This chart shows the Log Fold Change (LFC) of water samples vs the bacteria species determined to be in all samples. In water, Methanoculleus, Euryarchaeota, Syntrophorhabdaceae, Mathanomicroviales, an an Unassigned bacteria are enriched, while the rest of the bacteria are depleted. The depleted bacteria shown are those that are enriched in the duckweed samples.

</details>

</details></details>

<details> <summary><H2> Code </H2></summary>
  
```bash
source activate qiime2-amplicon-2024.5

qiime tools import \
 --type 'SampleData[PairedEndSequencesWithQuality]' \
 --input-path manifest.tsv \
 --output-path demux.qza \
 --input-format PairedEndFastqManifestPhred33V

qiime demux summarize \
 --i-data demux.qza \
 --o-visualization visualization.qzv

mkdir Data_trimmed

#trims reads
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left-f 0 \
  --p-trunc-len-f 250 \
  --p-trim-left-r 0 \
  --p-trunc-len-r 249 \
  --o-representative-sequences Data_trimmed/asv-seqs.qza \
  --o-table Data_trimmed/asv-table.qza \
  --o-denoising-stats Data_trimmed/stats.qza

cd Data_trimmed

#visually summarizes data
qiime metadata tabulate \
  --m-input-file stats.qza \
  --o-visualization stats.qzv
#may need solution to exercise four from tutorial#

#information on how many sequences are associated with each sample and with each feature, histograms of those distributions, and some related summary statistics
qiime feature-table summarize-plus \
  --i-table asv-table.qza \
  --m-metadata-file ../metadata.tsv \
  --o-summary asv-table.qzv \
  --o-sample-frequencies sample-frequencies.qza \
  --o-feature-frequencies asv-frequencies.qza

#provide a mapping of feature IDs to sequences, and provide links to easily BLAST each sequence against the NCBI nt database
#merge two asv files and made into qzv
qiime feature-table tabulate-seqs \
  --i-data asv-seqs.qza \
  --m-metadata-file asv-frequencies.qza \
  --o-visualization asv-seqs.qzv

#filter our feature table, and then we use the new feature table to filter our sequences to only the ones that are contained in the new table
qiime feature-table filter-features \
  --i-table asv-table.qza \
  --p-min-samples 2 \
  --o-filtered-table asv-table-ms2.qza

qiime feature-table filter-seqs \
  --i-data asv-seqs.qza \
  --i-table asv-table-ms2.qza \
  --o-filtered-data asv-seqs-ms2.qza

#summarize filter table
qiime feature-table summarize-plus \
  --i-table asv-table-ms2.qza \
  --m-metadata-file ../metadata.tsv \
  --o-summary asv-table-ms2.qzv \
  --o-sample-frequencies sample-frequencies-ms2.qza \
  --o-feature-frequencies asv-frequencies-ms2.qza

#Taxonomic Annotation

#download pretrained classifier
wget -O 'suboptimal-16S-rRNA-classifier.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/suboptimal-16S-rRNA-classifier.qza'
#if things go badly, use different classifier

#classify data using downloaded  program and sorted table
qiime feature-classifier classify-sklearn \
  --i-classifier suboptimal-16S-rRNA-classifier.qza \
  --i-reads asv-seqs-ms2.qza \
  --o-classification taxonomy.qza

#Install new Qiime environment and yml file
conda env create -n qiime2-amplicon-2024.10 --file https://data.qiime2.org/distr
o/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml
conda activate qiime2-amplicon-2024.10

#Install empress
pip install --user empress
qiime dev refresh-cache

#Create rooted-tree
nohup qiime phylogeny align-to-tree-mafft-fasttree \
  --p-n-threads 20 \
  --i-sequences asv-seqs.qza \
  --o-alignment aligned-asv-seq.qza \
  --o-masked-alignment masked-aligned-asv-seq.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza &

#Adds taxonomy to the tree
qiime empress tree-plot \
   --i-tree rooted-tree.qza \
   --m-feature-metadata-file taxonomy.qza \
   --o-visualization empress-tree-tax.qzv

#Adds taxonomy and metadata to tree
qiime empress community-plot \
   --p-filter-missing-features \
   --i-tree rooted-tree.qza \
   --i-feature-table asv-table-ms2.qza \
   --m-sample-metadata-file metadata.tsv \
   --m-feature-metadata-file taxonomy.qza \
   --o-visualization empress-tree-tax-table.qzv

#Downstream Data Analysis
#Kmerization of features

#download boots tool from the internet
conda env create --name q2-boots-amplicon-2025.4 --file https://raw.githubusercontent.com/caporaso-lab/q2-boots/refs/heads/main/environment-files/q2-boots-qiime2-amplicon-2025.4.yml
source deactivate
source activate q2-boots-amplicon-2025.4

#move metadata into directory
cd ..
mv metadata.tsv Data_trimmed
cd Data_trimmed

#generate kmer feature table
#boots provides bootstrapped and rareification-based alpha and beta diversity analyses, designed to mirror the q2-diversity interface
qiime boots kmer-diversity \
  --i-table asv-table-ms2.qza \
  --i-sequences asv-seqs-ms2.qza \
  --m-metadata-file metadata.tsv \
  --p-sampling-depth 21648 \
  --p-n 19 \
  --p-replacement \
  --p-alpha-average-method median \
  --p-beta-average-method medoid \
  --output-dir boots-kmer-diversity
#use this scatterplot in the report scatter_plot.qzv

#Alpha Rarefication Plottiing
#alpha rareification plot explore alpha diversity as a function of sampling depth
#visualizer computes one or more alpha diversity metrics at multiple sampling depths
qiime diversity alpha-rarefaction \
  --i-table asv-table-ms2.qza \
  --p-max-depth 62887 \
  --m-metadata-file metadata.tsv \
  --o-visualization alpha-rarefaction.qzv
#use graph in report

#Taxonomic Analysis
#creates file to show taxonomic composition (bar plots)
qiime taxa barplot \
  --i-table asv-table-ms2.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization taxa-bar-plots.qzv

#Differential Abundance Testing with ANCOM-BC
#ANCOM-BC is a compositionally-aware linear regression model that allows testing for differentially abundant features across sample groups while also implementing bias correction.
qiime feature-table filter-samples \
  --i-table asv-table-ms2.qza \
  --m-metadata-file metadata.tsv \
  --p-where '[sample_type] IN ("duckweed", "water")' \
  --o-filtered-table asv-table-ms2-dominant-sample-types.qza

#collapse ASVs into genera w/ taxa collapse
qiime taxa collapse \
  --i-table asv-table-ms2-dominant-sample-types.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table genus-table-ms2-dominant-sample-types.qza

#apply differential abundance testing
#apply ANCOM-BC to see which genera are differentially abundant across those sample types
qiime composition ancombc \
  --i-table genus-table-ms2-dominant-sample-types.qza \
  --m-metadata-file metadata.tsv \
  --p-formula sample_type \
  --p-reference-levels 'smaple_type::duckweed' \
  --o-differentials genus-ancombc.qza

#visualize differentially abundant genera
qiime composition da-barplot \
  --i-data genus-ancombc.qza \
  --p-significance-threshold 0.001 \
  --p-level-delimiter ';' \
  --o-visualization genus-ancombc.qzv
```

</details></details>

<details> <summary><H2> Bibliography </H2></summary>

- This project followed the [qiime2 Gut-to-soil axis tutorial](https://amplicon-docs.qiime2.org/en/latest/tutorials/gut-to-soil.html#FvS2KInpQE)
- [qiime2view](https://view.qiime2.org/) is a website used to visualize qzv files
- [chatGPT](https://chatgpt.com/) helps explain what all the inputs do, outputs mean, and what can be done wtih them
- [q2-boots](https://library.qiime2.org/plugins/caporaso-lab/q2-boots) website gives information on the q2-boots qiime plugin
- [Canva](https://www.canva.com/) was a good website to make the workflow visualization

</details></details>
