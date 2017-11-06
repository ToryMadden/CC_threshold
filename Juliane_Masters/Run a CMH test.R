
library(vcdExtra)
library(tidyverse)

# Import data

df <- read_rds(path = './Juliane_Masters/data/Juliane_raw_FEST.rds')

df %<>% mutate(painful = ifelse(rating > 0, 
                                yes = "yes",
                                no = ifelse(rating < 0,
                                            yes = "no",
                                            no = NA))) %>%
  filter(trial_type == "CSplus_UStest" | trial_type == "CSminus_UStest")

# Create cross-tabulation table

df_tab <- xtabs(~ trial_type + painful + id, data = df)

# Look at table
ftable(df_tab)

# Run CMH test (which allows for ordinal variables, even though we don't have any here, and stratification - here it stratifies by ID before it pools all the IDs)

CMHtest(df_tab, overall = TRUE)

# We can also choose the Mantel-Haenszel test instead, because we don't need to allow for ordered variables (e.g. very sick, slightly sick, not sick).  This test also applied a contoinuity correction in its default form, which correct the p-value over-estimation that tends to happen in a chi square with 2 x 2 arrangement - therefore this version is more conservative.  This result shows a meaningful result.

mantelhaen.test(df_tab)

# And check the direction of the effect by creating a mosaic plot:
# First remove the stratification.
df_tab2 <- xtabs(~ trial_type + painful, data = df)
mosaicplot(df_tab2)

# Create a joyplot to show dichotoised data visually

library(forcats)
library(ggridges)

df %>% mutate(id_fct = fct_rev(as.factor(id))) %>%
  ggplot(aes(y = id_fct)) + 
  geom_density_ridges(aes(x = rating, 
                          fill = paste(id_fct, trial_type)), 
                      alpha = .8, 
                      color = "white", 
                      from = -50, 
                      to = 50) +
  labs(x = "FEST rating",
       y = "Participant ID",
       title = "CS-/UStest vs CS+/UStest trial ratings",
       caption = "Consider next to Mantel Haenszel test results") +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("CSminus_UStest", "CSplus_UStest"),
                      labels = c(`CSminus_UStest` = "CS-/UStest", `CSplus_UStest` = "CS+/UStest"),
                      values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
                      name = "trial_type", guide = "legend") +
  theme_ridges(grid = TRUE)


df %>% ggplot(aes(y = as.factor(id))) + 
  geom_density_ridges(aes(x = rating, 
                          fill = paste(trial_type)), 
                      alpha = .8, 
                      color = "white", 
                      from = -50, 
                      to = 50) +
  labs(x = "FEST rating",
       y = "Participant ID",
       title = "CS-/UStest vs CS+/UStest trial ratings",
       caption = "Consider next to Mantel Haenszel test results") +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("CSminus_UStest", "CSplus_UStest"),
                      labels = c(`CSminus_UStest` = "CS-/UStest", `CSplus_UStest` = "CS+/UStest"),
                      values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
                      name = "trial_type", guide = "legend") +
  geom_vline(xintercept = 0)

df %>% ggplot(aes(y = as.factor(block_number))) + 
  geom_density_ridges(aes(x = rating, 
                          fill = paste(trial_type)), 
                      alpha = .8, 
                      color = "white", 
                      from = -50, 
                      to = 50) +
  labs(x = "FEST rating",
       y = "Participant ID",
       title = "CS-/UStest vs CS+/UStest trial ratings",
       caption = "Consider next to Mantel Haenszel test results") +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("CSminus_UStest", "CSplus_UStest"),
                      labels = c(`CSminus_UStest` = "CS-/UStest", `CSplus_UStest` = "CS+/UStest"),
                      values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
                      name = "trial_type", guide = "legend") +
  geom_vline(xintercept = 0)

# Check validity of acquisition phase trials

df_acq <- read_rds(path = './Juliane_Masters/data/Juliane_raw_FEST.rds')

df_acq %<>% mutate(painful = ifelse(rating > 0, 
                                yes = "yes",
                                no = ifelse(rating < 0,
                                            yes = "no",
                                            no = NA))) %>%
  filter(trial_type == "CSplus_UShigh" | trial_type == "CSminus_USlow") %>%
  filter(block_number == "acq1" | block_number == "acq3" | block_number == "acq3" )

df_acq %>% ggplot(aes(y = as.factor(id))) + 
  geom_density_ridges(aes(x = rating, 
                          fill = paste(trial_type)), 
                      alpha = .8, 
                      color = "white", 
                      from = -50, 
                      to = 50) +
  labs(x = "FEST rating",
       y = "Participant ID",
       title = "CS-/USlow vs CS+/UShigh trial ratings, acquisition phase only",
       caption = "To assess acquisition ratings") +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("CSminus_USlow", "CSplus_UShigh"),
                      labels = c(`CSminus_USlow` = "CS-/USlow", `CSplus_UShigh` = "CS+/UShigh"),
                      values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
                      name = "trial_type", guide = "legend") +
  geom_vline(xintercept = 0)

# Check acquisition by perception

df_acq_perc <- read_rds(path = './Juliane_Masters/data/Juliane_raw_FEST.rds')

df_acq_perc %<>% mutate(painful = ifelse(rating > 0, 
                                    yes = "yes",
                                    no = ifelse(rating < 0,
                                                yes = "no",
                                                no = NA))) %>%
  separate(trial_type, into = c("perc_CS", "US2"), sep = "_") %>%
  filter(block_number == "acq1" | block_number == "acq3" | block_number == "acq3" )


df_acq_perc %>% ggplot(aes(y = as.factor(id))) + 
  geom_density_ridges(aes(x = rating, 
                          fill = paste(perc_CS)), 
                      alpha = .8, 
                      color = "white", 
                      from = -50, 
                      to = 50) +
  labs(x = "FEST rating",
       y = "Participant ID",
       title = "AS PERCEIVED CS- vs CS+ trial ratings, acquisition phase only",
       caption = "To assess acquisition ratings") +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("CSminus", "CSplus"),
                      labels = c(`CSminus` = "CS-", `CSplus` = "CS+"),
                      values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
                      name = "perc_CS", guide = "legend") +
  geom_vline(xintercept = 0)
