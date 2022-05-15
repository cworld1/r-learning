
library(tidyverse)
library(modelr)
options(na.action = na.warn)

# 模型由两部分组成：
# - 定义一系列模型，这些模型表示要捕获的精确但通用的模式。
# - 通过从最接近数据集中查找模型来生成拟合模型。这将采用通用模型系列，并使其具体化。

# 【实战】对 sim1 进行模型研究 ----
ggplot(sim1, aes(x, y)) +
    geom_point()
# 由图可以发现，x 变量和 y 变量可能有明显线性关系

random_models <- tibble(
    # 随机生成 250 个上限 -20 下限 40 的 a1 向量
    a1 = runif(n = 250, min = -20, max = 40),
    # 同理随机生成 250 个上限 -5 下限 5 的 a2 向量
    a2 = runif(250, -5, 5)
)
# 如果用随机生成数据的话，模型会看起来非常糟糕：
ggplot() +
    geom_abline(
        data = random_models,
        mapping = aes(intercept = a1, slope = a2), # intercept：截距，slope：斜率
        alpha = 1 / 4
    ) +
    geom_point(
        data = sim1,
        mapping = aes(x, y)
    )

# 我们希望有直线 y = a2*x + a1 来概括这个数据集的特征。所以我们创造了 model1
model1 <- function(a, data) {
    # 注意我们传入的 data 是一个数据集。这个设计的函数会针对数据集里的数据反复代入计算，最终返回一个向量
    a[1] + data$x * a[2]
}
# 试图用 a1 = 7 和 a2 = 1.5 数据来分析 sim1。这样我们得到了理想模型下对应 y 的值
model1(c(7, 1.5), sim1)

# 验证或者求得回归曲线的拟合度使我们通常采用方差，度量随机变量和其数学期望（即均值）之间的偏离程度。
# 所以我们新建了函数来获得方差
measure_distance <- function(mod, data) {
    diff <- data$y - model1(mod, data) # diff 为 data 中实际 y 值与 model1 得到的理想 y 值的差
    sqrt(mean(diff^2)) # 返回所有 diff 平方的均值进行的开方（方差）
}
# 试图用 a1 = 7 和 a2 = 1.5 数据求得关于 sim1 的方差
measure_distance(c(7, 1.5), sim1)
#> [1] 2.665212

# 由于我们这里仅用来研究 sim1 数据集，所以这里新建函数用来提交给 sim1，方便后面 map2_dbl 处理
sim1_dist <- function(a1, a2) {
    measure_distance(c(a1, a2), sim1) # nolint
}

# 通过 mutate 新增计算得到的列 dist 并赋值回去（方差）
models <- random_models %>%
    mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist)) %>%
    print()

# 注意这里的 map2_dbl 会返回离散程度较小的，即拟合程度最高的。例如：
df <- data.frame(
    x = c(1, 2, 5),
    y = c(5, 4, 8)
)
# 这个包的 map2_dbl 表达式相当于 pmin(df$x, df$y)
purrr::map2_dbl(df$x, df$y, min)
#> [1] 1 2 5

# 最后将实际得到的模型简单直观地展示出来
ggplot(sim1, aes(x, y)) +
    geom_point(size = 2, colour = "grey30") +
    geom_abline(
        aes(intercept = a1, slope = a2, colour = -dist), # 由 dist 反向上色，即越精确颜色越鲜亮
        data = filter(models, rank(dist) <= 10) # 不是所有线条都需要显示，这里选择 dist 排名前 10
    )

# 将 a1 和 a2 用图表示出来（同样上色），这里选择 dist 排名前 10来高亮显示（叠加）
ggplot(models, aes(a1, a2)) +
    geom_point(
        data = filter(models, rank(dist) <= 10), # 先画高亮部分
        size = 4, colour = "red"
    ) +
    geom_point(aes(colour = -dist))

# 事实上除了用 runif 创建随机模型外，我们还常常使用标准步长的规整矩阵数据模型来验算已知的回归模型
grid_models <- expand.grid(
    # expand.grid 用于于快速创建数据集（data frame）
    a1 = seq(-5, 20, length = 25), # seq 用于快速生成序列，参数分别代表起始、结束和序列长
    a2 = seq(1, 3, length = 25)
) %>%
    mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
ggplot(grid_models, aes(a1, a2)) +
    geom_point(
        data = filter(grid_models, rank(dist) <= 10),
        size = 4, colour = "red"
    ) +
    geom_point(aes(colour = -dist))
# 同样，我们把拟合出的回归模型放到原始数据集对照，事实告诉我们拟合的效果非常好
ggplot(sim1, aes(x, y)) +
    geom_point(size = 2, colour = "grey30") +
    geom_abline(
        aes(intercept = a1, slope = a2, colour = -dist),
        data = filter(grid_models, rank(dist) <= 10)
    )

# 当然这对 a1 和 a2 数据是我们根据矩阵数据集拟合得到的。我们现在可以通过大致拟合度，继续细化数据
# 这样已知细化下去，我们终究得到拟合度极高的数据。
# 所以我们需要一个名为牛顿-拉夫森搜索的数字最小化工具。
# 牛顿-拉夫森工具的思想很简单：你选择一个起点，环顾四周最陡峭的斜坡。
# 然后，你沿着斜坡滑了一点，然后一遍又一遍地重复，直到你不能再低了。
# 在 R 中，我们可以使用 optim() 做到这一点：
best <- optim(
    par = c(0, 0), # 要优化的参数的初始值
    fn = measure_distance, # 要最小化（或最大化）的函数，所以 par 参数是要进行最小化的参数向量。它应该返回标量结果
    data = sim1
)
# 注意 optm() 将返回一个 list，其中：
# par 为找到的最佳参数向量，value 为参数向量对应的返回值
best$par
#> [1] 4.222248 2.051204
# 我们画图验证一下刚刚得到的 a1 和 a2。相应的，它的拟合程度也相当完美
ggplot(sim1, aes(x, y)) +
    geom_point(size = 2, colour = "grey30") +
    geom_abline(intercept = best$par[1], slope = best$par[2], colour = "blue")

# 线性模型的一般形式为 y = a_1 + a_2 * x_1 + a_3 * x_2 + ... + a_n * x_(n - 1)。
# 在 R 里有一个专门为拟合线性模型而设计的工具 lm()。
# lm() 用一种特殊的方式来指定模型，即公式。
# 公式例如 y ~ x，lm() 将自动转换为 y = a_1 + a_2 * x 这样的函数
sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod) # coef() 是一个通用函数，用于从建模函数返回的对象中提取模型系数
# 结果与预期完全一致
#> (Intercept)           x
#>    4.220822    2.051533

# 【实战】对 dim1 模型可视化观察分析 ----

# 现在我们将通过查看模型的预测来专注于理解模型。每种类型的预测模型都需要进行预测。
# 查看模型未捕获的内容（即从数据中减去预测值后留下的所谓残差）也很有用。我们可以用来研究剩余的更微妙的趋势。

# 为了模型的预测，我们先创建网格，其最简单的方法是使用 data_grid() 函数
grid <- sim1 %>% # 相当于对 sim1 定制对应的 x 数据集
    data_grid(x) %>%
    print()
#> # A tibble: 10 x 1
#>       x
#>   <int>
#> 1     1
#> 2     2
#> 3     3
#> 4     4
#> 5     5
#> 6     6
#> # … with 4 more rows

# 接下来我们开始预测。请注意 sim1_mod 来自之前 lm() 函数生成的代码：
#> sim1_mod <- lm(y ~ x, data = sim1)
predictions <- grid %>%
    add_predictions(sim1_mod) %>%
    print()
#> # A tibble: 10 x 2
#>       x  pred
#>   <int> <dbl>
#> 1     1  6.27
#> 2     2  8.32
#> 3     3 10.4
#> 4     4 12.4
#> 5     5 14.5
#> 6     6 16.5
#> # … with 4 more rows

# 最后绘制预测结果
ggplot(sim1, aes(x)) +
    geom_point(aes(y = y)) +
    geom_line(aes(y = pred), data = predictions, colour = "red", size = 1)

# 残差分析
# 残差是我们的预测值与实际值之间的距离
residuals <- sim1 %>%
    # 注意这里使用的参数是 sim1，因为我们需要原始数据集才能发现残差
    add_residuals(sim1_mod) %>% # 用法与 add_predictions() 非常相似
    print()
#> # A tibble: 30 x 3
#>       x     y  resid
#>   <int> <dbl>  <dbl>
#> 1     1  4.20 -2.07
#> 2     1  7.51  1.24
#> 3     1  2.13 -4.15
#> 4     2  8.99  0.665
#> 5     2 10.2   1.92
#> 6     2 11.3   2.97
#> # … with 24 more rows
# 最后绘制残差关于 x 的图
ggplot(residuals, aes(resid)) +
    # geom_freqpoly 即频率多边形，非常适合模糊化地绘制表现一个向量的数据的大小和出现次数
    geom_freqpoly(binwidth = 0.5)
# 或者加入数据 x 来看到更多的数据。很容易发现它的分布非常完美
ggplot(residuals, aes(x, resid)) +
    geom_ref_line(h = 0) + # 调整基线为 0 而不是最小
    geom_point(aes(colour = -abs(resid)))


# 【热身】模型类别与相关关系式 ----
df <- tribble(
    ~sex, ~response,
    "male", 1,
    "female", 2,
    "male", 1
)
model_matrix(df, response ~ sex)
#> # A tibble: 3 x 2
#>   `(Intercept)` sexmale
#>           <dbl>   <dbl>
#> 1             1       1
#> 2             1       0
#> 3             1       1