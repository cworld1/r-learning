# The MLB_teams data set in the mdsr package contains information
# about Major League Baseball teams from 2008–2014.
# There are several quantitative and a few categorical variables present.
# See how many variables you can illustrate on a single plot in R.
# The current record is 7.
# (Note: This is not good graphical practice—it is merely an exercise
# to help you understand how to use visual cues and aesthetics!)


library(tidyverse)

teams <- mdsr::MLB_teams %>%
    mutate(attend_rate = attendance / metroPop)
# 关于团队与胜率的盒型图
ggplot(teams, aes(x = yearID, y = WPct)) +
    geom_boxplot(aes(color = teamID, linetype = lgID))

ggplot(teams, aes(x = teamID, y = attend_rate)) +
    geom_boxplot(aes(color = teamID))