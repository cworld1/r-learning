# Write a R program to take input from the user (name and age)
# and display the values.
# Also print the version of R installation.

name <- readline(prompt = "Please enter name: ")
age <- readline(prompt = "Please enter age: ")
cat("OK. There's info.\n")
cat("Your name: ", name, "\n")
cat("Your age: ", age, "\n")
cat("Version of the R: ", version$version.string, "\n")