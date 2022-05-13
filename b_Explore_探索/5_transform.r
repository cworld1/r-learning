# 5 Data transformation

library(nycflights13)
library(tidyverse)

# -------- 实战：分析 flights 数据集 --------

# 在后面的案例中，我们将持续关注来自 nycflights13 的数据集 flights。
# 它包含 2013 年从纽约市出发的所有 336,776 个航班
flights
# 列名称下字母缩写代表该列的数据类型：
#  - int：整数
#  - dbl：双精度或实数
#  - chr：字符向量或字符串
#  - dttm：日期时间（日期 + 时间）
# 此外还有：
#  - lgl：仅包含逻辑词（TRUE / FALSE）
#  - fctr：因子（factor），表示具有固定可能值的分类变量
#  - date：日期

# tidyverse 附带了一些神奇的功能，如 filter、arrange、select、rename、mutate 和 summarise

# filter
# 筛选月份为 1，天数为 1 的
filter(flights, month == 1, day == 1)
# 筛选月份为 12 或者天数为 25 的（圣诞节）
filter(flights, month == 12 & day == 25)
# 筛选出月份为12，天数为 11 或者 12 的
filter(flights, month == 12, day == 11 | day == 12)
# 筛选出月份为12，天数为 10 或者 11 或者 12 的
filter(flights, month == 12, day %in% c(10, 11, 12)) # 注意 “包含于” 表示的方法
# 添加函数参数 na.rm = TRUE 来剔除数据，is.na 来判断是否为 NA（这是通用的）
filter(flights, month == 1, na.rm = TRUE)
# 注意：在比较数据时你可能会遇到浮点数导致结果不符合常理：
sqrt(2)^2 == 2
#> [1] FALSE
1 / 49 * 49 == 1
#> [1] FALSE
# 请使用 near() 函数解决这个问题
near(sqrt(2)^2, 2)
#> [1] TRUE
near(1 / 49 * 49, 1)
#> [1] TRUE

# arange
# 按照年月日排序
arrange(flights, year, month, day)
# 反向排序。注意无论正反向，NA 值总是被排到末尾
arrange(flights, desc(dep_delay))

# select
# 选出年月日
select(flights, year, month, day)
select(flights, year:day)
# 选出除年月日以及 flight 的所有列
select(flights, -c(year:day, flight)) # 有时 c 可以省略掉
# 选出结尾为 delay 相关的列
select(flights, ends_with("delay"))
# 选出开头为 sched 相关的列
select(flights, starts_with("sched"))
# 选出包含 sched 相关的列
select(flights, contains("sched"))
# 选出的数据将包含 sched，其他排后
select(flights, contains("sched"), everything())

# rename
# 一般用得很少，但有时很刚需。其实它是 select() 的变体
rename(flights, tail_num = tailnum)

# mutate 与 transmute
# 生成优化版的 flights 数据集
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(
    flights_sml,
    gain = dep_delay - arr_delay,
    speed_min = distance / air_time, # 计算出的新数据
    speed_sec = speed_min * 60 # 从刚生成的数据中套新数据
)
# 生成数据中不包含旧数据，应该使用 transmute
transmute(
    flights_sml,
    gain = dep_delay - arr_delay,
    speed_min = distance / air_time, # 计算出的新数据
    speed_sec = speed_min * 60 # 从刚生成的数据中套新数据
)

# -------- 热身：其他的对于处理数据很有用的功能 --------
# 算术运算符：+ - * /。它们可以用于向量，会自动帮你做一个 for 循环

# 模算术：%/% 求模、 %% 求余

# Log：log()、log2()、log10()。这些会在未来建模时常常用到

# 偏移量：lag() 值前导、lead() 值滞后，用于将向量的值前导或滞后。如：
(x <- 1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
lag(x)
#>  [1] NA  1  2  3  4  5  6  7  8  9
lead(x)
#>  [1]  2  3  4  5  6  7  8  9 10 NA

# 累积和滚动聚合：cumsum() 总和、cumprod() 乘积、cummin() 最小值、cummax() 最大值、cummean() 均值
# dplyr 也提供累积手段。如果您需要滚动聚合（即在滚动窗口上计算的总和），请尝试 RcppRoll 包。
x
#>  [1]  1  2  3  4  5  6  7  8  9 10
cumsum(x)
#>  [1]  1  3  6 10 15 21 28 36 45 55
cummean(x)
#>  [1] 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5

# summarise
# 一般用来总结浓缩信息，通常配合 group_by() 使用
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))