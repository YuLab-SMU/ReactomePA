ReactomePA: Reactome Pathway Analysis
=====================================

[![releaseVersion](https://img.shields.io/badge/release%20version-1.16.2-green.svg?style=flat)](https://bioconductor.org/packages/ReactomePA) [![develVersion](https://img.shields.io/badge/devel%20version-1.17.4-green.svg?style=flat)](https://github.com/GuangchuangYu/ReactomePA) [![Bioc](http://www.bioconductor.org/shields/years-in-bioc/clusterProfiler.svg)](https://www.bioconductor.org/packages/devel/bioc/html/clusterProfiler.html#since) [![total](https://img.shields.io/badge/downloads-23001/total-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA) [![month](https://img.shields.io/badge/downloads-696/month-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![codecov](https://codecov.io/gh/GuangchuangYu/ReactomePA/branch/master/graph/badge.svg)](https://codecov.io/gh/GuangchuangYu/ReactomePA/) [![Last-changedate](https://img.shields.io/badge/last%20change-2016--10--03-green.svg)](https://github.com/GuangchuangYu/ReactomePA/commits/master) [![commit](http://www.bioconductor.org/shields/commits/bioc/ReactomePA.svg)](https://www.bioconductor.org/packages/devel/bioc/html/ReactomePA.html#svn_source) [![GitHub forks](https://img.shields.io/github/forks/GuangchuangYu/ReactomePA.svg)](https://github.com/GuangchuangYu/ReactomePA/network) [![GitHub stars](https://img.shields.io/github/stars/GuangchuangYu/ReactomePA.svg)](https://github.com/GuangchuangYu/ReactomePA/stargazers)

[![platform](http://www.bioconductor.org/shields/availability/devel/ReactomePA.svg)](https://www.bioconductor.org/packages/devel/bioc/html/ReactomePA.html#archives) [![Build Status](http://www.bioconductor.org/shields/build/devel/bioc/ReactomePA.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/ReactomePA/) [![Linux/Mac Travis Build Status](https://img.shields.io/travis/GuangchuangYu/ReactomePA/master.svg?label=Mac%20OSX%20%26%20Linux)](https://travis-ci.org/GuangchuangYu/ReactomePA) [![AppVeyor Build Status](https://img.shields.io/appveyor/ci/Guangchuangyu/ReactomePA/master.svg?label=Windows)](https://ci.appveyor.com/project/GuangchuangYu/ReactomePA) [![install with bioconda](https://img.shields.io/badge/install%20with-bioconda-green.svg?style=flat)](http://bioconda.github.io/recipes/bioconductor-reactomepa/README.html)

This package provides functions for pathway analysis based on REACTOME pathway database. It implements enrichment analysis, gene set enrichment analysis and several functions for visualization.

[![Twitter](https://img.shields.io/twitter/url/https/github.com/GuangchuangYu/ReactomePA.svg?style=social)](https://twitter.com/intent/tweet?hashtags=ReactomePA&url=http://pubs.rsc.org/en/Content/ArticleLanding/2016/MB/C5MB00663E#!divAbstract)

------------------------------------------------------------------------

Please cite the following article when using `ReactomePA`:

***G Yu***, QY He<sup>\*</sup>. ReactomePA: an R/Bioconductor package for reactome pathway analysis and visualization. ***Molecular BioSystems*** 2016, 12(2):477-479.

[![doi](https://img.shields.io/badge/doi-10.1039/c5mb00663e-green.svg?style=flat)](http://dx.doi.org/10.1039/c5mb00663e) [![citation](https://img.shields.io/badge/cited%20by-8-green.svg?style=flat)](https://scholar.google.com.hk/scholar?oi=bibs&hl=en&cites=3311691878690959578) [![Altmetric](https://img.shields.io/badge/Altmetric-15-green.svg?style=flat)](https://www.altmetric.com/details/4796667)

------------------------------------------------------------------------

For details, please visit our project website, <https://guangchuangyu.github.io/ReactomePA>.

-   [Documentation](https://guangchuangyu.github.io/ReactomePA/documentation/)
-   [Featured Articles](https://guangchuangyu.github.io/ReactomePA/featuredArticles/)
-   [Feedback](https://guangchuangyu.github.io/ReactomePA/#feedback)

### Citation

[![citation](https://img.shields.io/badge/cited%20by-8-green.svg?style=flat)](https://scholar.google.com.hk/scholar?oi=bibs&hl=en&cites=3311691878690959578)

      +--+---------+---------+---------+---------+---------+---+
    7 +                                                    *   +
      |                                                        |
    6 +                                                        +
      |                                                        |
    5 +                                                        +
      |                                                        |
    4 +                                                        +
    3 +                                                        +
      |                                                        |
    2 +                                                        +
      |                                                        |
    1 +  *                                                     +
      +--+---------+---------+---------+---------+---------+---+
       2015     2015.2    2015.4    2015.6    2015.8     2016   

### Download stats

[![download](http://www.bioconductor.org/shields/downloads/ReactomePA.svg)](https://bioconductor.org/packages/stats/bioc/ReactomePA/) [![total](https://img.shields.io/badge/downloads-23001/total-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA) [![month](https://img.shields.io/badge/downloads-696/month-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)

        +------------------+------------------+------------------+-------------------+-----------------+
        |                                                                                    *         |
        |                                                                                              |
    800 +                                                                                              +
        |                                                                                              |
        |                                                                                *             |
        |                                                                                  *  *   *    |
        |                                                                          *                   |
    600 +                                             *                          *      *              +
        |                                                                     *       *         *      |
        |                                                          *         *  *    *                 |
        |                                     *    **   *  **   *     *    *                           |
        |                          *                          *         **                             |
    400 +                       *   *      *             *       *  *                                  +
        |                        *      *   *   *                                                      |
        |                                *                                                             |
        |               **            *          *                                                     |
    200 +     *  *         ** *                                                                        +
        |      *    * *                                                                                |
        |          *                                                                                   |
        |                                                                                              |
        |                                                                                              |
      0 +   *                                                                                          +
        +------------------+------------------+------------------+-------------------+-----------------+
                         2013               2014               2015                2016
