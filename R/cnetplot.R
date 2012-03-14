##' @importFrom igraph graph.data.frame
list2graph <- function(inputList) {
	x <- data.frame()
	for (i in 1:length(inputList)) {
		x=rbind(x, data.frame(categoryID=rep(names(inputList[i]), length(inputList[[i]])), Gene=inputList[[i]]))
	}
	g <- graph.data.frame(x, directed=F)
	return(g)
}



##' @importFrom igraph tkplot
##' @importFrom igraph plot.igraph
##' @importFrom igraph V
##' @importFrom igraph "V<-"
##' @importFrom igraph E
##' @importFrom igraph "E<-"
##' @importFrom igraph degree
##' @importFrom igraph layout.fruchterman.reingold
cnetplot <- function(inputList,
                     categorySize="geneNum",
                     showCategory=5,
                     pvalue=NULL,
                     foldChange=NULL,
                     output="fixed") {

	inputList <- inputList[1:showCategory]
	pvalue <- pvalue[1:showCategory]


	## generate graph object
	g=list2graph(inputList)

	## setting some attributes
	V(g)$size <- 8
	V(g)$color <- "#B3B3B3"
	V(g)$label <- V(g)$name

	E(g)$width=2
	E(g)$color <- "#8DA0CB"

	## attributes of Category Node
	lengthOfCategory <- length(inputList)
	V(g)[0:(lengthOfCategory-1)]$size=30  ## setting by default.
	V(g)[0:(lengthOfCategory-1)]$color= "#E5C494"

	if(is.numeric(categorySize)) {
		V(g)[0:(lengthOfCategory-1)]$size=categorySize
	} else {
		if (categorySize == "geneNum") {
			n <- degree(g)[1:lengthOfCategory]
			V(g)[0:(lengthOfCategory-1)]$size <- n/sum(n) * 100
		}
		if (categorySize == "pvalue") {
			if (is.null(pvalue)) {
				stop("pvalue must not be null...")
			}
			pScore<- -log10(pvalue)
			V(g)[0:(lengthOfCategory-1)]$size <- pScore/sum(pScore) * 100
		}
	}
	if (output == "fixed"){
		igraph::plot.igraph(g,
                                    vertex.label.font=2,
                                    vertex.label.color='#666666',
                                    vertex.label.cex=1.5,
                                    vertex.frame.color=V(g)$color,
                                    layout=layout.fruchterman.reingold)
	} else {
		tkplot(g,
                       vertex.label.font=2, 
                       vertex.label.color='#666666',
                       vertex.label.cex=1.5,
                       vertex.frame.color=V(g)$color,
                       layout=layout.fruchterman.reingold)
	}

}
