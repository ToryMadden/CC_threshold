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

df_all %<>% select(id,
                   phase,
                   block.number,
                   trial.number,
                   is_CSplus,
                   is_CSmin,
                   do_pulse1,
                   do_pulse3,
                   rating,
                   button,
                   rating_time,
                   button_time)
                   do_pulse5)

df_all %<>% rename(block_number = block.number,
                   trial_number = trial.number)

#START HERE

df_all %<>% mutate(block_number = ifelse(block_number = 2,
                                         yes = 1,
                                         no = ifelse(block_number = 4,
                                                yes = 2,
                                                no = ifelse(block_number = 7,
                                                   yes = 3,
                                                   no = ifelse(block_number = 10,
                                                          yes = 4,
                                                          no = ifelse(block_number = 13,
                                                                 yes = 5,
                                                                 no = ifelse(block_number = 16,
                                                                        yes = 6,
                                                                        no = 7)))))))

# Save outputs

write_rds(x = df_all, 
          path = './Juliane_Masters/data/Juliane_raw.rds')
write_csv(x = df_all,
          path = './Juliane_Masters/data/Juliane_raw.csv')
