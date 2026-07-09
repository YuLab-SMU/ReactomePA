#' view reactome pathway
#'
#' plotting reactome pathway
#' @title viewPathway
#' @param pathName pathway Name
#' @param organism supported organism
#' @param readable logical
#' @param foldChange fold change
#' @param keyType keyType of gene ID (i.e. names of foldChange, if available)
#' @param layout graph layout
## @importFrom graphite pathways
#' @importFrom graphite convertIdentifiers
#' @importFrom graphite pathwayGraph
#' @importFrom igraph graph_from_graphnel
#' @importFrom igraph as.undirected
#' @importFrom igraph V<-
#' @importFrom enrichit EXTID2NAME
#' @importFrom ggraph ggraph
#' @importFrom ggraph geom_edge_link
#' @importFrom ggraph geom_node_point
#' @importFrom ggraph geom_node_text
#' @importFrom ggplot2 aes
#' @importFrom utils getFromNamespace
#' @importFrom ggplot2 scale_color_continuous
#' @importFrom ggplot2 scale_size
#' @importFrom ggplot2 theme_void
#' @return plot
#' @export
#' @author Yu Guangchuang
viewPathway <- function(pathName,
                        organism="human",
                        readable=TRUE,
                        foldChange=NULL,
                        keyType = "ENTREZID",
                        layout = "kk"){

    if (!organism %in% names(REACTOME_ORG_MAP)) {
        cat(paste(c("the list of supported organisms:", names(REACTOME_ORG_MAP)), collapse = '\n'))
        stop(sprintf("organism %s is not supported", organism))
    }

    pathways <- getFromNamespace("pathways", "graphite")
    p <- pathways(REACTOME_ORG_MAP[[organism]], 'reactome')[[pathName]]

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
    gg <- graph_from_graphnel(g)
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
        geom_node_point(aes(color = as.numeric(as.character(color)), size = size)) +
        scale_color_continuous(low="red", high="blue", name = "fold change", na.value = "#E5C494") +
        geom_node_text(aes(label = name), repel=TRUE) +
        ## scale_color_gradientn(name = "fold change", colors=palette, na.value = "#E5C494") +
        scale_size(guide = "none") + theme_void()
}


#' @importFrom igraph V
#' @importFrom igraph V<-
#' @importFrom igraph E
#' @importFrom igraph E<-
setting.graph.attributes <- function(g, node.size=8,
                                     node.color="#B3B3B3",
                                     edge.width=2,
                                     edge.color="#8DA0CB") {
    V(g)$size <- node.size
    V(g)$color <- node.color
    V(g)$label <- V(g)$name

    E(g)$width <- edge.width
    E(g)$color <- edge.color

    return(g)
}
