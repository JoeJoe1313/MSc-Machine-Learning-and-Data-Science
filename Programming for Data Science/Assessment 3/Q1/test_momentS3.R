# Joana Levtcheva, CID 01252821


# source the functions
source("momentS3.R")

# specifying tolerance
tol <- 1e-5

test_that("Test1: creating moment S3 object", {
  m <- moment()

  expect_equal(getSize(m), 0)
  expect_equal(getMean(m), 0, tolerance = tol)
  expect_equal(getVariance(m), 0, tolerance = tol)
})

test_that("Test 2: updating moment with one observation", {
  m <- moment()
  m <- update(m, 5)

  expect_equal(getSize(m), 1)
  expect_equal(getMean(m), 5, tolerance = tol)
  expect_equal(getVariance(m), 0, tolerance = tol)
})

test_that("Test 3: updating moment with two observations", {
  m <- moment()
  m <- update(m, 5)
  m <- update(m, 3)

  expect_equal(getSize(m), 2)
  expect_equal(getMean(m), 4, tolerance = tol)
  expect_equal(getVariance(m), 2, tolerance = tol)
})

test_that("Test 4: updating moment with 50 observations from a normal distribution", {
  m <- moment()
  set.seed(1)
  x <- rnorm(n = 50, mean = 0, sd = 1)
  for(element in x) {
    m <- update(m, element)
  }
  
  expect_equal(getSize(m), 50)
  expect_equal(getMean(m), 0.1004483, tolerance = tol)
  expect_equal(getVariance(m), 0.6912159, tolerance = tol)
})

