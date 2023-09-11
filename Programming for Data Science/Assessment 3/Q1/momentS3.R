# Joana Levtcheva, CID 01252821


# S3 class `moment`, stores the sample mean and variance, updates sequentially
moment <- function(){
    structure(list(n=0, xbar=0, s2=0), class="moment")
}

# declare a getSize method
getSize <- function(x) UseMethod("getSize")
# implementation of the getSize method
# get the size value of the object
getSize.moment <- function(x) {
  return(x$n)
}

# declare a getMean method
getMean <- function(x) UseMethod("getMean")
# implementation of the getMean method
# get the mean value of the object
getMean.moment <- function(x) {
  return(x$xbar)
}

# declare a getVariance method
getVariance <- function(x) UseMethod("getVariance")
# implementation of the getVariance method
# get the variance value of the object
getVariance.moment <- function(x) {
  return(x$s2)
}

# an `update` function exists in R, so we only need to modify `update.moment`
# update estimates for sample mean and sample variance
update.moment <- function(m, x){
  m$n <- m$n + 1
  # s2 only holds for n >= 2
  if(m$n >= 2) {
    m$s2 <- (m$n * (m$n - 2) * m$s2 + (m$n - 1) * ((x - m$xbar)^2)) / (m$n * (m$n -1))
  }
  m$xbar <- ((m$n - 1) * m$xbar  + x) / m$n

  return(m)
}

# a `print` function exists in R, so we only need to modify `print.moment`
print.moment <- function(m){
  cat("Moment object:", "\n  ")
  cat("Size:", getSize(m), "\n  ")
  cat("Mean:", getMean(m), "\n  ")
  cat("Variance:", getVariance(m))
}
