library(tidyverse)

# 统计各种品质钻石的数量并绘图
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut))

# 统计各种克拉数的数量并绘图
ggplot(data = diamonds) +
    geom_histogram(
        mapping = aes(x = carat),
        binwidth = 0.5 # 将宽度容纳（区间）增加至指定宽度
    )

# ----- 清除丢失的数据 -----
filter(diamonds, y < 3 | y > 20) # 会看到有很多看起来很糟糕的数据

# 方法一，简单粗暴
diamonds_new <- diamonds %>%
    filter(between(y, 3, 20)) # 新建数据集过滤掉杂质
# 方法二，替换为 NA
diamonds_new <- diamonds %>%
    # 非常类似于 C 语言中的 xx?xx:xx 。如果 y 在 3 到 20 间则保持，否则返回 NA
    mutate(y = ifelse(y > 3 & y < 20, y, NA))

# 事实上，如果数据含有 NA，ggplot 绘图会发出警告并将相应数据剔除。
ggplot(data = diamonds_new, mapping = aes(x = x, y = y)) +
    geom_point()
# 我们应该手动剔除
ggplot(data = diamonds_new, mapping = aes(x = x, y = y)) +
    geom_point(na.rm = TRUE)

# ----- 实战：对于 flights 数据集的统计与绘图 -----
nycflights13::flights %>%
    mutate(
        cancelled = is.na(dep_time), # 如果数据是 NA 就提示航班取消了
        sched_hour = sched_dep_time %/% 100, # 国际计时除 100 商得到小时
        sched_min = sched_dep_time %% 100, # 国际计时除 100 取余得到分钟
        sched_dep_time = sched_hour + sched_min / 60 # 按照我们习惯转换成正常的分钟数
    ) %>%
    # freqpoly 非常适合折现图效果。对应的柱状图是 histogram
    # binwidth 通常会用来描述线或柱的精度。精度不足的部分会用平均值模糊化替代。
    ggplot(mapping = aes(sched_dep_time)) +
    geom_freqpoly(mapping = aes(color = cancelled), binwidth = 1 / 4)

# ----- 实战：对于 diamonds 数据集的统计与绘图 -----
# 这里点点表示该数据的频率
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
    geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
# 使用 boxplot 进一步探索
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
    geom_boxplot()
# 盒子中间：中位数
# 盒子两头：25% 和 75%
# 盒子两头延伸的细线：最小和最大值
# 盒子两头远处的点：异常值

# 查看颜色与质量的关系
ggplot(data = diamonds_new) +
    # geom_count 用来通过显示点的大小展示数据大小（次数、频率）
    geom_count(mapping = aes(x = color, y = cut))
# 通过色砖图更直观地查看
diamonds_new %>%
    count(color, cut) %>% # 这里只能手动计数，但不需要 group_by
    ggplot(mapping = aes(x = color, y = cut)) +
    # 注意这里的 color 只是边框颜色
    geom_tile(mapping = aes(fill = n), color = "grey50")

# 查看质量与价格的关系
ggplot(data = diamonds_new) +
    geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)
# 通过方形小色块（类似平均值效果）来模糊数据
ggplot(data = diamonds_new) +
    geom_bin2d(mapping = aes(x = carat, y = price))
# 或者使用六边形小块（需要安装包 hexbin）
#* install.packages("hexbin")
ggplot(data = diamonds_new) +
    geom_hex(mapping = aes(x = carat, y = price))
# 甚至使用 box_plot
ggplot(data = diamonds_new, mapping = aes(x = carat, y = price)) +
    # cut_width 是 ggplot 包的函数，用来切片配合分组，将前者以后者数值划分
    geom_boxplot(mapping = aes(group = cut_width(carat, 0.3)))

# ----- 实战：对于 mpg 数据集的统计与绘图 -----
ggplot(data = mpg) +
    geom_boxplot(mapping = aes(
        # reorder 排序，对 class 根据对应的 hwy 值进行排序, median 用来确认函数是否具有返回值
        x = reorder(class, hwy, FUN = median),
        y = hwy
    )) +
    coord_flip() # xy 轴交换