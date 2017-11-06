
library(vcdExtra)
library(tidyverse)

# Import data

df <- read_rds(path = './Tory_CC_laser_2015/data/FEST_ratings.rds')

df %<>% mutate(painful = ifelse(rating > 0, 
                                yes = "yes",
                                no = "no")) %>%
  filter(trial_type == "CSplus_UStest" | trial_type == "CSminus_UStest")

# Create cross-tabulation table

df_tab <- xtabs(~ trial_type + painful + id, data = df)

# Look at table
ftable(df_tab)

# Run CMH test (which allows fro rodinal variables, even though we don't have any here, and stratification - here it stratifies by ID before it pools all the IDs)

CMHtest(df_tab, overall = TRUE)

# We can also choose the Mantel-Haenszel test instead, because we don't need to allow for ordered variables (e.g. very sick, slightly sick, not sick).  This test also applied a contoinuity correction in its default form, which correct the p-value over-estimation that tends to happen in a chi square with 2 x 2 arrangement - therefore this version is more conservative.  This result shows a meaningful result.

mantelhaen.test(df_tab)

# And check the direction of the effect by creating a mosaic plot:
# First remove the stratification.
df_tab2 <- xtabs(~ trial_type + painful, data = df)
mosaicplot(df_tab2)

