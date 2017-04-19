---
html_preview: False
output:
  md_document:
    variant: markdown
---

ReactomePA: Reactome Pathway Analysis
=====================================

<!-- AddToAny BEGIN -->
<div class="a2a_kit a2a_kit_size_32 a2a_default_style">

<a class="a2a_dd" href="//www.addtoany.com/share"></a>
<a class="a2a_button_facebook"></a> <a class="a2a_button_twitter"></a>
<a class="a2a_button_google_plus"></a>
<a class="a2a_button_pinterest"></a> <a class="a2a_button_reddit"></a>
<a class="a2a_button_sina_weibo"></a> <a class="a2a_button_wechat"></a>
<a class="a2a_button_douban"></a>

</div>

<script async src="//static.addtoany.com/menu/page.js"></script>
<!-- AddToAny END -->
<link rel="stylesheet" href="https://guangchuangyu.github.io/css/font-awesome.min.css">
<link rel="stylesheet" href="https://guangchuangyu.github.io/css/academicons.min.css">

[![](https://img.shields.io/badge/release%20version-1.18.1-blue.svg?style=flat)](https://bioconductor.org/packages/ReactomePA)
[![](https://img.shields.io/badge/devel%20version-1.19.1-blue.svg?style=flat)](https://github.com/guangchuangyu/ReactomePA)
[![](https://img.shields.io/badge/download-18184/total-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)
[![](https://img.shields.io/badge/download-517/month-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/ReactomePA)

This package provides functions for pathway analysis based on REACTOME
pathway database. It implements enrichment analysis, gene set enrichment
analysis and several functions for visualization.

`ReactomePA` is released within the
[Bioconductor](https://bioconductor.org/packages/ReactomePA) project and
the source code is hosted in
<a href="https://github.com/GuangchuangYu/ReactomePA"><i class="fa fa-github fa-lg"></i>
GitHub</a>.

<i class="fa fa-user"></i> Author
---------------------------------

Guangchuang Yu, School of Public Health, The University of Hong Kong.

<a href="https://twitter.com/guangchuangyu"><i class="fa fa-twitter fa-3x"></i></a>
<a href="https://guangchuangyu.github.io/blog_images/biobabble.jpg"><i class="fa fa-wechat fa-3x"></i></a>
<a href="https://www.ncbi.nlm.nih.gov/pubmed/?term=Guangchuang+Yu[Author+-+Full]"><i class="ai ai-pubmed ai-3x"></i></a>
<a href="https://scholar.google.com.hk/citations?user=DO5oG40AAAAJ&hl=en"><i class="ai ai-google-scholar ai-3x"></i></a>
<a href="https://orcid.org/0000-0002-6485-8781"><i class="ai ai-orcid ai-3x"></i></a>
<a href="https://impactstory.org/u/0000-0002-6485-8781"><i class="ai ai-impactstory ai-3x"></i></a>

<i class="fa fa-book"></i> Citation
-----------------------------------

Please cite the following article when using `ReactomePA`:

[![](https://img.shields.io/badge/doi-10.1039/c5mb00663e-blue.svg?style=flat)](http://dx.doi.org/10.1039/c5mb00663e)
[![](https://img.shields.io/badge/Altmetric-15-blue.svg?style=flat)](https://www.altmetric.com/details/4796667)
[![citation](https://img.shields.io/badge/cited%20by-23-blue.svg?style=flat)](https://scholar.google.com.hk/scholar?oi=bibs&hl=en&cites=3311691878690959578)
[![](https://img.shields.io/badge/ESI-Highly%20Cited%20Paper-blue.svg?style=flat)](http://apps.webofknowledge.com/InboundService.do?mode=FullRecord&customersID=RID&IsProductCode=Yes&product=WOS&Init=Yes&Func=Frame&DestFail=http%3A%2F%2Fwww.webofknowledge.com&action=retrieve&SrcApp=RID&SrcAuth=RID&SID=Y2CXu6nry8nDQZcUy1w&UT=WOS%3A000368858900017)

**Yu G** and He QY<sup>\*</sup>. ReactomePA: an R/Bioconductor package
for reactome pathway analysis and visualization. ***Molecular
BioSystems***, 2016,12(2):477-9.

<i class="fa fa-pencil"></i> Featured Articles
----------------------------------------------

<img src="https://guangchuangyu.github.io/featured_img/ReactomePA/pnas_F4.large.jpg" width="500">

<i class="fa fa-hand-o-right"></i> Find out more on
<i class="fa fa-pencil"></i> [Featured
Articles](https://guangchuangyu.github.io/ReactomePA/featuredArticles/).

<i class="fa fa-download"></i> Installation
-------------------------------------------

Install `ReactomePA` is easy, follow the guide in the [Bioconductor
page](https://bioconductor.org/packages/ReactomePA/):

``` {.r}
## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
## biocLite("BiocUpgrade") ## you may need this
biocLite("ReactomePA")
```

<i class="fa fa-cogs"></i> Overview
-----------------------------------

#### <i class="fa fa-angle-double-right"></i> Enrichment Analysis

-   Over-representation analysis
-   Gene set enrichment analysis

#### <i class="fa fa-angle-double-right"></i> Visualization

-   barplot
-   cnetplot
-   dotplot
-   enrichMap
-   gseaplot
-   upsetplot
-   viewPathway

<i class="fa fa-hand-o-right"></i> Find out details and examples on
<i class="fa fa-book"></i>
[Documentation](https://guangchuangyu.github.io/ReactomePA/documentation/).

<i class="fa fa-wrench"></i> Related Tools
------------------------------------------

<ul class="fa-ul">
    <li><i class="fa-li fa fa-angle-double-right"></i><a href="https://guangchuangyu.github.io/clusterProfiler">clusterProfiler</a> for Ontologies/pathways enrichment analyses</li>
    <li><i class="fa-li fa fa-angle-double-right"></i><a href="https://guangchuangyu.github.io/DOSE">DOSE</a> for Disease Ontology Semantic and Enrichment analyses</li>
    <li><i class="fa-li fa fa-angle-double-right"></i><a href="https://guangchuangyu.github.io/meshes">meshes</a> for MeSH Enrichment and Semantic analysis</li>

</ul>
<i class="fa fa-hand-o-right"></i> Find out more on
[projects](https://guangchuangyu.github.io/#projects).

<i class="fa fa-code-fork"></i> Projects that depend on *ReactomePA*
--------------------------------------------------------------------

#### <i class="fa fa-angle-double-right"></i> Bioconductor packages

-   [bioCancer](https://www.bioconductor.org/packages/bioCancer):
    Interactive Multi-Omics Cancers Data Visualization and Analysis
-   [LINC](https://www.bioconductor.org/packages/LINC): co-expression of
    lincRNAs and protein-coding genes

<i class="fa fa-comment"></i> Feedback
--------------------------------------

<ul class="fa-ul">
    <li><i class="fa-li fa fa-hand-o-right"></i> Please make sure you have followed <a href="https://guangchuangyu.github.io/2016/07/how-to-bug-author/"><strong>the important guide</strong></a> before posting any issue/question</li>
    <li><i class="fa-li fa fa-bug"></i> For bugs or feature requests, please post to <i class="fa fa-github-alt"></i> <a href="https://github.com/GuangchuangYu/ReactomePA/issues">github issue</a></li>
    <li><i class="fa-li fa fa-question"></i>  For user questions, please post to <a href="https://support.bioconductor.org/">Bioconductor support site</a> and <a href="https://www.biostars.org/">Biostars</a>. We are following every post tagged with <strong>ReactomePA</strong></li>
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
