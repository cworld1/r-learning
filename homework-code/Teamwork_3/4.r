# Use the nycflights13 packageand the flights and planes tables
# to answer the following questions:

library(tidyverse)
library(nycflights13)

# a. What is the oldest plane (specified by the tailnum variable)
# that flew from New York City airports in 2013?
flights %>%
    inner_join(planes, by = "tailnum") %>%
    filter(!is.na(year.y)) %>%
    group_by(tailnum) %>%
    summarize(age = mean(year.x - year.y), .groups = "drop") %>%
    arrange(desc(age))

# b. How many airplanes that flew from New York City are included
# in the planes table?
flights %>%
    group_by(tailnum) %>%
    filter(origin %in% c("EWR", "LGA", "JFK")) %>%
    inner_join(planes, by = "tailnum") %>%
    count(tailnum) %>%
    print() %>%
    nrow()
