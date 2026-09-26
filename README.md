# ReactomePA: Reactome Pathway Analysis

[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![](https://img.shields.io/badge/release%20version-1.56.0-green.svg)](https://www.bioconductor.org/packages/ReactomePA)
[![](https://img.shields.io/badge/devel%20version-1.99.2-green.svg)](https://github.com/YuLab-SMU/ReactomePA)
[![Bioc](http://www.bioconductor.org/shields/years-in-bioc/ReactomePA.svg)](https://www.bioconductor.org/packages/devel/bioc/html/ReactomePA.html#since)
[![platform](http://www.bioconductor.org/shields/availability/devel/ReactomePA.svg)](https://www.bioconductor.org/packages/devel/bioc/html/ReactomePA.html#archives)

This package provides functions for pathway analysis based on REACTOME
pathway database. It implements enrichment analysis, gene set enrichment
analysis, network-based enrichment analysis (NSEA) on the Reactome
reaction graph, Bayesian term selection, weighted enrichment, and
several functions for visualization. This package is not affiliated with
the Reactome team.

For details, please visit
<https://yulab-smu.top/biomedical-knowledge-mining-book/>.

## :arrow_double_down: Installation

Get the released version from Bioconductor:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("ReactomePA")
```

Or install the development version from GitHub:

``` r
if (!requireNamespace("remotes", quietly = TRUE))
    install.packages("remotes")
remotes::install_github("YuLab-SMU/ReactomePA")
```

## :writing_hand: Authors

Guangchuang YU

School of Basic Medical Sciences, Southern Medical University

<https://yulab-smu.top>

## :sparkling_heart: Contributing

We welcome any contributions! By participating in this project you agree
to abide by the terms outlined in the [Contributor Code of
Conduct](CONDUCT.md).

------------------------------------------------------------------------

Please cite the following article when using `ReactomePA`:

***G Yu***, QY He<sup>\*</sup>. ReactomePA: an R/Bioconductor package
for reactome pathway analysis and visualization. ***Molecular
BioSystems*** 2016, 12(2):477-479.
