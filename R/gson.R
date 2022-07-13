##' download the latest version of Reactome and stored in a 'GSON' object
##'
##'
##' @title gson_Reactome
##' @param organism one of "human", "rat", "mouse", "celegans", "yeast", "zebrafish", "fly".
##' @return a 'GSON' object
##' @importFrom gson gson
##' @importFrom utils stack
##' @export
gson_Reactome <- function(organism = "human") {

    Reactome_DATA <- get_Reactome_DATA(organism)
    EXTID2PATHID = get("EXTID2PATHID", envir=Reactome_DATA)
    PATHID2EXTID = get("PATHID2EXTID", envir = Reactome_DATA)
    PATHID2NAME = get("PATHID2NAME", envir = Reactome_DATA)


###############
    reactomeAnno <- stack(PATHID2EXTID)   
    gsid2gene <- reactomeAnno[, c(2,1)]
    colnames(gsid2gene) <- c("gsid", "gene")
    gsid2gene <- unique(gsid2gene[!is.na(gsid2gene[,2]), ]) 

    termname <- PATHID2NAME
    gsid2name <- data.frame(gsid = names(termname),
                            name = termname)
    species <- organism

    gson(gsid2gene = gsid2gene, 
        gsid2name = gsid2name,
        species = species,
        gsname = "reactome pathway",
        # version = version,
        accessed_date = as.character(Sys.Date())
        # keytype = keytype
    )
}