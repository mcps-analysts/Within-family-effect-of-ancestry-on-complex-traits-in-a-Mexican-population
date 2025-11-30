
# Within-family effect of ancestry on complex traits in a Mexican population

This repository provides a complete pipeline for analyzing genetype data and phenotype data, focusing on ancestry effects.
It includes phenotype processing, association tests, IBD inference, REML modeling, selection analysis, ancestry-effect prediction, and power calculations.

---

# 📁 Repository Structure

```
📦 ancestry-effect-pipeline
├── 1_phenotype_processing/
├── 2_ibd_estimation/
├── 3_reml_analysis/
├── 4_partial_correlation/
├── 5_selection_analysis/
├── 6_prediction_of_ancestry_effect/
├── 7_power_calculation/
```

---

# 🚀 Pipeline Overview

## 1. Phenotype Processing & Association Analysis (R)

### ✔️ 1.0 Standardizing Continuous Traits
- Split data by sex  
- Adjust traits for **AGE** and **AGE²**  
- Standardize residuals (mean = 0, SD = 1)  
- Remove outliers (±5 SD)  
- Merge processed sex-specific datasets  

📌 Output: `Filtered_Trait_A` (clean, standardized phenotype)

---

### ✔️ 1.1 Independent Population Models
Models fit on unrelated individuals (`Independent = 1`).

**Trait A (Continuous)**  
- Standardized phenotype `Y_res_S`  
- Linear model: `Trait ~ ANCs + covariates`

**Trait B (Binary)**  
- Excludes missing trait values  
- Logistic model: `Trait ~ ANCs + covariates`

---

### ✔️ 1.2 Family-Based Mixed Models
Mixed-effects logistic regression for family data.

- Uses `family_set = 1`  
- Random intercept: **Fam_ID**  
- Fixed effects: ANCs, family-mean ANCs, age (scaled), age², covariates  

📌 Captures shared family environment + within-family ancestry variation.

---

## 2. 🧬 IBD Estimation (Shell)

Using **Snipar**  
🔗 https://github.com/AlexTISYoung/snipar

- Requires PLINK genotype files per chromosome  
- Uses KING-identified full-sibling pairs  
- Shell script loops through chromosomes 1–22  
- Computes chromosome-level IBD matrices  

---

## 3. 📉 REML Analysis with GCTA (Shell)

Using **GCTA**  
🔗 https://github.com/JianYang-Lab/GCTA

Performs variance-component estimation via REML using:
- Multiple GRMs (`mgrm.txt`)  
- Phenotype + covariate files  

📌 Outputs variance components & fixed-effect var-cov matrices.

---

## 4. 🔗 Partial Correlation Analysis (R)

Computes partial correlations:
- Select variables (e.g., `v1`, `v2`, `v3`, `v4`)  
- Use `pcor()` from **ppcor**  

📌 Reveals direct variable relationships controlling for other variables.

---

## 5. 🧬 Selection Analysis (R)

Tests for evidence of selection on trait-associated SNPs.

Pipeline:
- Combine target & background SNPs  
- Bin SNPs by allele frequency + LD (20×20)  
- Sample matched background SNPs  
- Run **10,000 permutations**  
- Compute **Fst** & allele frequency differences  
- Compare observed vs. null distributions  

📌 Outputs Z-scores + p-values for selection signals.

---

## 6. 📊 Prediction of Ancestry Effects (R)

Combines:
- Within-family (direct)
- Between-family (indirect)

Steps:
- Fit random-intercept model  
- Extract family/residual variance  
- Compute shrinkage factor **c**  
- Predict population-level ancestry effect + SE  

---

## 7. 📈 Statistical Power Calculation (R)

Computes power for detecting ancestry effects using sibling pairs.

Inputs:
- Sibling sample size  
- Phenotypic correlation  
- Within-family ancestry variance  
- Effect size (beta)  
- Alpha  

Power is computed via noncentral chi-square statistics.

---

# 🧩 Summary

This repository provides a full genetics workflow including:
- 🧪 Phenotype processing  
- 📊 Independent and family-based association models  
- 🧬 IBD estimation  
- 📉 REML variance analysis  
- 🚩 Selection testing  
- 📈 Ancestry-effect prediction  
- 🔧 Power evaluation  

Together, these tools help characterize ancestry effects in complex traits using robust statistical genetics methods.


## 🛠 Software 
- **R **
- **Shell tools**: [`snipar`](https://github.com/AlexTISYoung/snipar), [`GCTA`](https://cnsgenomics.com/software/gcta/)

---

# 📜 Citation

If you use this pipeline, please cite the corresponding manuscript (add once available).


## ✉️ Contact
siqi.wang@ndph.ox.ac.uk

