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
    
    # convertion to the names that graphite::pathways understands
    org2org <- list(arabidopsis="athaliana",
                        bovine="btaurus",
                        canine="cfamiliaris",
                        chicken="ggallus",
                        ecolik12="ecoli",
                        fly="dmelanogaster",
                        human="hsapiens",
                        mouse="mmusculus",
                        pig="sscrofa",
                        rat="rnorvegicus",
                        celegans="celegans",
                        xenopus="xlaevis",
                        yeast="scerevisiae",
                    zebrafish="drerio")
    
    if(!(organism %in% names(org2org))){
        cat(paste(c("the list of supported organisms:",names(org2org)), collapse='\n'))
        stop(sprintf("organism %s is not supported", organism))
    }
    pathways <- eval(parse(text="pathways"))
    p <- pathways(org2org[[organism]], 'reactome')[[pathName]]

    if (readable) {
        p <- convertIdentifiers(p, "symbol")
        if (!is.null(foldChange)) {
            stopifnot(!any(duplicated(names(foldChange)))) # can't have two value for one gene
            OrgDb <- getDb(organism)
            names(foldChange) <- EXTID2NAME(OrgDb, names(foldChange), "ENTREZID")

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
