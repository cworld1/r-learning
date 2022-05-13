# 1 Introduction

# 数据科学

![data-science.png](https://d33wubrfki0l68.cloudfront.net/571b056757d68e6df81a3e3853f54d3c76ad6efc/32d37/diagrams/data-science.png)

首先我们需要**导入**数据。然后对其进行**整理**。理解数据的核心就是**转换**、**可视化**数据和建立**模型**。通信是最后的步骤，理解的数据最终很可能走向分享他人。

## 安装 R

要下载 R，需要前往 CRAN，即 cromprehensive R archive network。CRAN 由分布在世界各地的一组镜像服务器组成，用于分发 R 和 R 的拓展包。不要试图选择看起来地点离你很近的镜像，而是使用 [云镜像](https://cloud.r-project.org/)，它会自动为你找出答案。

## 安装编辑器

RStudio 是一个用于 R 编程的集成开发环境或 IDE。从 http://www.rstudio.com/download 下载并安装它。

## 相关包

您可以使用一行代码安装完整的 tidyverse：

```R
install.packages("tidyverse")
```

在您自己的计算机上，在控制台中键入该行代码，然后按 Enter 运行它。R 将从 CRAN 下载软件包并将其安装到您的计算机上。如果您在安装时遇到问题，请确保您已连接到互联网，并且 https://cloud.r-project.org/ 未被防火墙或代理阻止。

在本书中，我们将使用来自 tidyverse 之外的三个数据包：

```R
install.packages(c("nycflights13", "gapminder", "Lahman"))
```

这些软件包提供了有关航空公司航班、世界发展和棒球的数据，我们将用这些数据来说明关键的数据科学理念。

## 更多学习路径

[R for Data Science](https://r4ds.had.co.nz/)

[R for Data Science: Exercise Solutions](https://jrnold.github.io/r4ds-exercise-solutions)