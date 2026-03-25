## Newick tree
#----------------------------------------------------------------------------------
# phyML tree evaluation
tree <- ape::read.tree(phyml_tree_file)

tree$node.label <- ifelse(as.numeric(tree$node.label) > 20, tree$node.label, "")
groups <- c(rep("paraffine", 19), rep("", length(tree$tip.label)-19))
for (i in seq_along(tree$tip.label)) {
  tree$tip.label[i] <- paste0("ASV_", i)
}
tree$tip.label <- rev(tree$tip.label)

mrca_node <- tidytree::MRCA(tree, tree$tip.label[1:19])

p <- ggtree(tree, branch.length = "none") +
  geom_tiplab(size = 5, offset=0.2) +
  geom_nodelab(color = "red",
               nudge_x = 0.5) +
  geom_treescale(fontsize=5, linesize=1) +
  geom_strip(taxa1 = "ASV_50", 
           taxa2 = "ASV_37", 
           barsize = 2,
           color = "blue",
           offset = 5,
           offset.text = 0.5,
           label = "paraffin") +
  xlim(0, 38)


ggsave(
    filename = "results/05_pseudomona_tree.png",
    plot = p,
    width = 7,
    height = 10,
    dpi = 600
)
