# File 1: Initial Set Up

# Load package(s)
library(tidymodels)
library(tidyverse)

# handle common conflicts
tidymodels_prefer()

# Set working directory
setwd("/Users/rohankrishnamurthi/Downloads/BMI 714/Final Project/final-project-rohan")

# read in data
nhanes <- read_csv(("BMI714_NHANES2020_Data.csv")) |> 
  janitor::clean_names() 

nhanes_dictionary <- read_csv(("BMI714_NHANES_VariableDictionary.csv")) |> 
  janitor::clean_names() 



# Clean up data
## EX: transform vars to log10 scale, address missingness, change var types

# Select variables of interest
nhanes_filtered <- nhanes |> 
  select()

nhanes_filtered_1 <- nhanes |> 
  select(p_ds1tot_ds1tcarb, p_ds1tot_ds1tsugr, p_ds1tot_ds1tsfat,
         p_ds1tot_ds1tmfat, p_ds1tot_ds1tpfat, p_ds1tot_ds1tfibe,
         p_ds1tot_ds1tprot, p_alq_alq121)

nhanes_expanded_1 <- nhanes |> 
  select(p_ds1tot_ds1tcarb, p_ds1tot_ds1tsugr, p_ds1tot_ds1tsfat,
         p_ds1tot_ds1tmfat, p_ds1tot_ds1tpfat, p_ds1tot_ds1tfibe,
         p_ds1tot_ds1tprot, p_alq_alq121, p_demo_ridreth3, 
         p_demo_ridreth1, p_demo_ridageyr, p_demo_riagendr)

# Split data
## Set seed for random split
set.seed(714)
nhanes_split <- nhanes |> 
  initial_split(prop = 0.8, strata = seqn)

nhanes_train <- nhanes_split |> training()
nhanes_test <- nhanes_split |> testing()

# save datasets
save(nhanes_train, file = ("data-splitting/nhanes_train.rda"))
save(nhanes_test, file = ("data-splitting/nhanes_test.rda"))

#write_rds(atp_split, file = here("atp_split.rds"))
#write_rds(atp_train, file = here("cleaned data/atp_train.rds"))
#write_rds(atp_test, file = here("cleaned data/atp_test.rds"))

# *Can Add V-fold cross-validation (v = 10 folds, 5 repeats)
# set up controls for fitted resamples ----

