# ReactomePA — Domain Glossary

> Canonical terms for the Reactome pathway enrichment analysis package.  
> Use these terms precisely; don't drift to synonyms.

## Core concepts

- **Reactome pathway**: A curated biological process represented as a directed series of reaction steps. Each step involves gene products (proteins, RNAs, complexes) as inputs, outputs, or catalysts. Pathways are hierarchical — parent pathways contain child sub-pathways.

- **Reaction graph**: The gene-product interaction network derived from all Reactome reaction steps. Two genes are connected if they participate in the same reaction step (as input/output/catalyst). This is the network used for RWR-based enrichment, NOT a generic PPI network.

- **ORA (Over-Representation Analysis)**: Classical hypergeometric test — given a gene list of interest, which pathways contain more of these genes than expected by chance? Implemented via `enrichPathway()`.

- **GSEA (Gene Set Enrichment Analysis)**: Given a ranked gene list (e.g. by log2FC), tests whether pathway genes cluster toward the extremes of the ranking. Implemented via `gsePathway()`.

- **NSEA (Network-based Set Enrichment Analysis)**: GSEA on a network-diffused ranking. Instead of using raw gene scores directly, scores are propagated across the Reactome reaction graph via Random Walk with Restart (RWR), then GSEA is run on the diffused scores. This captures pathway-level signal that may be diluted in individual gene-level statistics.

## Data structures

- **GSON**: A generic gene-set annotation object (from `gson` package). Contains `gsid2gene` (pathway ID → gene mapping) and `gsid2name` (pathway ID → name mapping). `gson_Reactome()` builds this from `reactome.db`.

- **enrichResult**: S4 class returned by `enrichPathway()`. Contains ORA results: pathway ID, p-value, adjusted p-value, gene IDs, gene ratio, etc.

- **gseaResult**: S4 class returned by `gsePathway()`. Contains GSEA results: pathway ID, enrichment score, NES, p-value, leading edge genes, etc.

- **nseaResult**: S4 class returned by `nsePathway()`. Inherits from `gseaResult`, adding RWR diffusion metadata: the network matrix used, diffusion scores, RWR mode (evidence/signed), restart probability, iterations to convergence.

## Visualization

- **viewPathway()**: Renders a specific Reactome pathway's topological structure using `graphite` + `igraph` + `ggraph`, with optional foldChange color mapping on nodes.

- **enrichplot re-exports**: `dotplot`, `cnetplot`, `emapplot`, `heatplot`, `ridgeplot`, `gseaplot` — all work on `enrichResult`, `gseaResult`, and `nseaResult` objects.

## Key dependencies

- **enrichit**: Core computation engine (ORA, GSEA, NSEA, Bayesian selection, weighted enrichment)
- **enrichplot**: Visualization engine
- **reactome.db**: Reactome annotation database
- **graphite**: Reaction pathway topology
- **gson**: Gene-set annotation data format
