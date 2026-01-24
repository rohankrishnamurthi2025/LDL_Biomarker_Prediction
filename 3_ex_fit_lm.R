# L03 Model workflows & recipes ----
# Purpose: Define and fit types of linear models

## load packages ----
library(tidyverse)
library(tidymodels)
library(here)


# Handle conflicts
tidymodels_prefer()

# Load training data
kc_train <- read_rds(here("data/kc_train.rds"))

# Define preprocessing/feature/engineering
# Exercise 3, task 1
kc_recipe <- recipe(price_log10 ~ waterfront + sqft_living + 
                      yr_built + bedrooms, data = kc_train) |> 
  step_dummy(waterfront)

# Check Recipe
#kc_recipe |> prep() |> bake(new_data = NULL)

# Model specifications

#1st Model: ordinary linear specification
lm_spec <- linear_reg() %>% 
  set_engine("lm") |> 
  set_mode("regression")

lm_fit <- lm_spec %>% 
  fit(price_log10 ~ waterfront + sqft_living + 
        yr_built + bedrooms, data = kc_train)


#2nd Model: ridge specification
ridge_spec <- linear_reg(mixture = 0, penalty = 0.01) %>% 
  set_engine("glmnet") |> 
  set_mode("regression")

ridge_fit <- ridge_spec %>% 
  fit(price_log10 ~ waterfront + sqft_living + 
        yr_built + bedrooms, data = kc_train)

#3rd Model: lasso specification
lasso_spec <- linear_reg(mixture = 1, penalty = 0.01) %>% 
  set_engine("glmnet") |> 
  set_mode("regression")

lasso_fit <- lasso_spec %>% 
  fit(price_log10 ~ waterfront + sqft_living + 
        yr_built + bedrooms, data = kc_train)

# Define workflows
# EX 3, task 2
lm_wflow <- workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(kc_recipe)

ridge_wflow <- workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(kc_recipe)

lasso_wflow <- workflow() |>
  add_model(lasso_spec) |>
  add_recipe(kc_recipe)


# EX 3, task 3
#fit workflows/models
fit_lm <- fit(lm_wflow, kc_train)
fit_ridge <- fit(ridge_wflow, kc_train)
fit_lasso <- fit(lasso_wflow, kc_train)

# write out fitted wflows
save(fit_lm, file = here("results/lm_fit.rda"))
save(fit_ridge, file = here("results/ridge_fit.rda"))
save(fit_lasso, file = here("results/lasso_fit.rda"))

