############################################################
#                                                          #
#                  Plot expectancy ratings                 #
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

df <- read_csv('/Users/tory/Google Drive/Git/CC_threshold/Juliane_all_data/data/R_data_complete_expectancies')

# Plot ratings

df_medians <- df %>% filter(!is.na(rating)) %>%
                               group_by(measurement, CS) %>%
  summarise(median_rating = median(rating))

df %>%
  ggplot(data = .) +
  aes(x = measurement,
      y = rating,
      colour = CS) +
  geom_point() +
  geom_smooth(se = FALSE) +
  scale_colour_brewer(palette = "Set1") +
  geom_vline(xintercept = 4, linetype = 3) +
  facet_wrap(~ id) +
  labs(title = "Expectancy ratings over course of procedure",
       subtitle = "Faceted by participant ID; coloured by CS being asked about; vertical stippled line is ratings taken between acquisition and test phases")

# Use trelliscope

library(trelliscope)

df_post_acq <- df %>% filter(measurement < 8  & measurement > 3)

ggplot(data = df_post_acq) +
  aes(x = measurement,
      y = rating,
      colour = CS) +
  geom_point() +
  geom_smooth(se = FALSE) +
  scale_colour_brewer(palette = "Set1") +
    geom_vline(xintercept = 4.5, linetype = 3) +
  facet_wrap(~ id) +
  labs(title = "Expectancy ratings from immediately after acquisition, through test phase, to after test phase",
       subtitle = "Faceted by participant ID; coloured by CS being asked about; vertical stippled line shows the first block of test phase")

ggplot(data = df_medians) +
  aes(x = measurement,
      y = median_rating,
      group = CS,
      colour = CS) +
  geom_boxplot() +
  scale_colour_brewer(palette = "Set1") +
  geom_vline(xintercept = 4, linetype = 3) +
  labs(title = "Expectancy ratings averaged across whole procedure; whole sample",
       subtitle = "Coloured by CS being asked about")

df_post_acq_medians <- df_medians %>% filter(measurement < 8  & measurement > 3)

ggplot(data = df_post_acq_medians) +
    aes(x = measurement,
        y = median_rating,
        group = CS,
        colour = CS) +
    geom_boxplot() +
    scale_colour_brewer(palette = "Set1") +
    geom_vline(xintercept = 4, linetype = 3) +
    labs(title = "Expectancy ratings averaged from post-acquisition and test phase ratings; whole sample",
         subtitle = "Coloured by CS being asked about")

