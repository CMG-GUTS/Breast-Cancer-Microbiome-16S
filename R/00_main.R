## Library loading
library("OmicFlow")
library("magrittr")
library("ggplot2")
library("ggtree")
library("patchwork")

## Set working environment
set.seed(1970)
dir.create("results", showWarnings = FALSE)

# main input
metadata_file <- "metadata.tsv"
biom_file <- "biom_with_taxonomy.biom"

# pre-computed data
qiime_wunifrac_dist <- "distance_matrices/weighted_unifrac_distance_matrix.qza.txt"
qiime_uunifrac_dist <- "distance_matrices/unweighted_unifrac_distance_matrix.qza.txt"
phyml_tree_file <- "pseudomonas_BRAAF.phylip_phyml_tree.txt"

## Run scripts
source("R/01_load.R")
source("R/02_clean.R")
source("R/03_visualisations.R")
source("R/04_alpha-beta-diversity.R")