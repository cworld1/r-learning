library(tidyverse)
library(modelr)
options(na.action = na.warn)

# 模型由两部分组成：
# - 定义一系列模型，这些模型表示要捕获的精确但通用的模式。
# - 通过从最接近数据集中查找模型来生成拟合模型。这将采用通用模型系列，并使其具体化。

# -------- 实战：对 sim1 进行模型研究 --------
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
    sqrt(mean(diff^2)) # 返回所有 diff 平方的均值进行的开放
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
        data = filter(models, rank(dist) <= 10) # 不是所有线条都需要显示，这里选择 dist <= 10
    )

ggplot(models, aes(a1, a2)) +
    geom_point(
        data = filter(models, rank(dist) <= 10),
        size = 4,
        colour = "red"
    ) +
    geom_point(aes(colour = -dist))