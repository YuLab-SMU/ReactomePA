#' Pathway Enrichment Analysis of a gene set.
#' Given a vector of genes, this function will return the enriched pathways
#' with FDR control.
#'
#'
#' @param gene a vector of entrez gene id.
#' @param organism one of "human", "rat", "mouse", "celegans", "yeast", "zebrafish", "fly".
#' @param pvalueCutoff Cutoff value of pvalue.
#' @param pAdjustMethod one of "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
#' @param qvalueCutoff Cutoff value of qvalue
#' @param universe background genes
#' @param minGSSize minimal size of genes annotated by Ontology term for testing.
#' @param maxGSSize maximal size of each geneSet for analyzing
#' @param readable whether mapping gene ID to gene Name
#' @param weight A named numeric vector of weights for background genes. If provided, Weighted ORA will be performed using Wallenius' noncentral hypergeometric distribution.
#' @return A \code{enrichResult} instance.
#' @importFrom enrichit setReadable
#' @importClassesFrom enrichit enrichResult
#' @importMethodsFrom enrichit show
#' @importMethodsFrom enrichit summary
#' @importFrom enrichit EXTID2NAME
#' @export
#' @author Guangchuang Yu \url{http://ygc.name}
#' @seealso \code{\link[enrichit]{enrichResult-class}}
#' @keywords manip
#' @examples
#' \dontrun{
#' 	gene <- c("11171", "8243", "112464", "2194",
#'				"9318", "79026", "1654", "65003",
#'				"6240", "3476", "6238", "3836",
#'				"4176", "1017", "249")
#' 	yy = enrichPathway(gene, pvalueCutoff=0.05)
#' 	head(summary(yy))
#' }
enrichPathway <- function(gene,
                          pvalueCutoff = 0.05,
                          pAdjustMethod="BH",
                          universe = NULL,
                          weight = NULL,
                          minGSSize=10,
                          maxGSSize=500,
                          qvalueCutoff = 0.2,
                          organism="human",
                          readable=FALSE) {

    gson <- gson_Reactome(organism)

    res <- enrichit::ora_gson(gene,
                           pvalueCutoff=pvalueCutoff,
                           pAdjustMethod=pAdjustMethod,
                           universe = universe,
                           weight = weight,
                           minGSSize = minGSSize,
                           maxGSSize = maxGSSize,
                           qvalueCutoff=qvalueCutoff,
                           gson = gson)

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

