test_that("Test 1: create a WMWS3 object", {
  actual = WMWS3(2, TRUE)
  expect_equal(actual$stat, 2)
  expect_equal(actual$reject, TRUE)
})

test_that("Test 2: function wmw with all correct inputs", {
  actual = wmw(x=c(2.1, 7.2, 4.3), y=c(1.4, 2.1, 5.6, 8.7), alpha=0.05)
  expected = WMWS3(6.5, FALSE)
  expect_equal(actual, expected)
})

test_that("Test 3: function wmw with incorrect alpha", {
  expect_error(
    wmw(x=c(2.1, 7.2, 4.3), y=c(1.4, 2.1, 5.6, 8.7), alpha=0),
    "Alpha is not")
})

test_that("Test 4: function wmw with incorrect x type", {
  expect_error(
    wmw(x=WMWS3(2, TRUE), y=c(1.4, 2.1, 5.6, 8.7), alpha=0.05),
    "x is not a vector")
})

test_that("Test 5: function wmw with incorrect y type", {
  expect_error(
    wmw(x=c(2.1, 7.2, 4.3), y=WMWS3(2, TRUE), alpha=0.05),
    "y is not a vector")
})

test_that("Test 6: function wmw with x containing not numeric elements", {
  expect_error(
    wmw(x=c(2.1, "s", 4.3), y=c(1.4, 2.1, 5.6, 8.7), alpha=0.05),
    "x contains not numeric elements")
})

test_that("Test 7: function wmw with y containing not numeric elements", {
  expect_error(
    wmw(x=c(2.1, 7.2, 4.3), y=c("k", 2.1, "l", 8.7), alpha=0.05),
    "y contains not numeric elements")
})

test_that("Test 8: function wmw with x and y containing not numeric elements", {
  expect_error(
    wmw(x=c(2.1, "s", 4.3), y=c("k", 2.1, "l", 8.7), alpha=0.05),
    "x contains not numeric elements")
})
