# ReactomePA 1.57.1

+ `nsePathway()`: network-based set enrichment analysis (NSEA) on the Reactome reaction graph using Random Walk with Restart (2026-07-08, Wed)
+ `bayes_reactome()`: Bayesian term selection for compressing redundant Reactome pathway output via `enrichit::bayes_enrich()` (2026-07-08, Wed)
+ `prepareReactomeNetwork()`: utility to build and cache the Reactome reaction graph for reuse in `nsePathway()` (2026-07-08, Wed)
+ `enrichPathway()` and `gsePathway()` now accept a `weight` parameter for weighted ORA/GSEA (2026-07-08, Wed)
+ migrate caching from custom environment (`reactome_env`) to `yulab.utils::with_cache()`; delete `get_Reactome_DATA()`, `getALLEG()` (2026-07-08, Wed)
+ `gson_Reactome()` now caches the final GSON object directly, with data cleaning inlined (2026-07-08, Wed)

# ReactomePA 1.56.0

+ Bioconductor RELEASE_3_23 (2026-04-29, Wed)

# ReactomePA 1.55.1

+ use 'enrichit' as engine for enrichment analysis (2025-12-07, Sun)

# ReactomePA 1.54.0

+ Bioconductor RELEASE_3_22 (2025-11-01, Sat)

# ReactomePA 1.52.0

+ Bioconductor RELEASE_3_21 (2025-04-17, Thu)

#  ReactomePA 1.50.0

+ Bioconductor  (2024-10-30, Wed)

# ReactomePA 1.49.1

+ use `yulab.utils::yulab_msg()` for startup message (2024-07-26, Fri)

# ReactomePA 1.48.0

+ Bioconductor RELEASE_3_19 (2024-05-15, Wed)

# ReactomePA 1.47.1

+ Add a disclaimer in package Description to claim that this package is not affiliated with the Reactome team (2023-11-17, Fri)

# ReactomePA 1.46.0

+ Bioconductor RELEASE_3_18 (2023-10-25, Wed)

# ReactomePA 1.44.0

+ Bioconductor RELEASE_3_16 (2022-11-02, Wed)

# ReactomePA 1.41.1

+ add function `gson_Reactome` (2022-7-13, Wed)

# ReactomePA 1.34.0

+ Bioconductor 3.12 release (2020-10-28, Wed)

