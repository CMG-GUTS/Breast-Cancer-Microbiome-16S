## Load Clean Biom
#----------------------------------------------------------------------------------
clean <- metagenomics$new(
    biomData = "results/02_clean_biom.biom",
    metaData = "results/02_metadata.csv"
)

## Alpha diversity
#----------------------------------------------------------------------------------

alpha_response <- clean$alpha_diversity(col_name = "response", metric = "shannon")$plot +
  labs(title = NULL,
   subtitle = NULL,
   y = "Shannon index",
   x = NULL) +
  scale_colour_manual(name = "",
                      values = c("adjuvant" = "#8DA0CB",
                                 "high-responders" = "#E78AC3",
                                 "low-responders" = "#E78AC3"),
                      labels = c("adjuvant" = "adjuvant",
                                "high-responders" = "neoadjuvant"),
                      breaks = c("adjuvant", "high-responders")) +
  theme(legend.position = "bottom")

ggsave(
    filename = "results/04_alpha-div-shannon-response.png",
    plot = alpha_response,
    width = 10,
    height = 7,
    dpi = 300
)


## Beta diversity
#----------------------------------------------------------------------------------

## Load in matrix
qiime_unifrac <- data.table::fread(qiime_uunifrac_dist, header=TRUE)
distmat <- Matrix::Matrix(as.matrix(qiime_unifrac[, .SD, .SDcols = !c("V1")]))
rownames(distmat) <- colnames(distmat)
distmat <- distmat[clean$metaData[["SAMPLE_ID"]], clean$metaData[["SAMPLE_ID"]]]

cat("Ordination will mention that metric is switched to Bray, PLEASE IGNORE THIS bug!")
plt_pcoa_uunifrac <- clean$ordination(
    metric = "unifrac",
    method = "pcoa",
    group_by = "response",
    distmat = distmat
)

ggsave(
    filename = "results/04_beta-div-unweighted-unifrac.png",
    plot = patchwork::wrap_plots(plt_pcoa_uunifrac[c("anova_plot", "scores_plot")], nrow = 1),
    width = 10,
    height = 5,
    dpi = 300
)

qiime_unifrac <- data.table::fread(qiime_wunifrac_dist, header=TRUE)
distmat <- Matrix::Matrix(as.matrix(qiime_unifrac[, .SD, .SDcols = !c("V1")]))
rownames(distmat) <- colnames(distmat)
distmat <- distmat[clean$metaData[["SAMPLE_ID"]], clean$metaData[["SAMPLE_ID"]]]

cat("Ordination will mention that metric is switched to Bray, PLEASE IGNORE THIS bug!")
plt_pcoa_wunifrac <- clean$ordination(
    metric = "unifrac",
    method = "pcoa",
    group_by = "response",
    distmat = distmat
)

ggsave(
    filename = "results/04_beta-div-weighted-unifrac.png",
    plot = patchwork::wrap_plots(plt_pcoa_wunifrac[c("anova_plot", "scores_plot")], nrow = 1),
    width = 10,
    height = 5,
    dpi = 300
)
