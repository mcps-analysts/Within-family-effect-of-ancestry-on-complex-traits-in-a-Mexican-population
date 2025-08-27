#####################################################################################################
## 5. Selection Analysis
#####################################################################################################

# --------------------------------------------------------------------------------------------------
#  Load Packages and Setup
# --------------------------------------------------------------------------------------------------
library(dplyr)
library(purrr)
library(tidyr)
library(furrr)
library(parallel)
library(data.table)

plan(multisession, workers = 8)  # Parallel processing setup

# --------------------------------------------------------------------------------------------------
#  Load Input Data (Update file paths accordingly)
# --------------------------------------------------------------------------------------------------
df1 <- read.csv("Trait_A_target_snps.csv")     # target SNPs
df2 <- read.csv("Trait_A_background_snps.csv") # background SNPs

df1$set <- "target"
df2$set <- "background"

df_all <- rbind(df1, df2) %>%
  rename(fTIA_ANC2 = ANC2_freq_risk_allele,
         fTIA_ANC1 = ANC1_freq_risk_allele)


# --------------------------------------------------------------------------------------------------
#  Binning by Frequency of Trait-Increasing Alleles (fTIA) and LD Score
#
#  - LD scores were calculated using the 1000 Genomes reference panel before the selection analysis.
#  - Both fTIA and LD scores are derived from the same ancestry population (ANC2).
#  - If ANC2 corresponds to EUR, allele frequencies can also be calculated using
#    an independent set of UK Biobank individuals with available genotype data.
# --------------------------------------------------------------------------------------------------

df_all <- df_all %>%
  mutate(EAF_bin = ntile(fTIA_ANC2, 20)) %>%
  group_by(EAF_bin) %>%
  mutate(LD_bin = ntile(ldscore, 20)) %>%
  ungroup() %>%
  mutate(bin_id = paste(EAF_bin, LD_bin, sep = "_"))

assoc_snps <- df_all %>% filter(set == "target")
background_snps <- df_all %>% filter(set == "background", bin_id %in% assoc_snps$bin_id)

assoc_snps <- as.data.table(assoc_snps)

background_by_bin <- split(background_snps, background_snps$bin_id)
background_by_bin <- lapply(background_by_bin, as.data.table)

# --------------------------------------------------------------------------------------------------
#  Core Functions
# --------------------------------------------------------------------------------------------------
# Match a background SNP from same bin
get_matched_snp_fast <- function(bin_id, snp_name, seed_val = NULL) {
  if (!is.null(seed_val)) set.seed(seed_val)   # Ensure reproducibility
  
  candidates <- background_by_bin[[bin_id]]
  if (is.null(candidates) || nrow(candidates) == 0) return(NULL)
  
  idx <- sample.int(nrow(candidates), 1)
  sampled <- candidates[idx]
  sampled[, ori_asso_SNP := snp_name]  # original associated SNP 
  sampled[, matched_SNP := SNP]        # matched SNP 
  return(sampled)
}


# Generate N permutations of matched SNPs
generate_permuted_snps <- function(n_perm, assoc_snps) {
  future_map_dfr(1:n_perm, function(i) {
    if (i %% 50 == 0) message(sprintf("Sampling iteration %d / %d", i, n_perm))  # Progress tracking
    
    matched_list <- lapply(seq_len(nrow(assoc_snps)), function(j) {
      get_matched_snp_fast(
        assoc_snps$bin_id[j],
        assoc_snps$SNP[j],
        seed_val = i * 100000 + j
      )
    })
    
    matched <- rbindlist(matched_list, fill = TRUE)
    matched[, sample_id := i]
    return(matched)
  }, .options = furrr_options(seed = TRUE))
}

# Compute Fst estimate
compute_fst <- function(p1, p2, n1, n2) {
  num <- (p1 - p2)^2 - (p1 * (1 - p1)) / (n1 - 1) - (p2 * (1 - p2)) / (n2 - 1)
  denom <- p1 * (1 - p2) + p2 * (1 - p1)
  
  fst <- ifelse(denom == 0, NA, num / denom)
  return(fst)
}

# --------------------------------------------------------------------------------------------------
#  Run Permutations
# --------------------------------------------------------------------------------------------------
n_perm <- 10000
all_matched_snps <- generate_permuted_snps(n_perm, assoc_snps)
all_matched_snps <- as.data.table(all_matched_snps)
all_matched_snps <- all_matched_snps %>% select("sample_id", "ori_asso_SNP", "matched_SNP", "fTIA_ANC2", "fTIA_ANC1","ldscore","bin_id")
saveRDS(all_matched_snps, file = "matched_snps_all_samples.rds")

# --------------------------------------------------------------------------------------------------
#  Fst and Allele Frequency Difference Analysis
# --------------------------------------------------------------------------------------------------
###########
# Fst #
###########
n1 <- 1000    # Update n1 accordingly
n2 <- 300000  # Update n2 accordingly

assoc_snps$fst <- mapply(compute_fst, assoc_snps$fTIA_ANC1, assoc_snps$fTIA_ANC2, n1, n2)
all_matched_snps$fst <- mapply(compute_fst, all_matched_snps$fTIA_ANC1, all_matched_snps$fTIA_ANC2, n1, n2)

obs_mean_fst <- mean(assoc_snps$fst, na.rm = TRUE)

perm_mean_fsts <- all_matched_snps %>%
  group_by(sample_id) %>%
  summarise(mean_fst = mean(fst, na.rm = TRUE), .groups = "drop")

null_mean_fst <- mean(perm_mean_fsts$mean_fst)

null_sd_fst <- sd(perm_mean_fsts$mean_fst)
z_fst <- (obs_mean_fst - null_mean_fst) / null_sd_fst
p_norm_fst <- 2 * pnorm(-abs(z_fst))

###############################
# Allele Frequency Difference
###############################
assoc_snps$freq_diff <- assoc_snps$fTIA_ANC1 - assoc_snps$fTIA_ANC2
all_matched_snps$freq_diff <- all_matched_snps$fTIA_ANC1 - all_matched_snps$fTIA_ANC2

obs_mean_diff <- mean(assoc_snps$freq_diff, na.rm = TRUE)

perm_mean_diffs <- all_matched_snps %>%
  group_by(sample_id) %>%
  summarise(mean_diff = mean(freq_diff, na.rm = TRUE), .groups = "drop")

null_mean_diff <- mean(perm_mean_diffs$mean_diff)
null_sd_diff <- sd(perm_mean_diffs$mean_diff)
z_diff <- (obs_mean_diff - null_mean_diff) / null_sd_diff
p_norm_diff <- 2 * pnorm(-abs(z_diff))

# End of Script
#####################################################################################################
