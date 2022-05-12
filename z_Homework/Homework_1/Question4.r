library(tidyverse)

not_cancelled <- filter(
    nycflights13::flights,
    !is.na(dep_delay), !is.na(arr_delay)
)

not_cancelled %>%
    transmute(tailnum, total_delay = dep_delay + arr_delay) %>%
    group_by(tailnum) %>%
    summarise(total_delay_time = sum(total_delay)) %>%
    arrange(desc(total_delay_time))