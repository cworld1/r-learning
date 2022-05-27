library(tidyverse)

not_cancelled <- filter(
    nycflights13::flights,
    !is.na(dep_delay), !is.na(arr_delay)
)

not_cancelled %>%
    transmute(sched_dep_time, total_delay = dep_delay + arr_delay) %>%
    group_by(sched_dep_time) %>%
    summarise(mean_delay_time = mean(total_delay)) %>%
    arrange(mean_delay_time) %>%
    filter(mean_delay_time < 1) %>%
    mutate(
        sched_hour = sched_dep_time %/% 100,
        sched_min = sched_dep_time %% 100,
    )