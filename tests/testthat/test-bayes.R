context("bayes_reactome")

# Compute once, reuse across all tests
gene <- c("11171", "8243", "112464", "2194",
          "9318", "79026", "1654", "65003",
          "6240", "3476", "6238", "3836",
          "4176", "1017", "249")
x <- enrichPathway(gene, pvalueCutoff = 0.1)
skip_if_no_result <- nrow(x@result) == 0

test_that("bayes_reactome adds posterior columns to enrichResult", {
    skip_if(skip_if_no_result, "No significant enrichment results")
    bx <- bayes_reactome(x, seed = 123)
    
    expect_s4_class(bx, "enrichResult")
    expect_true("posterior" %in% names(bx@result))
    expect_true("posterior_odds" %in% names(bx@result))
    expect_true("bayes_rank" %in% names(bx@result))
    expect_true("bayes_active" %in% names(bx@result))
    expect_true("bayes_covered_gene" %in% names(bx@result))
    expect_true("bayes_covered_count" %in% names(bx@result))
})

test_that("bayes_reactome compresses results (bayes_active <= total)", {
    skip_if(skip_if_no_result, "No significant enrichment results")
    bx <- bayes_reactome(x, seed = 123)
    n_active <- sum(bx@result$bayes_active, na.rm = TRUE)
    n_total <- nrow(bx@result)
    
    expect_lte(n_active, n_total)
})

test_that("bayes_reactome with candidate = 'all' uses all terms", {
    skip_if(skip_if_no_result, "No significant enrichment results")
    bx <- bayes_reactome(x, candidate = "all", seed = 123)
    expect_s4_class(bx, "enrichResult")
})

test_that("bayes_reactome respects seed for reproducibility", {
    skip_if(skip_if_no_result, "No significant enrichment results")
    bx1 <- bayes_reactome(x, seed = 42)
    bx2 <- bayes_reactome(x, seed = 42)
    
    expect_equal(bx1@result$posterior, bx2@result$posterior)
})
