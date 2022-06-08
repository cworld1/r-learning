# Introduction {#introduction}

## 数据科学

![data-science.png](https://d33wubrfki0l68.cloudfront.net/571b056757d68e6df81a3e3853f54d3c76ad6efc/32d37/diagrams/data-science.png)

首先我们需要**导入**数据。然后对其进行**整理**。理解数据的核心就是**转换**、**可视化**数据和建立**模型**。通信是最后的步骤，理解的数据最终很可能走向分享他人。

## 一些准备

### 安装 R

要下载 R，需要前往 CRAN，即 cromprehensive R archive network。CRAN 由分布在世界各地的一组镜像服务器组成，用于分发 R 和 R 的拓展包。不要试图选择看起来地点离你很近的镜像，而是使用 [云镜像](https://cloud.r-project.org/)，它会自动为你找出答案。

### 安装编辑器

RStudio 是一个用于 R 编程的集成开发环境或 IDE。从 http://www.rstudio.com/download 下载并安装它。

### 相关包

我们可以使用一行代码安装完整的 tidyverse：


```r
install.packages("tidyverse")
```

在我们自己的计算机上，在控制台中键入该行代码，然后按 Enter 运行它。R 将从 CRAN 下载软件包并将其安装到我们的计算机上。如果我们在安装时遇到问题，请确保我们已连接到互联网，并且 https://cloud.r-project.org/ 未被防火墙或代理阻止。

在本项目笔记中，我们将使用来自 tidyverse 之外的三个数据包：


```r
install.packages(c("nycflights13", "gapminder", "Lahman"))
```

这些软件包提供了有关航空公司航班、世界发展和棒球的数据，我们将用这些数据来说明关键的数据科学理念。

## 更多学习途径

[R for Data Science](https://r4ds.had.co.nz/)

[R for Data Science: Exercise Solutions](https://jrnold.github.io/r4ds-exercise-solutions)

## 初识 R

我们就从 HelloWorld 开始吧：


```r
print("hello world!")
#> [1] "hello world!"
```

R 里有一些约定俗成的代码形式。如：


```r
# 函数后面带括号
sum(c(1, 2))
# 对象直接书写
iris
# 不加载包直接调用
dplyr::mutate(iris) # mutate() 函数
nycflights13::flights # flights 数据集
```

一些基础功能后面可能不会再反复提到，但它们通常很有用：


```r
library(tidyverse) # 加载之前安装的包
tidyverse_update() # 更新 tidyverse 包内的附带包
dput(mtcars) # 查看数据集（如 mtcars）的更多信息
sessionInfo(c("tidyverse")) # 查看本地 R 及相关信息
```
