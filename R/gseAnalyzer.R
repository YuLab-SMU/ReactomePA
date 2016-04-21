##' Gene Set Enrichment Analysis of Reactome Pathway
##'
##'
##' @title gsePathway
##' @param geneList order ranked geneList
##' @param organism organism
##' @param exponent weight of each step
##' @param nPerm permutation numbers
##' @param minGSSize minimal size of each geneSet for analyzing
##' @param maxGSSize maximal size of each geneSet for analyzing
##' @param pvalueCutoff pvalue Cutoff
##' @param pAdjustMethod pvalue adjustment method
##' @param verbose print message or not
##' @param seed logical
##' @importClassesFrom DOSE gseaResult
##' @importMethodsFrom DOSE show
##' @importMethodsFrom DOSE summary
##' @importMethodsFrom DOSE plot
##' @importFrom DOSE GSEA_internal
##' @export
##' @return gseaResult object
##' @author Yu Guangchuang
gsePathway <- function(geneList,
                       organism      = "human",
                       exponent      = 1,
                       nPerm         = 1000,
                       minGSSize     = 10,
                       maxGSSize     = 500,
                       pvalueCutoff  = 0.05,
                       pAdjustMethod = "BH",
                       verbose       = TRUE,
                       seed          = FALSE) {

    Reactome_DATA <- get_Reactome_DATA(organism)
    
    res <- GSEA_internal(geneList      = geneList,
                         exponent      = exponent,
                         nPerm         = nPerm,
                         minGSSize     = minGSSize,
                         maxGSSize     = maxGSSize,
                         pvalueCutoff  = pvalueCutoff,
                         pAdjustMethod = pAdjustMethod,
                         verbose       = verbose,
                         USER_DATA     = Reactome_DATA,
                         seed          = seed)

    if (is.null(res))
        return(res)
    
    res@organism <- organism
    res@setType <- "Reactome"
    res@keytype <- "ENTREZID"
    
    return(res)
}


get_Reactome_Env <- function() {
    if (!exists(".ReactomePA_Env", envir = .GlobalEnv)) {
        assign(".ReactomePA_Env", new.env(), .GlobalEnv)
    }    
    get(".ReactomePA_Env", envir= .GlobalEnv)
}

##' @importMethodsFrom AnnotationDbi as.list
##' @importFrom reactome.db reactomeEXTID2PATHID
##' @importFrom reactome.db reactomePATHID2EXTID
##' @importFrom reactome.db reactomePATHID2NAME
get_Reactome_DATA <- function(organism = "human") {
    ReactomePA_Env <- get_Reactome_Env()
    
    if (exists("organism", envir=ReactomePA_Env, inherits = FALSE)) {
        org <- get("organism", envir=ReactomePA_Env)
        if (org == organism &&
            exists("PATHID2EXTID", envir = ReactomePA_Env) &&
            exists("EXTID2PATHID", envir = ReactomePA_Env) &&
            exists("PATHID2NAME",  envir = ReactomePA_Env)) {
            
            ## use_cached
            return(ReactomePA_Env)
        }
    }

    ALLEG <- getALLEG(organism)
    
    EXTID2PATHID <- as.list(reactomeEXTID2PATHID)
    EXTID2PATHID <- EXTID2PATHID[names(EXTID2PATHID) %in% ALLEG]
    
    PATHID2EXTID <- as.list(reactomePATHID2EXTID) ## also contains reactions
    
    PATHID2NAME <- as.list(reactomePATHID2NAME)
    PI <- names(PATHID2NAME)
    ## > PATHID2NAME[['68877']]
    ## [1] "Homo sapiens: Mitotic Prometaphase" "Homo sapiens: Mitotic Prometaphase"
    PATHID2NAME <- lapply(PATHID2NAME, function(x) x[1])
    names(PATHID2NAME) <- PI
    
    PATHID2EXTID <- PATHID2EXTID[names(PATHID2EXTID) %in% names(PATHID2NAME)]
    PATHID2EXTID <- PATHID2EXTID[names(PATHID2EXTID) %in% unique(unlist(EXTID2PATHID))]
    PATHID2EXTID <- lapply(PATHID2EXTID, function(x) intersect(x, ALLEG))
    
    PATHID2NAME <- PATHID2NAME[names(PATHID2NAME) %in% names(PATHID2EXTID)]

    PATHID2NAME <- unlist(PATHID2NAME)
    PATHID2NAME <- gsub("^\\w+\\s\\w+:\\s+", "", PATHID2NAME) # remove leading spaces
    
    assign("PATHID2EXTID", PATHID2EXTID, envir=ReactomePA_Env)
    assign("EXTID2PATHID", EXTID2PATHID, envir=ReactomePA_Env)
    assign("PATHID2NAME", PATHID2NAME, envir=ReactomePA_Env)
    return(ReactomePA_Env)
}


##' get all entrezgene ID of a specific organism
##'
##'
##' @title getALLEG
##' @param organism species
##' @return entrez gene ID vector
##' @importFrom GOSemSim getDb
##' @importMethodsFrom AnnotationDbi keys
##' @author Yu Guangchuang
getALLEG <- function(organism) {
    annoDb <- getDb(organism)
    require(annoDb, character.only = TRUE)
    annoDb <- eval(parse(text=annoDb))
    eg=keys(annoDb, keytype="ENTREZID")
    return(eg)
}

