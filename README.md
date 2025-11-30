
# Within-family effect of ancestry on complex traits in a Mexican population

This repository provides a complete pipeline for analyzing genetype data and phenotype data, focusing on ancestry effects.
It includes phenotype processing, association tests, IBD inference, REML modeling, selection analysis, ancestry-effect prediction, and power calculations.

---

# 📁 Repository Structure

```
├── 1. Phenotype Processing & Association Analysis (R)
├── 2. IBD Estimation (Shell)
├── 3. REML Analysis (Shell)
├── 4. Partial Correlation (R)
├── 5. Selection Analysis (R)
├── 6. Prediction of Ancestry Effect (R)
├── 7. Statistical Power calculation (R)
```

---

# 🚀 Pipeline Overview

## 1. 📌 Phenotype Processing & Association Analysis (R)

### ✔️ 1.0 Standardizing Continuous Traits
- Split data by sex  
- Adjust traits for **Age** and **Age²**  
- Standardize residuals (mean = 0, SD = 1)  
- Remove outliers (±5 SD)  
- Merge processed sex-specific datasets  
- Output: standardized phenotype

---

### ✔️ 1.1 Independent Population Analysis (R)
This section performs association analyses within the independent subset of the data

**Trait A (Continuous)**  
- Standardized phenotype  
- Linear model: `Trait ~ ANCs + covariates`

**Trait B (Binary)**  
- Logistic model: `Trait ~ ANCs + covariates`

---

### ✔️ 1.2 Analysis of Binary Trait within Family Data
Using Mixed model logistic regression — R Code

- Using family data 
- Random intercept for family 
- Fixed effects for individual-level ANCs, family-mean ANCs, and covariates  

---

## 2. 🧬 Estimation of IBD (Shell)

Using **Snipar**  
🔗 https://github.com/AlexTISYoung/snipar

- Requires genotype data
- Uses KING identified full-sibling pairs  
- Shell script loops through chromosomes 1–22  

---

## 3. 📌 REML Analysis using GCTA (Shell)

Using **GCTA**  
🔗 https://github.com/JianYang-Lab/GCTA

Performs REML analysis:
- Multiple GRMs (`mgrm.txt`)  
- Phenotype + covariate files  

---

## 4. 📌 Partial Correlation Analysis (R)

Computes partial correlations:
- Select variables (e.g., `v1`, `v2`, `v3`, `v4`)  
- Use `pcor()` from **ppcor**  

Reveals direct variable relationships controlling for other variables.

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


---
# 🛠 Software 

- **R **
- **Shell tools**: [`snipar`](https://github.com/AlexTISYoung/snipar), [`GCTA`](https://cnsgenomics.com/software/gcta/)

---

# 📜 Citation

If you use this pipeline, please cite the corresponding manuscript (add once available).


---
# ✉️ Contact
siqi.wang@ndph.ox.ac.uk
