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

df <- read_rds('/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/expect_ratings.rds')

# Plot ratings

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
       subtitle = "Coloured by CS being asked about")

# Use trelliscope

library(trelliscopejs)

df_post_acq <- df %>% filter(measurement < 7  & measurement > 3)

ggplot(data = df_post_acq) +
  aes(x = measurement,
      y = rating,
      colour = CS) +
  geom_point() +
  geom_smooth(se = FALSE) +
  scale_colour_brewer(palette = "Set1") +
  facet_wrap(~ id) +
  labs(title = "Expectancy ratings over course of procedure",
       subtitle = "Coloured by CS being asked about")

ggplot(data = df_medians) +
  aes(x = measurement,
      y = median_rating,
      group = CS,
      colour = CS) +
  geom_errorbar() +
  scale_colour_brewer(palette = "Set1") +
  geom_vline(xintercept = 4, linetype = 3) +
  labs(title = "Expectancy ratings over course of procedure",
       subtitle = "Coloured by CS being asked about")

# Did expectancy relate to whether or not any CC effect was seen?  Combine data frame from FEST ratings with classification of participants as having an effect or no effect (defn: ANY CS+/UStest trials falling outside prediction interval for CS-/UStest trials) with the data frame for expectancies.  Use left-join.

# Import FEST data

df_FEST <- read_rds('./Juliane_Masters/data/Juliane_raw_as_perc.rds') %>% select(-CS, -rating)

# Mutate new column for ANY trial showing CC effect

df_FEST %<>% group_by(id) %>%
  mutate(foo = ifelse(CC_effect == "yes",
                      yes = 1,
                      no = 0)) %>%
  mutate(CC_effect_class = ifelse(sum(foo) > 0,
                                yes = "yes",
                                no = "no"))
                                
# Left-join

df_joined <- df_post_acq %>%
  left_join(df_FEST)

# Plot together

df_joined %>%
  ggplot(.) +
  aes(x = measurement,
      y = rating,
      colour = CS) +
  geom_rect(aes(xmin = 4,
            xmax = 6,
            ymin = 0,
            ymax = 10,
            fill = CC_effect_class)) +
  geom_point(aes(x = measurement,
             y = rating,
             colour = CS)) +
  geom_smooth(aes(x = measurement,
              y = rating,
              colour = CS)) +
  scale_fill_brewer(palette = "Set3") +
  facet_wrap(~ id) +
  labs(title = "Expectancy ratings after acquisition, test 1 and test 2",
       subtitle = "Background colour shows presence/absence of CC_effect(loose defn)",
       x = "Time of expectancy measurement",
       y = "Expectancy rating on 0-10 VAS")
