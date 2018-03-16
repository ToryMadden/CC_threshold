############################################################
#                                                          #
#      Check for possible location bias in test phase      #
#                                                          #
############################################################

# Load packages
library(readr)
library(tidyverse)
library(dplyr)
library(tidyr)
library(magrittr)
library(RColorBrewer)
library(ggplot2)

# Import data

df <- read_rds(path = './Tory_CC_laser_2015/data/FEST_ratings.rds')


str(df)
head(df)

df %<>% mutate(rated_painful = case_when(
    rating > 0 ~ "yes",
    rating <= 0 ~ "no"))

df_testtrials <- df %>% filter(trial_type == "CSplus_UStest" | trial_type == "CSminus_UStest")
str(df_testtrials)

df_testtrials$trial_type <- factor(df_testtrials$trial_type)
df_testtrials$id <- factor(df_testtrials$id)
df_testtrials$Csplus_location <- factor(df_testtrials$Csplus_location)

mosaicplot((xtabs(~ Csplus_location + rated_painful, df_testtrials)))
mosaicplot((xtabs(~ trial_type + rated_painful, df_testtrials)))


# To use a paired t-test, we first have to convert the binary variable to a percentage for each participant.

df_testtrials %<>% mutate(painful = case_when(
    rated_painful == "yes" ~ 1,
    rated_painful == "no" ~ 0
))

df_temp <- df_testtrials %>% group_by(id, trial_type) %>%
    summarise(sum_painful = sum(painful)) %>%
    mutate(perc_painful = sum_painful/30) 

df_ttest <- spread(data = df_temp,
                key = trial_type,
                value = perc_painful) %>%
    select(-sum_painful)

df_ttest %<>% group_by(id) %>% summarise_all(funs(sum(., na.rm=TRUE))) 

t.test(df_ttest$CSplus_UStest, 
       df_ttest$CSminus_UStest,
       paired=TRUE, 
       conf.level=0.95)

# Substitute bias term

df_testtrials %<>% 
    mutate(trial_location = case_when(
           trial_type == "CSplus_UStest" & Csplus_location == "head" ~ "above",
           trial_type == "CSminus_UStest" & Csplus_location == "head" ~ "below",
           trial_type == "CSplus_UStest" & Csplus_location == "feet" ~ "below",
           trial_type == "CSminus_UStest" & Csplus_location == "feet" ~ "above"))

df_biastemp <- df_testtrials %>% group_by(id, trial_location) %>%
    summarise(sum_painful = sum(painful)) %>%
    mutate(perc_painful = sum_painful/30) 

df_biasttest <- spread(data = df_biastemp,
                   key = trial_location,
                   value = perc_painful) %>%
    select(-sum_painful)

df_biasttest %<>% group_by(id) %>% summarise_all(funs(sum(., na.rm=TRUE))) 

t.test(df_biasttest$above, 
       df_biasttest$below,
       paired=TRUE, 
       conf.level=0.95)
# Interpretation: no systematic bias by location