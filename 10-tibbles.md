# Tibbles {#tibbles}

就像我们之前提到的那样，我们常常使用来自 tidyverse 的 tibbles，而不是 R 传统的 data.frame。Tibbles 是一种比 R 自带的 dataframe 更人性化更方便的数据集存储形式。


```r
library(tidyverse)
```

## 创建 tibble

### as_tibble()
我们使用 as_tibble() 来转化原有的 dataframe：


```r
as_tibble(iris)
#> # A tibble: 150 × 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # … with 140 more rows
```

### tibble()
或者使用 tibble() 直接创建：


```r
tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)
#> # A tibble: 5 × 3
#>       x     y     z
#>   <int> <dbl> <dbl>
#> 1     1     1     2
#> 2     2     1     5
#> 3     3     1    10
#> 4     4     1    17
#> 5     5     1    26
```

### tribble()
这种方法真的优雅很多！就像你在书写 markdown 一样 ~


```r
tribble(
  ~x, ~y, ~z,
  #--|--|---
  "a", 2, 3.6,
  "b", 1, 8.5
)
#> # A tibble: 2 × 3
#>   x         y     z
#>   <chr> <dbl> <dbl>
#> 1 a         2   3.6
#> 2 b         1   8.5
```

将符号或数字放在开头虽然墙裂不推荐，但 tibble 也不会报错：


```r
tb <- tibble(
  `:)` = "smile", # 注意使用 `` 来囊括
  ` ` = "space",
  `2000` = "number"
)
tb
#> # A tibble: 1 × 3
#>   `:)`  ` `   `2000`
#>   <chr> <chr> <chr> 
#> 1 smile space number
```

## tibbles VS. data.frame

### 控制台打印方面


```r
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)
#> # A tibble: 1,000 × 5
#>    a                   b              c      d e    
#>    <dttm>              <date>     <int>  <dbl> <chr>
#>  1 2022-06-14 09:02:48 2022-06-23     1 0.745  u    
#>  2 2022-06-15 08:02:32 2022-07-13     2 0.456  l    
#>  3 2022-06-14 21:48:36 2022-06-21     3 0.562  p    
#>  4 2022-06-14 13:19:02 2022-07-05     4 0.0293 f    
#>  5 2022-06-15 03:05:39 2022-06-25     5 0.634  w    
#>  6 2022-06-14 20:02:23 2022-07-08     6 0.570  k    
#>  7 2022-06-15 00:08:10 2022-07-05     7 0.0700 x    
#>  8 2022-06-14 20:06:30 2022-07-05     8 0.602  l    
#>  9 2022-06-14 21:00:50 2022-07-02     9 0.940  r    
#> 10 2022-06-15 05:56:02 2022-06-26    10 0.174  h    
#> # … with 990 more rows
```

tibble 对于太多的数据，只会显示前十行，不会让你的控制台被内容淹没；同时会显示每一列的数据类型。这得益于 str() 函数。

tibble 还完美兼容 print() 函数：


```r
nycflights13::flights %>%
  print(n = 10, width = Inf) # Inf 表示无限，即所有指定内容（前十行）都打印
#> # A tibble: 336,776 × 19
#>     year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
#>    <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
#>  1  2013     1     1      517            515         2      830            819
#>  2  2013     1     1      533            529         4      850            830
#>  3  2013     1     1      542            540         2      923            850
#>  4  2013     1     1      544            545        -1     1004           1022
#>  5  2013     1     1      554            600        -6      812            837
#>  6  2013     1     1      554            558        -4      740            728
#>  7  2013     1     1      555            600        -5      913            854
#>  8  2013     1     1      557            600        -3      709            723
#>  9  2013     1     1      557            600        -3      838            846
#> 10  2013     1     1      558            600        -2      753            745
#>    arr_delay carrier flight tailnum origin dest  air_time distance  hour minute
#>        <dbl> <chr>    <int> <chr>   <chr>  <chr>    <dbl>    <dbl> <dbl>  <dbl>
#>  1        11 UA        1545 N14228  EWR    IAH        227     1400     5     15
#>  2        20 UA        1714 N24211  LGA    IAH        227     1416     5     29
#>  3        33 AA        1141 N619AA  JFK    MIA        160     1089     5     40
#>  4       -18 B6         725 N804JB  JFK    BQN        183     1576     5     45
#>  5       -25 DL         461 N668DN  LGA    ATL        116      762     6      0
#>  6        12 UA        1696 N39463  EWR    ORD        150      719     5     58
#>  7        19 B6         507 N516JB  EWR    FLL        158     1065     6      0
#>  8       -14 EV        5708 N829AS  LGA    IAD         53      229     6      0
#>  9        -8 B6          79 N593JB  JFK    MCO        140      944     6      0
#> 10         8 AA         301 N3ALAA  LGA    ORD        138      733     6      0
#>    time_hour          
#>    <dttm>             
#>  1 2013-01-01 05:00:00
#>  2 2013-01-01 05:00:00
#>  3 2013-01-01 05:00:00
#>  4 2013-01-01 05:00:00
#>  5 2013-01-01 06:00:00
#>  6 2013-01-01 05:00:00
#>  7 2013-01-01 06:00:00
#>  8 2013-01-01 06:00:00
#>  9 2013-01-01 06:00:00
#> 10 2013-01-01 06:00:00
#> # … with 336,766 more rows
```

查看数据的另一种办法是使用 view() 函数，会更直观地显示在你的编辑器上。


```r
nycflights13::flights %>%
  head(10) %>%
  view() # 请不要尝试展示太多数据！小心的的电脑炸掉（
```

### 读取子元素方面

元数据建立如下：


```r
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
```

按名字读取:


```r
df$x
#> [1] 0.7262986 0.4102714 0.6992059 0.3834217 0.4869947
df[["x"]]
#> [1] 0.7262986 0.4102714 0.6992059 0.3834217 0.4869947
```

按序列位置读取：


```r
df[[1]]
#> [1] 0.7262986 0.4102714 0.6992059 0.3834217 0.4869947
```

但如果使用管道符的话，我们需要使用 “.”：


```r
df %>% .$x
#> [1] 0.7262986 0.4102714 0.6992059 0.3834217 0.4869947
df %>% .[["x"]]
#> [1] 0.7262986 0.4102714 0.6992059 0.3834217 0.4869947
```

## tibble 的转换

上面提到使用 as_tibble() 将 data.frame 转换为 tibble，而 as.data.frame() 函数则是将 tibble 转化为 data.frame：


```r
class(as.data.frame(tb)) # class() 函数用于检查数据格式
#> [1] "data.frame"
```

