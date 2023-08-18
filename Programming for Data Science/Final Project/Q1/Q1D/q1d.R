# base R: wilcox.test
x <- c(2.1, 7.2, 4.3)
y <- c(1.4, 2.1, 5.6, 8.7)
print("Base R result")
wilcox.test(x, y, paired = FALSE, exact = FALSE)


# function taken from wmw.R and modified a little (removed inputs checks, 
# doesn't return WMW object) for example purposes
wmw <- function(x, y, alpha) {
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
  
  print(w)
  print(reject)
}

print("Implementation result")
wmw(x, y, 0.05)
