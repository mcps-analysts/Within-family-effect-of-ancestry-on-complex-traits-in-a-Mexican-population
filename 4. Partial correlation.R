###############################################################################################
## 4. Partial Correlation
###############################################
## This section computes the partial correlation coefficients between variables,
## controlling for the influence of the other variables in the set.
###############################################################################################

# Load required libraries
library(haven)
library(ppcor)

# Load dataset
df <- read_dta("/dataset.dta")

# Select relevant variables for partial correlation analysis
df <- df[, c("v1", "v2", "v3", "v4")]

# Compute partial correlation matrix
pcor_result <- pcor(df)

# Print results
print(pcor_result)