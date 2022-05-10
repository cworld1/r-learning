# Use the nycflights13 package's'flights data to answer the following questions:
# What month had the highest proportion of cancelled flights?
# What month had the lowest?
# Interpret any seasonal patterns.

library(tidyverse)

# 查看数据
view(head(nycflights13::flights)) # 数据太大，推荐只看头文件

# 新建数据
top_teams <- Lahman::Teams %>%
    filter(yearID >= 1969) %>%
    # H 包括了 Doubles，Triples 和 Homeruns，所以包括部分应当少算一次
    mutate(SLG = (H + 1 * X2B + 2 * X3B + 3 * HR) / AB) %>%
    group_by(teamID) %>%
    summarise(mean_slg = mean(SLG)) %>%
    arrange(desc(mean_slg)) # 按 SLG 从大到小排序

# 打印前五的数据
print(top_teams[1:5, ])