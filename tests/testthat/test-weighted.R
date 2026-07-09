context("weighted enrichment")

gene <- c("11171", "8243", "112464", "2194",
          "9318", "79026", "1654", "65003",
          "6240", "3476", "6238", "3836",
          "4176", "1017", "249")

test_that("enrichPathway with equal weights produces same result as without weight", {
    skip_if_not_installed("BiasedUrn")
    res_no_weight <- enrichPathway(gene, pvalueCutoff = 0.5)
    w <- rep(1, length(gene))
    names(w) <- gene
    res_weight <- enrichPathway(gene, pvalueCutoff = 0.5, weight = w)
    expect_equal(res_no_weight@result$pvalue, res_weight@result$pvalue)
})

test_that("enrichPathway with non-equal weights produces different result", {
    skip_if_not_installed("BiasedUrn")
    w <- rep(0.1, length(gene))
    names(w) <- gene
    w[1:3] <- 10
    res <- enrichPathway(gene, pvalueCutoff = 0.5, weight = w)
    expect_s4_class(res, "enrichResult")
    expect_true(nrow(res@result) > 0)
})

test_that("enrichPathway with unnamed weight errors before checking BiasedUrn", {
    w <- 1:3  # unnamed, triggers early error
    expect_error(
        enrichPathway(gene[1:3], weight = w),
        "named numeric"
    )
})

geneList <- setNames(c(3, 2, 1), c("11171", "8243", "112464"))

test_that("gsePathway with unnamed weight errors", {
    w <- rep(1, 5)
    expect_error(
        gsePathway(geneList, weight = w, verbose = FALSE),
        "named numeric"
    )
})

test_that("gsePathway with mismatched weight names errors", {
    w <- c(a = 1, b = 2)
    expect_error(
        gsePathway(geneList, weight = w, verbose = FALSE),
        "No common genes|named numeric"
    )
})
