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

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left-f 0 \
  --p-trunc-len-f 250 \
  --p-trim-left-r 0 \
  --p-trunc-len-r 249 \
  --o-representative-sequences Data_trimmed/asv-seqs.qza \
  --o-table Data_trimmed/asv-table.qza \
  --o-denoising-stats Data_trimmed/stats.qza
