#!bin/bash

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

