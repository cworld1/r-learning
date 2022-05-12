# Write a R program to find the maximum and the minimum value of a given vector.

vector <- c(1, 6, 8, 7, 13, 14)
cat(
    "The max:", max(vector, na.rm = TRUE),
    ", the min:", min(vector, na.rm = TRUE)
)