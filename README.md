# Within-family effect of ancestry on complex traits in a Mexican population
This repository provides a complete pipeline for analyzing genetype data and phenotype data, focusing on ancestry effects.

---

## 📦 Contents


### 1.0. **Standardize Continuous Traits and Exclude Outliers (R)**

### 1.1. **Independent Population Analysis (R)**
- Linear and logistic regression models
- Focused on unrelated individuals

### 1.2. **Family-Based Mixed Models (R)**
- Mixed-effects logistic models with family random effects
- Accounts for shared environment and within-family ancestry variation

### 2. **IBD Estimation (Shell)**
- Identity-by-descent inference using snipar 

### 3. **REML Analysis (Shell)**
- Variance component estimation using GCTA 
- Supports multiple GRMs and covariate adjustments

### 4. **Partial Correlation (R)**
- Computes partial correlations
- Controls for confounding variables using `ppcor`

### 5. **Selection Analysis (R)**
- Tests for selection via matched background SNPs
- Fst and allele frequency difference assessed across 10,000 permutations

### 6. **Prediction of Ancestry Effect (R)**
- Combines within- and between-family effects to predict marginal ancestry effects
- Estimates expected effect size and standard error

### 7. **Statistical Power calculation (R)**
- Computes statistical power for detecting a between-ancestry effect
- based on the number of sibling pairs, within-family ancestry variation, and the sibling phenotypic correlation


## 🛠 Software 

- **R **
- **Shell tools**: [`snipar`](https://github.com/AlexTISYoung/snipar), [`GCTA`](https://cnsgenomics.com/software/gcta/)


## ✉️ Contact


siqi.wang@ndph.ox.ac.uk
