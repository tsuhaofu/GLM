# GLM-Projects

## Analysis of the minn38 Dataset Using Log-Linear Models and Proportional Odds Models
This project conducts a comprehensive analysis of the `minn38` dataset available in the `MASS` package in R. The main focus is to understand how post-high-school (phs) statuses are influenced by various factors such as high school rank (hs), father's occupational level (fol), and sex. Additionally, the joint effect of phs and hs, conditioned on other factors, is explored. The analysis also includes fitting proportional odds models to understand the effect of `fol` and `sex` on `hs`.

### Objective

The `minn38` dataset contains information about Minnesota high school graduates of 1938, classified according to four factors (`phs`, `hs`, `fol`, `sex`). This analysis aims to explore:
1. How `phs` is affected by `hs`, `fol`, and `sex`.
2. How the joint status of `phs` and `hs` is influenced by `fol` and `sex`.
3. How `hs` is influenced by `fol` and `sex` using proportional odds models.

### Data

The analysis is based on the `minn38` dataset, which includes:
- `phs`: Post-high school status of the graduates.
- `hs`: High school rank of the graduates.
- `fol`: Father's occupational level.
- `sex`: Sex of the graduate.
- `Freq`: Frequency of each category.

### Methodology

### For Log-Linear Models
1. **Initial Model Building:** Start with minimal models assuming independence and then gradually add interaction terms based on residual deviance and AIC.
2. **Stepwise Model Selection:** Use the `step()` function to perform a stepwise selection to find a more optimal model by AIC.
3. **Model Refinement:** Utilize `drop1()` and `add1()` to explore nearby models that might offer better interpretability or significance.
4. **Final Model Selection:** Choose the final model based on AIC, log-likelihood tests, and interpretability.
5. **Presentation of Results:** Estimated cell probabilities are presented to show the effect of the factors and their interactions.

### For Proportional Odds Models
1. **Model Fitting:** Fit both interaction and additive proportional odds models to predict `hs` based on `fol` and `sex`.
2. **Model Selection:** Compare the models based on residual deviance, AIC, and likelihood ratio tests.
3. **Chosen Model:** Select the additive model for its interpretability and comparable performance.
4. **Model Adequacy:** Assess the chosen model's fit using residual deviance and AIC.

### Results

The analysis highlights the significant factors and their interactions affecting `phs` and the pair (`phs`, `hs`). Key findings include:

- **For `phs`:** High school rank (`hs`) and `sex` are significant predictors, with `fol` having a minor impact.
- **For `phs` and `hs` Pair:** Conditional probabilities reveal that `sex` and `fol` have minor but observable effects on the outcomes.
- **For `hs` in Proportional Odds Models**: Selected the additive model with `fol` and `sex` for its clarity and performance, showing these factors independently impact hs but not all variability is captured.
