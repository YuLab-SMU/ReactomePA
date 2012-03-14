##' convert gene IDs to gene Names.
##'
##'
##' @title convert gene IDs to gene Names
##' @param geneID a vector of gene IDs
##' @param organism currently, only "human" supported.
##' @return a vector of gene names.
##' @importMethodsFrom AnnotationDbi mget
##' @importFrom org.Hs.eg.db org.Hs.egSYMBOL
##' @author Guangchuang Yu \url{http://ygc.name}
##' @export
##' @examples
##'
##' 	gene <- as.character(1:10)
##' 	geneID2Name(gene, organism="human")
##'

## geneID2Name <- function(geneID, organism="human") {
## 	geneID <- as.character(geneID)
## 	if (organism == "human") {
## 		gn <- mget(geneID, org.Hs.egSYMBOL, ifnotfound=NA)
## 	}
## 	gn <- unique(unlist(gn))
## 	gn <- gn[!is.na(gn)]
## 	return(gn)
## }

geneID2Name <- function(geneID, annoDb="org.Hs.eg.db") {
    require(annoDb, character.only = TRUE)
    annoDb <- eval(parse(text=annoDb))
    geneID <- as.character(geneID)
    gn.df <- select(annoDb, keys=geneID,cols="SYMBOL")
    gn <- gn.df$SYMBOL
    gn <- unique(gn[!is.na(gn)])
    return(gn)
}
