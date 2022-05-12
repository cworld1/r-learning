# Write a R program to print the numbers from 1 to 100
# and print "Fizz" for multiples of 3, print "Buzz" for multiples of 5,
# and print "FizzBuzz" for multiples of both.

cat("1 to 100:\n")
array <- print(1:100)
cat("fizz as 3rd from 1 to 100:\n")
fizz <- print(seq(from = 3, to = 100, by = 3))
cat("buzz as 5th from 1 to 100:\n")
buzz <- print(seq(from = 5, to = 100, by = 5))
cat("fizz and buzz:\n")
print(append(fizz, buzz))