# The Relative Age Effect is an attempt to explain anomalies
# in the distribution of birth month among athletes.
# Briefly, the idea is that children born just after the age cut-off
# to enroll in school will be as much as 11 months older than their
# fellow athletes, which is enough of a disparity to give them an advantage.
# That advantage will then be compounded over the years,
# resulting in notably more professional athletes born in these months.

install.packages("mosaicData")
library(tidyverse)
library(lubridate)

# a. Display the distribution of birth months of baseball players
# who batted during the decade of the 2000s.
people <- Lahman::People %>%
    as_tibble() %>%
    filter(!is.na(debut)) %>%
    mutate(debut = as.Date(debut)) %>%
    filter(year(debut) %in% 2001:2010)
people %>%
    group_by(birthMonth) %>%
    count() %>%
    ggplot(aes(birthMonth, n)) +
    geom_line()

# b. How are they distributed over the calendar year?
# Does this support the notion of a relative age effect?
# Use the Births78 data set from the mosaicData package as a reference.
mosaicData::Births78 %>%
    group_by(month) %>%
    summarise(n = sum(births)) %>%
    arrange(desc(n)) %>%
    ggplot(aes(month, n)) +
    geom_line()
# Athletes born in July to September were significantly more than other months,
# which can indeed prove the notion of a relative age effect.
