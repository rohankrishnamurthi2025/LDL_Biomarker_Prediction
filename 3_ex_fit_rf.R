# L03 Model workflows & recipes ----
# Purpose: define and fit a random forest model

## load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parsnip)
library(ranger)

# Handle conflicts
tidymodels_prefer()

# Load training data
load("data-splitting/nhanes_train.rda")

# Define preprocessing/feature/engineering
kc_recipe <- recipe(price_log10 ~ waterfront + sqft_living + 
                      yr_built + bedrooms, data = kc_train) |> 
  step_dummy(waterfront)

# Check Recipe
#kc_recipe |> prep() |> bake(new_data = NULL)


#Model specifications
#4th Model: random forest model

rf_spec <- rand_forest(trees = 500, min_n = 5) %>% 
  set_engine("ranger", verbose = TRUE) %>% 
  set_mode("regression") 

rf_fit <- rf_spec %>%
  fit(price_log10 ~ waterfront + sqft_living +
        yr_built + bedrooms, data = kc_train)

# Define workflow
# EX 3, task 2
rf_wflow <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(kc_recipe)

# EX 3, task 3
#fit workflows/models
fit_rf <- fit(rf_wflow, kc_train)

# write out fitted wflows
save(fit_rf, file = ("results/rf_fit.rda"))