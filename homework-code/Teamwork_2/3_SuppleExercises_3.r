# Consider the following data graphic about world-class swimmers.
# Emphasis is on Katie Ledecky, a five-time Olympic gold medalist.
# It may be helpful to peruse the original article,
# entitled “Katie Ledecky Is The Present And The Future Of Swimming.”

tibble(
    name = c("Ledecky", "Ledecky", "Ledecky"),
    gender = c("F", "F", "F"),
    distance = c(100, 200, 400),
    time_in_sd = c(-0.8, 1.7, 2.9)
)

# 1. Mapped to the position aesthetic in the horizontal direction: distance
# 2. Mapped to the color aesthetic in the vertical direction: time_in_sd
# 3. Mapped to the position aesthetic in the vertical direction: time_in_sd