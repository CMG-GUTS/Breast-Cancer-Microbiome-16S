## Load Clean Biom
#----------------------------------------------------------------------------------
clean <- metagenomics$new(
    biomData = "results/02_clean_biom.biom",
    metaData = "results/02_metadata.csv"
)

## Compositions
#----------------------------------------------------------------------------------

## Creating composition plots for each taxonomic rank
for (exclude_pseudomonas in c(TRUE, FALSE)) {
    plt_list <- list()

    for (taxa_name in c("Phylum", "Genus")) {
        clean$reset()

        if (exclude_pseudomonas) {
            clean$feature_subset(Genus != "Pseudomonas")
        }
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
                                        title_name = "Surgery only") +
                        theme(legend.position = "right") +
                        composition_plot(data = neoadjuvant.res[neoadjuvant.res[, response == "high-responders"], ],
                                        palette = res$palette,
                                        feature_rank = taxa_name,
                                        title_name = "Neoadjuvant") +
                        theme(legend.position = "none") +
                        labs(subtitle = "poor responder") +
                        composition_plot(data = neoadjuvant.res[neoadjuvant.res[, response == "low-responders"], ],
                                        palette = res$palette,
                                        feature_rank = taxa_name) +
                        theme(legend.position = "none") +
                        labs(subtitle = "good responder")) +
                            plot_layout(guides = "collect",
                                        axis_titles = "collect",
                                        nrow = 1,
                                        widths = rep(5, times = 3))
    }

    combined <- (wrap_elements(plt_list$Phylum) / wrap_elements(plt_list$Genus)) +
    plot_layout(axis = "collect") +
    plot_annotation(tag_levels = "A") &
    theme(plot.tag = element_text(face = 'bold', size = 15))

    if (exclude_pseudomonas) {
        filepath <- "results/03_composition-treatment-response-without-pseudomonas.png"
    } else {
        filepath <- "results/03_composition-treatment-response-with-pseudomonas.png"
    }

    ggsave(filename = filepath, 
        plot = combined, 
        width = 15, 
        height = 10,
        dpi = 600
    )
}