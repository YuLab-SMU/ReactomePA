##' Gene Set Enrichment Analysis of Reactome Pathway
##'
##'
##' @title gseAnalyzer
##' @param geneList order ranked geneList
##' @param organism organism
##' @param exponent weight of each step
##' @param nPerm permutation numbers
##' @param minGSSize minimal size of each geneSet for analyzing
##' @param pvalueCutoff pvalue Cutoff
##' @param pAdjustMethod pvalue adjustment method
##' @param verbose print message or not
##' @importFrom DOSE gsea
##' @importClassesFrom DOSE gseaResult
##' @importMethodsFrom DOSE show
##' @importMethodsFrom DOSE summary
##' @importMethodsFrom DOSE plot
##' @export
##' @return gseaResult object
##' @author Yu Guangchuang
gseAnalyzer <- function(geneList,
                        organism      = "human",
                        exponent      = 1,
                        nPerm         = 1000,
                        minGSSize     = 10,
                        pvalueCutoff  = 0.05,
                        pAdjustMethod = "BH",
                        verbose       = TRUE) {

    setType <- "Reactome"
    if (verbose)
        sprintf("preparing geneSet collections of setType '%s'...", setType)

    class(setType) <- setType
    geneSets <- getGeneSet(setType, organism)

    gsea(geneList      = geneList,
         geneSets      = geneSets,
         setType       = setType,
         organism      = organism,
         exponent      = exponent,
         nPerm         = nPerm,
         minGSSize     = minGSSize,
         pvalueCutoff  = pvalueCutoff,
         pAdjustMethod = pAdjustMethod,
         verbose       = verbose)
}


##' @importFrom DOSE getGeneSet
##' @importFrom reactome.db reactomePATHID2EXTID
##' @importFrom AnnotationDbi as.list
##' @S3method getGeneSet Reactome
getGeneSet.Reactome <- function(setType="Reactome", organism) {
    if (setType != "Reactome")
        stop("setType should be 'Reactome'... ")
    gs <- as.list(reactomePATHID2EXTID)
    return(gs)
}


