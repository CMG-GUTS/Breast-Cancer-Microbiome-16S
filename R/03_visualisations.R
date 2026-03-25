## Load Clean Biom
#----------------------------------------------------------------------------------
clean <- metagenomics$new(
    biomData = "results/02_clean_biom.biom",
    metaData = "results/02_metadata.csv"
)

## Compositions
#----------------------------------------------------------------------------------

## Creating composition plots for each taxonomic rank
plt_list <- list()
for (taxa_name in c("Phylum", "Genus")) {
    clean$reset()
    clean$feature_subset(Genus != "Pseudomonas")
    clean$feature_merge(feature_rank = taxa_name)

    res <- clean$composition(
        feature_rank = taxa_name,
        feature_filter = c("uncultured"),
        feature_top = 10,
        col_name = c("treatment", "response", "group")
        )

    # Making neat sample names
    res$data$SAMPLE_ID <- res$data$SAMPLE_ID %>% 
    stringr::str_extract("(\\w*?.\\d{1,2}-?\\w)") %>% 
    stringr::str_replace("[-H]$", "AN")

    neoadjuvant.res <- res$data[res$data[, treatment == "neoadjuvant"], ]
    adjuvant.res <- res$data[res$data[, treatment == "adjuvant"], ]

    plt_list[[taxa_name]] <- (composition_plot(data = adjuvant.res,
                                    palette = res$palette,
                                    feature_rank = taxa_name,
                                    title_name = "Adjuvant") +
                    theme(legend.position = "right") +
                    composition_plot(data = neoadjuvant.res[neoadjuvant.res[, response == "low-responders"], ],
                                    palette = res$palette,
                                    feature_rank = taxa_name,
                                    title_name = "Neoadjuvant") +
                    theme(legend.position = "none") +
                    labs(subtitle = "low-responders") +
                    composition_plot(data = neoadjuvant.res[neoadjuvant.res[, response == "high-responders"], ],
                                    palette = res$palette,
                                    feature_rank = taxa_name) +
                    theme(legend.position = "none") +
                    labs(subtitle = "high-responders")) +
                        plot_layout(guides = "collect",
                                    axis_titles = "collect",
                                    nrow = 1,
                                    widths = rep(5, times = 3))
}


combined <- (wrap_elements(plt_list$Phylum) / wrap_elements(plt_list$Genus)) +
plot_layout(axis = "collect") +
plot_annotation(tag_levels = "A") &
theme(plot.tag = element_text(face = 'bold', size = 15))

res$data$group <- factor(res$data$group, levels = c("control", "Adjacent normal", "Tumor"))
plt <- composition_plot(data = res$data,
                group_by = "group",
                palette = res$palette,
                feature_rank = taxa_name) +
theme(legend.position = "right")


ggsave(filename = paste0("results/03_composition-treatment-response.png"), 
    plot = combined, 
    width = 15, 
    height = 10,
    dpi = 600
)
