##' Pathway Enrichment Analysis of a gene set.
##' Given a vector of genes, this function will return the enriched pathways
##' with FDR control.
##'
##'
##' @param gene a vector of entrez gene id.
##' @param pvalueCutoff Cutoff value of pvalue.
##' @param qvalueCutoff Cutoff value of qvalue.
##' @param readable if readable is TRUE, the gene IDs will mapping to gene
##'   symbols.
##' @return A \code{enrichResult} instance.
##' @importFrom DOSE enrich.internal
##' @importClassesFrom DOSE enrichResult
##' @importMethodsFrom DOSE show
##' @importMethodsFrom DOSE summary
##' @importMethodsFrom DOSE plot
##' @importMethodsFrom DOSE setReadable
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
                          pvalueCutoff = 0.05,
                          qvalueCutoff = 0.05,
                          readable=FALSE) {

    enrich.internal(gene,
                    organism="human",
                    pvalueCutoff,
                    qvalueCutoff,
                    ont="Reactome",
                    readable)
}

##' @importFrom DOSE EXTID2TERMID
##' @importMethodsFrom AnnotationDbi mget
##' @importFrom reactome.db reactomeEXTID2PATHID
##' @S3method EXTID2TERMID Reactome
EXTID2TERMID.Reactome <- function(gene, organism) {
    gene <- as.character(gene)
    ## query external ID to pathway ID
    qExtID2PathID <- mget(gene, reactomeEXTID2PATHID, ifnotfound=NA)

    notNA.idx <- unlist(lapply(qExtID2PathID, function(i) !all(is.na(i))))
    qExtID2PathID <- qExtID2PathID[notNA.idx]
    return(qExtID2PathID)
}

##' @importFrom DOSE TERMID2EXTID
##' @importMethodsFrom AnnotationDbi mget
##' @importFrom reactome.db reactomePATHID2EXTID
##' @S3method TERMID2EXTID Reactome
TERMID2EXTID.Reactome <- function(term, organism) {
    pathID2ExtID <- mget(unique(term), reactomePATHID2EXTID)
    return(pathID2ExtID)
}

##' @importFrom DOSE ALLEXTID
##' @importMethodsFrom AnnotationDbi mappedkeys
##' @importFrom reactome.db reactomeEXTID2PATHID
##' @S3method ALLEXTID Reactome
ALLEXTID.Reactome <- function(organism) {
    extID <- unique(mappedkeys(reactomeEXTID2PATHID))
    return(extID)
}

##' @importFrom DOSE TERM2NAME
##' @importFrom reactome.db reactomePATHID2NAME
##' @importMethodsFrom AnnotationDbi mget
##' @S3method TERM2NAME Reactome
TERM2NAME.Reactome <- function(term) {
    pathID <- as.character(term)
    pathName <- unlist(mget(pathID, reactomePATHID2NAME))

    if (length(pathName) != length(pathID)) {
	## multiple mapping of pathway ID to pathway Name
	## such as pathway 162906 can mapping to 1629061
	## and 1629062 when getting pathway name, remain the first one.
	dd <- names(pathName)
	pm.idx <- dd %in% pathID
	pm <- dd[pm.idx] ##perfect match

	mm <- dd[!pm.idx] ## miss match
	mm.idx <- as.numeric(mm) %% 10 == 1
	mm <- mm[mm.idx]

	remainPath <- c(pm, mm)
	pathName <- pathName[dd %in% remainPath]
    }

    return(pathName)
}

