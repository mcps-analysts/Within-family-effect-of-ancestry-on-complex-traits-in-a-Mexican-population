########################################################################################################################
# 2. Estimation of IBD — Shell Script
########################################################################################################################
## This section estimates identity-by-descent (IBD) using the Snipar.
##
## - The script loops over all 22 autosomal chromosomes.
## - For each chromosome, it uses PLINK files and KING-identified full sibling pairs.
########################################################################################################################

#######################################
# Step 1: Install Snipar
#######################################
# Visit and follow instructions at:
# https://github.com/AlexTISYoung/snipar

#######################################
# Step 2: Run Snipar for IBD Estimation
#######################################

#!/bin/bash

# Set directory paths
genoDIR=/path/to/genotype_data      # Directory containing genotype data per chromosome
PheDIR=/path/to/phenotype_data      # Directory containing KING full sibling pairs
OutDIR=/path/to/output_directory    # Directory to save IBD results

module load python
module load Anaconda3/2022.05

# Loop through chromosomes 1–22
for i in {1..22}; do
  ibd.py \
    --bed ${genoDIR}/chr${i} \
    --king ${PheDIR}/king_full_sibling_pairs.txt \
    --out ${OutDIR}/chr${i}_IBD \
    --chrom ${i} \
    --threads 16 \
    --p_error 0.00045
done
