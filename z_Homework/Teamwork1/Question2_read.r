data <- read.table(
    "./Homework//Teamwork1//data.txt",
    header = T, na.strings = c("NA")
)
cat("Here's the content of the data.txt: \n\n")
print(data)