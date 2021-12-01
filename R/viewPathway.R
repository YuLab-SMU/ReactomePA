##' view reactome pathway
##'
##' plotting reactome pathway
##' @title viewPathway
##' @param pathName pathway Name
##' @param organism supported organism
##' @param readable logical
##' @param foldChange fold change
##' @param keyType keyType of gene ID (i.e. names of foldChange, if available)
##' @param layout graph layout
## @importFrom graphite pathways
##' @importFrom graphite convertIdentifiers
##' @importFrom graphite pathwayGraph
##' @importFrom igraph igraph.from.graphNEL
##' @importFrom igraph as.undirected
##' @importFrom igraph "V<-"
##' @importFrom DOSE EXTID2NAME
##' @importFrom ggraph ggraph
##' @importFrom ggraph geom_edge_link
##' @importFrom ggraph geom_node_point
##' @importFrom ggraph geom_node_text
##' @importFrom ggplot2 aes_
##' @importFrom ggplot2 scale_color_continuous
##' @importFrom ggplot2 scale_size
##' @importFrom ggplot2 theme_void
##' @return plot
##' @export
##' @author Yu Guangchuang
viewPathway <- function(pathName,
                        organism="human",
                        readable=TRUE,
                        foldChange=NULL,
                        keyType = "ENTREZID",
                        layout = "kk"){

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
            names(foldChange) <- EXTID2NAME(OrgDb, names(foldChange), keyType)

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
    V(gg)$name <- sub("[^:]+:", "", V(gg)$name)

    if (!is.null(foldChange)) {
        ## gg <- scaleNodeColor(gg, foldChange)
        fc <- foldChange[V(gg)$name]
        V(gg)$color <- fc
        ## palette <- enrichplot:::fc_palette(fc)

    }
    ## netplot(gg, foldChange=foldChange, ...)
    ggraph(gg, layout=layout) +
        geom_edge_link(alpha=.8, colour='darkgrey') +
        geom_node_point(aes_(color=~as.numeric(as.character(color)), size=~size)) +
        scale_color_continuous(low="red", high="blue", name = "fold change", na.value = "#E5C494") +
        geom_node_text(aes_(label=~name), repel=TRUE) +
        ## scale_color_gradientn(name = "fold change", colors=palette, na.value = "#E5C494") +
        scale_size(guide = "none") + theme_void()
}


##' @importFrom igraph V
##' @importFrom igraph V<-
##' @importFrom igraph E
##' @importFrom igraph E<-
setting.graph.attributes <- function(g, node.size=8,
                                     node.color="#B3B3B3",
                                     edege.width=2,
                                     edege.color="#8DA0CB") {
    V(g)$size <- node.size
    V(g)$color <- node.color
    V(g)$label <- V(g)$name

    E(g)$width <- edege.width
    E(g)$color <- edege.color

    return(g)
}
