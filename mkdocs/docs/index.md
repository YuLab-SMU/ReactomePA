<!-- AddToAny BEGIN -->
<div class="a2a_kit a2a_kit_size_32 a2a_default_style">
<a class="a2a_dd" href="//www.addtoany.com/share"></a>
<a class="a2a_button_facebook"></a>
<a class="a2a_button_twitter"></a>
<a class="a2a_button_google_plus"></a>
<a class="a2a_button_pinterest"></a>
<a class="a2a_button_reddit"></a>
<a class="a2a_button_sina_weibo"></a>
<a class="a2a_button_wechat"></a>
<a class="a2a_button_douban"></a>
</div>
<script async src="//static.addtoany.com/menu/page.js"></script>
<!-- AddToAny END -->

<link rel="stylesheet" href="https://guangchuangyu.github.io/css/font-awesome.min.css">

[![releaseVersion](https://img.shields.io/badge/release%20version-1.18.0-blue.svg?style=flat)](https://bioconductor.org/packages/ReactomePA)
[![develVersion](https://img.shields.io/badge/devel%20version-1.19.0-blue.svg?style=flat)](https://github.com/GuangchuangYu/ReactomePA)
[![total](https://img.shields.io/badge/downloads-24252/total-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)
[![month](https://img.shields.io/badge/downloads-999/month-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)

This package provides functions for pathway analysis based on REACTOME pathway database. It implements enrichment analysis, gene set enrichment analysis and several functions for visualization.

`ReactomePA` is released within the [Bioconductor](https://bioconductor.org/packages/ReactomePA) project and the source code is hosted in <a href="https://github.com/GuangchuangYu/ReactomePA"><i class="fa fa-github fa-lg"></i> GitHub</a>.


## <i class="fa fa-user"></i> Author

Guangchuang Yu, School of Public Health, The University of Hong Kong.

## <i class="fa fa-book"></i> Citation

Please cite the following article when using `ReactomePA`:

[![doi](https://img.shields.io/badge/doi-10.1039/c5mb00663e-blue.svg?style=flat)](http://dx.doi.org/10.1039/c5mb00663e)
[![citation](https://img.shields.io/badge/cited%20by-12-blue.svg?style=flat)](https://scholar.google.com.hk/scholar?oi=bibs&hl=en&cites=3311691878690959578)
[![Altmetric](https://img.shields.io/badge/Altmetric-15-blue.svg?style=flat)](https://www.altmetric.com/details/4796667)

__Yu G__ and He QY<sup>*</sup>. ReactomePA: an R/Bioconductor package for reactome pathway analysis and visualization. __*Molecular BioSystems*__, 2016,12(2):477-9.

## <i class="fa fa-pencil"></i> Featured Articles

<img src="https://guangchuangyu.github.io/featured_img/ReactomePA/pnas_F4.large.jpg" width="500">

<i class="fa fa-hand-o-right"></i> Find out more on <i class="fa fa-pencil"></i> [Featured Articles](https://guangchuangyu.github.io/ReactomePA/featuredArticles/).


## <i class="fa fa-download"></i> Installation

Install `ReactomePA` is easy, follow the guide in the [Bioconductor page](https://bioconductor.org/packages/ReactomePA/):

```r
## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
## biocLite("BiocUpgrade") ## you may need this
biocLite("ReactomePA")
```

## <i class="fa fa-cogs"></i> Overview

#### <i class="fa fa-angle-double-right"></i> Enrichment Analysis

+ Over-representation analysis
+ Gene set enrichment analysis

#### <i class="fa fa-angle-double-right"></i> Visualization

+ barplot
+ cnetplot
+ dotplot
+ enrichMap
+ gseaplot
+ upsetplot
+ viewPathway


<i class="fa fa-hand-o-right"></i> Find out details and examples on <i class="fa fa-book"></i> [Documentation](https://guangchuangyu.github.io/ReactomePA/documentation/).

## <i class="fa fa-wrench"></i> Related Tools

<ul class="fa-ul">
	<li><i class="fa-li fa fa-angle-double-right"></i><a href="https://guangchuangyu.github.io/clusterProfiler">clusterProfiler</a> for Ontologies/pathways enrichment analyses</li>
	<li><i class="fa-li fa fa-angle-double-right"></i><a href="https://guangchuangyu.github.io/DOSE">DOSE</a> for Disease Ontology Semantic and Enrichment analyses</li>
	<li><i class="fa-li fa fa-angle-double-right"></i><a href="https://guangchuangyu.github.io/meshes">meshes</a> for MeSH Enrichment and Semantic analysis</li>
</ul>

<i class="fa fa-hand-o-right"></i> Find out more on [projects](https://guangchuangyu.github.io/#projects).


## <i class="fa fa-code-fork"></i> Projects that depend on _ReactomePA_


#### <i class="fa fa-angle-double-right"></i> Bioconductor packages
+ [bioCancer](https://www.bioconductor.org/packages/bioCancer): Interactive Multi-Omics Cancers Data Visualization and Analysis
+ [debrowser](https://www.bioconductor.org/packages/debrowser): Interactive Differential Expresion Analysis Browser
+ [LINC](https://www.bioconductor.org/packages/LINC): co-expression of lincRNAs and protein-coding genes


## <i class="fa fa-comment"></i> Feedback
<ul class="fa-ul">
	<li><i class="fa-li fa fa-hand-o-right"></i> Please make sure you [follow the guide](https://guangchuangyu.github.io/2016/07/how-to-bug-author/) before posting any issue/question</li>
	<li><i class="fa-li fa fa-bug"></i> For bugs or feature requests, please post to <i class="fa fa-github-alt"></i> [github issue](https://github.com/GuangchuangYu/ReactomePA/issues)</li>
	<li><i class="fa-li fa fa-question"></i>  For user questions, please post to [Bioconductor support site](https://support.bioconductor.org/) and [Biostars](https://www.biostars.org/). We are following every post tagged with **ReactomePA**</li>
	<li><i class="fa-li fa fa-commenting"></i> Join the group chat on <a href="https://twitter.com/hashtag/ReactomePA"><i class="fa fa-twitter fa-lg"></i></a> and <a href="http://huati.weibo.com/k/ReactomePA"><i class="fa fa-weibo fa-lg"></i></a></li>
</ul>


<!--
<div id="disqus_thread"></div>
<script type="text/javascript">

(function() {
    // Don't ever inject Disqus on localhost--it creates unwanted
    // discussions from 'localhost:1313' on your Disqus account...
    // if (window.location.hostname == "localhost")
    //     return;

    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
    var disqus_shortname = 'gcyu';
    dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com/" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>

-->
