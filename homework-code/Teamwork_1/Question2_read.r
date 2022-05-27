# Write a R program to get the details of the objects in memory.

data <- read.table(
    "./z_Homework//Teamwork1//data.txt",
    header = T, na.strings = c("NA")
)
cat("Here's the content of the data.txt: \n\n")
print(data)