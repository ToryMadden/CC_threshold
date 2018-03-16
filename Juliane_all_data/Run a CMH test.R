
# Load packages

library(vcdExtra)
library(tidyverse)

# Import data

df <- read_csv('/Users/tory/Google Drive/Git/CC_threshold/Juliane_all_data/data/R_data_complete_dataset_ratings')

df %<>% mutate(painful = ifelse(rating > 0, 
                                yes = "yes",
                                no = "no")) %>%
  filter(trial_type == "CSplus_UStest" | trial_type == "CSminus_UStest")

# Create cross-tabulation table

df_tab <- xtabs(~ trial_type + painful + id, data = df)

# Look at table
ftable(df_tab)

# We can choose the Mantel-Haenszel test, because we don't need to allow for ordered variables (e.g. very sick, slightly sick, not sick).  This test stratifies by IF before it pools all the IDs.  It also applied a contoinuity correction in its default form, which correct the p-value over-estimation that tends to happen in a chi square with 2 x 2 arrangement - therefore this version is more conservative than the CMH option considered below.  

mantelhaen.test(df_tab)

# Interpretation: This result is meaningful difference.

# Check the direction of the effect by creating a mosaic plot:
# First remove the stratification.

df_tab2 <- xtabs(~ trial_type + painful, data = df)

mosaicplot(df_tab2)

# If we wanted to add other stratification (e.g. test for effect of test phse block, we could run a CMH test (which allows for ordinal variables as well as stratification).
# We would do that by using the syntax
# CMHtest(df_tab, overall = TRUE)
# Currently this produces an error - possibly becasue we haven't provided an ordinal variable.

