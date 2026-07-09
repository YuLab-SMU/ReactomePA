#' Prepare Reactome reaction network for NSEA
#'
#' Builds a gene-gene interaction network from all Reactome reaction steps
#' for a given species. Two genes are connected if they co-participate in
#' the same reaction step. The network is returned as a column-normalized
#' sparse matrix (dgCMatrix) suitable for Random Walk with Restart.
#'
#' The network is cached via `yulab.utils::with_cache()` so
#' repeated calls are fast.
#'
#' @param organism Supported organism: "human", "mouse", "rat", "yeast",
#'   "zebrafish", "fly", "celegans", etc. See `graphite::pathways()` for
#'   the full list.
#' @param directed Logical. If FALSE (default), edges are treated as
#'   undirected (reciprocal edges added).
#' @return A sparse matrix (dgCMatrix) of the Reactome reaction graph.
#' @importFrom Matrix sparseMatrix
#' @importFrom igraph graph_from_graphnel
#' @importFrom igraph as_edgelist
#' @importFrom graphite convertIdentifiers
#' @importFrom utils getFromNamespace
#' @importFrom enrichit prepare_network
#' @export
#' @examples
#' \dontrun{
#'   net <- prepareReactomeNetwork("human")
#' }
prepareReactomeNetwork <- function(organism = "human", directed = FALSE) {
    cache_key <- paste0(organism, "_", directed)
    
    yulab.utils::with_cache("ReactomePA_network", cache_key, function() {
    
    if (!organism %in% names(REACTOME_ORG_MAP)) {
        stop(
            "Organism '", organism, "' is not supported. ",
            "Supported organisms: ",
            paste(names(REACTOME_ORG_MAP), collapse = ", ")
        )
    }
    
    graphite_org <- REACTOME_ORG_MAP[[organism]]
    pathways <- getFromNamespace("pathways", "graphite")
    all_pathways <- pathways(graphite_org, "reactome")
    
    if (length(all_pathways) == 0) {
        stop("No Reactome pathways found for organism '", organism, "'.")
    }
    
    edges <- list()
    edge_idx <- 0
    
    for (path_name in names(all_pathways)) {
        p <- all_pathways[[path_name]]
        p <- tryCatch(
            graphite::convertIdentifiers(p, "entrez"),
            error = function(e) NULL
        )
        if (is.null(p)) next

        g <- tryCatch(
            graphite::pathwayGraph(p),
            error = function(e) NULL
        )
        if (is.null(g)) next
        
        gg <- tryCatch(
            graph_from_graphnel(g),
            error = function(e) NULL
        )
        if (is.null(gg)) next
        
        # Extract edges: each edge represents a reaction between two gene products
        edge_list <- igraph::as_edgelist(gg, names = TRUE)
        if (nrow(edge_list) == 0) next
        
        # Remove species prefix from node names
        edge_list[, 1] <- sub("^[^:]+:", "", edge_list[, 1])
        edge_list[, 2] <- sub("^[^:]+:", "", edge_list[, 2])
        
        edge_idx <- edge_idx + 1
        edges[[edge_idx]] <- edge_list
    }
    
    if (length(edges) == 0) {
        stop("No reaction edges could be extracted from Reactome pathways for '", organism, "'.")
    }
    
    edge_df <- as.data.frame(do.call(rbind, edges), stringsAsFactors = FALSE)
    colnames(edge_df) <- c("from", "to")
    edge_df <- unique(edge_df)
    
    # Build sparse matrix via prepare_network
    enrichit::prepare_network(edge_df, directed = directed)
    })  # end with_cache function
}

#' Network-based Reactome pathway enrichment analysis
#'
#' `nsePathway()` performs network-based set enrichment analysis (NSEA)
#' on Reactome pathways. Instead of using raw gene-level scores directly,
#' scores are propagated across the Reactome reaction graph via Random
#' Walk with Restart (RWR), then GSEA is run on the diffused scores.
#' This captures pathway-level signals that may be diluted in individual
#' gene-level statistics.
#'
#' The Reactome reaction network is automatically built and cached on
#' first call. Users can pre-build and pass a custom network via the
#' `network` parameter.
#'
#' @param geneList A named numeric vector of gene-level scores (e.g. log2FC).
#'   Names must be Entrez Gene IDs.
#' @param organism Supported organism. Default is "human".
#' @param mode Character, either "evidence" (default) or "signed".
#'   In "evidence" mode, all seeds are propagated once.
#'   In "signed" mode, positive and negative seeds are propagated
#'   separately and the difference is taken.
#' @param network Optional pre-built network from `prepareReactomeNetwork()`.
#'   If NULL, the network is auto-built and cached.
#' @param restart_prob Restart probability for RWR (default: 0.5).
#' @param specific_weight Logical, whether to apply gene specificity
#'   weighting (TF-IDF style). Default is FALSE.
#' @param minGSSize Minimal size of each gene set for analyzing (default: 10).
#' @param maxGSSize Maximal size of each gene set for analyzing (default: 500).
#' @param threshold Convergence threshold for RWR (default: 1e-9).
#' @param maxIter Maximal number of RWR iterations (default: 100).
#' @param verbose Print progress messages (default: TRUE).
#' @param ... Other arguments passed to `enrichit::gsea_gson()`.
#'
#' @return A `nseaResult` object (inherits from `gseaResult`).
#' @importClassesFrom enrichit nseaResult
#' @importClassesFrom enrichit gseaResult
#' @importFrom enrichit nsea_gson
#' @export
#' @seealso [prepareReactomeNetwork()], [enrichit::nsea()]
#' @examples
#' \dontrun{
#'   data(geneList, package = "DOSE")
#'   nsea_res <- nsePathway(geneList)
#'   head(nsea_res)
#' }
nsePathway <- function(geneList,
                       organism       = "human",
                       mode           = c("evidence", "signed"),
                       network        = NULL,
                       restart_prob   = 0.5,
                       specific_weight = FALSE,
                       minGSSize      = 10,
                       maxGSSize      = 500,
                       threshold      = 1e-9,
                       maxIter        = 100,
                       verbose        = TRUE,
                       ...) {
    
    mode <- match.arg(mode)
    
    if (!is.numeric(geneList) || is.null(names(geneList))) {
        stop("geneList must be a named numeric vector")
    }
    
    # Build or retrieve network
    if (is.null(network)) {
        if (verbose) message("Building Reactome reaction network for ", organism, "...")
        network <- prepareReactomeNetwork(organism)
    }
    
    # Get GSON for gene sets
    gson <- gson_Reactome(organism)
    
    # Run NSEA via enrichit
    enrichit::nsea_gson(
        geneList        = geneList,
        network         = network,
        gson            = gson,
        mode            = mode,
        p               = restart_prob,
        specific_weight = specific_weight,
        minGSSize       = minGSSize,
        maxGSSize       = maxGSSize,
        threshold       = threshold,
        maxIter         = maxIter,
        verbose         = verbose,
        ...
    )
}
