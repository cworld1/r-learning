# 11 Data import

library(tidyverse)

# 【实战】简单读取文件 ----

# 函数及其功能 ----
# | 文件特征 | 函数            | 适用条件                               |
# | -------- | --------------- | ------------------------------------- |
# | 符号分隔 | read_csv()      | 逗号分隔                               |
# | 符号分隔 | read_csv2()     | 分号分隔（常见于用作小数位的国家）       |
# | 符号分隔 | read_tsv()      | 制表符分隔                             |
# | 符号分隔 | read_delim()    | 任何符号分隔                           |
# | 固定宽度 | read_fwf()      | 固定宽度                               |
# | 固定宽度 | fwf_widths()    | 宽度指定字段                           |
# | 固定宽度 | fwf_positions() | 位置指定字段                           |
# | 固定宽度 | read_table()    | 固定宽度文件的常见变体，且列用空格分隔   |
# | 日志     | read_log()      | Apache 风格的日志文件                  |

# 此外 webreadr 基于 read_log() 构建，并提供更多有用的工具。
# 这些函数都有类似的语法：一旦您掌握了一个，您可以轻松地使用其他功能。
# csv 文件是最常见的数据存储形式之一。我们将重点关注 read_csv()，其首个参数最为重要，即要读取的文件的路径。

# read_csv() ----
# read_csv() 会给出相当丰富的信息，包括行列数、分隔符、各列的数据格式（自动识别）等：
heights <- read_csv("./c_Wrangle_扭结/source/heights.csv")
#> Rows: 1192 Columns: 6
#> -- Column specification -----------------------------------------------<
#> Delimiter: ","
#> chr (2): sex, race
#> dbl (4): earn, height, ed, age
#>
#> i Use `spec()` to retrieve the full column specification for this data.
#> i Specify the column types or set `show_col_types = FALSE` to quiet message.

# 对于内联表格我们同样可以这样处理：
read_csv("a,b,c
1,2,3
4,5,6")
#> # A tibble: 2 x 3
#>       a     b     c
#>   <dbl> <dbl> <dbl>
#> 1     1     2     3
#> 2     4     5     6

# 如果内容的开头有一些不需要的数据，我们可以跳过开头的内容：
read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)
#> # A tibble: 1 x 3
#>       x     y     z
#>   <dbl> <dbl> <dbl>
#> 1     1     2     3

# 或者直接跳过以指定字符开头的行（如以 “#” 开头）
read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#")
#> # A tibble: 1 x 3
#>       x     y     z
#>   <dbl> <dbl> <dbl>
#> 1     1     2     3

# 有时导入的数据可能没有表头！忽略掉表头，R 会为你加上 “X1”、“X2”...
read_csv("1,2,3\n4,5,6", col_names = FALSE)
#> # A tibble: 2 x 3
#>      X1    X2    X3
#>   <dbl> <dbl> <dbl>
#> 1     1     2     3
#> 2     4     5     6
# 或者手动加表头：
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))
#> # A tibble: 2 x 3
#>       x     y     z
#>   <dbl> <dbl> <dbl>
#> 1     1     2     3
#> 2     4     5     6

# 不只是表头，有时数据也会缺失。对 NA 值的数进行符号标记即可：
read_csv("a,b,c\n1,2,.", na = ".")
#> # A tibble: 1 x 3
#>       a     b c
#>   <dbl> <dbl> <lgl>
#> 1     1     2 NA

# 【热身】解析向量 ----
# 在深入了解阅读器如何从磁盘读取文件之前，我们需要先了解 parse_*() 函数。

# 对这些函数传入字符串向量，可以得到数据类型更专一合理的向量，如逻辑、整数或日期：
str(parse_logical(c("TRUE", "FALSE", "NA"))) # str() 用于显示 R 对象的内部结构
#>  logi [1:3] TRUE FALSE NA
str(parse_integer(c("1", "2", "3")))
#>  int [1:3] 1 2 3
str(parse_date(c("2010-01-01", "1979-10-14")))
#> Date[1:2], format: "2010-01-01" "1979-10-14"

# 我们也可以设置缺省值：
parse_integer(c("1", "231", ".", "456"), na = ".")
#> [1]   1 231  NA 456

# 解析失败会提示相关警示：
x <- parse_integer(c("123", "345", "abc", "123.45"))
#> Warning: 2 parsing failures.
#> row col               expected actual
#>   3  -- an integer             abc
#>   4  -- no trailing characters 123.45
# 之后的读取也会报错：
x
#> [1] 123 345  NA  NA
#> attr(,"problems")
#> # A tibble: 2 x 4
#>     row   col expected               actual
#>   <int> <int> <chr>                  <chr>
#> 1     3    NA an integer             abc
#> 2     4    NA no trailing characters 123.45
# 和提示的一样，我们可以使用 problems() 函数显示错误根源：
problems(x)
#> # A tibble: 2 x 4
#>     row   col expected               actual
#>   <int> <int> <chr>                  <chr>
#> 1     3    NA an integer             abc
#> 2     4    NA no trailing characters 123.45

# 数字类型 ----
# 不同国家地区使用的分隔符、习惯等都不相同。所以这里有 locale 参数用来处理。如：

# 小数点标识符（decimal_mark）：
parse_double("1.23")
#> [1] 1.23
parse_double("1,23", locale = locale(decimal_mark = ",")) # 改用 “,” 识别
#> [1] 1.23

# 数字前后非数字字符：
parse_number("$100")
#> [1] 100
parse_number("20%")
#> [1] 20
parse_number("It cost $123.45")
#> [1] 123.45

# 位数标记（grouping_mark）：
parse_number("$123,456,789")
#> [1] 123456789
parse_number("123.456.789", locale = locale(grouping_mark = ".")) # 常见于欧洲
#> [1] 123456789
parse_number("123'456'789", locale = locale(grouping_mark = "'")) # 常见于瑞士
#> [1] 123456789

# 字符类型 ----
# 貌似 parse_character() 是只会返回输入的无用函数。但事实上，我们有多种方式来表示同一字符串。
# 要了解 R 中如何表示字符串的细节，我们可以使用 charToRaw() 获得字符串的底层表示：
charToRaw("Hadley")
#> [1] 48 61 64 6c 65 79

# 像这样，从十六进制数字到字符的映射的编码称为 ASCII，也是美国信息交换标准代码。
# 但英语以外的编码就非常复杂了，用不同编码读取数据，他们将完全不同。
# 如今我们有一个通用标准：UTF-8。UTF-8几乎可以编码当今人类使用的每个字符，以及许多额外的符号。

# 但旧的非通用标准有时也是需要的：
(x1 <- "El Ni\xf1o was particularly bad this year")
#> [1] "El Ni\xf1o was particularly bad this year"
(x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd")
#> [1] "\x82\xb1\x82\xf1\x82\u0242\xbf\x82\xcd"

# 使用 encoding 来转译它们的编码：
parse_character(x1, locale = locale(encoding = "Latin1"))
#> [1] "El Ni<U+00F1>o was particularly bad this year"
parse_character(x2, locale = locale(encoding = "Shift-JIS"))
#> [1] "こんにちは"

# 有时我们并不知道它是什么类型的编码！所幸的是，guess_encodeing() 会帮助我们尝试：
guess_encoding(charToRaw(x1))
#> # A tibble: 2 x 2
#>   encoding   confidence
#>   <chr>           <dbl>
#> 1 ISO-8859-1       0.46
#> 2 ISO-8859-9       0.23
guess_encoding(charToRaw(x2))
#> # A tibble: 1 x 2
#>   encoding confidence
#>   <chr>         <dbl>
#> 1 KOI8-R         0.42

# 因子类型 ----
# R 使用因子来表示具有一组已知可能值的分类变量。
# 给 parse_factor() 一个已知 levels 的向量，以便在出现意外值时生成警告：
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
#> Warning: 1 parsing failure.
#> row col           expected   actual
#>   3  -- value in level set bananana
#> [1] apple  banana <NA>
#> attr(,"problems")
#> # A tibble: 1 x 4
#>     row   col expected           actual
#>   <int> <int> <chr>              <chr>
#> 1     3    NA value in level set bananana
#> Levels: apple banana

# 日期时间类型 ----
# 我们可以根据想要的日期（自1970-01-01以来的天数）、日期时间（自1970-01-01年以来的秒数）
# 或时间（自午夜以来的秒数），在三个解析器之间进行选择。当在没有任何其他参数的情况下调用时：

# parse_datetime() 根据 ISO8601 国际标准转换日期时间：
parse_datetime("2010-10-01T2010")
#> [1] "2010-10-01 20:10:00 UTC"
# If time is omitted, it will be set to midnight
parse_datetime("20101010")
#> [1] "2010-10-10 UTC"

# parse_date() 用于转换四位数年份，使用 “-” 或 “/” 都可（但没有分隔符则会报错）：
parse_date("2010-10-01")
#> [1] "2010-10-01"

# parse_time() 用于转换时分秒（秒和上下午可选）：
library(hms) # R 不自带，我们需要调用 hms 包（tidyverse 的 readr 包也有）
parse_time("01:10 am")
#> 01:10:00
parse_time("20:10:01")
#> 20:10:01

# 日期时间字符串形式可以自己制定：
# | 类型     | 表示符 | 备注                      | 示例               |
# | -------- | ------ | ------------------------ | ------------------ |
# | 年       | %Y     | 4位数字                  |                    |
# | 年       | %y     | 2位数字                  | 00-69 -> 2000-2069 |
# | 月       | %m     | 2位数字                  |                    |
# | 月       | %b     | 缩写                     | Jan                |
# | 月       | %B     | 全称                     | 一月               |
# | 日       | %d     | 2位数字                  |                    |
# | 日       | %e     | optional leading space   |                    |
# | 时       | %H     | 0-23小时                 |                    |
# | 时       | %I     | 0-12小时，与 %p 捆绑使用  |                    |
# | 上下午   | %p     | AM/PM                    |                    |
# | 分       | %M     | 分钟                     |                    |
# | 秒       | %S     | 整数秒                   |                    |
# | 秒       | %OS    | 真正意义的秒             |                    |
# | 时区     | %Z     | 时区（名称）             | America/Chicago    |
# | 标准时区 | %z     | 以 UTC 标准时区做偏移量   | +0800              |
# | 非数字   | %.     | 跳过一个非数字字符        |                    |
# | 非数字   | %*     | 跳过任意数量的非数字      |                    |

# 例如：
parse_date("01/02/15", "%m/%d/%y")
#> [1] "2015-01-02"
parse_date("01/02/15", "%d/%m/%y")
#> [1] "2015-02-01"
parse_date("01/02/15", "%y/%m/%d")
#> [1] "2001-02-15"

# 如果将 %b 或 %B 与非英语的月份名称一起使用，则需要将 lang 参数设置为 locale()。
# 使用函数 date_names_langs() 查看内置语言列表，或者使用 date_names() 自定义。
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))
#> [1] "2015-01-01"

# 【实战】解析文件 ----

# 自动匹配 ----
# readr 一般读取前 1000 行，并使用一些启发式的方法（保持适度保守）来确定每列的类型。
# guess_parser() 返回字符向量的最佳类型猜测
# parse_guess() 返回用该类型解析的内容：
guess_parser("2010-10-01")
#> [1] "date"
guess_parser("15:01")
#> [1] "time"
guess_parser(c("TRUE", "FALSE"))
#> [1] "logical"
guess_parser(c("1", "5", "9"))
#> [1] "double"
guess_parser(c("12,352,561"))
#> [1] "number"
str(parse_guess("2010-10-10"))
#>  Date[1:1], format: "2010-10-10"

# 这种 “启发式” 尝试以下每种类型，并在找到满足匹配项时停止：
# - 逻辑值：仅包含 “F”、“T”、“FALSE” 或 “TRUE”。
# - 整数：仅包含数字字符（可能还有 “-”）。
# - 小数：仅包含有效的小数（可能还有 4.5e-5 等数字）。
# - 数字：包含有效的小数类型（可能还有分组标记）。
# - 时间：与默认的 time_format 匹配。
# - 日期：与默认的 date_format 匹配。
# - 日期时间：任何满足 ISO8601 格式的日期时间。
# 如果这些规则都不适用，那么该列将保持字符串向量。

# 自动匹配遇到的问题 ----
challenge <- read_csv(readr_example("challenge.csv"))
# Coder 在学习这里的时候发现问题已经无法复现。此处已经不再报错
#> ── Column specification ───────────────────────────────────────────
#> cols(
#>   x = col_double(),
#>   y = col_logical()
#> )
#> Warning: 1000 parsing failures.
#>  row col           expected     actual                        file
#> 1001   y 1/0/T/F/TRUE/FALSE 2015-01-16 '/Users/runner/work/_temp/…
#> 1002   y 1/0/T/F/TRUE/FALSE 2018-05-18 '/Users/runner/work/_temp/…
#> 1003   y 1/0/T/F/TRUE/FALSE 2015-09-05 '/Users/runner/work/_temp/…
#> 1004   y 1/0/T/F/TRUE/FALSE 2012-11-28 '/Users/runner/work/_temp/…
#> 1005   y 1/0/T/F/TRUE/FALSE 2020-01-13 '/Users/runner/work/_temp/…
#> .... ... .................. .......... .........................…
#> See problems(...) for more details.

# 我们决定对错误进行定位：
problems(challenge)
#> # A tibble: 1,000 x 5
#>     row col   expected        actual   file
#>   <int> <chr> <chr>           <chr>    <chr>
#> 1  1001 y     1/0/T/F/TRUE/F… 2015-01… '/Users/runner/work/_temp/…
#> 2  1002 y     1/0/T/F/TRUE/F… 2018-05… '/Users/runner/work/_temp/…
#> 3  1003 y     1/0/T/F/TRUE/F… 2015-09… '/Users/runner/work/_temp/…
#> 4  1004 y     1/0/T/F/TRUE/F… 2012-11… '/Users/runner/work/_temp/…
#> 5  1005 y     1/0/T/F/TRUE/F… 2020-01… '/Users/runner/work/_temp/…
#> 6  1006 y     1/0/T/F/TRUE/F… 2016-04… '/Users/runner/work/_temp/…
#> # … with 994 more rows

# 嗯...怎么看了跟没看似的。tail() 函数用来查看表头或表尾：
tail(challenge)
#> # A tibble: 6 x 2
#>       x y
#>   <dbl> <lgl>
#> 1 0.805 NA
#> 2 0.164 NA
#> 3 0.472 NA
#> 4 0.718 NA
#> 5 0.270 NA
#> 6 0.608 NA

# 这表明我们需要手动对数据进行解析：
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols( # 对列类型进行手动声明
    x = col_double(), # 第一列为 x，小数类型
    y = col_logical() # 第二列为 y，逻辑值类型
  )
)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
tail(challenge)
#> # A tibble: 6 x 2
#>       x y
#>   <dbl> <date>
#> 1 0.805 2019-11-21
#> 2 0.164 2018-03-29
#> 3 0.472 2014-08-04
#> 4 0.718 2015-08-16
#> 5 0.270 2020-02-04
#> 6 0.608 2019-01-06

# col_types 是有必要的，这至少能确保它生成的数据更为可靠一些。

# 其他的匹配解决策略 ----
# 上面提到的自动解析出错只是因为默认的 1000 行不够用而已。哪怕只是多解析一行：
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
#>
#> ── Column specification ────────────────────────────────
#> cols(
#>   x = col_double(),
#>   y = col_date(format = "")
#> )
challenge2
#> # A tibble: 2,000 x 2
#>       x y
#>   <dbl> <date>
#> 1   404 NA
#> 2  4172 NA
#> 3  3004 NA
#> 4   787 NA
#> 5    37 NA
#> 6  2332 NA
#> # … with 1,994 more rows
# 你看。问题解决了呢。

# 另外一种思路是将向量声明为默认字符类型向量，这可能使你的定位更容易一些：
challenge2 <- read_csv(readr_example("challenge.csv"),
  col_types = cols(.default = col_character())
)

# 这里用简单的数据集演示 type_convert() 的效果：
df <- tribble(
  ~x,  ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df
#> # A tibble: 3 x 2
#>   x     y
#>   <chr> <chr>
#> 1 1     1.21
#> 2 2     2.32
#> 3 3     4.56
type_convert(df)
#>
#> ── Column specification ─────────────────────────────────────────
#> cols(
#>   x = col_double(),
#>   y = col_double()
#> )
#> # A tibble: 3 x 2
#>       x     y
#>   <dbl> <dbl>
#> 1     1  1.21
#> 2     2  2.32
#> 3     3  4.56
# 可以看到 “启发性” 转换到底转换成了什么类型。

# 【实战】写入数据 ----

# csv 格式 ----
write_csv(challenge, "./c_Wrangle_扭结/source/challenge.csv")
# 很简单，不是吗？
# 小心事情还没结束。你看，数据类型就这么丢了：
challenge
#> # A tibble: 2,000 x 2
#>       x y
#>   <dbl> <date>
#> 1   404 NA
#> 2  4172 NA
#> 3  3004 NA
#> 4   787 NA
#> 5    37 NA
#> 6  2332 NA
#> # … with 1,994 more rows
write_csv(challenge, "./c_Wrangle_扭结/source/challenge-2.csv")
read_csv("./c_Wrangle_扭结/source/challenge-2.csv")
# Coder 这里也没有发现错读的问题。应该使 R 包对于行的检测增强增加了。
#> ── Column specification ────────────────────────────────────────
#> cols(
#>   x = col_double(),
#>   y = col_logical()
#> )
#> # A tibble: 2,000 x 2
#>       x y
#>   <dbl> <lgl>
#> 1   404 NA
#> 2  4172 NA
#> 3  3004 NA
#> 4   787 NA
#> 5    37 NA
#> 6  2332 NA
#> # … with 1,994 more rows

# rds 格式
# 为了解决这个问题，我们提出了新的函数：
# write_rds() 和 read_rds() 基于 R 的基本函数 readRDS() 和 saveRDS()。
# 注意这些数据会以被 R 称为 RDS 格式的自定义二进制格式存储数据：
write_rds(challenge, "./c_Wrangle_扭结/source/challenge.rds")
read_rds("./c_Wrangle_扭结/source/challenge.rds")
#> # A tibble: 2,000 x 2
#>       x y
#>   <dbl> <date>
#> 1   404 NA
#> 2  4172 NA
#> 3  3004 NA
#> 4   787 NA
#> 5    37 NA
#> 6  2332 NA
#> # … with 1,994 more rows
# 但 rds 格式不流行也不通用。

# feather 格式 ----
# feather 包也实现了一种快速的二进制文件格式，可以跨编程语言共享：
library(feather)
write_feather(challenge, "./c_Wrangle_扭结/source/challenge.feather")
read_feather("./c_Wrangle_扭结/source/challenge.feather")
#> # A tibble: 2,000 x 2
#>       x      y
#>   <dbl> <date>
#> 1   404   <NA>
#> 2  4172   <NA>
#> 3  3004   <NA>
#> 4   787   <NA>
#> 5    37   <NA>
#> 6  2332   <NA>
#> # ... with 1,994 more rows

# 其他格式 ----
# 其他的一些常见格式也支持。事实上所有已知格式，在社区包的帮助下，通常都能解决。
# 下面是一些常见格式：
# - haven：读取 SPSS、Stata 和 SAS 文件。
# - readxl：读取 excel 文件（包括.xls和.xlsx）。
# - DBI：DBI 和一些特定数据库的后端（如 RMySQL、RSQLite、RPostgreSQL 等）。