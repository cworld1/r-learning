library(tidyverse)

not_cancelled <- filter(
    nycflights13::flights,
    !is.na(dep_delay), !is.na(arr_delay)
)

# 按公司分析
not_cancelled %>%
    group_by(carrier) %>%
    summarise(total_dep_delay = sum(dep_delay + arr_delay), n = n()) %>%
    arrange(desc(total_dep_delay))

# 按出发地分析
not_cancelled %>%
    group_by(origin) %>%
    summarise(total_dep_delay = sum(dep_delay), n = n()) %>%
    arrange(desc(total_dep_delay))
# 按目的地分析
not_cancelled %>%
    group_by(dest) %>%
    summarise(total_arr_delay = sum(arr_delay), n = n()) %>%
    arrange(desc(total_arr_delay))