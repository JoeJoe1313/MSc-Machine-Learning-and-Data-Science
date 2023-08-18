# Joana Levtcheva, CID 01252821

#' WMWS3 object
#' 
#' Constructor for WMWS3 S3 object.
#' 
#' @param stat Value of the Wilcoxon-Mann-Whitney (WMW) statistic.
#' @param reject Indicates if the null hypothesis for the WMW test had been rejected.
#' @return Returns an object of type \code{WMWS3}.
#' 
#' @rdname WMWS3
#' @export
WMWS3 <- function(stat, reject){
  structure(list(stat=stat, reject=reject), class="WMWS3")
}

check_inputs <- function(x, y, alpha) {
  if (alpha <= 0 || alpha >=1) {
    stop("Alpha is not in the open interval 0 to 1!")
  }

  if (!is.vector(x)) {
    stop("The input x is not a vector!")
  }
    
  if (!is.vector(y)) {
    stop("The input y is not a vector!")
  }

  if (!is.numeric(x)) {
    stop("The input x contains not numeric elements!")
  }

  if (!is.numeric(y)) {
    stop("The input y contains not numeric elements!")
  }
}

#' Returns a WMWS3 object.
#' 
#' @param x The first vector.
#' @param y The second vector.
#' @param alpha The level of significance.
#' 
#' @details Given two vectors \code{x} and \code{y} of length \code{n}
#'          computes \deqn{f(x, y) = \sum_{i=1}^{n} |x_i - y_i|}.
#'
#' @return The value of the one-norm of the two vectors.
#' @export
wmw <- function(x, y, alpha) {

  check_inputs(x, y, alpha)
  
  n <- length(x)
  m <- length(y)
  
  df <- data.frame(
    x_values = c(x, rep(NA, m)), 
    y_values = c(rep(NA, n), y),
    is_x_value = c(rep(TRUE, n), rep(FALSE, m)),
    ranked_z_values = rank(c(x, y))
  )
  
  x_ranks_sum <- sum(df[df$is_x_value == TRUE,]$ranked_z_values)
  w <- x_ranks_sum - n * (n + 1) / 2
  
  mu <- n * m / 2
  sigma_squared <- n * m * (n + m + 1) / 12
  sd <- sqrt(sigma_squared)
  
  l_alpha <- qnorm(p = alpha / 2, mean = mu, sd = sd)
  u_alpha <- qnorm(p = 1 - alpha / 2, mean = mu, sd = sd)
  
  reject <- (w < l_alpha) | (w > u_alpha)
  
  return(WMWS3(w, reject))
}
