# Write a R program to create a vector which contains 10 random integer values
# between -50 and +50.

array <- round(
    runif(10, min = -50, max = 50),
    digits = 0
)
print(array)