//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3. REML Analysis using GCTA — Shell Script
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#######################################
# Step 1: Install GCTA
#######################################
# Visit and follow instructions at:
# https://github.com/JianYang-Lab/GCTA
# https://yanglab.westlake.edu.cn/software/gcta/#Download

#######################################
# Step 2: Perform REML Analysis
#######################################
gcta64=/path/to/gcta64             # Path to the GCTA
Out_Dir=/path/to/output_directory  # Directory to store results

# Run REML using multiple GRMs
${gcta64} \
  --mgrm mgrm.txt \                            
  --pheno trait.phen \                          
  --qcovar quantitative_covariates.txt \        
  --covar categorical_covariates.txt \          
  --reml \                                     
  --reml-est-fix-varcov \                       
  --reml-no-constrain \                         
  --thread-num 10 \                            
  --out ${Out_Dir}/result_name    