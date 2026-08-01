###############################################################################################
# 1.0. Standardize Continuous Traits and Exclude Outliers
###############################################################################################
# This section performs trait standardization and outlier removal for a continuous phenotype:
#
# - A linear regression is used to adjust the trait for AGE and age².
# - Residuals from the model are standardized to have mean = 0 and SD = 1.
# - Outliers (defined as ±5 SD from the mean) are excluded.
# - The process is applied separately to female and male data, then combined.
###############################################################################################

# Load required libraries
library(haven)
library(dplyr)

# Load dataset
df_all <- read_dta("path/to/your/datafile/ALL_study_population_Pheno.dta")

df_all <- df_all %>%
  filter(!is.na(AGE), !is.na(SEX))

df_all$age2 <- (df_all$AGE - mean(df_all$AGE))^2

# ----------------------------------------------------------------------------------------
# Separate Female (SEX == 0) and Male (SEX == 1) Data
# ----------------------------------------------------------------------------------------
df_Female <- df_all %>% filter(SEX == 0)
df_Male   <- df_all %>% filter(SEX == 1)

# ----------------------------------------------------------------------------------------
# Function to Standardize Trait and Remove Outliers
# ----------------------------------------------------------------------------------------
process_trait <- function(df, trait_name) {
  # Remove missing values for the selected trait
  df <- df %>% filter(complete.cases(.data[[trait_name]]))
  
  # Fit linear model: trait ~ AGE + AGE²
  model <- lm(as.formula(paste(trait_name, "~ AGE + age2")), data = df)
  
  # Add residuals to the dataset
  df <- df %>%
    mutate(Y_res = residuals(model))
  
  # Manually standardize residuals (mean = 0, SD = 1)
  mean_res <- mean(df$Y_res)
  sd_res   <- sd(df$Y_res)
  
  df <- df %>%
    mutate(Y_res_S = (Y_res - mean_res) / sd_res)
  
  # Filter out residuals beyond ±5 SD
  df_filtered <- df %>%
    filter(between(Y_res_S, -5, 5))
  
  return(df_filtered)
}

# ----------------------------------------------------------------------------------------
# Apply to Female and Male Data Separately
# ----------------------------------------------------------------------------------------
df_Female_Trait_A <- process_trait(df_Female, "Trait_A")
df_Male_Trait_A   <- process_trait(df_Male, "Trait_A")

# ----------------------------------------------------------------------------------------
# Combine Processed Female and Male Data
# ----------------------------------------------------------------------------------------
Filtered_Trait_A <- bind_rows(df_Female_Trait_A, df_Male_Trait_A)
