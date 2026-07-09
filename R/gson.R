#' download the latest version of Reactome and stored in a 'GSON' object
#'
#'
#' @title gson_Reactome
#' @param organism one of "human", "rat", "mouse", "celegans", "yeast", "zebrafish", "fly".
#' @return a 'GSON' object
#' @importFrom gson gson
#' @importFrom utils stack
#' @importFrom yulab.utils with_cache
#' @importMethodsFrom AnnotationDbi as.list
#' @importMethodsFrom AnnotationDbi keys
#' @importFrom reactome.db reactomeEXTID2PATHID
#' @importFrom reactome.db reactomePATHID2EXTID
#' @importFrom reactome.db reactomePATHID2NAME
#' @export
#' @examples
#' \dontrun{
#' rec_gson <- gson_Reactome("human")
#' }
#'
gson_Reactome <- function(organism = "human") {
    yulab.utils::with_cache("ReactomePA", organism, function() {
        # Get all Entrez IDs for the species
        annoDb <- getDb(organism)
        require(annoDb, character.only = TRUE)
        annoDb <- eval(parse(text = annoDb))
        ALLEG <- keys(annoDb, keytype = "ENTREZID")

        # Load and filter annotation data
        EXTID2PATHID <- as.list(reactomeEXTID2PATHID)
        EXTID2PATHID <- EXTID2PATHID[names(EXTID2PATHID) %in% ALLEG]

        PATHID2EXTID <- as.list(reactomePATHID2EXTID)
        PATHID2NAME  <- as.list(reactomePATHID2NAME)

        # Deduplicate pathway names
        PI <- names(PATHID2NAME)
        PATHID2NAME <- lapply(PATHID2NAME, function(x) x[1])
        names(PATHID2NAME) <- PI

        # Align: only pathways with both name and gene annotation
        PATHID2EXTID <- PATHID2EXTID[names(PATHID2EXTID) %in% names(PATHID2NAME)]
        PATHID2EXTID <- PATHID2EXTID[names(PATHID2EXTID) %in% unique(unlist(EXTID2PATHID))]
        PATHID2EXTID <- lapply(PATHID2EXTID, function(x) intersect(x, ALLEG))

        PATHID2NAME <- PATHID2NAME[names(PATHID2NAME) %in% names(PATHID2EXTID)]
        PATHID2NAME <- unlist(PATHID2NAME)
        PATHID2NAME <- gsub("^\\w+\\s\\w+:\\s+", "", PATHID2NAME)

        # Build GSON gene-set annotation
        reactomeAnno <- stack(PATHID2EXTID)
        gsid2gene <- reactomeAnno[, c(2, 1)]
        colnames(gsid2gene) <- c("gsid", "gene")
        gsid2gene <- unique(gsid2gene[!is.na(gsid2gene[, 2]), ])

        gsid2name <- data.frame(
            gsid = names(PATHID2NAME),
            name = PATHID2NAME
        )

        # Metadata
        m <- AnnotationDbi::metadata(reactome.db::reactome.db)
        version <- paste(
            "Version: ",
            m$value[m$name == "DBSCHEMAVERSION"],
            "; Source date: ",
            m$value[m$name == "SOURCEDATE"],
            sep = ""
        )
        info <- paste("Source url: ", m$value[m$name == "SOURCEURL"], sep = "")

        gson(
            gsid2gene = gsid2gene,
            gsid2name = gsid2name,
            gene2name = NULL,
            schema_version = "1.0",
            species = organism,
            gsname = "reactome pathway",
            version = version,
            accessed_date = as.character(Sys.Date()),
            keytype = "ENTREZID",
            urlpattern = NULL,
            info = info
        )
    })
}
