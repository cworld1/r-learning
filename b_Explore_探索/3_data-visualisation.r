library(tidyverse) # 方便使用其中的 ggplot2

# -------- 热身：初识 ggplot --------
view(mpg) # 使用 view() 函数可以方便观察对应数据集
head(mpg) # 可以在控制台打印数据集头部信息（前十行）
# 列 displ：汽车的发动机尺寸，以升为单位。
# 列 hwy：汽车在高速公路上的燃油效率，以英里 / 加仑（mpg）为单位

ggplot(data = mpg) + # 统一设置想要处理的数据集
    # 绘制 point，mapping 属性用来设置相关的 x 轴和 y 轴参数
    geom_point(mapping = aes(x = displ, y = hwy))

# 三维映射 -----------

# 使用颜色映射
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color = class))
# 使用大小映射（不建议）
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, size = class))
# 使用形状映射（注意最多只支持 6 种）
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, size = class))
# 使用透明度映射（不建议）
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# 修改样式 ----------

# 例如颜色
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
# 支持参数：color，shape，fill，stroke（点的粗细），linetype 等。同时，样式参数支持变量。
# shape 填写时是填写数字，有 21 种。详细对照：https://shorturl.at/jCSU0

# 多组画图 ---------

# 简单分组（分片）
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_wrap(~class, nrow = 3) # 以 class 分类，三列，不限制行
# 自定义条件分组
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(drv ~ cyl) # 以 drv 为 x 轴，cyl 为 y 轴


# 线性回归与叠加 ----------

# mapping 为默认接收内容，可以省略
ggplot(data = mpg) +
    geom_point(aes(x = displ, y = hwy)) +
    geom_smooth(aes(x = displ, y = hwy))

# mapping 写在基本配置项中，方便绘图自动调用
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point() +
    geom_smooth()

# 绘图时使用自定义 data 覆盖默认 data 配置（filter 为筛选数据）
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(color = "blue") +
    geom_smooth(data = filter(mpg, class == "subcompact"))

# show legend 控制现实图例显示与否，se 控制自信指数（半透明带）显示与否
ggplot(data = mpg) +
    geom_smooth(
        mapping = aes(x = displ, y = hwy, color = drv),
        show.legend = FALSE,
        se = FALSE
    )

# 其他图 ----------

# 条状图
ggplot(data = mpg) +
    geom_bar(mapping = aes(x = displ), stat = "cyl")
# 使用将条分割的方法进行颜色叠加（降低透明度避免重叠导致部分柱状图被遮挡）
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
    geom_bar(alpha = 0.5, position = "identity")
# position 改用 fill 为频率图
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
    geom_bar(position = "fill")
# position 改用 dodge 为分柱图
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
    geom_bar(position = "dodge")

# Summary 线条信息图
ggplot(data = diamonds) +
    stat_summary(
        mapping = aes(x = cut, y = depth),
        fun.max = max, # 上限最大值
        fun.min = min, # 下限为最小值
        fun.y = mean # 标点为平均数
    )

# -------- 实战：绘制超级汇总图 --------
# https://shorturl.at/aozX5

p <- list()
p[[1]] <- ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    geom_smooth(se = FALSE) # 注意包含回归曲线
p[[2]] <- ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_smooth(mapping = aes(group = drv), se = FALSE) + # 以 drv 分组作出多条回归线
    geom_point()
p[[3]] <- ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) + # 全局以 drv 分类添加着色
    geom_point() +
    geom_smooth(se = FALSE)
p[[4]] <- ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = drv)) +
    geom_smooth(se = FALSE) # 如果只要总的回归线，就不要把 colour 变量对 smooth 进行应用
p[[5]] <- ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = drv)) +
    geom_smooth(aes(linetype = drv), se = FALSE) # 与以颜色分组类似，这里只是改用线条样式
p[[6]] <- ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_point(size = 4, color = "white") +
    geom_point(aes(colour = drv)) # 这里是两幅非常相似的图重叠的效果。注意后画的图优先显示

library(grid) # 引用一下布局包
grid.newpage() # 新建布局包
pushViewport(viewport(layout = grid.layout(3, 2))) # 设置 2x3 布局
print(p[[1]], vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(p[[2]], vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(p[[3]], vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(p[[4]], vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
print(p[[5]], vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
print(p[[6]], vp = viewport(layout.pos.row = 3, layout.pos.col = 2))