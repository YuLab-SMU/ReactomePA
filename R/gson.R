##' download the latest version of Reactome and stored in a 'GSON' object
##'
##'
##' @title gson_Reactome
##' @param organism one of "human", "rat", "mouse", "celegans", "yeast", "zebrafish", "fly".
##' @return a 'GSON' object
##' @importFrom gson gson
##' @importFrom utils stack
##' @export
##' @examples
##' \dontrun{
##' rec_gson <- gson_Reactome("human")
##' }
##'
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
    m <- AnnotationDbi::metadata(reactome.db::reactome.db)
    version <- paste("Version: ", 
                     m$value[m$name == "DBSCHEMAVERSION"], 
                     "; Source date: ", 
                     m$value[m$name == "SOURCEDATE"], 
                     sep = "")
    info = paste("Source url: ", m$value[m$name == "SOURCEURL"], sep = "")
    gson(gsid2gene = gsid2gene, 
        gsid2name = gsid2name,
        species = species,
        gsname = "reactome pathway",
        version = version,
        accessed_date = as.character(Sys.Date()),
        keytype = "ENTREZID",
        info = info
    )
}