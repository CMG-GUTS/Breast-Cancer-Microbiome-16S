# Check filepaths
if (!file.exists(metadata_file))
    cli::cli_abort("File: {.val {metadata_file}} doesn't exist.")

if (!file.exists(biom_file))
    cli::cli_abort("File: {.val {biom_file}} doesn't exist.")

if (!file.exists(qiime_wunifrac_dist))
    cli::cli_abort("File: {.val {qiime_wunifrac_dist}} doesn't exist.")

if (!file.exists(qiime_uunifrac_dist))
    cli::cli_abort("File: {.val {qiime_uunifrac_dist}} doesn't exist.")

if (!file.exists(phyml_tree_file))
    cli::cli_abort("File: {.val {phyml_tree_file}} doesn't exist.")

# Load metataxonomics class
taxa <- metagenomics$new(
    metaData = metadata_file,
    biomData = biom_file
)