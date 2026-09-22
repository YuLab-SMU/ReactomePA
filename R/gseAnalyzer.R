#' Gene Set Enrichment Analysis of Reactome Pathway
#'
#'
#' @title gsePathway
#' @param geneList order ranked geneList
#' @param organism organism
#' @param exponent weight of each step
#' @param weight A named numeric vector of weights for genes. The names should match the names of geneList. If provided, the geneList will be multiplied by the weight and resorted before GSEA (default: NULL).
#' @param minGSSize minimal size of each geneSet for analyzing
#' @param maxGSSize maximal size of each geneSet for analyzing
#' @param pvalueCutoff pvalue Cutoff
#' @param pAdjustMethod pvalue adjustment method
#' @param verbose print message or not
#' @param nPerm The number of permutations for the "permute" method
#' @param method one of "sample", "permute", "multilevel"
#' @param adaptive logical
#' @param minPerm minimal number of permutations for the "multilevel" method
#' @param maxPerm maximal number of permutations for the "multilevel" method
#' @param pvalThreshold The p-value threshold for the "multilevel" method
#' @param seed random seed for reproducibility, set to a number (or TRUE to use a
#'   fixed default seed) to make the result reproducible, or FALSE (default) to draw
#'   a random seed on each run, so results may vary between runs. The underlying
#'   permutation engine uses its own RNG seeded with this value; see
#'   \code{enrichit::gsea()} for details.
#' @importClassesFrom enrichit gseaResult
#' @importMethodsFrom enrichit show
#' @importMethodsFrom enrichit summary
#' @export
#' @return gseaResult object
#' @author Yu Guangchuang
gsePathway <- function(geneList,
                       organism      = "human",
                       exponent      = 1,
                       weight        = NULL,
                       minGSSize     = 10,
                       maxGSSize     = 500,
                       pvalueCutoff  = 0.05,
                       pAdjustMethod = "BH",
                       verbose       = TRUE,
                       nPerm         = 1000,
                       method        = "multilevel",
                       adaptive      = FALSE,
                       minPerm       = 101,
                       maxPerm       = 1e5,
                       pvalThreshold = 0.1,
                       seed          = FALSE) {

    gson <- gson_Reactome(organism)

    res <- enrichit::gsea_gson(geneList      = geneList,
                               gson          = gson,
                               exponent      = exponent,
                               weight        = weight,
                               minGSSize     = minGSSize,
                               maxGSSize     = maxGSSize,
                               pvalueCutoff  = pvalueCutoff,
                               pAdjustMethod = pAdjustMethod,
                               verbose       = verbose,
                               nPerm         = nPerm,
                               method        = method,
                               adaptive      = adaptive,
                               minPerm       = minPerm,
                               maxPerm       = maxPerm,
                               pvalThreshold = pvalThreshold,
                               seed          = seed)

    if (is.null(res))
        return(res)

    res@organism <- organism
    res@setType <- "Reactome"
    res@keytype <- "ENTREZID"

    return(res)
}

