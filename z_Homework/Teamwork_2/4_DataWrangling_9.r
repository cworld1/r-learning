# Use the nycflights13 package's'flights data to answer the following questions:
# What month had the highest proportion of cancelled flights?
# What month had the lowest?
# Interpret any seasonal patterns.

library(tidyverse)

# 查看数据
view(head(nycflights13::flights)) # 数据太大，推荐只看头文件

cancelled <- nycflights13::flights %>%
    group_by(month) %>% # 仔细观察会发现只有 2013 这一年
    summarise(
        total = n(),
        cancelled = sum(is.na(arr_delay)),
        cancelled_prop = cancelled / total
    )
cat("The month that highest prop of cancelled flights: \n")
print(tail(arrange(cancelled, cancelled_prop), 1))
cat("\nThe month that lowest prop of cancelled flights: \n")
print(head(arrange(cancelled, cancelled_prop), 1))

ggplot(cancelled, aes(x = month, y = cancelled_prop)) +
    geom_line()
# 可以看到良好的节气时间点会明显降低航班取消率