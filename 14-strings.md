# Strings {#string}

本节主要学习字符串如何工作以及如何手动创建字符串的基础知识，但其重点在正则表达式上。

正则表达式很有用，因为字符串通常包含非结构化或半结构化数据，而正则表达式是一种用于描述字符串中模式的简洁语言。


```r
library(tidyverse)
```

## 字符串基本知识

与其他语言不同，或者说与 Python 相同，我们可以随意创建带有单引号或双引号的字符串，而且它们没有区别。但其实更建议始终使用`"`，除非要创建一个包含多个`"`的字符串。


```r
string1 <- "This is a string"
string1
#> [1] "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
string2
#> [1] "If I want to include a \"quote\" inside a string, I use single quotes"
# 有时候其实使用反斜杠 “\” 来转义是一个更好的选择
double_quote <- "\"" # 或者 '"'
single_quote <- "'" # 或者 "'"
# 这意味着如果要包含文字反斜杠，则需要将其加倍："\\"
```

但注意字符串的打印表示形式与字符串本身不同：打印的表示形式为显示转义。要查看字符串的原始内容，我们需要用上 `str_view()` 或者 R 自带包的 `writeLines()`：


```r
x <- c(single_quote, double_quote)
x
#> [1] "'"  "\""
writeLines(x) # 查看原始
#> '
#> "
```

还有其他几个特殊字符书写。最常见的是 `\n` 换行符和`\t`。有时还会看到像是 `\u00b5` 这样的字符串，这是一种在所有平台上编写非英语字符的通用方法：


```r
x <- "\u00b5"
x
#> [1] "µ"
```

多个字符串通常存储在字符向量中，您可以使用以下命令创建：c()


```r
c("one", "two", "three")
#> [1] "one"   "two"   "three"
```

R 自带的 Base 包含许多用于处理字符串的函数，但我们不打算使用它们，因为它们种类复杂繁多各个函数结果也不同。相反，我们将使用 stringr 包（已经集成在 tidyverse 里）里的函数 `str_*()`。它们具有更直观的名称，也更好用。

### 字符串长度


```r
str <- c("a", "R for data science", NA)
str_length(str) # 查看长度
#> [1]  1 18 NA
```

### 合并字符串


```r
str_c("|-", str, "-|") # 将多个字符串合并层一个
#> [1] "|-a-|"                  "|-R for data science-|" NA
str_c("|-", str_replace_na(str), "-|") # NA 转字符
#> [1] "|-a-|"                  "|-R for data science-|" "|-NA-|"
str_c(c("x", "y", "z"), collapse = ", ") # 使用指定字符串接
#> [1] "x, y, z"
```

其中 `str_c()` 参数里，长度为 0 的对象将自动被丢弃掉。这与 `if` 结合使用时特别有用：


```r
name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)
#> [1] "Good morning Hadley."
```

### 提取字符串

我们可以使用 `str_sub()` 提取字符串的指定部分，其参数分别为向量、起始和结束位。


```r
fruit <- c("Apple", "Banana", "Pear")
str_sub(fruit, 1, 3)
#> [1] "App" "Ban" "Pea"
str_sub(fruit, -3, -1)
#> [1] "ple" "ana" "ear"
# 我们也可以通过赋值法将内容赋值给选中部分：
str_sub(fruit, 1, 1) <- str_to_lower(str_sub(fruit, 1, 1))
fruit
#> [1] "apple"  "banana" "pear"
```

### 语言环境

不同的语言环境也会对大小写的写法造成影响。`str_to_upper` 就考虑到了这个问题，并给予了 `locate` 参数。


```r
str_to_upper(c("i", "<U+0131>"))
#> [1] "I"        "<U+0131>"
str_to_upper(c("i", "<U+0131>"), locale = "tr")
#> [1] "İ"        "<U+0131>"
```

这里有一个很好的表格：

| `aa` |    [阿法尔语](https://www.wanweibaike.net/wiki-阿法爾語)     | `fr` |        [法语](https://www.wanweibaike.net/wiki-法语)         | `li` | [林堡语](https://www.wanweibaike.net/wiki-林堡语)            | `se` | [北萨米语](https://www.wanweibaike.net/wiki-北萨米语)        |
| :--: | :----------------------------------------------------------: | :--: | :----------------------------------------------------------: | ---- | ------------------------------------------------------------ | ---- | ------------------------------------------------------------ |
| `ab` |  [阿布哈兹语](https://www.wanweibaike.net/wiki-阿布哈兹语)   | `fy` |  [弗里西亚语](https://www.wanweibaike.net/wiki-弗里西亚语)   | `ln` | [林加拉语](https://www.wanweibaike.net/wiki-林加拉语)        | `sg` | [桑戈语](https://www.wanweibaike.net/wiki-桑戈语)            |
| `ae` |  [阿维斯陀语](https://www.wanweibaike.net/wiki-阿维斯陀语)   | `ga` |    [爱尔兰语](https://www.wanweibaike.net/wiki-爱尔兰语)     | `lo` | [老挝语](https://www.wanweibaike.net/wiki-老挝语)            | `sh` | [塞尔维亚-克罗地亚语](https://www.wanweibaike.net/wiki-塞尔维亚-克罗地亚语) |
| `af` |      [南非语](https://www.wanweibaike.net/wiki-南非語)       | `gd` | [苏格兰盖尔语](https://www.wanweibaike.net/wiki-苏格兰盖尔语) | `lt` | [立陶宛语](https://www.wanweibaike.net/wiki-立陶宛语)        | `si` | [僧伽罗语](https://www.wanweibaike.net/wiki-僧伽罗语)        |
| `ak` |      [阿坎语](https://www.wanweibaike.net/wiki-阿坎语)       | `gl` |  [加利西亚语](https://www.wanweibaike.net/wiki-加利西亚语)   | `lu` | 卢巴语                                                       | `sk` | [斯洛伐克语](https://www.wanweibaike.net/wiki-斯洛伐克语)    |
| `am` |  [阿姆哈拉语](https://www.wanweibaike.net/wiki-阿姆哈拉语)   | `gn` |    [瓜拉尼语](https://www.wanweibaike.net/wiki-瓜拉尼语)     | `lv` | [拉脱维亚语](https://www.wanweibaike.net/wiki-拉脱维亚语)    | `sl` | [斯洛文尼亚语](https://www.wanweibaike.net/wiki-斯洛文尼亚语) |
| `an` |    [阿拉贡语](https://www.wanweibaike.net/wiki-阿拉贡语)     | `gu` |  [古吉拉特语](https://www.wanweibaike.net/wiki-古吉拉特语)   | `mg` | [马达加斯加语](https://www.wanweibaike.net/wiki-马达加斯加语) | `sm` | [萨摩亚语](https://www.wanweibaike.net/wiki-萨摩亚语)        |
| `ar` |    [阿拉伯语](https://www.wanweibaike.net/wiki-阿拉伯语)     | `gv` |    [马恩岛语](https://www.wanweibaike.net/wiki-马恩岛语)     | `mh` | [马绍尔语](https://www.wanweibaike.net/wiki-马绍尔语)        | `sn` | [修纳语](https://www.wanweibaike.net/wiki-修納語)            |
| `as` |    [阿萨姆语](https://www.wanweibaike.net/wiki-阿萨姆语)     | `ha` |      [豪萨语](https://www.wanweibaike.net/wiki-豪萨语)       | `mi` | [毛利语](https://www.wanweibaike.net/wiki-毛利语)            | `so` | [索马里语](https://www.wanweibaike.net/wiki-索马里语)        |
| `av` |    [阿瓦尔语](https://www.wanweibaike.net/wiki-阿瓦尔语)     | `he` |    [希伯来语](https://www.wanweibaike.net/wiki-希伯来语)     | `mk` | [马其顿语](https://www.wanweibaike.net/wiki-马其顿语)        | `sq` | [阿尔巴尼亚语](https://www.wanweibaike.net/wiki-阿尔巴尼亚语) |
| `ay` |    [艾马拉语](https://www.wanweibaike.net/wiki-艾马拉语)     | `hi` |      [印地语](https://www.wanweibaike.net/wiki-印地语)       | `ml` | [马拉雅拉姆语](https://www.wanweibaike.net/wiki-马拉雅拉姆语) | `sr` | [塞尔维亚语](https://www.wanweibaike.net/wiki-塞尔维亚语)    |
| `az` |  [阿塞拜疆语](https://www.wanweibaike.net/wiki-阿塞拜疆语)   | `ho` |  [希里莫图语](https://www.wanweibaike.net/wiki-希里莫圖語)   | `mn` | [蒙古语](https://www.wanweibaike.net/wiki-蒙古语)            | `ss` | [斯威士语](https://www.wanweibaike.net/wiki-斯威士語)        |
| `ba` |  [巴什基尔语](https://www.wanweibaike.net/wiki-巴什基尔语)   | `hr` |  [克罗地亚语](https://www.wanweibaike.net/wiki-克罗地亚语)   | `mo` | [摩尔达维亚语](https://www.wanweibaike.net/wiki-摩尔达维亚语) | `st` | [塞索托语](https://www.wanweibaike.net/wiki-塞索托语)        |
| `be` |  [白俄罗斯语](https://www.wanweibaike.net/wiki-白俄罗斯语)   | `ht` | [海地克里奥尔语](https://www.wanweibaike.net/wiki-海地克里奥尔语) | `mr` | [马拉地语](https://www.wanweibaike.net/wiki-马拉地语)        | `su` | [巽他语](https://www.wanweibaike.net/wiki-巽他語)            |
| `bg` |  [保加利亚语](https://www.wanweibaike.net/wiki-保加利亚语)   | `hu` |    [匈牙利语](https://www.wanweibaike.net/wiki-匈牙利语)     | `ms` | [马来语](https://www.wanweibaike.net/wiki-马来语)            | `sv` | [瑞典语](https://www.wanweibaike.net/wiki-瑞典语)            |
| `bh` |    [比哈尔语](https://www.wanweibaike.net/wiki-比哈尔语)     | `hy` |  [亚美尼亚语](https://www.wanweibaike.net/wiki-亚美尼亚语)   | `mt` | [马耳他语](https://www.wanweibaike.net/wiki-马耳他语)        | `sw` | [斯瓦希里语](https://www.wanweibaike.net/wiki-斯瓦希里语)    |
| `bi` |  [比斯拉马语](https://www.wanweibaike.net/wiki-比斯拉马语)   | `hz` |    [赫雷罗语](https://www.wanweibaike.net/wiki-赫雷罗语)     | `my` | [缅甸语](https://www.wanweibaike.net/wiki-缅甸语)            | `ta` | [泰米尔语](https://www.wanweibaike.net/wiki-泰米尔语)        |
| `bm` |    [班巴拉语](https://www.wanweibaike.net/wiki-班巴拉语)     | `ia` |      [因特语](https://www.wanweibaike.net/wiki-因特語)       | `na` | [瑙鲁语](https://www.wanweibaike.net/wiki-瑙鲁语)            | `te` | [泰卢固语](https://www.wanweibaike.net/wiki-泰卢固语)        |
| `bn` |    [孟加拉语](https://www.wanweibaike.net/wiki-孟加拉语)     | `id` |      [印尼语](https://www.wanweibaike.net/wiki-印尼语)       | `nb` | [书面挪威语](https://www.wanweibaike.net/wiki-書面挪威語)    | `tg` | [塔吉克语](https://www.wanweibaike.net/wiki-塔吉克语)        |
| `bo` |        [藏语](https://www.wanweibaike.net/wiki-藏语)         | `ie` |  [西方国际语](https://www.wanweibaike.net/wiki-西方国际语)   | `nd` | [北恩德贝莱语](https://www.wanweibaike.net/wiki-北恩德贝莱语) | `th` | [泰语](https://www.wanweibaike.net/wiki-泰语)                |
| `br` |  [布列塔尼语](https://www.wanweibaike.net/wiki-布列塔尼语)   | `ig` |      [伊博语](https://www.wanweibaike.net/wiki-伊博语)       | `ne` | [尼泊尔语](https://www.wanweibaike.net/wiki-尼泊尔语)        | `ti` | [提格雷尼亚语](https://www.wanweibaike.net/wiki-提格雷尼亚语) |
| `bs` |  [波斯尼亚语](https://www.wanweibaike.net/wiki-波斯尼亚语)   | `ii` | 四川[彝语](https://www.wanweibaike.net/wiki-彝语)（[诺苏语](https://www.wanweibaike.net/wiki-诺苏语)） | `ng` | [恩敦加语](https://www.wanweibaike.net/wiki-恩敦加语)        | `tk` | [土库曼语](https://www.wanweibaike.net/wiki-土库曼语)        |
| `ca` |    [加泰隆语](https://www.wanweibaike.net/wiki-加泰隆语)     | `ik` |  [伊努皮克语](https://www.wanweibaike.net/wiki-伊努皮克语)   | `nl` | [荷兰语](https://www.wanweibaike.net/wiki-荷兰语)            | `tl` | [他加禄语](https://www.wanweibaike.net/wiki-他加禄语)        |
| `ce` |      [车臣语](https://www.wanweibaike.net/wiki-车臣语)       | `io` |      [伊多语](https://www.wanweibaike.net/wiki-伊多语)       | `nn` | [新挪威语](https://www.wanweibaike.net/wiki-新挪威语)        | `tn` | [茨瓦纳语](https://www.wanweibaike.net/wiki-茨瓦纳语)        |
| `ch` |    [查莫罗语](https://www.wanweibaike.net/wiki-查莫罗语)     | `is` |      [冰岛语](https://www.wanweibaike.net/wiki-冰岛语)       | `no` | [挪威语](https://www.wanweibaike.net/wiki-挪威语)            | `to` | [汤加语](https://www.wanweibaike.net/wiki-湯加語)            |
| `co` |    [科西嘉语](https://www.wanweibaike.net/wiki-科西嘉语)     | `it` |    [意大利语](https://www.wanweibaike.net/wiki-意大利语)     | `nr` | [南恩德贝莱语](https://www.wanweibaike.net/wiki-南恩德贝莱语) | `tr` | [土耳其语](https://www.wanweibaike.net/wiki-土耳其语)        |
| `cr` |      [克里语](https://www.wanweibaike.net/wiki-克里语)       | `iu` |    [因纽特语](https://www.wanweibaike.net/wiki-因纽特语)     | `nv` | [纳瓦霍语](https://www.wanweibaike.net/wiki-納瓦霍語)        | `ts` | [宗加语](https://www.wanweibaike.net/wiki-宗加语)            |
| `cs` |      [捷克语](https://www.wanweibaike.net/wiki-捷克语)       | `ja` |        [日语](https://www.wanweibaike.net/wiki-日语)         | `ny` | [尼扬贾语](https://www.wanweibaike.net/wiki-尼扬贾语)        | `tt` | [塔塔尔语](https://www.wanweibaike.net/wiki-塔塔尔语)        |
| `cu` | [古教会斯拉夫语](https://www.wanweibaike.net/wiki-古教會斯拉夫語) | `jv` |      [爪哇语](https://www.wanweibaike.net/wiki-爪哇语)       | `oc` | [奥克语](https://www.wanweibaike.net/wiki-奥克语)            | `tw` | [特威语](https://www.wanweibaike.net/wiki-特威语)            |
| `cv` |    [楚瓦什语](https://www.wanweibaike.net/wiki-楚瓦什语)     | `ka` |  [格鲁吉亚语](https://www.wanweibaike.net/wiki-格鲁吉亚语)   | `oj` | [奥杰布瓦语](https://www.wanweibaike.net/wiki-奥杰布瓦语)    | `ty` | [塔希提语](https://www.wanweibaike.net/wiki-塔希提语)        |
| `cy` |    [威尔士语](https://www.wanweibaike.net/wiki-威尔士语)     | `kg` |      [刚果语](https://www.wanweibaike.net/wiki-刚果语)       | `om` | [奥罗莫语](https://www.wanweibaike.net/wiki-奥罗莫语)        | `ug` | [维吾尔语](https://www.wanweibaike.net/wiki-维吾尔语)        |
| `da` |      [丹麦语](https://www.wanweibaike.net/wiki-丹麦语)       | `ki` |    [基库尤语](https://www.wanweibaike.net/wiki-基庫尤語)     | `or` | [奥里亚语](https://www.wanweibaike.net/wiki-奥里亚语)        | `uk` | [乌克兰语](https://www.wanweibaike.net/wiki-乌克兰语)        |
| `de` |        [德语](https://www.wanweibaike.net/wiki-德语)         | `kj` |    [宽亚玛语](https://www.wanweibaike.net/wiki-寬亞瑪語)     | `os` | [奥塞梯语](https://www.wanweibaike.net/wiki-奥塞梯语)        | `ur` | [乌尔都语](https://www.wanweibaike.net/wiki-乌尔都语)        |
| `dv` |    [迪维西语](https://www.wanweibaike.net/wiki-迪维西语)     | `kk` |    [哈萨克语](https://www.wanweibaike.net/wiki-哈萨克语)     | `pa` | [旁遮普语](https://www.wanweibaike.net/wiki-旁遮普语)        | `uz` | [乌兹别克语](https://www.wanweibaike.net/wiki-乌兹别克语)    |
| `dz` |      [不丹语](https://www.wanweibaike.net/wiki-不丹语)       | `kl` |    [格陵兰语](https://www.wanweibaike.net/wiki-格陵兰语)     | `pi` | [巴利语](https://www.wanweibaike.net/wiki-巴利语)            | `ve` | [文达语](https://www.wanweibaike.net/wiki-文達語)            |
| `ee` |      [埃维语](https://www.wanweibaike.net/wiki-埃维语)       | `km` |      [高棉语](https://www.wanweibaike.net/wiki-高棉语)       | `pl` | [波兰语](https://www.wanweibaike.net/wiki-波兰语)            | `vi` | [越南语](https://www.wanweibaike.net/wiki-越南语)            |
| `el` |    [现代希腊语](https://www.wanweibaike.net/wiki-希腊语)     | `kn` |    [卡纳达语](https://www.wanweibaike.net/wiki-卡纳达语)     | `ps` | [普什图语](https://www.wanweibaike.net/wiki-普什图语)        | `vo` | [沃拉普克语](https://www.wanweibaike.net/wiki-沃拉普克语)    |
| `en` |        [英语](https://www.wanweibaike.net/wiki-英语)         | `ko` | [朝鲜语](https://www.wanweibaike.net/wiki-朝鲜语)、[韩语](https://www.wanweibaike.net/wiki-韩语) | `pt` | [葡萄牙语](https://www.wanweibaike.net/wiki-葡萄牙语)        | `wa` | [瓦隆语](https://www.wanweibaike.net/wiki-瓦隆语)            |
| `eo` |      [世界语](https://www.wanweibaike.net/wiki-世界语)       | `kr` |    [卡努里语](https://www.wanweibaike.net/wiki-卡努里語)     | `qu` | [克丘亚语](https://www.wanweibaike.net/wiki-克丘亚语)        | `wo` | [沃洛夫语](https://www.wanweibaike.net/wiki-沃洛夫語)        |
| `es` |    [西班牙语](https://www.wanweibaike.net/wiki-西班牙语)     | `ks` |  [克什米尔语](https://www.wanweibaike.net/wiki-克什米尔语)   | `rm` | [罗曼什语](https://www.wanweibaike.net/wiki-罗曼什语)        | `xh` | [科萨语](https://www.wanweibaike.net/wiki-科萨语)            |
| `et` |  [爱沙尼亚语](https://www.wanweibaike.net/wiki-爱沙尼亚语)   | `ku` |    [库尔德语](https://www.wanweibaike.net/wiki-库尔德语)     | `rn` | [基隆迪语](https://www.wanweibaike.net/wiki-基隆迪语)        | `yi` | [依地语](https://www.wanweibaike.net/wiki-意第绪语)          |
| `eu` |    [巴斯克语](https://www.wanweibaike.net/wiki-巴斯克语)     | `kv` |      [科米语](https://www.wanweibaike.net/wiki-科米语)       | `ro` | [罗马尼亚语](https://www.wanweibaike.net/wiki-罗马尼亚语)    | `yo` | [约鲁巴语](https://www.wanweibaike.net/wiki-约鲁巴语)        |
| `fa` |      [波斯语](https://www.wanweibaike.net/wiki-波斯语)       | `kw` |    [康沃尔语](https://www.wanweibaike.net/wiki-康沃尔语)     | `ru` | [俄语](https://www.wanweibaike.net/wiki-俄语)                | `za` | [壮语](https://www.wanweibaike.net/wiki-壮语)                |
| `ff` |      [富拉语](https://www.wanweibaike.net/wiki-富拉语)       | `ky` |  [吉尔吉斯语](https://www.wanweibaike.net/wiki-吉尔吉斯语)   | `rw` | [卢旺达语](https://www.wanweibaike.net/wiki-卢旺达语)        | `zh` | [中文](https://www.wanweibaike.net/wiki-中文)、[汉语](https://www.wanweibaike.net/wiki-汉语) |
| `fi` |      [芬兰语](https://www.wanweibaike.net/wiki-芬兰语)       | `la` |      [拉丁语](https://www.wanweibaike.net/wiki-拉丁语)       | `sa` | [梵语](https://www.wanweibaike.net/wiki-梵语)                | `zu` | [祖鲁语](https://www.wanweibaike.net/wiki-祖鲁语)            |
| `fj` |      [斐济语](https://www.wanweibaike.net/wiki-斐济语)       | `lb` |    [卢森堡语](https://www.wanweibaike.net/wiki-卢森堡语)     | `sc` | [撒丁语](https://www.wanweibaike.net/wiki-撒丁语)            |      |                                                              |
| `fo` |      [法罗语](https://www.wanweibaike.net/wiki-法罗语)       | `lg` |    [卢干达语](https://www.wanweibaike.net/wiki-卢干达语)     | `sd` | [信德语](https://www.wanweibaike.net/wiki-信德语)            |      |                                                              |

自 [RFC 3066](https://tools.ietf.org/html/rfc3066) 出版后，ISO 639-1 新增了以下语言：

| ISO 639-1 | ISO 639-2 |                             名称                             |    更改日期    | 更改类型 | 曾用代码 |
| :-------: | :-------: | :----------------------------------------------------------: | :------------: | :------: | :------: |
|   `io`    |   `ido`   |      [伊多语](https://www.wanweibaike.net/wiki-伊多语)       | 2002年1月15日  |   新增   |  `art`   |
|   `wa`    |   `wln`   |      [瓦隆语](https://www.wanweibaike.net/wiki-瓦隆语)       | 2002年1月29日  |   新增   |  `roa`   |
|   `li`    |   `lim`   |      [林堡语](https://www.wanweibaike.net/wiki-林堡语)       |  2002年8月2日  |   新增   |  `gem`   |
|   `ii`    |   `iii`   | 四川省[彝语](https://www.wanweibaike.net/wiki-彝语)（[诺苏语](https://www.wanweibaike.net/wiki-诺苏语)） | 2002年10月14日 |   新增   |          |
|   `an`    |   `arg`   |    [阿拉贡语](https://www.wanweibaike.net/wiki-阿拉贡语)     | 2002年12月23日 |   新增   |  `roa`   |
|   `ht`    |   `hat`   | [海地克里奥尔语](https://www.wanweibaike.net/wiki-海地克里奥尔语) | 2003年2月26日  |   新增   |  `cpf`   |

### 字符串排序

事实上 R 自带的 `sort()` 和 `order()` 就已经很好用了，能依据系统设置区域来排序。但如果你想要自定义功能，那  `str_sort()` 可能是更优解。


```r
str_sort(fruit, locale = "en") # 使用 English 排序
#> [1] "apple"  "banana" "pear"
str_sort(fruit, locale = "haw") # 使用 Hawaiian 排序
#> [1] "apple"  "banana" "pear"
```

## 正则表达式

### 基本匹配

使用 `str_view()` 可以可视化地观察匹配到的字符串：


```r
str_view(fruit, "an")
#> [2] │ b<an><an>a
```

匹配字符串遵循 regexps 规则，其中 “.” 表示任意字符：


```r
str_view(fruit, ".a.")
#> [2] │ <ban>ana
#> [3] │ p<ear>
```

但我们很快就发现一个问题：“.” 固然好用，但当我们真正要匹配字符 “.” 的时候，就会变得棘手。regexps 提供了转义法，即 `\.`，但这个 “\” 会与我们的 R 语言规范相冲突。所以我们提出了转义斜杠。


```r
# 双斜杠会转义斜杠
dot_symbol <- "\\."

# 实际打印出来的表达式是单斜杠
writeLines(dot_symbol)
#> \.

# 而通过 regexps 转换匹配时，刚好就只是一个 “.” 而已
str_view(c("abc", "a.c", "bef"), "a\\.c")
#> [2] │ <a.c>
```

同理，匹配一个反斜杠则需要4个斜杠：


```r
x <- "a\\b"
writeLines(x)
#> a\b

str_view(x, "\\\\")
#> [1] │ a<\>b
```

### 锚点定位

以锚点为起始，会一直指向字符串的开始或结尾点比较特征进行匹配。如：

- `^` + 匹配串：刚好与字符串的开头相匹配。
- 匹配串 + `$`：刚好与字符串的末尾相匹配。


```r
apple <- c("bad apple", "milk with apple & banana", "apple music", "apple")
str_view(apple, "^a") # 以 “a” 开头的字符串
#> [3] │ <a>pple music
#> [4] │ <a>pple
```


```r
str_view(apple, "a$") # 以 “a” 结尾的字符串
#> [2] │ milk with apple & banan<a>
```


```r
str_view(x, "^apple$") # 以 “apple” 开头和结束（不多不少完全匹配）的字符串
```

我知道你会记混的。所以我们从 [Evan Misshula](https://twitter.com/emisshula/status/323863393167613953) 那里搬出了这个口诀：

> 如果你从权力开始（`^`），你最终会得到财富（`$`）。

此外我们还可以将单词边界 `\b` 匹配。在 R 里我们可能不那么常常用到，但在 RStudio 等 IDE 里搜索时，当想找到作为其他函数组成部分的函数的名称时，有时会用到它。如，搜索 `\bsum\b`，可以避免匹配到 summarise、summary、rowsum 等。

### 字符型与替代法匹配

除了上面提到的 `$`、`^`、`\b` 锚点定位法，我们还有字符定位法：

- `\d`：匹配任何数字。
- `\s`：匹配任何空白符（如空格、制表符、换行符等）。
- `[abc]`：匹配 a、b 或 c。
- `[^abc]`：匹配除 a、b 或 c 之外的任何内容。

注意和上面的一样，在使用时仍然要常常进行二次转义。不过说到这里，比起二次转义，有很多人认为中括号转义会更舒服：


```r
abc <- c("abc", "a.c", "a*c", "a c")
str_view(abc, "a[.]c")
#> [2] │ <a.c>
```


```r
str_view(abc, ".[*]c")
#> [3] │ <a*c>
```


```r
str_view(abc, "a[ ]")
#> [4] │ <a >c
```

这种方法适用于大多数正则表达式元字符。但请不要过度依赖，因为仍然有部分特殊含义的字符不会被正常翻译转义。

此外我们还有一个或多个替代模式之间选择方案，如：`abc|d..f` 将匹配 “abc” 或 "deaf"。不过需要注意，`|` 的优先级通常很低，因此 `abc|xyz` 会匹配 “abc” 或 “xyz”，而不是 “abcyz” 或 “abxyz”。与数学表达式一样，如果优先级变得令人困惑，就请使用括号来明确你想要什么：


```r
str_view(c("grey", "gray"), "gr(e|a)y")
#> [1] │ <grey>
#> [2] │ <gray>
```

### 重复匹配

重复匹配用来匹配0个、一个甚至多个相同的内容。其中：

- 匹配字符 + `?`：0 或 1 次字符匹配（这个字符可有可无）
- 匹配字符 + `+`：1 或更多次字符匹配（这个字符允许出现一次或多次）
- 匹配字符 + `*`：0 或更多次字符匹配（这个字符可能没有，也可能有很多个）

查找 “CC” 或者 “C” 串：


```r
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
#> [1] │ 1888 is the longest year in Roman numerals: MD<CC><C>LXXXVIII
```

查找 “CC” 或者 “CCC...” 串：


```r
str_view(x, "CC+")
#> [1] │ 1888 is the longest year in Roman numerals: MD<CCC>LXXXVIII
```

查找 “CL”、“CX”、“CLX”、“CXL”，或者 “CLLL...”、“CXXX...”、“CLXXX...”、“CLLL...X”...

```r
str_view(x, "C[LX]+")
#> [1] │ 1888 is the longest year in Roman numerals: MDCC<CLXXX>VIII
```

注意这些运算符的优先级很高，并很多时候会用于匹配美式或英式拼写。这意味着大多数用途都需要括号，如：`colou?r` 或 `bana(na)+`

此外在数量上我们也可以手动说明：

- `{n}`：正好 n 个
- `{n,}`：n 或更多
- `{,m}`： 0 到 m 个
- `{n,m}`：介于 n 和 m 个之间


```r
str_view(x, "C{2}")
#> [1] │ 1888 is the longest year in Roman numerals: MD<CC>CLXXXVIII
```


```r
str_view(x, "C{2,}")
#> [1] │ 1888 is the longest year in Roman numerals: MD<CCC>LXXXVIII
```


```r
str_view(x, "C{2,3}")
#> [1] │ 1888 is the longest year in Roman numerals: MD<CCC>LXXXVIII
```

在通常情况下，如果碰到了能同时匹配到同一个点位的情况，Regex 会自动选择最长的。但你可以使用 “?” 来反其道而行之：


```r
str_view(x, "C{2,3}?")
#> [1] │ 1888 is the longest year in Roman numerals: MD<CC>CLXXXVIII
```


```r
str_view(x, "C[LX]+?")
#> [1] │ 1888 is the longest year in Roman numerals: MDCC<CL>XXXVIII
```

## 实际应用

在我们继续之前，我们需要注意一点：正因为正则表达式非常强大，我们很容易倾向于尝试用单个正则表达式解决每个问题。用 Jamie Zawinski 的话来说：

> Some people, when confronted with a problem, think “I know, I’ll use regular expressions.” Now they have two problems.
>
> 有些人在面对问题时，会这样想：“我知道，我会使用正则表达式。” 那现在他们有两个大问题。

比如我们有一个检查电子邮件的正则表达式：

```regex
(?:(?:\r\n)?[ \t])*(?:(?:(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t]
)+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:
\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(
?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ 
\t]))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\0
31]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\
](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+
(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:
(?:\r\n)?[ \t])*))*|(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z
|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)
?[ \t])*)*\<(?:(?:\r\n)?[ \t])*(?:@(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\
r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[
 \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)
?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t]
)*))*(?:,@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[
 \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*
)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t]
)+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*)
*:(?:(?:\r\n)?[ \t])*)?(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+
|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r
\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:
\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t
]))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031
]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](
?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?
:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?
:\r\n)?[ \t])*))*\>(?:(?:\r\n)?[ \t])*)|(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?
:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?
[ \t]))*"(?:(?:\r\n)?[ \t])*)*:(?:(?:\r\n)?[ \t])*(?:(?:(?:[^()<>@,;:\\".\[\] 
\000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|
\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>
@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"
(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t]
)*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\
".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?
:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[
\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*|(?:[^()<>@,;:\\".\[\] \000-
\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(
?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)*\<(?:(?:\r\n)?[ \t])*(?:@(?:[^()<>@,;
:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([
^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\"
.\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\
]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*(?:,@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\
[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\
r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] 
\000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]
|\\.)*\](?:(?:\r\n)?[ \t])*))*)*:(?:(?:\r\n)?[ \t])*)?(?:[^()<>@,;:\\".\[\] \0
00-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\
.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,
;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?
:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t])*
(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".
\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[
^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]
]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*\>(?:(?:\r\n)?[ \t])*)(?:,\s*(
?:(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\
".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(
?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[
\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t
])*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t
])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?
:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|
\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*|(?:
[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\
]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)*\<(?:(?:\r\n)
?[ \t])*(?:@(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["
()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)
?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>
@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*(?:,@(?:(?:\r\n)?[
 \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,
;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t]
)*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\
".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*)*:(?:(?:\r\n)?[ \t])*)?
(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".
\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(?:
\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\[
"()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])
*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])
+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\
.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z
|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*\>(?:(
?:\r\n)?[ \t])*))*)?;\s*)
```

这么变态的东西完全不能看！不过这确实可能会是我们实际在写代码的时候用到的东西（悲

### 匹配检测

如果只是要确定字符向量是否与模式匹配，请使用 `str_detect()` 。它将返回与输入长度相同的逻辑向量：


```r
fruit <- c("apple", "banana", "pear")
str_detect(fruit, "e")
#> [1]  TRUE FALSE  TRUE
```

不过由于 TRUE 和 FALSE 分别代表 0 或 1，我们也可以用来计数（`words` 是自带的一堆有序单词组成的向量）：


```r
# How many common words start with t?
sum(str_detect(words, "^t"))
#> [1] 65
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))
#> [1] 0.2765306
```

事实上，当我们具有复杂的逻辑条件（如匹配 a 或 b，但不匹配 c，除非 d），通常更容易将多个调用与逻辑运算符组合在一起，而不是尝试创建单个正则表达式。如刚刚的匹配元音字母：


```r
# 查找所有包含一个元音的所有单词并反向否定
no_vowels_1 <- !str_detect(words, "[aeiou]")
# 查找所有仅由辅音组成的单词（非元音单词）
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2) # identical() 用于返回两个内容是否相同
#> [1] TRUE
```

尽管结果是相同的，但我认为第一种方法更容易理解。如果你的正则表达式变得过于复杂，请尝试将其分解成更小的部分，为每个部分命名，然后将这些部分与逻辑运算相结合。


```r
words[str_detect(words, "x$")] # 选择模式，返回 T/F，需要中括号选出单词
#> [1] "box" "sex" "six" "tax"
str_subset(words, "x$") # 匹配模式，返回匹配到成功的子元素（注意并不是选出匹配到的部分内容）
#> [1] "box" "sex" "six" "tax"
```

但是，通常情况下，你要识别的字符串可能是 dataframe 或 tibble 的一列。所以我们通常对过滤器下手：


```r
df <- tibble(
  word = words,
  i = seq_along(word) # 针对指定列生成一列序号
)
df %>%
  filter(str_detect(word, "x$")) # 过滤筛选以 x 结尾的单词（元素）
#> # A tibble: 4 × 2
#>   word      i
#>   <chr> <int>
#> 1 box     108
#> 2 sex     747
#> 3 six     772
#> 4 tax     841
```

`str_detect()` 的变体是 `str_count()`。它不是简单的 yes 或 no，而是返回一个向量，告诉你字符串中有多少个匹配项：


```r
fruit <- c("apple", "banana", "pear")
str_count(fruit, "a")
#> [1] 1 3 1

# 求平均每个单词有几个元音
mean(str_count(words, "[aeiou]"))
#> [1] 1.991837
```

用的好就会非常自然：


```r
df %>%
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )
#> # A tibble: 980 × 4
#>    word         i vowels consonants
#>    <chr>    <int>  <int>      <int>
#>  1 a            1      1          0
#>  2 able         2      2          2
#>  3 about        3      3          2
#>  4 absolute     4      4          4
#>  5 accept       5      2          4
#>  6 account      6      3          4
#>  7 achieve      7      4          3
#>  8 across       8      2          4
#>  9 act          9      1          2
#> 10 active      10      3          3
#> # … with 970 more rows
```

### 提取匹配项

提取匹配项的实际文本，我们通常会使用 `str_extract()`。为了展示这一点，我们需要一个更复杂的例子。这里使用[哈佛句子（Harvard sentences）](https://en.wikipedia.org/wiki/Harvard_sentences) [stringr::sentences](https://stringr.tidyverse.org/reference/stringr-data.html)（已包含在 tidyverse），这些句子旨在测试 VOIP 系统，倒是对于练习正则表达式也格外有用：


```r
length(sentences)
#> [1] 720
head(sentences)
#> [1] "The birch canoe slid on the smooth planks." 
#> [2] "Glue the sheet to the dark blue background."
#> [3] "It's easy to tell the depth of a well."     
#> [4] "These days a chicken leg is a rare dish."   
#> [5] "Rice is often served in round bowls."       
#> [6] "The juice of lemons makes fine punch."
```

想象一下我们要找到所有包含颜色的句子。我们选择首先创建一个颜色名称的向量，然后将其转换为单个正则表达式：


```r
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match
#> [1] "red|orange|yellow|green|blue|purple"
```

然后我们可以选择包含颜色的句子，并提取颜色以确定它是哪一种：


```r
matches <- str_subset(sentences, colour_match) %>% # 筛选出带有颜色的句子
  str_extract(colour_match) # 提取匹配上的内容
head(matches)
#> [1] "blue" "blue" "red"  "red"  "red"  "blue"
```

但需要注意，我们这里仅提取了第一个匹配项。通过选择所有具有1个以上匹配项的句子，我们可以很容易地看到，其实这样的数据有不少：


```r
more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match) #
#> Warning: `str_view()` was deprecated in stringr 1.5.0.
#> ℹ Please use `str_view_all()` instead.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> [1] │ It is hard to erase <blue> or <red> ink.
#> [2] │ The <green> light in the brown box flicke<red>.
#> [3] │ The sky in the west is tinged with <orange> <red>.
```

可以明显看到一个句子匹配到了多个颜色。


```r
str_extract(more, colour_match) # 但 stringr 它真就只匹配一个。。
#> [1] "blue"   "green"  "orange"
str_extract_all(more, colour_match) # 使用 str_extract_all() 解决问题！
#> [[1]]
#> [1] "blue" "red" 
#> 
#> [[2]]
#> [1] "green" "red"  
#> 
#> [[3]]
#> [1] "orange" "red"
```

如果想要用矩阵表现结果的话，`simplify` 配置项可能会很有用。注意返回的矩阵，行表示元素，列表示匹配到第一次、第二次...分别匹配到的结果。


```r
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)
#>      [,1] [,2] [,3]
#> [1,] "a"  ""   ""  
#> [2,] "a"  "b"  ""  
#> [3,] "a"  "b"  "c"
```

## 分组匹配

例如，我是说假如，我们要从句子中提取名词。作为启发式方法，我们将查找 “a” 或 “the” 之后的任何单词，并标记为名词。在正则表达式中定义一个 “单词” 其实蛮麻烦的，所以在这里我使用一个简单的近似方法：至少不是一个空格。


```r
noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%
  str_subset(noun)

# str_extract() 会进行完整匹配
has_noun %>%
  str_extract(noun) %>%
  head(10)
#>  [1] "the smooth" "the sheet"  "the depth"  "a chicken"  "the parked"
#>  [6] "the sun"    "the huge"   "the ball"   "the woman"  "a helps"

# str_match() 则会按组给出每个单独匹配内容；返回矩阵
has_noun %>%
  str_match(noun) %>%
  head(10)
#>       [,1]         [,2]  [,3]     
#>  [1,] "the smooth" "the" "smooth" 
#>  [2,] "the sheet"  "the" "sheet"  
#>  [3,] "the depth"  "the" "depth"  
#>  [4,] "a chicken"  "a"   "chicken"
#>  [5,] "the parked" "the" "parked" 
#>  [6,] "the sun"    "the" "sun"    
#>  [7,] "the huge"   "the" "huge"   
#>  [8,] "the ball"   "the" "ball"   
#>  [9,] "the woman"  "the" "woman"  
#> [10,] "a helps"    "a"   "helps"
```

不出所料，我们检测名词的启发式方法很拉垮，并且还获取了像是 smooth、huge 等形容词。

如果你在自动匹配上遇到了困难，试着使用 `tidyr::extract()` 手动对比查看它们。它的工作方式类似于 `str_match()`，但需要手动命名匹配项，并将其放置在新列中：


```r
tibble(sentence = sentences) %>%
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove = FALSE
  )
#> # A tibble: 720 × 3
#>    sentence                                    article noun   
#>    <chr>                                       <chr>   <chr>  
#>  1 The birch canoe slid on the smooth planks.  the     smooth 
#>  2 Glue the sheet to the dark blue background. the     sheet  
#>  3 It's easy to tell the depth of a well.      the     depth  
#>  4 These days a chicken leg is a rare dish.    a       chicken
#>  5 Rice is often served in round bowls.        <NA>    <NA>   
#>  6 The juice of lemons makes fine punch.       <NA>    <NA>   
#>  7 The box was thrown beside the parked truck. the     parked 
#>  8 The hogs were fed chopped corn and garbage. <NA>    <NA>   
#>  9 Four hours of steady work faced us.         <NA>    <NA>   
#> 10 A large size in stockings is hard to sell.  <NA>    <NA>   
#> # … with 710 more rows
```

### 拆分

用于将字符串拆分为多个部分。例如，我们可以将句子拆分为单词：


```r
sentences %>%
  head(5) %>%
  str_split(" ")
#> [[1]]
#> [1] "The"     "birch"   "canoe"   "slid"    "on"      "the"     "smooth" 
#> [8] "planks."
#> 
#> [[2]]
#> [1] "Glue"        "the"         "sheet"       "to"          "the"        
#> [6] "dark"        "blue"        "background."
#> 
#> [[3]]
#> [1] "It's"  "easy"  "to"    "tell"  "the"   "depth" "of"    "a"     "well."
#> 
#> [[4]]
#> [1] "These"   "days"    "a"       "chicken" "leg"     "is"      "a"      
#> [8] "rare"    "dish."  
#> 
#> [[5]]
#> [1] "Rice"   "is"     "often"  "served" "in"     "round"  "bowls."

# 使用 simplify 配置项收缩到一个矩阵
sentences %>%
  head(5) %>%
  str_split(" ", simplify = TRUE)
#>      [,1]    [,2]    [,3]    [,4]      [,5]  [,6]    [,7]     [,8]         
#> [1,] "The"   "birch" "canoe" "slid"    "on"  "the"   "smooth" "planks."    
#> [2,] "Glue"  "the"   "sheet" "to"      "the" "dark"  "blue"   "background."
#> [3,] "It's"  "easy"  "to"    "tell"    "the" "depth" "of"     "a"          
#> [4,] "These" "days"  "a"     "chicken" "leg" "is"    "a"      "rare"       
#> [5,] "Rice"  "is"    "often" "served"  "in"  "round" "bowls." ""           
#>      [,9]   
#> [1,] ""     
#> [2,] ""     
#> [3,] "well."
#> [4,] "dish."
#> [5,] ""

# 配置 n 可以限制返回前几个
fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)
#>      [,1]      [,2]    
#> [1,] "Name"    "Hadley"
#> [2,] "Country" "NZ"    
#> [3,] "Age"     "35"
```

除了按模式拆分字符串之外，我们还可以使用 `boundary()` 按字符、行、句子和单词进行拆分：


```r
x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))
#> [1] │ <This> <is> <a> <sentence>.  <This> <is> <another> <sentence>.
```

## 正则表达式其他用法

- 用于查找全局环境中所有可用的对象 `apropos()`：如果里不太记得函数的名称，这将非常有用。


```r
apropos("replace")
#> [1] "%+replace%"       "replace"          "replace_na"       "setReplaceMethod"
#> [5] "str_replace"      "str_replace_all"  "str_replace_na"   "theme_replace"
```

- 列出目录中的所有指定文件 `dir()`：该参数采用正则表达式，并且仅返回与模式匹配的文件名。


```r
head(dir(pattern = "\\.Rmd$"))
#> [1] "01-introduction.Rmd"   "02-explore-intro.Rmd"  "15-factors.Rmd"       
#> [4] "22-model-intro.Rmd"    "23-model-basics.Rmd"   "24-model-building.Rmd"
```

