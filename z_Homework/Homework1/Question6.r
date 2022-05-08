library(tidyverse)

not_cancelled <- filter(
    nycflights13::flights,
    !is.na(dep_delay), !is.na(arr_delay)
)

# 对于每个目的地
not_cancelled %>%
    group_by(dest) %>%
    summarise(total_delay = sum(dep_delay))

# 对于每个航班
total_delay_time <- sum(not_cancelled$dep_delay)
not_cancelled %>%
    group_by(tailnum) %>%
    summarise(delay_proportion = sum(dep_delay) / total_delay_time)