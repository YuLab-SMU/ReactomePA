context("gsePathway reproducibility and seed")

gene <- c("11171", "8243", "112464", "2194",
          "9318", "79026", "1654", "65003",
          "6240", "3476", "6238", "3836",
          "4176", "1017", "249")

# mix of positive and negative scores so scoreType = "std" is appropriate
geneList <- setNames(c(seq(8, 1, -1), -seq(1, 7)), gene)

# fast multilevel configuration: small adaptive permutation budget
ml_args <- list(verbose = FALSE, minPerm = 10, maxPerm = 50,
                minGSSize = 1, maxGSSize = 500)

test_that("gsePathway and nsePathway expose an explicit seed argument", {
    expect_true("seed" %in% names(formals(gsePathway)))
    expect_true("seed" %in% names(formals(nsePathway)))
})

test_that("gsePathway with a fixed seed gives identical results across runs", {
    r1 <- do.call(gsePathway, c(list(geneList, seed = 123, pvalueCutoff = 1), ml_args))
    r2 <- do.call(gsePathway, c(list(geneList, seed = 123, pvalueCutoff = 1), ml_args))
    expect_s4_class(r1, "gseaResult")
    expect_identical(r1@result, r2@result)
})

test_that("gsePathway honors set.seed() when seed = FALSE", {
    set.seed(42)
    r1 <- do.call(gsePathway, c(list(geneList, pvalueCutoff = 1), ml_args))
    set.seed(42)
    r2 <- do.call(gsePathway, c(list(geneList, pvalueCutoff = 1), ml_args))
    expect_identical(r1@result, r2@result)
})

test_that("gsePathway filters by both pvalue and p.adjust (historical double-cutoff)", {
    # with only the raw pvalue filtered, rows with p.adjust above the cutoff
    # would survive; the double-cutoff must exclude them
    r <- do.call(gsePathway, c(list(geneList, seed = 123,
                                    pvalueCutoff = 0.9), ml_args))
    expect_false(is.null(r))
    expect_true(all(r@result$pvalue <= 0.9))
    expect_true(all(r@result$p.adjust <= 0.9))
})
