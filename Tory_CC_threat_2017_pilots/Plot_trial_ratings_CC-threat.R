############################################################
#                                                          #
#               Create prediction intervals                #
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

df <- read_rds('/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/trial_ratings.rds')

# Plot ratings

ggplot(data = df) +
    aes(x = trial_no,
        y = rating,
        colour = trial_type) +
    geom_point() +
    scale_colour_brewer(palette = "Set1") +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_vline(xintercept = 10.5, linetype = 3) +
    geom_vline(xintercept = 34.5, linetype = 3) +
    facet_wrap(~ id) +
    labs(title = "Ratings over course of procedure",
         subtitle = "Faceted by ID")

df_test <- df %>% filter(trial_type == "CSplus_UStest" | trial_type == "CSminus_UStest")

ggplot(data = df_test) +
    aes(x = trial_no,
        y = rating,
        colour = trial_type) +
    geom_point() +
    scale_colour_brewer(palette = "Set1") +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_vline(xintercept = 70.5, linetype = 3) +
    geom_vline(xintercept = 34.5, linetype = 3) +
    geom_vline(xintercept = 105.5, linetype = 3) +
    facet_wrap(~ id) +
    labs(title = "Ratings over course of test phases, UStest trials only",
         subtitle = "Faceted by ID")

ggplot(data = df_test) +
    aes(x = as.factor(trial_type),
        y = rating,
        colour = trial_type) +
    geom_jitter(height = 0) +
    geom_boxplot() +
    scale_colour_brewer(palette = "Set1") +
    facet_wrap(~ id) +
    labs(title = "Ratings of test stimuli according to actual trial type",
         subtitle = "Faceted by ID")

ggplot(data = df_test) +
    aes(x = as.factor(perc_trial_type),
        y = rating,
        colour = perc_trial_type) +
    geom_jitter(height = 0) +
    geom_boxplot() +
    scale_colour_brewer(palette = "Set1") +
    facet_wrap(~ id) +
    labs(title = "Ratings of test stimuli according to perceived trial type",
         subtitle = "Faceted by ID")

df_test %>% filter(!is.na(trial_type)) %>%
    ggplot(data = .) +
    aes(x = as.factor(trial_type),
        y = rating,
        colour = trial_type) +
    geom_jitter(height = 0) +
    geom_boxplot() +
    scale_colour_brewer(palette = "Set1") +
    labs(title = "Ratings of test stimuli",
         subtitle = "According to actual trial type")

df_test %>% filter(!is.na(perc_trial_type)) %>%
    ggplot(data = .) +
    aes(x = as.factor(perc_trial_type),
        y = rating,
        colour = perc_trial_type) +
    geom_jitter(height = 0) +
    geom_boxplot() +
    scale_colour_brewer(palette = "Set1") +
    labs(title = "Ratings of test stimuli",
         subtitle = "According to perceived trial type")
