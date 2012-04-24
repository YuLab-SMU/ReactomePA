\name{enrichPathway}
\alias{enrichPathway}
\title{Pathway Enrichment Analysis of a gene set.
Given a vector of genes, this function will return the enriched pathways
with FDR control.}
\usage{
  enrichPathway(gene, pvalueCutoff = 0.05,
    qvalueCutoff = 0.05, readable = FALSE)
}
\arguments{
  \item{gene}{a vector of entrez gene id.}

  \item{pvalueCutoff}{Cutoff value of pvalue.}

  \item{qvalueCutoff}{Cutoff value of qvalue.}

  \item{readable}{if readable is TRUE, the gene IDs will
  mapping to gene symbols.}
}
\value{
  A \code{enrichResult} instance.
}
\description{
  Pathway Enrichment Analysis of a gene set. Given a vector
  of genes, this function will return the enriched pathways
  with FDR control.
}
\examples{
gene <- c("11171", "8243", "112464", "2194",
				"9318", "79026", "1654", "65003",
				"6240", "3476", "6238", "3836",
				"4176", "1017", "249")
	yy = enrichPathway(gene, pvalueCutoff=0.05)
	head(summary(yy))
	#plot(yy)
}
\author{
  Guangchuang Yu \url{http://ygc.name}
}
\seealso{
  \code{\link{enrichResult-class}}
}
\keyword{manip}

