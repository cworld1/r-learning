# 10 Tibbles

library(tidyverse)

# 就像我们之前提到的那样，我们常常使用来自 tidyverse 的 tibbles，而不是 R 传统的 data.frame。
# Tibbles 是一种比 R 自带的 dataframe 更人性化更方便的数据集存储形式。

# 【热身】创建 tibble ----

# as_tibble() ----
# 我们使用 as_tibble() 来转化原有的 dataframe：
as_tibble(iris)
#> # A tibble: 150 x 5
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>          <dbl>       <dbl>        <dbl>       <dbl> <fct>
#> 1          5.1         3.5          1.4         0.2 setosa
#> 2          4.9         3            1.4         0.2 setosa
#> 3          4.7         3.2          1.3         0.2 setosa
#> 4          4.6         3.1          1.5         0.2 setosa
#> 5          5           3.6          1.4         0.2 setosa
#> 6          5.4         3.9          1.7         0.4 setosa
#> # … with 144 more rows

# tibble() ----
# 或者使用 tibble() 直接创建：
tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)
#> # A tibble: 5 x 3
#>       x     y     z
#>   <int> <dbl> <dbl>
#> 1     1     1     2
#> 2     2     1     5
#> 3     3     1    10
#> 4     4     1    17
#> 5     5     1    26

# tribble() ----
# 这种方法真的优雅很多！就像你在书写 markdown 一样 ~
tribble(
  ~x, ~y, ~z,
  #--|--|---
  "a", 2, 3.6,
  "b", 1, 8.5
)
#> # A tibble: 2 x 3
#>   x         y     z
#>   <chr> <dbl> <dbl>
#> 1 a         2   3.6
#> 2 b         1   8.5

# 将符号或数字放在开头虽然墙裂不推荐，但 tibble 也不会报错：
tb <- tibble(
  `:)` = "smile", # 注意使用 `` 来囊括
  ` ` = "space",
  `2000` = "number"
)
tb
#> # A tibble: 1 x 3
#>   `:)`  ` `   `2000`
#>   <chr> <chr> <chr>
#> 1 smile space number

# 【补充】tibbles VS. data.frame ----

# 控制台打印方面 ----
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)
#> # A tibble: 1,000 x 5
#>   a                   b              c     d e
#>   <dttm>              <date>     <int> <dbl> <chr>
#> 1 2020-10-09 13:55:17 2020-10-16     1 0.368 n
#> 2 2020-10-10 08:00:26 2020-10-21     2 0.612 l
#> 3 2020-10-10 02:24:06 2020-10-31     3 0.415 p
#> 4 2020-10-09 15:45:23 2020-10-30     4 0.212 m
#> 5 2020-10-09 12:09:39 2020-10-27     5 0.733 i
#> 6 2020-10-09 23:10:37 2020-10-23     6 0.460 n
#> # … with 994 more rows
# tibble 对于太多的数据，只会显示前十行，不会让你的控制台被内容淹没；
# 同时会显示每一列的数据类型。这得益于 str() 函数。
# tibble 还完美兼容 print() 函数：
nycflights13::flights %>%
  print(n = 10, width = Inf) # Inf 表示无限，即所有都打印
# 查看数据的另一种办法是使用 view() 函数，会更直观地显示在你的编辑器上。
nycflights13::flights %>%
  head(10) %>%
  View() # 请不要尝试展示太多数据！小心的的电脑炸掉（

# 读取子元素方面 ----
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
# 按名字读取
df$x
#> [1] 0.73296674 0.23436542 0.66035540 0.03285612 0.46049161
df[["x"]]
#> [1] 0.73296674 0.23436542 0.66035540 0.03285612 0.46049161
# 按序列位置读取
df[[1]]
#> [1] 0.73296674 0.23436542 0.66035540 0.03285612 0.46049161

# 使用管道符的话，我们需要使用 “.”：
df %>% .$x
#> [1] 0.73296674 0.23436542 0.66035540 0.03285612 0.46049161
df %>% .[["x"]]
#> [1] 0.73296674 0.23436542 0.66035540 0.03285612 0.46049161

# 【补充】tibble 的转换 ----
# 上面提到使用 as_tibble() 将 data.frame 转换为 tibble，
# 而 as.data.frame() 函数则是将 tibble 转化为 data.frame：
class(as.data.frame(tb)) # class() 函数用于检查数据格式
#> [1] "data.frame"