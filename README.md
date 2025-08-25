# Gene Regulation and Chromatin Dynamics in Breast Cancer

## Overview
A modular & reproducible ChIP-seq analysis pipeline to study transcription factor binding and chromatin dynamics in MCF-7 breast cancer cells. The pipeline utilizes Nextflow for workflow management & Conda for environment reproducibility for analyses such as peak calling, motif discovery, and differential binding.

## Features

- **ChIP-seq Analysis**: Comprehensive pipeline for processing ChIP-seq data, including quality control, alignment, peak calling, and annotation.
- **Motif Discovery**: Identification of enriched motifs within TF-bound regions.
- **Differential Binding Analysis**: Comparison of binding sites across conditions or replicates.
- **Reproducibility**: Workflow managed by Nextflow with environment specifications provided via Conda.


The pipeline generates:

- **Quality Control Reports**: FastQC reports for raw and trimmed reads.
- **Alignment Files**: BAM files aligned to the reference genome.
- **Peak Files**: BED files of called peaks.
- **Motif Analysis**: HOMER results for motif enrichment.
- **Differential Binding Analysis**: Results from comparing binding across conditions.
- **Visualization**: Coverage plots and heatmaps generated using deepTools.

## Citation
> Chakraborty, A., et al. (2022). *RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells*. Nature Communications. [PMCID: PMC5071180](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5071180/)
