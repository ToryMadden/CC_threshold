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

df8 <- read.csv('./Juliane_Masters/data/raw data/Ccp_008_1/Ccp_008_trial_ratings.txt', header = TRUE, sep = "\t")
df9 <- read.csv('./Juliane_Masters/data/raw data/Ccp_009_2/trial_ratings.txt', header = TRUE, sep = "\t")
df10 <- read.csv('./Juliane_Masters/data/raw data/Ccp_010_2/trial_ratings.txt', header = TRUE, sep = "\t")
df11 <- read.csv('./Juliane_Masters/data/raw data/Ccp_011_1/trial_ratings.txt', header = TRUE, sep = "\t")
df12 <- read.csv('./Juliane_Masters/data/raw data/Ccp_012_1/trial_ratings.txt', header = TRUE, sep = "\t")
df14 <- read.csv('./Juliane_Masters/data/raw data/Ccp_014_2/trial_ratings.txt', header = TRUE, sep = "\t")
df15 <- read.csv('./Juliane_Masters/data/raw data/Ccp_015_2/trial_ratings.txt', header = TRUE, sep = "\t")
df16 <- read.csv('./Juliane_Masters/data/raw data/Ccp_016_2/trial_ratings.txt', header = TRUE, sep = "\t")
df17 <- read.csv('./Juliane_Masters/data/raw data/Ccp_017_1/trial_ratings.txt', header = TRUE, sep = "\t")
df19 <- read.csv('./Juliane_Masters/data/raw data/Ccp_019_2/trial_ratings.txt', header = TRUE, sep = "\t")
df21 <- read.csv('./Juliane_Masters/data/raw data/Ccp_021_1/trial_ratings.txt', header = TRUE, sep = "\t")
df22 <- read.csv('./Juliane_Masters/data/raw data/Ccp_022_2/trial_ratings.txt', header = TRUE, sep = "\t")
df23 <- read.csv('./Juliane_Masters/data/raw data/Ccp_023_2/trial_ratings.txt', header = TRUE, sep = "\t")
df24 <- read.csv('./Juliane_Masters/data/raw data/Ccp_024_2/trial_ratings.txt', header = TRUE, sep = "\t")
df25 <- read.csv('./Juliane_Masters/data/raw data/Ccp_025_1/trial_ratings.txt', header = TRUE, sep = "\t")
df26 <- read.csv('./Juliane_Masters/data/raw data/Ccp_026_1/trial_ratings.txt', header = TRUE, sep = "\t")
df27 <- read.csv('./Juliane_Masters/data/raw data/Ccp_027_2/trial_ratings.txt', header = TRUE, sep = "\t")
df28 <- read.csv('./Juliane_Masters/data/raw data/Ccp_028_2/trial_ratings.txt', header = TRUE, sep = "\t")
df29 <- read.csv('./Juliane_Masters/data/raw data/Ccp_029_1/trial_ratings.txt', header = TRUE, sep = "\t")
df30 <- read.csv('./Juliane_Masters/data/raw data/Ccp_030_1/trial_ratings.txt', header = TRUE, sep = "\t")

df8 <- df8 %>% mutate(id = 8)
df9 <- df9 %>% mutate(id = 9)
df10 <- df10 %>% mutate(id = 10)
df11 <- df11 %>% mutate(id = 11)
df12 <- df12 %>% mutate(id = 12)
df14 <- df14 %>% mutate(id = 14)
df15 <- df15 %>% mutate(id = 15)
df16 <- df16 %>% mutate(id = 16)
df17 <- df17 %>% mutate(id = 17)
df19 <- df19 %>% mutate(id = 19)
df21 <- df21 %>% mutate(id = 21)
df22 <- df22 %>% mutate(id = 22)
df23 <- df23 %>% mutate(id = 23)
df24 <- df24 %>% mutate(id = 24)
df25 <- df25 %>% mutate(id = 25)
df26 <- df26 %>% mutate(id = 26)
df27 <- df27 %>% mutate(id = 27)
df28 <- df28 %>% mutate(id = 28)
df29 <- df29 %>% mutate(id = 29)
df30 <- df30 %>% mutate(id = 30)

df_all <- rbind(df8, df9, df10, df11, df12, df14, df15, df16, df17, df19, df21, df22, df23, df24, df25, df26, df27, df28, df29, df30)

df_all %<>% rename(block_number = block.number,
                   trial_number = trial.number)

df_all %<>% mutate(CS = ifelse(is_CSplus == 1,
                               yes = "CSplus",
                               no = ifelse(is_CSmin == 1,
                                           yes = "CSminus",
                                           no = NA)))

df_all %<>% mutate(US = ifelse(do_pulse1 == 1,
                               yes = "low",
                               no = ifelse(do_pulse3 == 1,
                                           yes = "test",
                                           no = ifelse(do_pulse5 == 1,
                                                       yes = "high",
                                                       no = NA))))

df_all %<>% mutate(tactor_active = ifelse(do_tactor1 == 1,
                                          yes = 1,
                                          no = ifelse(do_tactor2 == 1,
                                                      yes = 2,
                                                      no = ifelse(do_tactor3 == 1,
                                                      yes = 3,
                                                      no = NA))))

df_all %<>% mutate(button_correct = ifelse(button == tactor_active,
                                          yes = "correct",
                                          no = "incorrect"))

df_all %<>% mutate(button_choice = ifelse(button == 1,
                                          yes = "above",
                                          no = ifelse(button == 2,
                                                      yes = "below",
                                                      no = NA)))

df_all %<>% mutate(block_number = ifelse(block_number == 2,
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

df_all %<>% 
  mutate(trial_type = case_when(
    CS == "CSplus" & is.na(US) ~ "CS_only",
    CS == "CSminus" & is.na(US) ~ "CSminus_only",
    CS == "CSplus" & US == "high" ~ "CSplus_UShigh",
    CS == "CSminus" & US == "low" ~ "CSminus_USlow",
    CS == "CSplus" & US == "test" ~ "CSplus_UStest",
    CS == "CSminus" & US == "test" ~ "CSminus_UStest"))

df_all %<>% 
  mutate(CSplus_location = ifelse(is_CSplus == do_tactor1,
                                  yes = "above",
                                  no = "below"))

df_all %<>% 
  mutate(perc_CS = case_when(
    CS == "CSplus" & CSplus_location == "above" & button_choice == "above" ~ "CSplus",
    CS == "CSminus" & CSplus_location == "above" & button_choice == "above" ~ "CSplus",
    CS == "CSplus" & CSplus_location == "below" & button_choice == "above" ~ "CSminus",
    CS == "CSminus" & CSplus_location == "below" & button_choice == "above" ~ "CSminus",
    CS == "CSplus" & CSplus_location == "above" & button_choice == "below" ~ "CSminus",
    CS == "CSminus" & CSplus_location == "above" & button_choice == "below" ~ "CSminus",
    CS == "CSplus" & CSplus_location == "below" & button_choice == "below" ~ "CSplus",
    CS == "CSminus" & CSplus_location == "below" & button_choice == "below" ~ "CSplus"))

df_all %<>% 
  mutate(perc_trial_type = case_when(
    perc_CS == "CSplus" & is.na(US) ~ "CS_only",
    perc_CS == "CSminus" & is.na(US) ~ "CSminus_only",
    perc_CS == "CSplus" & US == "high" ~ "CSplus_UShigh",
    perc_CS == "CSminus" & US == "low" ~ "CSminus_USlow",
    perc_CS == "CSplus" & US == "test" ~ "CSplus_UStest",
    perc_CS == "CSminus" & US == "test" ~ "CSminus_UStest",
    perc_CS == "CSplus" & US == "low" ~ "CSplus_USlow",
    perc_CS == "CSminus" & US == "high" ~ "CSlow_UShigh"))
    
df_all %<>% group_by(id) %>% mutate(trial_no = row_number())

df_all %<>% select(id,
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

write_rds(x = df_all, 
          path = './Juliane_Masters/data/Juliane_raw_FEST.rds')
write_csv(x = df_all,
          path = './Juliane_Masters/data/Juliane_raw_FEST.csv')

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

df8 <- read.csv('./Juliane_Masters/data/raw data/Ccp_008_1/Ccp_008_expectancy_ratings.txt', header = TRUE, sep = "\t")
df9 <- read.csv('./Juliane_Masters/data/raw data/Ccp_009_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df10 <- read.csv('./Juliane_Masters/data/raw data/Ccp_010_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df11 <- read.csv('./Juliane_Masters/data/raw data/Ccp_011_1/expectancy_ratings.txt', header = TRUE, sep = "\t")
df12 <- read.csv('./Juliane_Masters/data/raw data/Ccp_012_1/expectancy_ratings.txt', header = TRUE, sep = "\t")
df14 <- read.csv('./Juliane_Masters/data/raw data/Ccp_014_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df15 <- read.csv('./Juliane_Masters/data/raw data/Ccp_015_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df16 <- read.csv('./Juliane_Masters/data/raw data/Ccp_016_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df17 <- read.csv('./Juliane_Masters/data/raw data/Ccp_017_1/expectancy_ratings.txt', header = TRUE, sep = "\t")
df19 <- read.csv('./Juliane_Masters/data/raw data/Ccp_019_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df21 <- read.csv('./Juliane_Masters/data/raw data/Ccp_021_1/expectancy_ratings.txt', header = TRUE, sep = "\t")
df22 <- read.csv('./Juliane_Masters/data/raw data/Ccp_022_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df23 <- read.csv('./Juliane_Masters/data/raw data/Ccp_023_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df24 <- read.csv('./Juliane_Masters/data/raw data/Ccp_024_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df25 <- read.csv('./Juliane_Masters/data/raw data/Ccp_025_1/expectancy_ratings.txt', header = TRUE, sep = "\t")
df26 <- read.csv('./Juliane_Masters/data/raw data/Ccp_026_1/expectancy_ratings.txt', header = TRUE, sep = "\t")
df27 <- read.csv('./Juliane_Masters/data/raw data/Ccp_027_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df28 <- read.csv('./Juliane_Masters/data/raw data/Ccp_028_2/expectancy_ratings.txt', header = TRUE, sep = "\t")
df29 <- read.csv('./Juliane_Masters/data/raw data/Ccp_029_1/expectancy_ratings.txt', header = TRUE, sep = "\t")
df30 <- read.csv('./Juliane_Masters/data/raw data/Ccp_030_1/expectancy_ratings.txt', header = TRUE, sep = "\t")

df8 <- df8 %>% mutate(id = 8)
df9 <- df9 %>% mutate(id = 9)
df10 <- df10 %>% mutate(id = 10)
df11 <- df11 %>% mutate(id = 11)
df12 <- df12 %>% mutate(id = 12)
df14 <- df14 %>% mutate(id = 14)
df15 <- df15 %>% mutate(id = 15)
df16 <- df16 %>% mutate(id = 16)
df17 <- df17 %>% mutate(id = 17)
df19 <- df19 %>% mutate(id = 19)
df21 <- df21 %>% mutate(id = 21)
df22 <- df22 %>% mutate(id = 22)
df23 <- df23 %>% mutate(id = 23)
df24 <- df24 %>% mutate(id = 24)
df25 <- df25 %>% mutate(id = 25)
df26 <- df26 %>% mutate(id = 26)
df27 <- df27 %>% mutate(id = 27)
df28 <- df28 %>% mutate(id = 28)
df29 <- df29 %>% mutate(id = 29)
df30 <- df30 %>% mutate(id = 30)

df_all <- rbind(df8, df9, df10, df11, df12, df14, df15, df16, df17, df19, df21, df22, df23, df24, df25, df26, df27, df28, df29, df30)

df_all %<>% rename(block_number = block.number,
                   trial_number = trial.number)

df_all %<>% mutate(block = ifelse(block_number == 3,
                                         yes = "BL_acq1",
                                         no = ifelse(block_number == 6,
                                                     yes = "acq1_2",
                                                     no = ifelse(block_number == 9,
                                                                 yes = "acq2_3",
                                                                 no = ifelse(block_number == 12,
                                                                             yes = "acq_test",
                                                                             no = ifelse(block_number == 15,
                                                                                         yes = "test1_2",
                                                                                         no = ifelse(block_number == 18,
                                                                                                     yes = "test2_3",
                                                                                                     no = "after_test3")))))))

df_all %<>% 
  mutate(measurement = case_when(
    block_number == 3 ~ 1,
    block_number == 6 ~ 2,
    block_number == 9 ~ 3,
    block_number == 12 ~ 4,
    block_number == 15 ~ 5,
    block_number == 18 ~ 6,
    block_number == 20 ~ 7))

df_all %<>% mutate(tactor = ifelse(boven == 1,
                               yes = "above",
                               no = ifelse(beneden == 1,
                                           yes = "below",
                                           no = NA)))

df_all %<>% mutate(rating = ifelse(is.na(above),
                               yes = below,
                               no = ifelse(is.na(below),
                                           yes = above,
                                           no = NA)))
df_all %<>% 
  mutate(group = case_when(
    id == 8 ~ 1,
    id == 9 ~ 2,
    id == 10 ~ 2,
    id == 11 ~ 1,
    id == 12 ~ 1,
    id == 14 ~ 2,
    id == 15 ~ 2,
    id == 16 ~ 2,
    id == 17 ~ 1,
    id == 19 ~ 2,
    id == 21 ~ 1,
    id == 22 ~ 2,
    id == 23 ~ 2,
    id == 24 ~ 2,
    id == 25 ~ 1,
    id == 26 ~ 1,
    id == 27 ~ 2,
    id == 28 ~ 2,
    id == 29 ~ 1,
    id == 30 ~ 1))

df_all %<>% 
  mutate(CS = case_when(
    group == 1 & tactor == "above" ~ "CSplus",
    group == 1 & tactor == "below" ~ "CSminus",
    group == 2 & tactor == "above" ~ "CSminus",
    group == 2 & tactor == "below" ~ "CSplus"))

df_all %<>% select(id,
                   block,
                   measurement,
                   CS,
                   rating,
                   group,
                   tactor)

# Save outputs

write_rds(x = df_all, 
          path = './Juliane_Masters/data/Juliane_raw_expectancies.rds')
write_csv(x = df_all,
          path = './Juliane_Masters/data/Juliane_raw_expectancies.csv')
