############################################################
#                                                          #
#                   Import and tidy data                   #
#                                                          #
############################################################

# Load packages
library(readr)
library(tidyverse)
library(dplyr)
library(tidyr)
library(magrittr)

# Import data

df <- read.csv('/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/trial_ratings.txt', header = TRUE, sep = "\t")

df <- df %>% mutate(id = 1)

df %<>% rename(block_number = block.number,
                   trial_number = trial.number)

df %<>% mutate(CS = ifelse(is_CSplus == 1,
                               yes = "CSplus",
                               no = ifelse(is_CSmin == 1,
                                           yes = "CSminus",
                                           no = NA)))

df %<>% mutate(US = ifelse(do_pulse1 == 1,
                               yes = "low",
                               no = ifelse(do_pulse3 == 1,
                                           yes = "test",
                                           no = ifelse(do_pulse5 == 1,
                                                       yes = "high",
                                                       no = NA))))

df %<>% mutate(tactor_active = ifelse(do_tactor1 == 1,
                                          yes = 1,
                                          no = ifelse(do_tactor2 == 1,
                                                      yes = 2,
                                                      no = ifelse(do_tactor3 == 1,
                                                                  yes = 3,
                                                                  no = NA))))

df %<>% mutate(button_correct = ifelse(button == tactor_active,
                                           yes = "correct",
                                           no = "incorrect"))

df %<>% mutate(button_choice = ifelse(button == 1,
                                          yes = "above",
                                          no = ifelse(button == 2,
                                                      yes = "below",
                                                      no = NA)))

df %<>% mutate(block_number = ifelse(block_number == 2,
                                         yes = "baseline",
                                         no = ifelse(block_number == 4,
                                                     yes = "acq1",
                                                     no = ifelse(block_number == 7,
                                                                 yes = "acq2",
                                                                 no = ifelse(block_number == 10,
                                                                             yes = "acq3",
                                                                             no = ifelse(block_number == 13,
                                                                                         yes = "test1",
                                                                                         no = ifelse(block_number == 16,
                                                                                                     yes = "test2",
                                                                                                     no = "test3")))))))

df %<>% 
    mutate(trial_type = case_when(
        CS == "CSplus" & is.na(US) ~ "CSplus_only",
        CS == "CSminus" & is.na(US) ~ "CSminus_only",
        CS == "CSplus" & US == "high" ~ "CSplus_UShigh",
        CS == "CSminus" & US == "low" ~ "CSminus_USlow",
        CS == "CSplus" & US == "test" ~ "CSplus_UStest",
        CS == "CSminus" & US == "test" ~ "CSminus_UStest"))

df %<>% 
    mutate(CSplus_location = ifelse(is_CSplus == do_tactor1,
                                    yes = "above",
                                    no = "below"))

df %<>% 
    mutate(perc_CS = case_when(
        CS == "CSplus" & CSplus_location == "above" & button_choice == "above" ~ "CSplus",
        CS == "CSminus" & CSplus_location == "above" & button_choice == "above" ~ "CSplus",
        CS == "CSplus" & CSplus_location == "below" & button_choice == "above" ~ "CSminus",
        CS == "CSminus" & CSplus_location == "below" & button_choice == "above" ~ "CSminus",
        CS == "CSplus" & CSplus_location == "above" & button_choice == "below" ~ "CSminus",
        CS == "CSminus" & CSplus_location == "above" & button_choice == "below" ~ "CSminus",
        CS == "CSplus" & CSplus_location == "below" & button_choice == "below" ~ "CSplus",
        CS == "CSminus" & CSplus_location == "below" & button_choice == "below" ~ "CSplus"))

df %<>% 
    mutate(perc_trial_type = case_when(
        perc_CS == "CSplus" & is.na(US) ~ "CSplus_only",
        perc_CS == "CSminus" & is.na(US) ~ "CSminus_only",
        perc_CS == "CSplus" & US == "high" ~ "CSplus_UShigh",
        perc_CS == "CSminus" & US == "low" ~ "CSminus_USlow",
        perc_CS == "CSplus" & US == "test" ~ "CSplus_UStest",
        perc_CS == "CSminus" & US == "test" ~ "CSminus_UStest",
        perc_CS == "CSplus" & US == "low" ~ "CSplus_USlow",
        perc_CS == "CSminus" & US == "high" ~ "CSlow_UShigh"))

df %<>% group_by(id) %>% mutate(trial_no = row_number())

df %<>% select(id,
                   block_number,
                   trial_no,
                   trial_type,
                   perc_trial_type,
                   CS, 
                   US, 
                   rating,
                   rating_time,
                   button_correct,
                   button_time)

# Save outputs

write_rds(x = df, 
          path = '/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/trial_ratings.rds')
write_csv(x = df,
          path = '/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/trial_ratings.csv')

############################################################
#                                                          #
#     Import and tidy expectancy ratings data              #
#                                                          #
############################################################

# Load packages
library(readr)
library(tidyverse)
library(dplyr)
library(tidyr)
library(magrittr)

# Import data

df_exp <- read.csv('/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/expectancy_ratings.txt', header = TRUE, sep = "\t")

df_exp <- df_exp %>% mutate(id = 1)

df_exp %<>% rename(block_number = block.number,
                   trial_number = trial.number)

df_exp %<>% mutate(block = ifelse(block_number == 14,
                                  yes = "BL_acq1",
                                  no = ifelse(block_number == 17,
                                              yes = "acq1_2",
                                              no = ifelse(block_number == 20,
                                                          yes = "acq2_3",
                                                          no = ifelse(block_number == 26,
                                                                      yes = "acq_test",
                                                                      no = ifelse(block_number == 29,
                                                                                  yes = "test1_2",
                                                                                  no = ifelse(block_number == 32,
                                                                                              yes = "test2_3",
                                                                                              no = "after_test3")))))))

df_exp %<>% 
    mutate(measurement = case_when(
        block_number == 14 ~ 1,
        block_number == 17 ~ 2,
        block_number == 20 ~ 3,
        block_number == 26 ~ 4,
        block_number == 29 ~ 5,
        block_number == 32 ~ 6,
        block_number == 34 ~ 7))

df_exp %<>% mutate(tactor = ifelse(boven == 1,
                                   yes = "above",
                                   no = ifelse(beneden == 1,
                                               yes = "below",
                                               no = NA)))

df_exp %<>% mutate(rating = ifelse(is.na(above),
                                   yes = below,
                                   no = ifelse(is.na(below),
                                               yes = above,
                                               no = NA)))
df_exp %<>% 
    mutate(group = case_when(
        id == 1 ~ 2))

df_exp %<>% 
    mutate(CS = case_when(
        group == 1 & tactor == "above" ~ "CSplus",
        group == 1 & tactor == "below" ~ "CSminus",
        group == 2 & tactor == "above" ~ "CSminus",
        group == 2 & tactor == "below" ~ "CSplus"))

df_exp %<>% select(id,
                   block,
                   measurement,
                   CS,
                   rating,
                   group,
                   tactor)

# Save outputs

write_rds(x = df_exp, 
          path = '/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/expect_ratings.rds')
write_csv(x = df_exp,
          path = '/Volumes/ADATA UFD/CC-thr for Belgium/CC-thr_31102017--results/RM031117_pilot_RM031117_pilot_2/expect_ratings.csv')
