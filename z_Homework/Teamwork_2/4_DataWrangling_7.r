# Using the Teams data frame in the Lahman package,
# display the top-5 teams ranked in terms of
# slugging percentage (SLG) in Major League Baseball history.
# Repeat this using teams since 1969.
# Slugging percentage is total bases divided by at-bats.
#  To compute total bases,
# you get 1 for a single, 2 for a double, 3 for a triple, and 4 for a home run.

library(tidyverse)

# 查看数据
view(Lahman::Teams)

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