
# LDL_Biomarker_Prediction

Author: Rohan Krishnamurthi

## Contents
- `data-splitting`: Data splitting files
- `recipes`: Recipes used to build models
- `results`: Predictive model results
- `BMI714_NHANES2020_Data.csv`: NHANES data used in this project
- `LDL_Biomarker.Rmd`: R Markdown file of code for this project in R

## Introduction:
The objective of this project was to build a predictive model in order to quantify the effect different biomarkers have on LDL levels. This research is imperative to better understanding the effect these biomarkers have on LDL accumulation in the body and the subsequent pathology of cardiovascular diseases. The NHANES dataset was used for this analysis, with LDL cholesterol, according to the NIH equation 2, as the outcome variable. Triglycerides, glucose, and insulin levels were selected as the first three predictors, as they are linked to the body’s lipid and glucose metabolism (Kurniawan 2024). Hemoglobin and white blood cell count were selected as the next two predictors, as they represent hematologic processes which may affect LDL levels (Ozturk 2021). Lastly, Gamma Glutamyl Transferase and Alkaline Phosphatase were selected as variables related to liver function, while creatinine was selected as a variable related to kidney function (High Cholesterol). Both of these organs are known to be related to lipid metabolism and cardiovascular risk.

## Methods:
Most variables had relatively low amounts of missingness (approximately 19% to
40%), so it was decided to select all rows of the NHANES data with complete observations for each variable. After filtering out rows with missingness, 4,521 of 15,560 rows remained. In the exploratory data analysis, LDL levels were plotted each predictor variable (Figure 1a) in order to roughly assess the relationship LDL had with each predictor. The graph shows that LDL has a weak to moderate positive relationship with each predictor. Additionally, a boxplot of the predictors’ values was created in order to compare their scales (Figure 1b). Given that disparities in their boxplots and the high degree of outliers, the predictors, all of which are numeric, were centered and scaled with a mean of 0 and a standard deviation of 1 in the subsequent recipe. The data was split into training and testing datasets, in order to build the model and then test its predictions.

<img width="219" height="133" alt="image" src="https://github.com/user-attachments/assets/f21fd0e2-1e2f-473b-8203-3d00877e7d8a" />

Figure 1a. Comparison of LDL levels with nine predictor variables. 

<img width="229" height="139" alt="image" src="https://github.com/user-attachments/assets/1740fbbc-967c-4203-9a47-b63f396a7518" />

Figure 1b. Boxplot of nine predictor variables. 

A boosted tree regression model was selected for this analysis. Given the continuity of LDL levels, a regression model was necessary. The boosted tree model in particular was chosen because it can effectively model nonlinear relationships that certain biomarkers may have with LDL levels in the body. For example, it is possible that LDL increases exponentially as the number of white blood cells increases incrementally. 
Whereas other regression models assume that variables have linear relationships, the boosted tree model combines many decision trees to capture more nuanced, non-linear relationships. Moreover, the boosted accounts for interactions between predictors that may impact the outcome variable. An additional advantage of this model is that it fits many small trees consecutively in order to reduce variance and overfitting. This is particularly useful in ensuring the model has strong predictive accuracy. While they avoid some of the assumptions of classic linear regression models, such as linear relationships, normality, and homoscedasticity of errors, they still assume that observations are independent and identically distributed. 

In the model development, the training data was split into folds for V-fold cross validation. This process reinforces the model’s performance by allowing it to iteratively train on different folds of the data. A simple recipe was made to relate the outcome to the predictors and normalize the predictors. The hyperparameters mtry, min_n, and learn_rate were fine-tuned in order to optimize the model’s performance. For context, mtry represents the number of predictors sampled at each split, min_n represents the minimum number of data points in a node for it to be split, and learn_rate represents the rate at which the algorithm adapts from iterations. These parameters collectively affect the model’s complexity and stability, so fine-tuning them can have a great impact on the model’s performance. A workflow was made with the simple recipe and model specifications, which was then fitted on the training data to make the model. 

## Results
The performance metrics of the model with each combination of hyperparameters was extracted. The combination with the lowest average RMSE across folds included an mtry of 1, a min_n of 30, and a learn_rate of 0.631. The model was retrained with that combination of hyperparameters only, and the predictions of the LDL levels using the testing data were collected. The comparison of the predicted and actual LDL values had an RMSE of 0.8598 mg. Given that the mean LDL value in the dataset is 2.77 mg and the standard deviation of 0.93 mg, the boosted tree model had fairly strong predictions.

<img width="226" height="142" alt="image" src="https://github.com/user-attachments/assets/c243ef97-16ae-4277-8d0a-55597ab25df2" />

Figure 2a. Original boosted tree model’s LDL predictions.

<img width="225" height="139" alt="image" src="https://github.com/user-attachments/assets/1d086c97-4c0e-4135-952f-57772fc9833d" />

Figure 2b. Secondary boosted tree model’s LDL predictions.


## Secondary Model:
In the secondary model, it was chosen to incorporate three confounder variables
in the analysis: age, gender, and race. The impact of these variables on LDL levels and the predictors themselves remains unclear in research, so it is important to understand their confounding effect. The model development process was repeated with these three predictors added. Given that gender and race are categorical variables, they were converted into dummy variables in the recipe process. The best performing set of hyperparameters involved an mtry of 1, a min_n of 40, and a learn_rate of 0.631, very similar to the first model. After using the extended model to make predictions on the testing data, the resulting predictions had an RMSE of 0.859 mg, similar to the first model. The results suggest that the addition of confounders had little to no impact on model performance.

## Follow-Up Analysis:
A two-sided student’s t-test was performed to see if the incorporation of the three
confounder variables had a positive impact on the boosted tree model’s performance, or more specifically, the error in its predictions. The differences in the predicted and actual LDL values for each model were compared in the t-test. The null hypothesis was that the incorporation of the confounders has no effect on lowering the prediction errors, while the alternative hypothesis was that the incorporation of the confounders significantly lowers the prediction errors. A significance threshold of 0.05 was used. The t-test output a p-value of 0.449, indicating that the results were not significant and the null hypothesis cannot be rejected.

## References
- High Cholesterol and Kidney Disease. National Kidney Federation. (n.d.). https://www.kidney.org.uk/blogs/high-cholesterol-and-kidney-disease
- Kurniawan L. B. (2024). Triglyceride-Glucose Index As A Biomarker Of Insulin
Resistance, Diabetes Mellitus, Metabolic Syndrome, And Cardiovascular Disease: A
Review. EJIFCC, 35(1), 44–51.
- Ozturk E. (2021). The Relationship Between Hematological Malignancy and Lipid
Profile. Medeniyet medical journal, 36(2), 146 151.
https://doi.org/10.5222/MMJ.2021.91145
- U.S. National Library of Medicine. (n.d.). LDL: The “bad” cholesterol. MedlinePlus. https://medlineplus.gov/ldlthebadcholesterol.html
- What’s So Bad about LDL? Cleveland Clinic. (2025, December 9). https://my.clevelandclinic.org/health/articles/24391-ldl-cholesterol






This project was conducted as a part of BMI 714: Advanced Coding and Statistics for Biomedical Informatics at Harvard Medical School.
