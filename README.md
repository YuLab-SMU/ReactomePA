ReactomePA: Reactome Pathway Analysis
=====================================

[![](https://img.shields.io/badge/release%20version-1.18.1-green.svg?style=flat)](https://bioconductor.org/packages/ReactomePA) [![](https://img.shields.io/badge/devel%20version-1.19.1-green.svg?style=flat)](https://github.com/guangchuangyu/ReactomePA) [![Bioc](http://www.bioconductor.org/shields/years-in-bioc/clusterProfiler.svg)](https://www.bioconductor.org/packages/devel/bioc/html/clusterProfiler.html#since) [![](https://img.shields.io/badge/download-18184/total-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA) [![](https://img.shields.io/badge/download-517/month-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![codecov](https://codecov.io/gh/GuangchuangYu/ReactomePA/branch/master/graph/badge.svg)](https://codecov.io/gh/GuangchuangYu/ReactomePA/) [![Last-changedate](https://img.shields.io/badge/last%20change-2017--04--19-green.svg)](https://github.com/GuangchuangYu/ReactomePA/commits/master) [![commit](http://www.bioconductor.org/shields/commits/bioc/ReactomePA.svg)](https://www.bioconductor.org/packages/devel/bioc/html/ReactomePA.html#svn_source) [![GitHub forks](https://img.shields.io/github/forks/GuangchuangYu/ReactomePA.svg)](https://github.com/GuangchuangYu/ReactomePA/network) [![GitHub stars](https://img.shields.io/github/stars/GuangchuangYu/ReactomePA.svg)](https://github.com/GuangchuangYu/ReactomePA/stargazers)

[![platform](http://www.bioconductor.org/shields/availability/devel/ReactomePA.svg)](https://www.bioconductor.org/packages/devel/bioc/html/ReactomePA.html#archives) [![Build Status](http://www.bioconductor.org/shields/build/devel/bioc/ReactomePA.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/ReactomePA/) [![Linux/Mac Travis Build Status](https://img.shields.io/travis/GuangchuangYu/ReactomePA/master.svg?label=Mac%20OSX%20%26%20Linux)](https://travis-ci.org/GuangchuangYu/ReactomePA) [![AppVeyor Build Status](https://img.shields.io/appveyor/ci/Guangchuangyu/ReactomePA/master.svg?label=Windows)](https://ci.appveyor.com/project/GuangchuangYu/ReactomePA)

This package provides functions for pathway analysis based on REACTOME pathway database. It implements enrichment analysis, gene set enrichment analysis and several functions for visualization.

[![Twitter](https://img.shields.io/twitter/url/https/github.com/GuangchuangYu/ReactomePA.svg?style=social)](https://twitter.com/intent/tweet?hashtags=ReactomePA&url=http://pubs.rsc.org/en/Content/ArticleLanding/2016/MB/C5MB00663E#!divAbstract)

------------------------------------------------------------------------

Please cite the following article when using `ReactomePA`:

***G Yu***, QY He<sup>\*</sup>. ReactomePA: an R/Bioconductor package for reactome pathway analysis and visualization. ***Molecular BioSystems*** 2016, 12(2):477-479.

[![](https://img.shields.io/badge/doi-10.1039/c5mb00663e-green.svg?style=flat)](http://dx.doi.org/10.1039/c5mb00663e) [![](https://img.shields.io/badge/Altmetric-15-green.svg?style=flat)](https://www.altmetric.com/details/4796667) [![citation](https://img.shields.io/badge/cited%20by-23-green.svg?style=flat)](https://scholar.google.com.hk/scholar?oi=bibs&hl=en&cites=3311691878690959578) [![](https://img.shields.io/badge/ESI-Highly%20Cited%20Paper-green.svg?style=flat)](http://apps.webofknowledge.com/InboundService.do?mode=FullRecord&customersID=RID&IsProductCode=Yes&product=WOS&Init=Yes&Func=Frame&DestFail=http%3A%2F%2Fwww.webofknowledge.com&action=retrieve&SrcApp=RID&SrcAuth=RID&SID=Y2CXu6nry8nDQZcUy1w&UT=WOS%3A000368858900017)

------------------------------------------------------------------------

For details, please visit our project website, <https://guangchuangyu.github.io/ReactomePA>.

-   [Documentation](https://guangchuangyu.github.io/ReactomePA/documentation/)
-   [Featured Articles](https://guangchuangyu.github.io/ReactomePA/featuredArticles/)
-   [Feedback](https://guangchuangyu.github.io/ReactomePA/#feedback)

### Citation

[![citation](https://img.shields.io/badge/cited%20by-23-green.svg?style=flat)](https://scholar.google.com.hk/scholar?oi=bibs&hl=en&cites=3311691878690959578) [![](https://img.shields.io/badge/ESI-Highly%20Cited%20Paper-green.svg?style=flat)](http://apps.webofknowledge.com/InboundService.do?mode=FullRecord&customersID=RID&IsProductCode=Yes&product=WOS&Init=Yes&Func=Frame&DestFail=http%3A%2F%2Fwww.webofknowledge.com&action=retrieve&SrcApp=RID&SrcAuth=RID&SID=Y2CXu6nry8nDQZcUy1w&UT=WOS%3A000368858900017)

       +-+------------+-----------+------------+-----------+---+
    15 +                          *                            +
       |                                                       |
       |                                                       |
       |                                                       |
    10 +                                                       +
       |                                                       |
       |                                                   *   |
       |                                                       |
     5 +                                                       +
       |                                                       |
       |                                                       |
       | *                                                     |
       +-+------------+-----------+------------+-----------+---+
       2015        2015.5       2016        2016.5       2017   

### Download stats

[![download](http://www.bioconductor.org/shields/downloads/ReactomePA.svg)](https://bioconductor.org/packages/stats/bioc/ReactomePA/) [![](https://img.shields.io/badge/download-18184/total-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA) [![](https://img.shields.io/badge/download-517/month-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)

         +----------------+----------------+----------------+----------------+---------------+---------+
    1000 +                                                                                 **          +
         |                                                                                             |
         |                                                                                        *    |
         |                                                                          *                  |
     800 +                                                                                      *      +
         |                                                                                   *         |
         |                                                                       *      *              |
         |                                                                 *      *  *   *     *       |
     600 +                                                                     *                       +
         |                                        *                       *   *                        |
         |                                                           * **    *        *                |
         |                                            *   *  *  *                                      |
         |                       *         *   **  *   * *       * **                                  |
     400 +                    *   *     *            *      * *                                        +
         |                     *     *   *  *                                                          |
         |                             *                                                               |
         |       *     * *   *      *        *                                                         |
     200 +     *    * *   **                                                                           +
         |      *  *                                                                                   |
         |                                                                                             |
         |                                                                                             |
       0 +   *                                                                                         +
         +----------------+----------------+----------------+----------------+---------------+---------+
       2012             2013             2014             2015             2016            2017
