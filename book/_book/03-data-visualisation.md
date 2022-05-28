# Data visualisation {#explore}




```r
library(tidyverse) # 方便使用其中的 ggplot2
```

## 初识 ggplot


```r
view(mpg) # 使用 view() 函数可以方便观察对应数据集
head(mpg) # 可以在控制台打印数据集头部信息（前十行）
#> # A tibble: 6 x 11
#>   manufacturer model displ  year   cyl trans      drv     cty   hwy fl    class 
#>   <chr>        <chr> <dbl> <int> <int> <chr>      <chr> <int> <int> <chr> <chr> 
#> 1 audi         a4      1.8  1999     4 auto(l5)   f        18    29 p     compa~
#> 2 audi         a4      1.8  1999     4 manual(m5) f        21    29 p     compa~
#> 3 audi         a4      2    2008     4 manual(m6) f        20    31 p     compa~
#> 4 audi         a4      2    2008     4 auto(av)   f        21    30 p     compa~
#> 5 audi         a4      2.8  1999     6 auto(l5)   f        16    26 p     compa~
#> 6 audi         a4      2.8  1999     6 manual(m5) f        18    26 p     compa~
```

列 displ：汽车的发动机尺寸，以升为单位。
列 hwy：汽车在高速公路上的燃油效率，以英里 / 加仑（mpg）为单位


```r
ggplot(data = mpg) + # 统一设置想要处理的数据集
    # 绘制 point，mapping 属性用来设置相关的 x 轴和 y 轴参数
    geom_point(mapping = aes(x = displ, y = hwy))
```

<img src="03-data-visualisation_files/figure-html/ggplot 绘图-1.png" width="672" />

## 美学映射

使用颜色映射：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

<img src="03-data-visualisation_files/figure-html/aes color-1.png" width="672" />

使用大小映射（不建议）：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, size = class))
#> Warning: Using size for a discrete variable is not advised.
```

<img src="03-data-visualisation_files/figure-html/aes size-1.png" width="672" />

使用形状映射（注意最多只支持 6 种）：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#> Warning: The shape palette can deal with a maximum of 6 discrete values because
#> more than 6 becomes difficult to discriminate; you have 7. Consider
#> specifying shapes manually if you must have them.
#> Warning: Removed 62 rows containing missing values (geom_point).
```

<img src="03-data-visualisation_files/figure-html/aes shape-1.png" width="672" />

使用透明度映射（不建议）：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
#> Warning: Using alpha for a discrete variable is not advised.
```

<img src="03-data-visualisation_files/figure-html/aes alpha-1.png" width="672" />

## 修改样式

例如颜色：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
```

<img src="03-data-visualisation_files/figure-html/color-1.png" width="672" />

支持参数：color，shape，fill，stroke（点的粗细），linetype 等。同时，样式参数支持变量。注意 shape 填写时是填写数字，有 21 种。

![R 有 25 个内置形状，这些形状由数字标识。有一些看似重复的：例如，0、15 和 22 都是正方形。不同之处在于“颜色”和“填充”美学的相互作用。空心形状（0--14）具有由“颜色”确定的边框;固体形状（15--20）填充有“颜色”;填充的形状（21--24）具有“颜色”边框，并用“填充”填充填充。](https://d33wubrfki0l68.cloudfront.net/e28a1b57b6622cf67fd8a7e01c6a9955914f8fe9/635be/visualize_files/figure-html/shapes-1.png)

## 多组画图

简单分组（分片）：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_wrap(~class, nrow = 3) # 以 class 分类，三列，不限制行
```

<img src="03-data-visualisation_files/figure-html/facet_wrap()-1.png" width="672" />

自定义条件分组：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(drv ~ cyl) # 以 drv 为 x 轴，cyl 为 y 轴
```

<img src="03-data-visualisation_files/figure-html/facet_grid()-1.png" width="672" />


## 叠加与参数

mapping 为默认接收内容，可以省略：


```r
ggplot(data = mpg) +
    geom_point(aes(x = displ, y = hwy)) +
    geom_smooth(aes(x = displ, y = hwy))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="03-data-visualisation_files/figure-html/omit mapping-1.png" width="672" />

其中 mapping 写在基本配置项中，方便绘图自动调用


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point() +
    geom_smooth()
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="03-data-visualisation_files/figure-html/default mapping-1.png" width="672" />

绘图时使用自定义 data 覆盖默认 data 配置（filter 为筛选数据）：


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(color = "blue") +
    geom_smooth(data = filter(mpg, class == "subcompact"))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="03-data-visualisation_files/figure-html/cover mapping-1.png" width="672" />

## 其他常见图

### 回归曲线图

回归曲线有它专门的配置项，其中 show legend 用于控制现实图例显示与否，se 控制自信指数（半透明带）显示与否：


```r
ggplot(data = mpg) +
    geom_smooth(
        mapping = aes(x = displ, y = hwy, color = drv),
        show.legend = FALSE,
        se = FALSE
    )
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="03-data-visualisation_files/figure-html/geom_smooth()-1.png" width="672" />

### 条形图


```r
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, colour = cut)) # colour 为描边颜色
```

<img src="03-data-visualisation_files/figure-html/geom_bar()-1.png" width="672" />

```r
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, fill = cut)) # fill 为填充颜色
```

<img src="03-data-visualisation_files/figure-html/geom_bar()-2.png" width="672" />

但如果 fill 使用的是其他变量，会导致不同数据重叠遮挡


```r
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, fill = clarity))
```

<img src="03-data-visualisation_files/figure-html/origin geom_bar()-1.png" width="672" />

解决方案 1：降低透明度


```r
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
    geom_bar(alpha = 1 / 5, position = "identity")
```

<img src="03-data-visualisation_files/figure-html/geom_bar() with alpha-1.png" width="672" />

解决方案 2：直接改为 colour 样式，并将 fill 设置为 NA


```r
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) +
    geom_bar(fill = NA, position = "identity")
```

<img src="03-data-visualisation_files/figure-html/geom_bar() with color-1.png" width="672" />

解决方案 3：position 改用 fill 为频率图（方便观察比例）


```r
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
    geom_bar(position = "fill")
```

<img src="03-data-visualisation_files/figure-html/geom_bar() with position fill-1.png" width="672" />

解决方案 4：position 改用 dodge 为分柱图


```r
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
    geom_bar(position = "dodge")
```

<img src="03-data-visualisation_files/figure-html/geom_bar() with position dodge-1.png" width="672" />

### Summary 线条信息图

这种图不太常用，因为 boxplot 图拥有它的所有特性，甚至做得更好：


```r
ggplot(data = diamonds) +
    stat_summary(
        mapping = aes(x = cut, y = depth),
        fun.max = max, # 上限最大值
        fun.min = min, # 下限为最小值
        fun.y = mean # 标点为平均数
    )
#> Warning: `fun.y` is deprecated. Use `fun` instead.
```

<img src="03-data-visualisation_files/figure-html/stat_summary()-1.png" width="672" />

## 坐标系相关

对调坐标轴：


```r
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
    geom_boxplot() +
    coord_flip()
```

<img src="03-data-visualisation_files/figure-html/coord_flip()-1.png" width="672" />

根据相关图像限制图形的纵横比例：


```r
nz <- map_data("nz") # 从 map_data 里调用某国的地图
ggplot(nz, aes(long, lat, group = group)) +
    geom_polygon(fill = "white", colour = "black") +
    coord_quickmap() # 这里会使图表以正确的横纵比显示，防止图像拉伸扭曲
```

<img src="03-data-visualisation_files/figure-html/coord_quickmap()-1.png" width="672" />

极坐标化：


```r
bar <- ggplot(data = diamonds) +
    geom_bar(
        mapping = aes(x = cut, fill = cut),
        show.legend = FALSE,
        width = 1
    ) +
    theme(aspect.ratio = 1) +
    labs(x = NULL, y = NULL) +
    coord_polar() # 设置为极坐标（有点像圆饼图）
```

## 绘制 diamonds 数据分析图

原题目：[Recreate the R code necessary to generate the following graphs.](https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.6.6)

建立列表，绘制好 6 张图并装配进去：


```r
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
```

随即使用布局逐张展示：


```r
library(grid) # 引用一下布局包
grid.newpage() # 新建布局包
pushViewport(viewport(layout = grid.layout(3, 2))) # 设置 2x3 布局
print(p[[1]], vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
print(p[[2]], vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
print(p[[3]], vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
print(p[[4]], vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
print(p[[5]], vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
print(p[[6]], vp = viewport(layout.pos.row = 3, layout.pos.col = 2))
```

<img src="03-data-visualisation_files/figure-html/grid()-1.png" width="672" />

## 研究 mpgcars 数据集
仔细观察数据集会发现 displ 和 hwy 是经过四舍五入的，在实际图表上很多点会产生重叠：


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(alpha = 1 / 5)
```

<img src="03-data-visualisation_files/figure-html/geom_point()-1.png" width="672" />

对 position 添加 jitter 值可以手动添加 “数据噪点”，从而更好地看到数据全貌（尽管会改变数值导致图表不那么准确）：


```r
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
```

<img src="03-data-visualisation_files/figure-html/geom_point() with position jitter-1.png" width="672" />

