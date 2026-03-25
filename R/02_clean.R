# Perform data wrangling
taxa$feature_subset(Kingdom == "Bacteria")
taxa$sample_subset(group != "control")

# Save clean
taxa$write_biom(filename = "results/02_clean_biom.biom")
data.table::fwrite(x = taxa$metaData, file = "results/02_metadata.csv")