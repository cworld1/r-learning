# Create a scatterplot of illiteracy (as a percent of population)
# and per capita income (in U.S. dollars)
# with points plus labels of the two letter state abbreviations.
# Add a smoother. Use the ggrepel package to offset the names that overlap.
# What pattern do you observe? Are there any outlying observations?

install.packages("ggrepel")
library(ggrepel)
library(tidyverse)
statenames <- tibble(names = state.name, twoletter = state.abb)
glimpse(statenames)
statedata <- tibble(
    names = state.name,
    income = state.x77[, 2],
    illiteracy = state.x77[, 3]
)
glimpse(statedata)
statedata |>
    ggplot(aes(illiteracy, income)) +
    geom_point() +
    geom_text_repel(aes(label = names))
