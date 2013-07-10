##' view reactome pathway
##'
##' plotting reactome pathway
##' @title viewPathway
##' @param pathName pathway Name
##' @param organism supported organism
##' @param readable logical
##' @param foldChange fold change
##' @param ... additional parameter
##' @importFrom graphite convertIdentifiers
##' @importFrom graphite pathwayGraph
##' @importFrom igraph igraph.from.graphNEL
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

    pkg <- "graphite"
    require(pkg, character.only=TRUE)
    reactome <- eval(parse(text="reactome"))
    p <- reactome[[pathName]]
    if (organism != "human") {
        stop("the specific organism is not supported yet...")
        ## p@species
    }
    if (readable) {
        p <- convertIdentifiers(p, "symbol")
        if (!is.null(foldChange)){
            gn <- EXTID2NAME(names(foldChange),organism)
            names(foldChange) <- gn
        }
    } else {
        if (!is.null(foldChange)) {
            p <- convertIdentifiers(p, "entrez")
        }
    }

    g <- pathwayGraph(p)
    gg <- igraph.from.graphNEL(g)
    gg <- setting.graph.attributes(gg)
    if (!is.null(foldChange)) {
        gg <- scaleNodeColor(gg, foldChange)
    }
    netplot(gg, foldChange=foldChange, ...)
}
