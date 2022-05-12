# The Violations data set in the mdsr package contains information
# regarding the outcome of health inspections of restaurants in New York City.
# Use these data to calculate the median violation score by zip code
# for zip codes in Manhattan with 50 or more inspections.
# What pattern do you see between the number of inspections and the mid score?

library(tidyverse)

# 查看数据
view(head(mdsr::Violations)) # 数据太大，推荐只看头文件

mdsr::Violations %>%
    #* count(boro) # 仔细观察会发现具体到区的数据被储存在 boro 这一列
    filter(boro == "MANHATTAN") %>%
    group_by(zipcode) %>%
    summarise(median_score = median(score, na.rm = TRUE))