
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

Here is a minimal working example with simulated censored data:

``` r
library(FMCensSkewReg)

set.seed(1)
n <- 50
x <- cbind(1, runif(n), rnorm(n))

# Simulated response with 20% censoring
y <- rnorm(n)
cc <- rbinom(n, 1, 0.2)   # censoring indicator

# Fit two mixture models
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
fitN$loglik
#> [1] -53.00811
# fitST <- EM.skewCens.mixR(cc, y, x, g = 2, family = "ST",    nu = 4, iter.max = 150)

#c(N = fitN$loglik, ST = fitST$loglik)
```
