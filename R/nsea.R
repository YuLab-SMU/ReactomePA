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
#' @param cores Number of CPU cores used to convert Reactome pathways to
#'   reaction edges in parallel. Defaults to `getOption("mc.cores")`, or
#'   `1` (serial) if the option is unset: the conversion is fast enough
#'   (~40 s for human) that parallelizing is optional, and serial leaves
#'   the rest of the machine untouched. The per-pathway conversions are
#'   independent and pure in-memory vectorized operations (the species
#'   identifier map is loaded once up front), so wall time scales close
#'   to linearly with `cores`. On Windows, `mclapply()` falls back to
#'   serial execution regardless.
#' @return A sparse matrix (dgCMatrix) of the Reactome reaction graph.
#' @importFrom Matrix sparseMatrix
#' @importFrom AnnotationDbi columns
#' @importFrom AnnotationDbi mapIds
#' @importFrom utils getFromNamespace
#' @importFrom enrichit prepare_network
#' @export
#' @examples
#' \dontrun{
#'   net <- prepareReactomeNetwork("human")
#' }
prepareReactomeNetwork <- function(organism = "human",
                                   directed = FALSE,
                                   cores = getOption("mc.cores", 1L)) {
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
    
    # ---- one-time species identifier map (built serially, before forking) ----
    # Reactome protein edges carry UNIPROT identifiers. graphite converts
    # them to Entrez via the species OrgDb, keeping any identifier type the
    # OrgDb does not support (e.g. CHEBI) verbatim. We replicate that
    # behaviour with a single vectorized lookup instead of a per-pathway
    # mapIds() round-trip (each such call carries ~0.2 s of fixed overhead
    # and is the reason the old serial build took ~40 min and did not scale
    # past ~4 cores). The map is plain read-only vectors shared across the
    # forked workers via copy-on-write.
    map <- .reactome_uniprot_map(organism)
    
    # Convert each pathway to an edge list. The per-pathway conversions are
    # independent and pure in-memory vectorized operations, so the loop is
    # parallelized with mclapply (falls back to serial execution on
    # Windows). NULL marks pathways with no protein edges (same as the
    # serial version's `next`); empty edge lists are dropped as well.
    convert_pathway <- function(p) {
        es <- rbind(p@protEdges, p@protPropEdges)
        if (nrow(es) == 0) return(NULL)
        es[] <- lapply(es, as.character)
        
        # UNIPROT -> Entrez with 1:many expansion (graphite semantics);
        # unsupported identifier types (CHEBI, ...) are kept verbatim
        if (!is.null(map)) {
            es <- .reactome_convert_column(es, "src", "src_type", map)
            if (nrow(es) == 0) return(NULL)
            es <- .reactome_convert_column(es, "dest", "dest_type", map)
        }
        if (nrow(es) == 0) return(NULL)
        
        # Reciprocal edges for undirected reaction steps
        mask <- es$direction == "undirected" &
            (es$src_type != es$dest_type | es$src != es$dest)
        dird <- es[!mask, , drop = FALSE]
        undir <- es[mask, , drop = FALSE]
        revdir <- undir
        revdir$src_type <- undir$dest_type
        revdir$src <- undir$dest
        revdir$dest_type <- undir$src_type
        revdir$dest <- undir$src
        all <- rbind(dird, undir, revdir)
        if (nrow(all) == 0) return(NULL)
        
        # Unique edge set
        all <- all[!duplicated(paste(all$src, all$dest, sep = "|")), , drop = FALSE]
        cbind(all$src, all$dest)
    }
    
    # Parallelize over the (independent) per-pathway conversions. The
    # conversion is now a few milliseconds per pathway, so `cores` scales
    # much better than the old graphite-based conversion (which was
    # hash-lookup/SQLite-bound and saturated at ~4-5 effective cores).
    # Fork before the workers start allocating, so the shared read-only
    # state (pathway list, identifier map) is clean and copy-on-write
    # churn is minimized.
    gc()
    edges <- parallel::mclapply(all_pathways, convert_pathway, mc.cores = cores)
    edges <- edges[!vapply(edges, is.null, logical(1))]
    
    if (length(edges) == 0) {
        stop("No reaction edges could be extracted from Reactome pathways for '", organism, "'.")
    }
    
    # Flatten the per-pathway edge lists and remove cross-pathway
    # duplicates. Encoding the (from, to) pairs as integer keys and
    # deduplicating on those is several times faster than
    # unique(data.frame(...)) on the ~3.5M edge rows.
    from <- unlist(lapply(edges, function(e) e[, 1]), use.names = FALSE)
    to   <- unlist(lapply(edges, function(e) e[, 2]), use.names = FALSE)
    if (length(from) == 0) {
        stop("No reaction edges could be extracted from Reactome pathways for '", organism, "'.")
    }
    i <- match(from, unique(from))
    j <- match(to, unique(to))
    keep <- !duplicated(as.double(i) * 20000 + j)
    edge_df <- data.frame(
        from = from[keep],
        to   = to[keep],
        stringsAsFactors = FALSE
    )
    
    # Build sparse matrix via prepare_network
    enrichit::prepare_network(edge_df, directed = directed)
    })  # end with_cache function
}

#' Build a UNIPROT -> Entrez lookup map for a species
#'
#' Loads the species OrgDb (as graphite would) and returns the UNIPROT ->
#' Entrez identifier map as plain vectors for fast `match()`-based lookup.
#' Returns `NULL` when the OrgDb does not support UNIPROT identifiers (in
#' that case protein identifiers are kept verbatim, exactly like graphite).
#'
#' @param organism ReactomePA organism name (see [REACTOME_ORG_MAP]).
#' @return A list with components `names`, `starts`, `ends` and `vals`, or
#'   `NULL` when the species OrgDb has no UNIPROT column.
#' @noRd
.reactome_uniprot_map <- function(organism) {
    anno_pkg <- getDb(organism)
    if (!requireNamespace(anno_pkg, quietly = TRUE)) {
        stop("The annotation package '", anno_pkg, "' is required for organism '",
             organism, "'. Please install it with BiocManager::install().")
    }
    orgdb <- get(anno_pkg, envir = asNamespace(anno_pkg))
    if (!"UNIPROT" %in% AnnotationDbi::columns(orgdb)) {
        return(NULL)
    }
    up2eg <- AnnotationDbi::mapIds(
        orgdb,
        AnnotationDbi::keys(orgdb, keytype = "UNIPROT"),
        "ENTREZID", "UNIPROT",
        multiVals = "list"
    )
    map_keys <- rep(names(up2eg), lengths(up2eg))
    map_vals <- unlist(up2eg, use.names = FALSE)
    first <- !duplicated(map_keys)
    starts <- which(first)
    list(
        names  = map_keys[first],
        starts = starts,
        ends   = c(starts[-1] - 1L, length(map_keys)),
        vals   = map_vals
    )
}

#' Convert one identifier column of a pathway edge table
#'
#' Expands UNIPROT identifiers to all their Entrez ids (1:many) like
#' graphite::convertIdentifiers does; rows whose identifier type is not
#' UNIPROT, or whose UNIPROT has no Entrez mapping, are handled exactly
#' like graphite (kept verbatim / dropped).
#'
#' @param es Edge data.frame (protEdges + protPropEdges).
#' @param col Column name to convert.
#' @param type_col Column holding the identifier type.
#' @param map Lookup map from `.reactome_uniprot_map()`.
#' @return The converted edge data.frame.
#' @noRd
.reactome_convert_column <- function(es, col, type_col, map) {
    is_prot <- es[[type_col]] == "UNIPROT"
    if (!any(is_prot)) return(es)
    pos <- match(es[[col]][is_prot], map$names)
    has <- !is.na(pos)
    if (!any(has)) return(es[!is_prot, , drop = FALSE])
    st <- map$starts[pos[has]]
    en <- map$ends[pos[has]]
    len <- en - st + 1L
    rows <- rep(which(is_prot)[has], len)
    converted <- es[rows, , drop = FALSE]
    converted[[col]] <- map$vals[sequence(len, from = st)]
    rbind(converted, es[!is_prot, , drop = FALSE])
}

#' Network-based Reactome pathway enrichment analysis
#'
#' `nsePathway()` performs network-based set enrichment analysis (NSEA)
#' on Reactome pathways. Instead of using raw gene-level scores directly,
#' scores are propagated across the Reactome reaction graph via Random
#' Walk with Restart (RWR), and enrichment scores are computed on the
#' diffused ranking. Statistical significance is assessed with a
#' whole-pipeline permutation null (gene labels of the input scores are
#' reshuffled, the diffusion is re-run, and the enrichment scores are
#' recomputed), so the reported p-values account for the correlation
#' induced by network diffusion and control the false-positive rate.
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
#' @param nPerm Number of whole-pipeline permutations used to estimate p-values
#'   and NES (default: 1000). Each permutation reshuffles the gene labels of the
#'   input scores, re-runs the RWR diffusion over the network, and recomputes
#'   the enrichment scores, giving a null distribution that accounts for the
#'   network diffusion. The smallest estimable p-value is 1/(nPerm + 1).
#' @param seed Numeric random seed for the whole-pipeline permutation null
#'   (default: NULL uses the current R RNG state). Set a number for fully
#'   reproducible results.
#' @param verbose Print progress messages (default: TRUE).
#' @param ... Other arguments passed to `enrichit::nsea_gson()`.
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
                       nPerm          = 1000,
                       seed           = NULL,
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
        nPerm           = nPerm,
        seed            = seed,
        verbose         = verbose,
        ...
    )
}
