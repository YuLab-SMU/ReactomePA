##' view reactome pathway
##'
##' plotting reactome pathway
##' @title viewPathway
##' @param pathName pathway Name
##' @param organism supported organism
##' @param readable logical
##' @param foldChange fold change
##' @param ... additional parameters passed to \code{\link[DOSE]{netplot}}
## @importFrom graphite pathways
##' @importFrom graphite convertIdentifiers
##' @importFrom graphite pathwayGraph
##' @importFrom igraph igraph.from.graphNEL
##' @importFrom igraph as.undirected
##' @importFrom DOSE scaleNodeColor
##' @importFrom DOSE netplot
##' @importFrom DOSE EXTID2NAME
##' @importFrom DOSE setting.graph.attributes
##' @return plot
##' @export
##' @author Yu Guangchuang
viewPathway <- function(pathName,
                        organism="human",
                        readable=TRUE,
                        foldChange=NULL, ...){

    ## call pathways via imported from graphite has the following issue:
    ##
    ## Error: processing vignette 'ReactomePA.Rnw' failed with diagnostics:
    ## no item called "package:graphite" on the search list
    ## Execution halted
    ##
    
    pkg <- "graphite"
    require(pkg, character.only=TRUE)
    p <- pathways(organism, 'reactome')[[pathName]]

    if (readable) {
        p <- convertIdentifiers(p, "symbol")
        if (!is.null(foldChange)) {
            org.X.eg.db <- GoSemSim::getDb(organism) # GOSemSim imported through DOSE
            org.X.egSYMBOL <- sub('.db', 'SYMBOL', org.X.eg.db)
            symbol <- loadNamespace(org.X.eg.db)[[org.X.egSYMBOL]]
            map <- as.list(symbol[names(geneList)])
            stopifnot(all(sapply(map, length) == 1))
            map <- unlist(map)
            stopifnot(identical(names(map), names(foldChange)))
            names(foldChange) <- map
        }
    } else {
        if (!is.null(foldChange)) {
            p <- convertIdentifiers(p, "entrez")
        }
    }

    g <- pathwayGraph(p)
    gg <- igraph.from.graphNEL(g)
    gg <- as.undirected(gg)
    gg <- setting.graph.attributes(gg)
    if (!is.null(foldChange)) {
        gg <- scaleNodeColor(gg, foldChange)
    }
    netplot(gg, foldChange=foldChange, ...)
}
