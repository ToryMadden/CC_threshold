############################################################
#                                                          #
#              Statistical power simulations               #
#                                                          #
############################################################

# Load packages
library(tidyverse)
library(magrittr)
library(lme4)
library(lmerTest)
library(simr)

# Load data
df_cc <- readr::read_rds('./Juliane_Masters/data/Juliane_raw.rds')

# Inspect
dim(df_cc)
head(df_cc)
glimpse(df_cc)

unique(as.factor(df_cc$US))
unique(as.factor(df_cc$CS))
