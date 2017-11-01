############################################################
#                                                          #
#              Statistical power simulations               #
#                                                          #
############################################################

# Load packages
library(ggridges)
library(magrittr)
library(tidyverse)
library(lme4)
library(lmerTest)
library(simr)

# Load data
df_base <- readr::read_rds('./Juliane_Masters/data/Juliane_raw.rds')

# Inspect
dim(df_base)
head(df_base)
glimpse(df_base)

# Clean data
df_base %<>%
    # Filter for block_number == test*
    filter(stringr::str_detect(block_number, 'test')) %>%
    # Remove participant 23 (not included in test phase)
    filter(id != 23) %>%
    # Create new columns with stimulus type and block number
    mutate(stimulus = paste0(CS, 'UStest'),
           block_number = ifelse(block_number == 'test1',
                                 yes = 1,
                                 no = ifelse(block_number == 'test2',
                                             yes = 2,
                                             no = 3))) %>%
    # Remove NA
    filter(complete.cases(.)) %>%
    # Recode rating (non-painful < 0, painful > 0)
    mutate(painful = ifelse(rating > 0,
                            yes = 'yes',
                            no = 'no'),
           painful = factor(painful)) %>%
    # Select required columns
    select(id, block_number, trial_number, stimulus, rating, painful)

# Scatter plot
df_base %>%
    mutate(id = factor(id),
           painful = factor(painful),
           stimulus = factor(stimulus)) %>%
    ggplot(data = .) +
    aes(x = rating,
        y = id,
        colour = stimulus,
        fill = stimulus) +
    geom_vline(xintercept = 0) +
    geom_jitter(shape = 21,
                alpha = 0.6,
                width = 0) +
    scale_colour_brewer(palette = 'Set1') +
    labs(x = 'FEST rating',
         y = 'Participant ID') +
    theme_minimal(base_size = 14) +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor = element_blank())

# Joy plot
df_base %>%
    mutate(id = factor(id),
           painful = factor(painful),
           stimulus = factor(stimulus)) %>%
    ggplot(data = .) +
    aes(x = rating,
        y = id,
        colour = stimulus,
        fill = stimulus) +
    geom_vline(xintercept = 0) +
    geom_density_ridges() +
    scale_colour_brewer(palette = 'Set1') +
    labs(x = 'FEST rating',
         y = 'Participant ID') +
    theme_minimal(base_size = 14) +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor = element_blank())
    
# Create a model using the empirical data
mod_base <- glmer(painful ~ stimulus + (1 | id),
                 data = df_base,
                 family = binomial)

# Summarise model
summary(mod_base)

# Get 95% CI of the coefficients (log odds)
confint(mod_base)

# Get 95% CI of the odds ratio
exp(confint(mod_base))

##################
# Power analysis #
##################
# "Observed power" is problematic, so instead of using the raw data (df_base)
# I took a random sample (with replacement) of 40 individuals from df_base, 
# and re-build a dummy cohort from this sample.

# For the modelling process, I modelled power over a range of sample sizes 
# (n: 5 to 40) for effect sizes (log odds) ranging between: 0.3, 0.6, 1.2, 2.4, 
# 3.4 (upper of original data 95% CI)

# Take a sample of df_base
df_pwr <- df_base %>%
    # Group and nest dataframe by id
    group_by(id) %>%
    nest() %>%
    # Take a random sample of n = 40 with replacement
    sample_n(size = 40,
             replace = TRUE) %>%
    # Relabel ids
    mutate(id = 1:40) %>%
    # Unnest dataframe
    unnest() 

# Generate and inspect a model for this reduced dataset
mod_pwr <- glmer(painful ~ stimulus + (1 | id),
                 data = df_pwr,
                 family = binomial)

# MODEL 1: effect size: 0.3
## Change effect size
fixef(mod_pwr)["stimulusCSplusUStest"] <- 0.3

## Simulate power curve
pwr_curve_0.3 <- powerCurve(fit = mod_pwr, 
                            along = 'id', 
                            breaks = c(5, 10, 15, 20, 25, 30, 35, 40))

# Print
pwr_curve_0.3

# Plot
pdf(file = './Juliane_Masters/estimate_0.3.pdf')
plot(pwr_curve_0.3)
dev.off()

# MODEL 1: effect size: 0.6
## Change effect size
fixef(mod_pwr)["stimulusCSplusUStest"] <- 0.6

## Simulate power curve
pwr_curve_0.6 <- powerCurve(fit = mod_pwr, 
                            along = 'id', 
                            breaks = c(5, 10, 15, 20, 25, 30, 35, 40))

# Print
pwr_curve_0.6

# Plot
pdf(file = './Juliane_Masters/estimate_0.6.pdf')
plot(pwr_curve_0.6)
dev.off()

# MODEL 1: effect size: 0.3
## Change effect size
fixef(mod_pwr)["stimulusCSplusUStest"] <- 1.2

## Simulate power curve
pwr_curve_1.2 <- powerCurve(fit = mod_pwr, 
                            along = 'id', 
                            breaks = c(5, 10, 15, 20, 25, 30, 35, 40))

# Print
pwr_curve_1.2

# Plot
pdf(file = './Juliane_Masters/estimate_1.2.pdf')
plot(pwr_curve_1.2)
dev.off()

# MODEL 1: effect size: 0.3
## Change effect size
fixef(mod_pwr)["stimulusCSplusUStest"] <- 2.4

## Simulate power curve
pwr_curve_2.4 <- powerCurve(fit = mod_pwr, 
                            along = 'id', 
                            breaks = c(5, 10, 15, 20, 25, 30, 35, 40))

# Print
pwr_curve_2.4

# Plot
pdf(file = './Juliane_Masters/estimate_2.4.pdf')
plot(pwr_curve_2.4)
dev.off()

# MODEL 1: effect size: 3.4
## Change effect size
fixef(mod_pwr)["stimulusCSplusUStest"] <- 3.4

## Simulate power curve
pwr_curve_3.4 <- powerCurve(fit = mod_pwr, 
                            along = 'id', 
                            breaks = c(5, 10, 15, 20, 25, 30, 35, 40))

# Print
pwr_curve_3.4

# Plot
pdf(file = './Juliane_Masters/estimate_3.4.pdf')
plot(pwr_curve_3.4)
dev.off()
