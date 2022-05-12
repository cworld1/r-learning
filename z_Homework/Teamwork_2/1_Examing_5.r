# Quantiles.
# Using the function quantile obtain a vector including the following quantiles:
# a) 0%, 25%, 50%, 75%, 100%
# b) .5%, 95%

set.seed(15051) # Set seed for reproducibility
x <- round(runif(100, 0, 100)) # Create uniformly distributed data
cat("a: \n")
print(quantile(x, probs = seq(0, 1, 1 / 4)))
b <- quantile(x, probs = seq(0, 1, 1 / 200))
cat("b: \n")
print(c(b["0.5%"], b["95.0%"]))