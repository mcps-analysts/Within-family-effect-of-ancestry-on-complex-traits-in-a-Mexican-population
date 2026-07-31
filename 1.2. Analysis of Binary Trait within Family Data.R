############################################################
## 1.2 Analysis of Binary Trait within Family Data
## Using Mixed model logistic regression — R Code
############################################################

# Load necessary libraries
library(lme4)     
library(Matrix)
library(haven)

############################################################
# Step 1: Import Data
############################################################
df_all <- read_dta("path/to/your/datafile.dta")

############################################################
# Step 2: Prepare Trait-Specific Data
############################################################
# Example: binary trait column is "Trait" (0/1)
# Keep individuals with non-missing trait values
df_trait <- df_all[complete.cases(df_all$Trait), ]

############################################################
# Step 3: Subset to Family Data
############################################################
fam_data <- df_trait[df_trait$family_set == 1, ]

############################################################
# Step 4: Fit Mixed model logistic regression
############################################################
# Random intercept for family (Fam_ID)
# Fixed effects: ANCs, family mean ANCs,and covariates
fam_data$AGE_scaled  <- scale(fam_data$AGE)
fam_data$AGE2_scaled <- fam_data$AGE_scaled^2

# Replace ANCs, family_mean_ANCs, and covariates with actual variable names.
model <- glmer(
  Trait ~ ANCs + family_mean_ANCs + covariates + (1 | Fam_ID),
  data = fam_data,
  family = binomial,
  control = glmerControl(
    optimizer = "bobyqa",
    optCtrl   = list(maxfun = 1e5),
    calc.derivs = TRUE
  )
)

summary(model)
