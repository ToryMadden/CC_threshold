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

df <- read.csv('/Users/tory/Google Drive/Git/CC_threshold/Juliane_all_data/data/R_data_complete_dataset_ratings')

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

# Prediction intervals for test trials as DELIVERED
df_prediction <- df_test %>%
  # Filter for CSminus_UStest
  filter(trial_type == 'CSminus_UStest' & id != 23) %>%
  # Calculate 95% prediction interval 
  group_by(id) %>%
  dplyr::summarise(lower_pi = mean(rating, na.rm = TRUE) - 1.96 * (sd(rating, na.rm = TRUE)),
            upper_pi = mean(rating, na.rm = TRUE) + 1.96 * (sd(rating, na.rm = TRUE))) %>%
  # Truncate PIs at +50 and -50
  mutate(lower_pi = ifelse(lower_pi < -50,
                           yes = -50,
                           no = lower_pi),
         upper_pi = ifelse(upper_pi > 50,
                           yes = 50,
                           no = upper_pi)) %>%
  # Join back with df_test
  left_join(df_test) %>%
  # Is CSplus_UStest within the prediction interval
  mutate(CC_effect = ifelse(rating > upper_pi,
                               yes = 'yes',
                               no = 'no')) %>%
  # Filter for CSplus_UStest
  filter(trial_type == 'CSplus_UStest') 

ggplot(data = df_prediction) +
  aes(x = as.factor(id),
      y = rating) +
  geom_jitter(aes(colour = CC_effect),
             height = 0) +
  geom_errorbar(aes(ymin = lower_pi,
                    ymax = upper_pi)) +
  ylim(-50, 50) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_colour_brewer(palette = "Set1") +
  coord_flip() +
  labs(title = 'Prediction interval for CSminus_UStest trial ratings',
       subtitle = 'Points are individual CSplus_UStest trial ratings',
       y = 'FEST rating',
       x = 'Participant ID')

# Prediction intervals for test trials as PERCEIVED

id_19 <- df_test %>% filter(id == 19)

plot(id_19$rating, id_19$trial_no)

df_prediction_perc <- df_test %>%
  filter(!is.na(perc_trial_type)) %>%
  # Filter for CSminus_UStest
  filter(perc_trial_type == 'CSminus_UStest' & id != 23 & id != 19) %>%
  # Calculate 95% prediction interval 
  group_by(id) %>%
  summarise(lower_pi = mean(rating, na.rm = TRUE) - 1.96 * (sd(rating, na.rm = TRUE)),
            upper_pi = mean(rating, na.rm = TRUE) + 1.96 * (sd(rating, na.rm = TRUE))) %>%
  # Truncate PIs at +50 and -50
  mutate(lower_pi = ifelse(lower_pi < -50,
                           yes = -50,
                           no = lower_pi),
         upper_pi = ifelse(upper_pi > 50,
                           yes = 50,
                           no = upper_pi)) %>%
  # Join back with df_test
  left_join(df_test) %>%
  # Is CSplus_UStest within the prediction interval
  mutate(CC_effect = ifelse(rating > upper_pi,
                            yes = 'yes',
                            no = 'no')) %>%
  # Filter for CSplus_UStest
  filter(perc_trial_type == 'CSplus_UStest') 

# Save file df_prediction_perc

write_rds(x = df_prediction_perc,
          path = './Juliane_all_data/data/Juliane_raw_as_perc.rds')

ggplot(data = df_prediction_perc) +
  aes(x = as.factor(id),
      y = rating) +
  geom_jitter(aes(colour = CC_effect),
              height = 0) +
  geom_errorbar(aes(ymin = lower_pi,
                    ymax = upper_pi)) +
  ylim(-50, 50) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_colour_brewer(palette = "Set1") +
  coord_flip() +
  labs(title = 'Prediction interval for ratings of trials perceived as CSminus_UStest ',
       subtitle = 'Points are individual CSplus_UStest (percieved) trial ratings',
       y = 'FEST rating',
       x = 'Participant ID')

# Prediction intervals for all reinforced (CS+/USH or CS-/USL) trials

df_prediction_reinf <- df %>%
  # Filter for CSminus_USlow
  filter(trial_type == 'CSminus_USlow' & id != 23) %>%
  # Calculate 95% prediction interval 
  group_by(id) %>%
  dplyr::summarise(lower_pi = mean(rating, na.rm = TRUE) - 1.96 * (sd(rating, na.rm = TRUE)),
            upper_pi = mean(rating, na.rm = TRUE) + 1.96 * (sd(rating, na.rm = TRUE))) %>%
  # Truncate PIs at +50 and -50
  mutate(lower_pi = ifelse(lower_pi < -50,
                           yes = -50,
                           no = lower_pi),
         upper_pi = ifelse(upper_pi > 50,
                           yes = 50,
                           no = upper_pi)) %>%
  # Join back with df_test
  left_join(df) %>%
  # Is CSplus_UShigh within the prediction interval
  mutate(diff_intensities = ifelse(rating > upper_pi,
                            yes = 'yes',
                            no = 'no')) %>%
  # Filter for CSplus_UShigh
  filter(trial_type == 'CSplus_UShigh') 

ggplot(data = df_prediction_reinf) +
  aes(x = as.factor(id),
      y = rating) +
  geom_jitter(aes(colour = diff_intensities),
              height = 0) +
  geom_errorbar(aes(ymin = lower_pi,
                    ymax = upper_pi)) +
  ylim(-50, 50) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_colour_brewer(palette = "Set1") +
  coord_flip() +
  labs(title = 'Prediction interval for CSminus_USlow trial ratings',
       subtitle = 'Points are individual CSplus_UShigh trial ratings',
       y = 'FEST rating',
       x = 'Participant ID')

# Calibration was poor.  However, participants 11, 15 and 26 have a prediction interval for their CS-/USlow trials that does not cross zero, and they also show no CC effect according to the previous plot.
