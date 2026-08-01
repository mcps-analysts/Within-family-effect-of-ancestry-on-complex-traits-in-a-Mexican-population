################################################################################
## 6. Prediction of Ancestry Effect
## 
## This script calculates the expected marginal beta for a phenotype
## using within-family and between-family effects.
################################################################################
# ------------------------------------------------------------------------------
#  Load Required Libraries
# ------------------------------------------------------------------------------
library(haven)
library(lme4)
library(lmerTest)
library(dplyr)

# ------------------------------------------------------------------------------
#  Load Family Data
# ------------------------------------------------------------------------------
df <- read_dta("path_to_your_data/FullSibling_ANC_Family_mean_ANC.dta")

df_family <- df %>%
  group_by(Fam_ID) %>%
  summarise(n_sib = first(n_sib))  

n <- mean(df_family$n_sib, na.rm = TRUE)

# ------------------------------------------------------------------------------
#  Estimate Variance Components from Random Intercept Model
# ------------------------------------------------------------------------------
model_ANC1 <- lmer(ANC1 ~ 1 + (1 | Fam_ID), data = df)
summary(model_ANC1)

# Extract variance components
vc <- as.data.frame(VarCorr(model_ANC1))
var_fam <- vc$vcov[1]              # Family (random effect) variance
var_resid <- sigma(model_ANC1)^2   # residual variance

# Compute lambda and shrinkage factor c
lambda <- var_resid / var_fam
c_factor <- (n + lambda) / (n * (1 + lambda))

# ------------------------------------------------------------------------------
#  Estimated Effects from Family-Based analysis (replace with actual values)
# -------------------------------------------------------------------------------
beta_within <- actual_values   # replace with actual values
beta_between <- actual_values  # replace with actual values
  
# ------------------------------------------------------------------------------
#  Compute Expected Marginal Beta at Population Scale
# ------------------------------------------------------------------------------
expected_beta <- beta_within + c_factor * beta_between

# ------------------------------------------------------------------------------
#  Compute Standard Error of Predicted Beta
# ------------------------------------------------------------------------------
se_within <- actual_values_SE_within_family_effect             # replace with actual values
se_between <- actual_values_SE_between_family_effect           # replace with actual values
cov_bw <- actual_values_covariance_between_within_and_between  # replace with actual values
  
SE_expected_beta <- sqrt(se_within^2 + c_factor^2 * se_between^2 + 2 * c_factor * cov_bw)

################################################################################


