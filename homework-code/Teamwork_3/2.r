install.packages("Lahman")
library(tidyverse)
library(Lahman)

# a. Name every player in baseball history who has accumulated
# at least 300 home runs (HR) and at least 300 stolen bases (SB).
# You can find the first and last name of the player in the Master data frame.
# Join this to your result along with the total home runs
# and total bases stolen for each of these elite players.
Batting |>
    group_by(playerID) |>
    summarise(hr_sum = sum(HR), sb_sum = sum(SB)) |>
    filter(hr_sum >= 300 & sb_sum >= 300) |>
    left_join(People, by = "playerID") |>
    select(
        first_name = nameFirst,
        last_name = nameLast,
        hr_sum, sb_sum
    )

# b. Similarly, name every pitcher in baseball history
# who has accumulated at least 300 wins (W) and at least 3,000 strikeouts (SO).
Pitching |>
    group_by(playerID) |>
    summarise(w_sum = sum(W), so_sum = sum(SO)) |>
    filter(w_sum >= 300 & so_sum >= 3000) |>
    select(player_id = playerID, w_sum, so_sum)

# c. Identify the name and year of every player
# who has hit at least 50 home runs in a single season.
# Which player had the lowest batting average in that season?
Batting |>
    group_by(playerID, yearID) |>
    summarise(
        hr_sum = sum(HR),
        batting_average = sum(H) / sum(AB),
        .groups = "drop"
    ) |>
    filter(hr_sum >= 50) |>
    select(
        player_id = playerID,
        year_id = yearID,
        hr_sum, batting_average
    ) |>
    arrange(batting_average)
