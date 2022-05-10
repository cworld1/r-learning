# Using the function range, obtain the following values:
# a) Size of the biggest island
# b) Size of the smallest island

library(tidyverse)
sorted <- sort(islands)
cat("Biggest island:", last(sorted), "\n")
cat("Smallest island:", first(sorted))