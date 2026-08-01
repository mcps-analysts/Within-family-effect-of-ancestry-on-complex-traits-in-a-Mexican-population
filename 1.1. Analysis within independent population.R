############################################################################################################
# 1.1. Analysis within Independent Population — R Code
############################################################################################################
# This section performs association analyses within the independent subset of the data:
#
# - A linear regression is used for a continuous trait (Trait A).
# - A logistic regression is used for a binary trait (Trait B).
# - Both models include ancestry proportions (ANCs) and covariates.
############################################################################################################

# ----------------------------------------------------------------------------------------
# Linear Regression for Continuous Trait A
# ----------------------------------------------------------------------------------------
# Subset: Independent Population Only
Independent_Trait_A <- Filtered_Trait_A %>%
  filter(Independent == 1)

# Replace 'Y_res_S' with the standardized trait variable
# Replace ANCs and covariates with the actual variable names used in your dataset.
M0_Trait_A <- lm(
  Y_res_S ~ ANCs + covariates,
  data = Independent_Trait_A
)
summary(M0_Trait_A)



# ----------------------------------------------------------------------------------------
# Logistic Regression for Binary Trait B
# ----------------------------------------------------------------------------------------
# Replace 'Trait_B' with the binary trait variable, and adjust covariates accordingly
Filtered_Trait_B <- df_all[complete.cases(df_all$Trait_B), ] 
Independent_Trait_B <- Filtered_Trait_B[Filtered_Trait_B$Independent == 1, ] 

M1_Trait_B <- glm(
  Trait_B ~ ANCs + covariates,
  data = Independent_Trait_B,
  family = binomial
)
summary(M1_Trait_B)
