#' Bayesian term selection for Reactome enrichment results
#'
#' `bayes_reactome()` adds a model-based selection layer on top of
#' `enrichPathway()` results. It estimates the posterior probability
#' that each candidate Reactome pathway is an active biological program
#' explaining the observed input genes.
#'
#' This is a thin wrapper around `enrichit::bayes_enrich()`, intended as
#' a result-compression and interpretation layer for Reactome pathway
#' enrichment. Reactome's hierarchical pathway structure often produces
#' many redundant significant terms — Bayesian selection helps distinguish
#' truly active programs from statistically significant but dependent ones.
#'
#' @param x An `enrichResult` object from `enrichPathway()`.
#' @param candidate Candidate terms to include. `"significant"` uses
#'   `as.data.frame(x)`, `"all"` uses `x@result`, `"top"` uses the top
#'   `n_terms` rows from `x@result` ordered by `by`; or provide a character
#'   vector of term IDs.
#' @param n_terms Maximum number of candidate terms when `candidate = "top"` or
#'   when more candidates are supplied than this value. Use `Inf` to disable.
#' @param by Column used to order candidate terms.
#' @param prior Prior probability that a term is active.
#' @param false_positive Probability of observing a gene not covered by active
#'   terms.
#' @param false_negative Probability of missing a gene covered by active terms.
#' @param n_iter Total number of MCMC iterations.
#' @param burnin Number of initial iterations discarded.
#' @param thin Keep one sample every `thin` iterations after burn-in.
#' @param posterior_cutoff Terms with posterior greater than or equal to this
#'   value are marked active.
#' @param seed Optional random seed.
#' @param verbose Print sampler progress.
#' @return The input `enrichResult` object with additional columns in
#'   `@result`: `posterior`, `posterior_odds`, `bayes_rank`,
#'   `bayes_active`, `bayes_covered_gene`, and `bayes_covered_count`.
#' @export
#' @importClassesFrom enrichit enrichResult
#' @seealso [enrichit::bayes_enrich()]
#' @examples
#' \dontrun{
#'   gene <- c("11171", "8243", "112464", "2194",
#'             "9318", "79026", "1654", "65003",
#'             "6240", "3476", "6238", "3836",
#'             "4176", "1017", "249")
#'   x <- enrichPathway(gene, pvalueCutoff = 0.1)
#'   bx <- bayes_reactome(x)
#'   head(as.data.frame(bx))
#' }
bayes_reactome <- function(x,
                           candidate = c("top", "significant", "all"),
                           n_terms = 200,
                           by = "p.adjust",
                           prior = 0.1,
                           false_positive = 0.01,
                           false_negative = 0.1,
                           n_iter = 5000,
                           burnin = 1000,
                           thin = 1,
                           posterior_cutoff = 0.5,
                           seed = NULL,
                           verbose = FALSE) {
    enrichit::bayes_enrich(
        x = x,
        candidate = candidate,
        n_terms = n_terms,
        by = by,
        prior = prior,
        false_positive = false_positive,
        false_negative = false_negative,
        n_iter = n_iter,
        burnin = burnin,
        thin = thin,
        posterior_cutoff = posterior_cutoff,
        seed = seed,
        verbose = verbose
    )
}
