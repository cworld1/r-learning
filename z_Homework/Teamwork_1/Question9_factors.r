# Write a R program to find the factors of a given number.

num <- as.numeric(readline(prompt = "Please enter number: "))

factor_list <- c()
for (n in 1:num) {
   if (num %% n == 0) factor_list <- append(factor_list, n)
}
print(factor_list)