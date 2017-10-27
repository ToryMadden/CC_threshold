############################################################
#                                                          #
#                   Import chaotic data                    #
#                                                          #
############################################################

# Load packages
library(tidyverse)
libarary(dplyr)
library(magrittr)
library(ggplot2)
library(tidyr)
library(readr)

# Load individual data sets

df_01SH <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "01SH", col_names = TRUE)
df_02BM <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "02BM", col_names = TRUE)
df_03CF <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "03CF", col_names = TRUE)
df_04WW <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "04WW", col_names = TRUE)
df_05JG <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "05JG", col_names = TRUE)
df_06RK <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "06RK", col_names = TRUE)
df_07AF <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "07AF", col_names = TRUE)
df_08DR <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "08DR", col_names = TRUE)
df_09CD <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "09CD", col_names = TRUE)
df_10HL <- readxl::read_excel('/Users/tory/Google Drive/Git/CC_threshold/Tory_CC_laser_2015/data/raw_data/tidy_data.xlsx', sheet = "10HL", col_names = TRUE)

data <- rbind(df_01SH, df_02BM, df_03CF, df_04WW, df_05JG, df_06RK, df_07AF, df_08DR, df_09CD, df_10HL)

df_all <- data %>% mutate(trial_type = case_when(
                   Trial_type == "head" & Csplus_location == "head" & block_type == "baseline" 
                   ~ "CSplus_only",
                   Trial_type == "head" & Csplus_location == "feet" & block_type == "baseline" 
                   ~ "CSminus_only",
                   Trial_type == "feet" & Csplus_location == "feet" & block_type == "baseline" 
                   ~ "CSplus_only",
                   Trial_type == "feet" & Csplus_location == "head" & block_type == "baseline" 
                   ~ "CSminus_only",
                   Trial_type == "head" & Csplus_location == "head" & block_type == "acquisition" 
                   ~ "CSplus_UShigh",
                   Trial_type == "head" & Csplus_location == "feet" & block_type == "acquisition" 
                   ~ "CSminus_USlow",
                   Trial_type == "feet" & Csplus_location == "feet" & block_type == "acquisition" 
                   ~ "CSplus_UShigh",
                   Trial_type == "feet" & Csplus_location == "head" & block_type == "acquisition" 
                   ~ "CSminus_USlow",
                   Trial_type == "headONLY" & Csplus_location == "head" ~ "CSplus_only",
                   Trial_type == "headONLY" & Csplus_location == "feet" ~ "CSminus_only",
                   Trial_type == "HeadONLY" & Csplus_location == "head" ~ "CSplus_only",
                   Trial_type == "HeadONLY" & Csplus_location == "feet" ~ "CSminus_only",
                   Trial_type == "feetONLY" & Csplus_location == "feet" ~ "CSplus_only",
                   Trial_type == "feetONLY" & Csplus_location == "head" ~ "CSminus_only",
                   Trial_type == "headLas" & Csplus_location == "head" ~ "CSplus_UShigh",
                   Trial_type == "headLas" & Csplus_location == "feet" ~ "CSminus_USlow",
                   Trial_type == "FeetLas" & Csplus_location == "feet" ~ "CSplus_UShigh",
                   Trial_type == "FeetLas" & Csplus_location == "head" ~ "CSminus_USlow",
                   Trial_type == "HeadTEST" & Csplus_location == "head" ~ "CSplus_UStest",
                   Trial_type == "HeadTEST" & Csplus_location == "feet" ~ "CSminus_UStest",
                   Trial_type == "FeetTEST" & Csplus_location == "feet" ~ "CSplus_UStest",
                   Trial_type == "FeetTEST" & Csplus_location == "head" ~ "CSminus_UStest",
                   Trial_type == "LasTestONLY" ~ "UStest_only"))  %>%
  select(-Trial_type)

# Save outputs

write_rds(x = df_all, 
          path = './Tory_CC_laser_2015/data/FEST_ratings.rds')
write_csv(x = df_all,
          path = './Tory_CC_laser_2015/data/FEST_ratings.csv')

