
# Within-family effect of ancestry on complex traits in a Mexican population

This repository provides a complete pipeline for analyzing genetype data and phenotype data, focusing on ancestry effects.

---

# 🧩 Repository Structure

- 📌 1. Phenotype Processing & Association Analysis (R) 
- 🧬 2. IBD Estimation (Shell)
- 🚩 3. REML Analysis (Shell)
- 📈 4. Partial Correlation (R)
- 🧬 5. Selection Analysis (R) 
- 📊 6. Prediction of Ancestry Effect (R) 
- 🧪 7. Statistical Power calculation (R)


---

# 🚀 Pipeline Overview

## 1. 📌 Phenotype Processing & Association Analysis (R)

### ✔️ 1.0 Standardizing Continuous Traits

To get a standardized phenotype
- Split data by sex  
- Adjust traits for **age** and **age²**  
- Standardize residuals (mean = 0, SD = 1)  
- Remove outliers (±5 SD)  
- Merge processed sex-specific datasets  

---

### ✔️ 1.1. Analyses within independent population (R)
This section performs association analyses within the independent subset of the data.

**Trait A (Continuous)**  
- Standardized phenotype  
- Linear regression

**Trait B (Binary)**  
- Logistic regression

---

### ✔️ 1.2 Analysis of Binary Trait within Family Data (R)
This section conducts association analysis for a binary trait in family-based data using mixed-model logistic regression.

- Using family data 
- Random intercept for family 
- Fixed effects for individual-level ANCs, family-mean ANCs, and covariates  

---

## 2. 🧬 Estimation of IBD (Shell)

This section estimates genome-wide identity-by-descent sharing between full siblings using [`snipar`](https://github.com/AlexTISYoung/snipar).

- Requires genotype data
- Uses KING identified full-sibling pairs  
- Shell script loops through chromosomes 1–22  

---

## 3. 🚩 REML Analyses using GCTA (Shell)

This section conducts REML analyses with [`GCTA`](https://cnsgenomics.com/software/gcta/) (version 1.94.3) to estimate variance components using multiple GRMs.

The analyses use:
- Multiple GRMs listed in (`mgrm.txt`)  
- Phenotype and covariate files  

Genetic covariance between siblings is modeled using an IBD relationship matrix, and shared environmental covariance is represented by a family-level matrix.
This framework enables GCTA to simultaneously estimate ancestry effects and partition phenotypic variance into genetic, shared environmental, and residual components.

---

## 4. 📈 Partial Correlation (R)

This section computes the partial correlation coefficients between variables, controlling for the influence of the other variables in the set.

Compute partial correlations:
- Select variables (e.g., `v1`, `v2`, `v3`, `v4`)  
- Use `pcor()` from **ppcor**  

---

## 5. 🧬 Selection Analysis (R)

This analysis evaluates whether genetic differences in the trait between the two ancestries exceed neutral expectations, indicating potential natural selection.

- Load target and background SNP sets
- Bin SNPs by trait-increasing allele frequency and LD score (20×20 bins)
- For each target SNP, sample matched background SNPs from the same bin
- Perform 10,000 permutations to generate a null distribution
- Compute Fst and allele-frequency differences for target and matched SNPs
- Compare observed values to the null


---

## 6. 📊 Prediction of Ancestry Effects (R)

This script calculates the expected marginal effect size for a phenotype using within-family and between-family effects.

- Load family data
- Estimate variance components from a random intercept model
- Estimated effects from family-based analysis
- Compute expected marginal beta at population scale
- Compute standard error of predicted beta

---

## 7. 🧪 Statistical Power Calculation (R)

This section computes the statistical power to detect a within-family ancestry effect.

Inputs:
- Number of sibling pairs  
- Sibling phenotypic correlation
- Within-family variance of ancestry proportion
- Between-ancestry effect
- Type-I error rate


---
# 🛠 Software 

- **R (version 4.3.2)**
- **Shell tools**:
  **snipar**🔗 https://github.com/AlexTISYoung/snipar, 
  **GCTA**🔗 https://github.com/JianYang-Lab/GCTA.
---
# 📜 Citation

If you use this pipeline, please cite our [`paper`](https://www.medrxiv.org/content/10.1101/2025.09.09.25335237v1).

---
# ✉️ Contact
siqi.wang@ndph.ox.ac.uk
