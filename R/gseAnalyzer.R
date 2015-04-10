##' Gene Set Enrichment Analysis of Reactome Pathway
##'
##'
##' @title gsePathway
##' @param geneList order ranked geneList
##' @param organism organism
##' @param exponent weight of each step
##' @param nPerm permutation numbers
##' @param minGSSize minimal size of each geneSet for analyzing
##' @param pvalueCutoff pvalue Cutoff
##' @param pAdjustMethod pvalue adjustment method
##' @param verbose print message or not
##' @importFrom DOSE gseAnalyzer
##' @importClassesFrom DOSE gseaResult
##' @importMethodsFrom DOSE show
##' @importMethodsFrom DOSE summary
##' @importMethodsFrom DOSE plot
##' @export
##' @return gseaResult object
##' @author Yu Guangchuang
gsePathway <- function(geneList,
                       organism      = "human",
                       exponent      = 1,
                       nPerm         = 1000,
                       minGSSize     = 10,
                       pvalueCutoff  = 0.05,
                       pAdjustMethod = "BH",
                       verbose       = TRUE) {

    gseAnalyzer(geneList      = geneList,
                setType       = "Reactome",
                organism      = organism,
                exponent      = exponent,
                nPerm         = nPerm,
                minGSSize     = minGSSize,
                pvalueCutoff  = pvalueCutoff,
                pAdjustMethod = pAdjustMethod,
                verbose       = verbose)
    
}


##' visualize analyzing result of GSEA
##'
##' plotting function for gseaResult
##' @title gseaplot
##' @param gseaResult gseaResult object
##' @param geneSetID geneSet ID
##' @param by one of "runningScore" or "position"
##' @return figure
##' @export
##' @author ygc
gseaplot <- DOSE::gseaplot


##' @importFrom DOSE getGeneSet
##' @importFrom reactome.db reactomePATHID2EXTID
##' @importFrom reactome.db reactomePATHID2NAME
##' @importFrom AnnotationDbi as.list
##' @importFrom AnnotationDbi keys
##' @method getGeneSet Reactome
##' @export
getGeneSet.Reactome <- function(setType="Reactome", organism, ...) {
    if (setType != "Reactome")
        stop("setType should be 'Reactome'... ")
    gs <- as.list(reactomePATHID2EXTID) ## also contains reactions

    paths <- keys(reactomePATHID2NAME)
    gs <- gs[names(gs) %in% paths]
    return(gs)
}


