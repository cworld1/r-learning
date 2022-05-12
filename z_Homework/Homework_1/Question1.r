library(tidyverse)

not_cancelled <- filter(
    nycflights13::flights,
    !is.na(dep_delay), !is.na(arr_delay)
)
# 相关列
not_cancelled %>% select(dest, tailnum, distance)

# 源代码
not_cancelled %>% count(dest)
# 另一种写法
not_cancelled %>%
    group_by(dest) %>%
    summarise(n = n())

# 源代码
not_cancelled %>% count(tailnum, wt = distance)
# 另一种写法
not_cancelled %>%
    group_by(tailnum) %>%
    summarise(n = sum(distance))