library(tidyverse)
library(nycflights13)

# ---------- 热身：理解合并数据概念 -----------
# 没有重复问题
x <- tribble(
    ~key, ~val_x,
    1, "x1",
    2, "x2",
    3, "x3"
)
y <- tribble(
    ~key, ~val_y,
    1, "y1",
    2, "y2",
    4, "y3"
)
# 内联（inner-join）：只观察共同包含的数据（交集）。事实上因为会丢掉不匹配的数据，所以不便于分析
inner_join(x, y, by = "key")
# 外联（left-join、right-join、full-join）
left_join(x, y, by = "key") # 左连接，保留左侧丢掉右侧不匹配的数据
right_join(x, y, by = "key") # 右连接，保留右侧丢掉左侧不匹配的数据
full_join(x, y, by = "key") # 全连接，保留全部数据，哪怕不互相匹配
# 匹配演算（semi_join、anti_join）：事实上匹配并不会做数据合并，只是把左侧数据做筛选
semi_join(x, y, by = "key") # 半连接，对左侧数据筛选出右侧数据能匹配的数据
anti_join(x, y, by = "key") # 反连接，对左侧数据排除掉右侧数据能匹配的数据

# 一边有重复问题
x <- tribble(
    ~key, ~val_x,
    1, "x1",
    2, "x2",
    2, "x3",
    1, "x4"
)
y <- tribble(
    ~key, ~val_y,
    1, "y1",
    2, "y2"
)
# 事实上下面两种模式结果相同
left_join(x, y, by = "key") # 左边所有列都从右边寻求
right_join(x, y, by = "key") # 右边所有列都从左边寻求（一对多时全保留）

# 两边都有重复问题
x <- tribble(
    ~key, ~val_x,
    1, "x1",
    2, "x2",
    2, "x3",
    3, "x4"
)
y <- tribble(
    ~key, ~val_y,
    1, "y1",
    2, "y2",
    2, "y3",
    3, "y4"
)
left_join(x, y, by = "key") # 左边某列对应到右边出现多个结果时会新增列对应完

# ---------- 热身：理解多种数据合并方式 -----------
# 事实上，四大 join 相关依赖包 dplyr，我们也可以用 r 原生自带的 base::merge 实现
#       dplyr	    <=>         merge
# inner_join(x, y)	<=> merge(x, y) # 匹配不上的均不保留
# left_join(x, y)	<=> merge(x, y, all.x = TRUE) # 保留所有的 x
# right_join(x, y)	<=> merge(x, y, all.y = TRUE), # 保留所有的 y
# full_join(x, y)	<=> merge(x, y, all.x = TRUE, all.y = TRUE) # 保留所有的 x 和 y

# intersect、union 和 setdiff 用于对不同表格的差异进行挖掘
df1 <- tribble(
    ~x, ~y,
    1, 1,
    2, 1
)
df2 <- tribble(
    ~x, ~y,
    1, 1,
    1, 2
)
intersect(df1, df2) # 返回两者共同的数据集
#> x     y
#> 1     1
union(df1, df2) # 合并两个数据集的数据（相同的只做一次记录）
#> x     y
#> 1     1
#> 2     1
#> 1     2
setdiff(df1, df2) # 返回前者观察到的后者所没有的差异部分
#> x     y
#> 2     1
setdiff(df2, df1)
#> x     y
#> 1     2

# ---------- 实战：合并 nycflights 数据并分析 -----------
# 仔细观察 nycflights 可以得出：
# 里面包含 airlines、airports、planes 和 weather，以及我们常用的 flights 数据集
# 关系图：https://shorturl.at/amzKM

flights_smaller <- flights %>%
    select(year:day, hour, origin, dest, tailnum, carrier)

flights_smaller %>%
    select(-c(origin, dest)) %>%
    # 根据别的数据集在右侧补全数据，依据 / 重叠数据为 carrier
    # left_join(airlines, by = "carrier") %>%

    # 也可以使用 mutate + carrier 实现同样效果
    mutate(
        # 从 airlines 的 name 向量获取数据，赋值到新列 “name”
        name = airlines$name[match(
            # 获取的数据通过 match 控制
            # 通过 filghts 的 carrier 匹配数据，返回对应 airlines 的 carrier
            carrier, airlines$carrier
        )]
    ) %>%
    print()

flights_smaller %>%
    left_join(weather) %>% # 如果不写 by，则为默认 NULL，会将左边所有列往右边对应一遍，相当于下面代码：
    # left_join(weather, by = c("year", "month", "day", "hour", "origin")) %>%
    print()

# 事实上 “by = ” 可以省略。如果筛选变量填入了用等于连接的向量，则是左右都指定了列
flights_smaller %>%
    # flighs_smaller 的 dest 列与 airports 的 faa 列比较、对应和连接
    left_join(airports, c("dest" = "faa"))

avg_dest_delays <-
    flights %>%
    group_by(dest) %>%
    # 新的列 delay 取值为各目的地的 arr_delay（到达延误）的平均值
    summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% # 注意可能存在 NA 值，需要剔除
    # 注意向量内左侧数据其实打不打引号都是可以的，但右侧必须打
    inner_join(airports, by = c(dest = "faa")) # 其中 faa 为机场代码

# 画出机场在美国的分布图和到达那里的飞机延误整体状况
avg_dest_delays %>%
    # lat 和 lon 为机场的经度和纬度信息，颜色代表平均延迟时长
    ggplot(mapping = aes(lon, lat, colour = delay)) +
    borders("state") + # 这一句话是在加入美国地图背板
    geom_point() + # 显示机场位置分布
    coord_quickmap() # 保持地图横纵比，防止实际图片拉伸导致的地图变形

# 将出发地的延误状况也统计进去
airport_locations <- airports %>%
    select(faa, lat, lon)
flights %>%
    select(year:day, hour, origin, dest) %>%
    # 注意这样 origin 和 dest 都由对应的经纬度坐标数据，存在命名冲突
    left_join(airport_locations, by = ("origin" <- "faa")) %>%
    # 实际运行时，运行到下面的 left_join 会发现，dplyr 会自动给旧列名加上 “.x”，新列名 “.y”
    # left_join(
    #     airport_locations,
    #*     by = c("dest" = "faa")
    # )
    # 所以我们使用 suffix 覆盖这个默认行为设置的后缀
    left_join(
        airport_locations,
        by = c("dest" = "faa"),
        suffix = c("_origin", "_dest")
    )