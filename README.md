
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FMCensSkewReg

<!-- badges: start -->
<!-- badges: end -->

FMCensSkewReg implements finite mixture censored regression models under
four distributional families: Normal (FM-NCR), Student-t (FM-TCR),
Skew-Normal (FM-SNCR), Skew-t (FM-STCR)

## Installation

You can install the development version of FMCensSkewReg from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("jpark335/FMCensSkewReg")
```

## Example

Here is a minimal working example with simulated left-censored data
generated from a two-component Skew-t mixture (both shape parameters \>
0):

``` r
set.seed(1)

n <- 150
x <- cbind(1, runif(n), rnorm(n))  # design matrix (n x 3)

# Mixture parameters (both shapes positive)
pi  <- c(0.6, 0.4)
nu  <- 4
b1  <- c(0.5,  1.0, -1.0);  sigma1 <- 1; shape1 <- 2
b2  <- c(1.0, -0.5,  0.5);  sigma2 <- 2; shape2 <- 3
mu1 <- drop(x %*% b1)
mu2 <- drop(x %*% b2)

# Generate from Skew-t mixture via mixsmsn::rmix (observation-wise params)
draw1 <- function(i) {
  arg1 <- list(mu = mu1[i], sigma2 = sigma1, shape = shape1, nu = nu)
  arg2 <- list(mu = mu2[i], sigma2 = sigma2, shape = shape2, nu = nu)
  mixsmsn::rmix(1, pi, "Skew.t", list(arg1, arg2), cluster = FALSE)
}
y_true <- vapply(seq_len(n), draw1, numeric(1))

# Left-censor ~20% at the 20th percentile
cutoff <- unname(quantile(y_true, 0.20))
cc     <- as.integer(y_true <= cutoff)       # 1 = censored, 0 = observed
y      <- ifelse(cc == 1, cutoff, y_true)

# Fit two-component mixture (fast: Normal); ST variant shown but commented
fitN  <- EM.skewCens.mixR(cc, y, x, g = 2, family = "Normal", iter.max = 100)
#> [1] 1
#> [1] 2
#> [1] 3
#> [1] 4
#> [1] 5
#> [1] 6
#> [1] 7
#> [1] 8
#> [1] 9
#> [1] 10
#> [1] 11
#> [1] 12
#> [1] 13
#> [1] 14
#> [1] 15
#> [1] 16
#> [1] 17
#> [1] 18
#> [1] 19
#> [1] 20
#> [1] 21
#> [1] 22
#> [1] 23
#> [1] 24
#> [1] 25
#> [1] 26
#> [1] 27
fitN$loglik
#> [1] -247.8763

# fitST <- EM.skewCens.mixR(cc, y, x, g = 2, family = "ST", nu = 4, iter.max = 150)
# c(N = fitN$loglik, ST = fitST$loglik)
```
