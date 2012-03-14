##' Pathway Enrichment Analysis of a gene set.
##' Given a vector of genes, this function will return the enriched pathways
##' with FDR control.
##'
##'
##' @param gene a vector of entrez gene id.
##' @param organism Currently, only "human" supported.
##' @param pvalueCutoff Cutoff value of pvalue.
##' @param qvalueCutoff Cutoff value of qvalue.
##' @param readable if readable is TRUE, the gene IDs will mapping to gene
##'   symbols.
##' @return A \code{enrichPathwayResult} instance.
##' @export
##' @importMethodsFrom AnnotationDbi mappedkeys
##' @importMethodsFrom AnnotationDbi mget
##' @importClassesFrom methods data.frame
##' @importFrom methods new
##' @importFrom qvalue qvalue
##' @importFrom plyr dlply
##' @importFrom plyr .
##' @importFrom reactome.db reactomeEXTID2PATHID
##' @importFrom reactome.db reactomePATHID2EXTID
##' @author Guangchuang Yu \url{http://ygc.name}
##' @seealso \code{\link{enrichPathwayResult-class}}
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
enrichPathway <- function(gene, organism="human", pvalueCutoff = 0.05, qvalueCutoff = 0.05, readable=FALSE) {
    ## all external IDs
    extID <- mappedkeys(reactomeEXTID2PATHID)

    ## query external ID to pathway ID
    qExtID2PathID <- mget(gene, reactomeEXTID2PATHID, ifnotfound=NA)

    notNA.idx <- unlist(lapply(qExtID2PathID, function(i) !all(is.na(i))))

    qExtID2PathID <- qExtID2PathID[notNA.idx]
    qPathID <- unlist(qExtID2PathID)

    qExtID2PathID.df <- data.frame(extID=rep(names(qExtID2PathID), times=lapply(qExtID2PathID, length)),
                                   pathID=qPathID)
    qExtID2PathID.df <- unique(qExtID2PathID.df)

    pathID <- NULL ## to satisfy code tools
    qPathID2ExtID <- dlply(qExtID2PathID.df, .(pathID), .fun=function(i) as.character(i$extID))

    qPathID <- unique(qPathID)
    k <- sapply(qPathID2ExtID, length)
    k <- k[qPathID]

    pathID2ExtID <- mget(unique(qPathID), reactomePATHID2EXTID)
    M <- sapply(pathID2ExtID, length)
    M <- M[qPathID]
    N <- rep(length(extID), length(M))
    n <- rep(length(gene), length(M))
    args.df <- data.frame(numWdrawn=k-1, ## White balls drawn
                          numW=M,        ## White balls
                          numB=N-M,      ## Black balls
                          numDrawn=n)    ## balls drawn

    ## calcute pvalues based on hypergeometric model
    pvalues <- apply(args.df, 1, function(n)
                     phyper(n[1], n[2], n[3], n[4], lower.tail=FALSE)
                     )

    ## gene ratio and background ratio
    GeneRatio <- apply(data.frame(a=k, b=n), 1, function(x)
                       paste(x[1], "/", x[2], sep="", collapse="")
                       )
    BgRatio <- apply(data.frame(a=M, b=N), 1, function(x)
                     paste(x[1], "/", x[2], sep="", collapse="")
                     )


    Description <- pathID2Name(qPathID)

    reactomeOver <- data.frame(pathwayID=qPathID,
                               Description=Description,
                               GeneRatio=GeneRatio,
                               BgRatio=BgRatio,
                               pvalue=pvalues)


    qobj = qvalue(reactomeOver$pvalue, lambda=0.05, pi0.method="bootstrap")
    qvalues <- qobj$qvalues

    if(readable) {
        qPathID2ExtID <- lapply(qPathID2ExtID, geneID2Name)
    }
    geneID <- sapply(qPathID2ExtID, function(i) paste(i, collapse="/"))
    geneID <- geneID[qPathID]
    reactomeOver <- data.frame(reactomeOver,
                               qvalue=qvalues,
                               geneID=geneID,
                               Count=k)

    reactomeOver <- reactomeOver[order(pvalues),]

    reactomeOver <- reactomeOver[ reactomeOver$pvalue <= pvalueCutoff, ]
    reactomeOver <- reactomeOver[ reactomeOver$qvalue <= qvalueCutoff, ]

    reactomeOver$Description <- as.character(reactomeOver$Description)



    new("enrichPathwayResult",
        enrichPathwayResult = reactomeOver,
        pvalueCutoff=pvalueCutoff,
        Organism = organism,
        Gene = gene,
        geneInCategory = qPathID2ExtID
	)
}

##' Class "enrichPathwayResult"
##'
##' This class represents the result of Pathway enrichment analysis.
##'
##' @name enrichPathwayResult-class
##' @aliases enrichPathwayResult-class show,enrichPathwayResult-method
##'   summary,enrichPathwayResult-method plot,enrichPathwayResult-method
##' @docType class
##' @slot enrichPathwayResult Pathway enrichment result
##' @slot pvalueCutoff pvalueCutoff
##' @slot qvalueCutoff qvalueCutoff
##' @slot Organism one of "humna", "mouse", and "yeast"
##' @slot Gene Gene IDs
##' @slot geneInCategory gene list with pathway annotation
##' @exportClass enrichPathwayResult
##' @usage \S4method{show}{enrichPathwayResult}(object)
##' @usage \S4method{summary}{enrichPathwayResult}(object)
##' @usage \S4method{plot}{enrichPathwayResult}(object)
##' @section Methods
##'
##' In the code snippets below, \code{x} is a \code{enrichPathwayResult} object.
##'
##' \describe{
##' \item{show}{\code{show(x)} show analysis summary.}
##' \item{summary}{\code{summary(x)} return enrichment result in a data frame.}
##' \item{plot}{\code{plot(x)} visualize enrichment result.}
##' }
##'
##' See \code{?\link{show}}, \code{?\link{summary}}, and \code{?\link{plot}} for details of operations on enrichPathwayResult objects.
##'
##' @author Guangchuang Yu \url{http://ygc.name}
##' @seealso \code{\link{enrichPathway}}
##' @keywords classes
setClass("enrichPathwayResult",
         representation=representation(
         enrichPathwayResult="data.frame",
         pvalueCutoff="numeric",
         qvalueCutoff="numeric",
         Organism = "character",
         Gene = "character",
         geneInCategory = "list"
         )
         )

##' show method for \code{enrichPathwayResult} instance
##'
##'
##' @name show
##' @docType methods
##' @rdname show-methods
##'
##' @title show method
##' @param object A \code{enrichPathwayResult} instance.
##' @return message
##' @importFrom methods show
##' @author Guangchuang Yu \url{http://ygc.name}
setMethod("show", signature(object="enrichPathwayResult"),
          function (object){
              Organism = object@Organism
              GeneNum = length(object@Gene)
              pvalueCutoff=object@pvalueCutoff
              cat (GeneNum, Organism,
                   "Genes to Pathway test for over-representation.", "\n",
                   "p value <", pvalueCutoff, "\n")
          }
          )

##' summary method for \code{enrichPathwayResult} instance
##'
##'
##' @name summary
##' @docType methods
##' @rdname summary-methods
##'
##' @title summary method
##' @param object A \code{enrichPathwayResult} instance.
##' @return A data frame
##' @importFrom stats4 summary
##' @exportMethod summary
##' @author Guangchuang Yu \url{http://ygc.name}
setMethod("summary", signature(object="enrichPathwayResult"),
          function(object) {
              return(object@enrichPathwayResult)
          }
          )

##' plot method for \code{enrichPathwayResult} instance
##'
##'
##' @name plot
##' @docType methods
##' @rdname plot-methods
##' @aliases plot,enrichPathwayResult,ANY-method
##'
##' @title plot method
##' @param x A \code{enrichPathwayResult} instance.
##' @param ... Additional argument list
##' @return plot
##' @importFrom stats4 plot
##' @export
##' @author Guangchuang Yu \url{http://ygc.name}
setMethod("plot", signature(x="enrichPathwayResult"),
          function(x, showCategory=5,
                   categorySize="geneNum",
                   output="interactive") {
              ##enrichResult <- x@enrichPathwayResult
			  enrichResult <- summary(x)
			  gc <- x@geneInCategory
              y <- enrichResult[enrichResult$pathwayID %in% names(gc),
                                c("pathwayID", "Description", "pvalue")]

              gc <- gc[y$pathwayID]
              names(gc) <- y$Description

              if (categorySize == "pvalue") {
                  pvalue <- y$pvalue
                  cnetplot(inputList=gc,
                           showCategory=showCategory,
                           categorySize=categorySize,
                           pvalue=pvalue,
                           output=output)
              } else {
                  cnetplot(inputList=gc,
                           showCategory=showCategory,
                           categorySize=categorySize,
                           output=output)
              }
          }
          )



