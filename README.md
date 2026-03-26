
# LDL_Biomarker_Prediction

Author: Rohan Krishnamurthi

## Introduction:
The objective of this project was to build a predictive model in order to quantify the effect different biomarkers have on LDL levels. This research is imperative to better understanding the effect these biomarkers have on LDL accumulation in the body and the subsequent pathology of cardiovascular diseases. The NHANES dataset was used for this analysis, with LDL cholesterol, according to the NIH equation 2, as the outcome variable. Triglycerides, glucose, and insulin levels were selected as the first three predictors, as they are linked to the body’s lipid and glucose metabolism (Kurniawan 2024). Hemoglobin and white blood cell count were selected as the next two predictors, as they represent hematologic processes which may affect LDL levels (Ozturk 2021). Lastly, Gamma Glutamyl Transferase and Alkaline Phosphatase were selected as variables related to liver function, while creatinine was selected as a variable related to kidney function (High Cholesterol). Both of these organs are known to be related to lipid metabolism and cardiovascular risk.

## Methods:
Most variables had relatively low amounts of missingness (approximately 19% to
40%), so it was decided to select all rows of the NHANES data with complete observations for each variable. After filtering out rows with missingness, 4,521 of 15,560 rows remained. In the exploratory data analysis, LDL levels were plotted each predictor variable (Figure 1a) in order to roughly assess the relationship LDL had with each predictor. The graph shows that LDL has a weak to moderate positive relationship with each predictor. Additionally, a boxplot of the predictors’ values was created in order to compare their scales (Figure 1b). Given that disparities in their boxplots and the high degree of outliers, the predictors, all of which are numeric, were centered and scaled with a mean of 0 and a standard deviation of 1 in the subsequent recipe. The data was split into training and testing datasets, in order to build the model and then test its predictions.

<img width="219" height="133" alt="image" src="https://github.com/user-attachments/assets/f21fd0e2-1e2f-473b-8203-3d00877e7d8a" />
Figure 1a. Comparison of LDL levels with nine predictor variables. 

<img width="468" height="53" alt="image" src="https://github.com/user-attachments/assets/f9e845bd-2c68-4427-a650-595f9081da6a" />

<img width="229" height="139" alt="image" src="https://github.com/user-attachments/assets/1740fbbc-967c-4203-9a47-b63f396a7518" />
Figure 1b. Boxplot of nine predictor variables. 

A boosted tree regression model was selected for this analysis. Given the continuity of LDL levels, a regression model was necessary. The boosted tree model in particular was chosen because it can effectively model nonlinear relationships that certain biomarkers may have with LDL levels in the body. For example, it is possible that LDL increases exponentially as the number of white blood cells increases incrementally. 
Whereas other regression models assume that variables have linear relationships, the boosted tree model combines many decision trees to capture more nuanced, non-linear relationships. Moreover, the boosted accounts for interactions between predictors that may impact the outcome variable. An additional advantage of this model is that it fits many small trees consecutively in order to reduce variance and overfitting. This is particularly useful in ensuring the model has strong predictive accuracy. While they avoid some of the assumptions of classic linear regression models, such as linear relationships, normality, and homoscedasticity of errors, they still assume that observations are independent and identically distributed. 

In the model development, the training data was split into folds for V-fold cross validation. This process reinforces the model’s performance by allowing it to iteratively train on different folds of the data. A simple recipe was made to relate the outcome to the predictors and normalize the predictors. The hyperparameters mtry, min_n, and learn_rate were fine-tuned in order to optimize the model’s performance. For context, mtry represents the number of predictors sampled at each split, min_n represents the minimum number of data points in a node for it to be split, and learn_rate represents the rate at which the algorithm adapts from iterations. These parameters collectively affect the model’s complexity and stability, so fine-tuning them can have a great impact on the model’s performance. A workflow was made with the simple recipe and model specifications, which was then fitted on the training data to make the model. 
<img width="468" height="370" alt="image" src="https://github.com/user-attachments/assets/fd6cb145-213e-489f-9392-df859cfc1096" />



This project was conducted as a part of BMI 714: Advanced Coding and Statistics for Biomedical Informatics at Harvard Medical School.
