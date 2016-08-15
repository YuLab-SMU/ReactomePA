library(ReactomePA)

context("getDb")

test_that("getDb", {
    expect_equal(getDb("human"), "org.Hs.eg.db")
    expect_equal(getDb("mouse"), "org.Mm.eg.db")
})

