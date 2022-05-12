# Write a R program to get the first 10 Fibonacci numbers.

fibo_list <- numeric(10)
fibo_list[1] <- 1
fibo_list[2] <- 1
for (i in 3:10) fibo_list[i] <- fibo_list[i - 1] + fibo_list[i - 2]
print(fibo_list)