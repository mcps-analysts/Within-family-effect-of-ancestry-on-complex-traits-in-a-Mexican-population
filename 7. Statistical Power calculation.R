########################################################################################################
## 7. Statistical Power calculation
##
## Computes statistical power for detecting a within-family ancestry effect
########################################################################################################

########################
## Function
########################
power_sibdiff <- function(n, r, VAR_w, beta, alpha) {
  # n     = number of sibling pairs
  # r     = sibling phenotypic correlation
  # VAR_w   = within-family variance of ancestry proportion
  # beta  = between-ancestry effect (in phenotypic SD units)
  # alpha = Type-I error rate
  
  # Critical chi-square threshold
  thres <- qchisq(1 - alpha, 1)
  
  # Non-centrality parameter
  ncp   <- n * VAR_w * beta^2 / (1 - r)
  
  # Statistical power
  power <- 1 - pchisq(thres, 1, ncp = ncp)
  
  return(power)
}

########################
## Example
########################
power_sibdiff(
  n   = 29796,
  r   = 0.41,
  VAR_w = 3.85e-4,
  beta = 0.5,
  alpha = 0.05
)
