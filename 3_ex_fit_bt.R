## BOOSTED TREE EXAMPLE
# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
install.packages("xgboost")
library(xgboost)

# handle common conflicts
tidymodels_prefer()

# load training data
#load(here("data/carseats_train.rds"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load pre-processing/feature engineering/recipe
load(here("recipes/carseats_recipe.rda"))

# model specifications ----
bt_spec <- boost_tree(
  min_n = tune(),
  mtry = tune(),
  learn_rate = tune()
) |> 
  set_mode("regression") |> 
  set_engine("xgboost")

# define workflows ----
bt_wflow <- workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(carseats_recipe)

# hyperparameter tuning values ----
# Check rangers for hyperparameters
hardhat::extract_parameter_set_dials(bt_spec)

# Change hyperparameter ranges
bt_params <- hardhat::extract_parameter_set_dials(bt_spec) |> 
  update(mtry = mtry(c(1,10)), learn_rate = learn_rate(c(-5, -0.2)))

# Build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
set.seed(111)
bt_tuned <- bt_wflow |> 
  tune_grid(carseats_folds, grid = bt_grid, control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(bt_tuned, file = here("results/bt_tuned.rda"))

load(bt)

## RF EXAMPLE


# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
install.packages("doMC")
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load training data
#load(here("data/carseats_train.rds"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load pre-processing/feature engineering/recipe
load(here("recipes/carseats_recipe.rda"))

# model specifications ----
rf_spec <- rand_forest(trees = 1000, min_n = tune(), mtry = tune()) |> 
  set_mode("regression") |> 
  set_engine("ranger")

# define workflows ----
rf_wflow <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(carseats_recipe)

# hyperparameter tuning values ----
#check rangers for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec)

# change hyperparameter ranges
rf_params <- hardhat::extract_parameter_set_dials(rf_spec) |> 
  update(mtry = mtry(c(1, 10)))

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

#25 grid points: 5 by 5 (25 models)

# fit workflows/models ----
set.seed(111)
# rf_tuned <- rf_wflow |> 
#   tune_grid(carseats_folds, grid = rf_grid, control = keep_wflow)

rf_tuned <- rf_wflow |> 
  tune_grid(carseats_folds, grid = rf_grid, control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----