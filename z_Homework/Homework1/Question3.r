library(tidyverse)

not_cancelled <- filter(
    nycflights13::flights,
    !is.na(dep_delay), !is.na(arr_delay)
)

not_cancelled %>%
    transmute(tailnum, total_delay = dep_delay) %>%
    filter(total_delay > 100) %>%
    count(tailnum)