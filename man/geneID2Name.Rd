\name{geneID2Name}
\alias{geneID2Name}
\title{convert gene IDs to gene Names}
\usage{
  geneID2Name(geneID, annoDb = "org.Hs.eg.db")
}
\arguments{
  \item{geneID}{a vector of gene IDs}

  \item{annoDb}{Name of the annotationDb object (same as the package name for the annotation).  If the org package has gene symbols available, then this method should work.  }
}
\value{
  a vector of gene names.
}
\description{
  convert gene IDs to gene Names.
}
\examples{
gene <- as.character(1:10)
	geneID2Name(gene, annoDb="org.Hs.eg.db")
}
\author{
  Guangchuang Yu \url{http://ygc.name}
}

