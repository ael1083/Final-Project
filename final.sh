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

#classify data using downloaded  program and sorted table

qiime feature-classifier classify-sklearn \
  --i-classifier suboptimal-16S-rRNA-classifier.qza \
  --i-reads asv-seqs-ms2.qza \
  --o-classification taxonomy.qza

#integrate taxonomy in the sequence summary

#LEFT OFF HERE --- WORKING ON IT (right befor eexeercise 8)

## constructing result collection ##
rc_name=taxonomy-collection/
ext=.qza
keys=( Greengenes-13-8 )
names=( taxonomy.qza )
construct_result_collection
##
qiime feature-table tabulate-seqs \
  --i-data asv-seqs-ms2.qza \
  --i-taxonomy taxonomy-collection/ \
  --m-metadata-file asv-frequencies-ms2.qza \
  --o-visualization asv-seqs-ms2.qzv

#Downstream Data Analysis
#Kmerization of features

#generate kmer feature table


