########################################################################################################
## 7. Statistical Power calculation
##
## Computes statistical power for detecting a between-ancestry effect
## based on the number of sibling pairs, within-family ancestry variation, and the sibling phenotypic correlation.
########################################################################################################

########################
## Function
########################
power_sibdiff <- function(n, r, sdw, beta, alpha) {
  # n     = number of sibling pairs
  # r     = sibling phenotypic correlation
  # sdw   = SD of within-family variation in ancestry proportion
  # beta  = between-ancestry effect (in phenotypic SD units)
  # alpha = Type-I error rate
  
  # Critical chi-square threshold
  thres <- qchisq(1 - alpha, 1)
  
  # Non-centrality parameter
  ncp   <- n * sdw^2 * beta^2 / (1 - r)
  
  # Statistical power
  power <-1 - pchisq(thres, 1, ncp = ncp)
  return(power)
}

########################
## Example
########################
power_sibdiff(
  n   = 29796,
  r   = 0.41,
  sdw = sqrt(3.85e-4),
  beta = 0.5,
  alpha = 0.05
)
