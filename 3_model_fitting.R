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

