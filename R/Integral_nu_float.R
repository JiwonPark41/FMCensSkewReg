#' Internal helpers: bivariate-t CDF via 1D integration
#'
#' Location–scale Student-t pdf/cdf helpers and a 2D t CDF
#' evaluator used when `nu` is non-integer.
#'
#' @keywords internal
#' @noRd
#'
#' @importFrom stats dt pt integrate
NULL

# location-scale Student-t pdf
#' @noRd
dent <- function(x, mu, sigma2, nu) {
  z  <- (x - mu)/sqrt(sigma2)
  aa <- dt(z, df = nu)/sqrt(sigma2)
  if (length(which(aa == 0)) > 0) aa[which(aa == 0)] <- .Machine$double.xmin
  aa
}

# location-scale Student-t CDF
#' @noRd
pent <- function(x, mu, sigma2, nu) {
  aa <- pt((x - mu)/sqrt(sigma2), nu)
  if (length(which(aa == 0)) > 0) aa[which(aa == 0)] <- .Machine$double.xmin
  aa
}

# 2D (bivariate) t CDF on rectangle (a,b] with optional a = -Inf
# a, b, mu are length-2 numeric vectors; Sigma is 2x2 covariance; nu > 0
#' @noRd
acumt2 <- function(a = NULL, b, mu, Sigma, nu) {
  # conditional variance of Y2|Y1
  Sigma21 <- c(Sigma[-1, -1] - Sigma[-1, 1] %*% solve(Sigma[1, 1]) %*% Sigma[1, -1])

  expab <- function(x, y) {
    delta1 <- c((x - mu[1])^2 / Sigma[1, 1])
    mu21   <- mu[-1] + Sigma[-1, 1] %*% solve(Sigma[1, 1]) %*% (x - mu[1])
    pent(y, mu21, Sigma21 * (nu + delta1)/(nu + 1), nu + 1)
  }

  kern <- function(x, val) val * dent(x, mu[1], Sigma[1, 1], nu)

  if (all(is.infinite(a)) || is.null(a)) {
    f <- function(x) kern(x, expab(x, b[2]))
    return(integrate(Vectorize(f), lower = -Inf, upper = b[1])$value)
  } else {
    i1 <- integrate(function(x) kern(x, expab(x, b[2])), lower = a[1], upper = b[1])$value
    i2 <- integrate(function(x) kern(x, expab(x, a[2])), lower = a[1], upper = b[1])$value
    return(i1 - i2)
  }
}
