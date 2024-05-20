# GLM-Projects

## Analysis of the minn38 Dataset Using Log-Linear Models
This project conducts a comprehensive analysis of the minn38 dataset available in the MASS package in R. The main focus is to understand how post-high-school (phs) statuses are influenced by various factors such as high school rank (hs), father's occupational level (fol), and sex. Additionally, the joint effect of phs and hs, conditioned on other factors, is explored.

### Objective

The `minn38` dataset contains information about Minnesota high school graduates of 1938, classified according to four factors (`phs`, `hs`, `fol`, `sex`). This analysis aims to explore:
1. How `phs` is affected by `hs`, `fol`, and `sex`.
2. How the joint status of `phs` and `hs` is influenced by `fol` and `sex`.

### Data

The analysis is based on the `minn38` dataset, which includes:
- `phs`: Post-high school status of the graduates.
- `hs`: High school rank of the graduates.
- `fol`: Father's occupational level.
- `sex`: Sex of the graduate.
- `Freq`: Frequency of each category.

### Methodology

The project utilizes surrogate log-linear models to analyze the data. The steps involved in the analysis are:
1. **Initial Model Building:** Start with minimal models assuming independence and then gradually add interaction terms based on residual deviance and AIC.
2. **Stepwise Model Selection:** Use the `step()` function to perform a stepwise selection to find a more optimal model by AIC.
3. **Model Refinement:** Utilize `drop1()` and `add1()` to explore nearby models that might offer better interpretability or significance.
4. **Final Model Selection:** Choose the final model based on AIC, log-likelihood tests, and interpretability.
5. **Presentation of Results:** Estimated cell probabilities are presented to show the effect of the factors and their interactions.

### Results

The analysis highlights the significant factors and their interactions affecting `phs` and the pair (`phs`, `hs`). Key findings include:

- **For `phs`:** High school rank (`hs`) and `sex` are significant predictors, with `fol` having a minor impact.
- **For `phs` and `hs` Pair:** Conditional probabilities reveal that `sex` and `fol` have minor but observable effects on the outcomes.
