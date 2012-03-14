##' Mapping Pathway ID to Pathway Name
##'
##'
##' @title pathID2Name
##' @param pathID query Path ID
##' @return Pathway Name
##' @importFrom reactome.db reactomePATHID2NAME
##' @importMethodsFrom AnnotationDbi mget
##' @author Guangchuang Yu \url{http://ygc.name}
##' @keywords mainip
##' @export
##' @examples
##'
##'     pathID2Name(c("1221632","75983"))
##'
pathID2Name <- function(pathID) {
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
