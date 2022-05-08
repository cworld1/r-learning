is_prime <- function(n) {
    ifelse(
        n %in% 2:3,
        TRUE,
        all(n %% 2:floor(sqrt(n)) != 0)
    )
}
prime_num <- function(start, end) {
    x <- start:end
    x[purrr::map_lgl(x, is_prime)]
}

num <- as.numeric(
    readline(prompt = "Please input the num to limit prime num end: ")
)
if (num <= 1) {
    print("Illegal input!")
} else {
    print(prime_num(2, num))
}