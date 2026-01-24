## EXAMPLE OF MODEL ANALYSIS
# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

#Identify number of cores and threads
library(parallel)
num_cores <- detectCores()
num_threads <- getOption("mc.cores")

install.packages("RcppParallel")
library(RcppParallel)
setNumThreads()

RcppParallel::setThreadOptions()

#Autoplot
load(here("results/bt_tuned.rda"))
load(here("results/rf_tuned.rda"))
load(here("results/knn_tuned.rda"))

bt_autoplot <- autoplot(bt_tuned, metric = "rmse")
rf_autoplot <- autoplot(rf_tuned, metric = "rmse")
knn_autoplot <- autoplot(knn_tuned, metric = "rmse")

bt_autoplot
rf_autoplot
knn_autoplot

# Select Best Parameters
select_best(bt_tuned, metric = "rmse")
select_best(rf_tuned, metric = "rmse")
select_best(knn_tuned, metric = "rmse")


# Load files/trainings for all models----
list.files(
  here("results/"),
  "_tuned.rda",
  full.names = TRUE
) |> map(load, envir = .GlobalEnv)

# boosted tree model
bt_tuned |> collect_metrics()
bt_tuned |> autoplot(metric = "rmse")

# all models
model_results <- as_workflow_set(
  knn = knn_tuned,
  rf = rf_tuned,
  bt = bt_tuned
)

model_results |> collect_metrics()

model_results |> collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err, n) |> 
  kable()

#^Will need to save this table as a tibble, .html
install.packages("kableExtra")
library(kableExtra)
model_results |> autoplot(metric = "rmse", select_best = TRUE, std_errs = 4)

#Train Best Model on Entire dataset
# Finalize workflow 
final_wflow <- bt_tuned |> 
  extract_workflow(bt_tuned) |> 
  finalize_workflow(select_best(bt_tuned, metric = "rmse"))

# train final model ----
# set seed
set.seed(123)
final_fit <- fit(final_wflow, carseats_train)

#Finalize Predictions
final_predictions <- carseats_test %>% 
  select(sales) %>% 
  bind_cols(predict(final_fit, carseats_test))

#Assess model performance
get_metrics <- metric_set(rmse, rsq, mae)
pred_metrics <- as.data.frame(get_metrics(final_predictions, truth = sales, estimate = .pred))
pred_metrics

#Final plot: predictions vs observed
sales_plot <- final_predictions |> ggplot(aes(x = sales, y = .pred)) +
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Sales", x = "Sales")

sales_plot

## CAN ALSO MAKE A METRICS TABLE
