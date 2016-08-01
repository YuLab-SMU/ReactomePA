##' Pathway Enrichment Analysis of a gene set.
##' Given a vector of genes, this function will return the enriched pathways
##' with FDR control.
##'
##'
##' @param gene a vector of entrez gene id.
##' @param organism one of "human", "rat", "mouse", "celegans", "yeast", "zebrafish", "fly".
##' @param pvalueCutoff Cutoff value of pvalue.
##' @param pAdjustMethod one of "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
##' @param qvalueCutoff Cutoff value of qvalue
##' @param universe background genes
##' @param minGSSize minimal size of genes annotated by Ontology term for testing.
##' @param maxGSSize maximal size of each geneSet for analyzing
##' @param readable whether mapping gene ID to gene Name
##' @return A \code{enrichResult} instance.
##' @importFrom DOSE setReadable
##' @importClassesFrom DOSE enrichResult
##' @importMethodsFrom DOSE show
##' @importMethodsFrom DOSE summary
##' @importMethodsFrom DOSE plot
##' @importFrom DOSE EXTID2NAME
##' @export
##' @author Guangchuang Yu \url{http://ygc.name}
##' @seealso \code{\link{enrichResult-class}}
##' @keywords manip
##' @examples
##'
##' 	gene <- c("11171", "8243", "112464", "2194",
##'				"9318", "79026", "1654", "65003",
##'				"6240", "3476", "6238", "3836",
##'				"4176", "1017", "249")
##' 	yy = enrichPathway(gene, pvalueCutoff=0.05)
##' 	head(summary(yy))
##' 	#plot(yy)
##'
enrichPathway <- function(gene,
                          organism="human",
                          pvalueCutoff = 0.05,
                          pAdjustMethod="BH",
                          qvalueCutoff = 0.2,
                          universe,
                          minGSSize=10,
                          maxGSSize=500,
                          readable=FALSE) {

    Reactome_DATA <- get_Reactome_DATA(organism)
    
    res <- enricher_internal(gene,
                           pvalueCutoff=pvalueCutoff,
                           pAdjustMethod=pAdjustMethod,
                           qvalueCutoff=qvalueCutoff,
                           universe = universe,
                           minGSSize = minGSSize,
                           maxGSSize = maxGSSize,
                           USER_DATA = Reactome_DATA)

    if (is.null(res))
        return(res)

    res@keytype <- "ENTREZID"
    res@organism <- organism
    OrgDb <- getDb(organism)
    if (readable) {
        res <- setReadable(res, OrgDb)
    }
    res@ontology <- "Reactome"
    return(res)
}



## ' @importFrom DOSE TERM2NAME
## ' @importFrom reactome.db reactomePATHID2NAME
## ' @importFrom reactome.db reactome.db
## ' @importMethodsFrom AnnotationDbi mget
## ' @importMethodsFrom AnnotationDbi mapIds
## ' @method TERM2NAME Reactome
## ' @export
## TERM2NAME.Reactome <- function(term, organism, ...) {
##     pathID <- as.character(term)
##     ## pathName <- mget(pathID, reactomePATHID2NAME)
##     pathName <- mapIds(reactome.db, pathID, 'PATHNAME', 'PATHID')
##     pathName <- pathName[!is.na(pathName)]
    
##     ##
##     ## this issue had been solve since reactome 52
##     ##
##     ## multiple mapping exists.
##     ## 
##     ##

##     ##     > term
##     ##     Homo sapiens:  NS1 Mediated Effects on Host Pathways
##     ##                                             "168276"
##     ##                 Homo sapiens: 2-LTR circle formation
##     ##                                             "164843"
##     ##     > pathName <- unlist(mget(pathID, reactomePATHID2NAME))
##     ##     > pathName
##     ##                                                     1682761
##     ##      "Homo sapiens:  NS1 Mediated Effects on Host Pathways"
##     ##                                                     1682762
##     ## "Influenza A virus:  NS1 Mediated Effects on Host Pathways"
##     ##                                                     1648431
##     ##                      "Homo sapiens: 2-LTR circle formation"
##     ##                                                     1648432
##     ##    "Human immunodeficiency virus 1: 2-LTR circle formation"
##     ##                                                     1629061
##     ##             "Human immunodeficiency virus 1: HIV Infection"
##     ##                                                     1629062
##     ##                               "Homo sapiens: HIV Infection"
##     ##                                                     1629063
##     ##             "Human immunodeficiency virus 2: HIV Infection"

##     ## The following description contain "Homo sapiens", and report a bug. 
##     ## "Mycobacterium tuberculosis: Latent infection of Homo sapiens with Mycobacterium tuberculosis"
##     ## To fix it, the ":" should presented in grep.
##     org <- switch(organism,
##                   human = "Homo sapiens:",
##                   rat = "Rattus norvegicus:",
##                   mouse = "Mus musculus:",
##                   yeast = "Saccharomyces cerevisiae:",
##                   zebrafish = "Danio rerio:",
##                   celegans = "Caenorhabditis elegans:",
##                   fly = "Drosophila melanogaster:"
##                   )

##     pathName <- sapply(pathName, function(p) p[grep(org, p)])
##     pathName <- unlist(pathName)
##     pathName <- sapply(pathName, function(i) unlist(strsplit(i, split=org))[2]) # splitting by ":" is risky
##     pathName <- sub("^\\s+", "", pathName)  # remove leading spaces

##     ##
##     ## BUG was reported by Jean-Christophe Aude (Jean-Christophe.AUDE@cea.fr)
##     ##
##     ## > get("174495", reactomePATHID2NAME)
##     ## [1] "Human immunodeficiency virus 1: Synthesis And Processing Of GAG, GAGPOL Polyproteins"
##     ## human genes involves, but pathway name was not labelled by "Homo sapiens".
    
##     ## get first term of missing ID
##     missID <- pathID[ ! pathID %in% names(pathName) ]
##     if (length(missID) > 0 ) {
##         missPathName <- unlist(sapply(mget(missID, reactomePATHID2NAME), "[[", 1))
##         names(missPathName) <- missID
##     } else {
##         missPathName <- NA
##     }
##     if (is.na(missPathName)) {
##         res <- pathName
##     } else {
##         ## merge and keep input order
##         res <- c(pathName, missPathName)
##         res <- res[pathID]
##     }
##     return(res)
## }

