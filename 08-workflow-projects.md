# Workflow: projects {#workflow-projects}



## 运行环境

使用 R 脚本（和数据文件），可以重新创建环境。从环境中重新创建 R 脚本要困难得多！你要么必须从内存中重新键入大量代码，要么必须仔细挖掘你的 R 脚本执行历史记录。

为了培养这种行为，我强烈建议我们将 RStudio 设置为不要在会话之间保留我们的工作区记录：

![rstudio-workspace](https://d33wubrfki0l68.cloudfront.net/7fa44a5471d40025344176ede4169c5ad3159482/1577f/screenshots/rstudio-workspace.png)

有一对很棒的键盘快捷键可以协同工作，以确保我们在编辑器中存储了代码的重要部分：

- `Cmd/Ctrl + Shift + F10` 重新启动 RStudio。
- `Cmd/Ctrl + Shift + S` 重新运行当前脚本。

## 工作区

**工作区目录**对 R 的文件路径处理上非常重要。这是 R 查找你所要求加载文件和保存执行文件的位置。RStudio 在控制台顶部会显示当前的工作目录：

![rstudio-wd](https://d33wubrfki0l68.cloudfront.net/176fc11b0b484209bd77f13ab5116b8a0d7aa13a/2b6f7/screenshots/rstudio-wd.png)

使用 `getwd()` 命令在 R 控制台中打印出来：


```r
getwd()
#> [1] "/home/runner/work/r-learning/r-learning/book"
```

作为 R 用户，可以让你的任何奇怪的目录成为 R 的工作目录。我们应该很快将要分析的项目组织到目录中，并且在处理项目时，将 R 的工作目录设置为与之关联的目录。

使用 `setwd()` 从控制台中设置工作目录（不推荐）：


```r
setwd("/path/to/my/CoolProject")
```

## 路径与目录

路径和目录有点复杂，因为Mac/Linux 和 Windows 两者不太一样：

- Mac 和 Linux 使用斜杠 “/”，Windows 使用反斜杠 “\”。R 可以使用任何一种类型（无论我们当前使用的是什么平台），但在路径中要单个反斜杠，我们需要键入两个反斜杠去等效，所以建议始终使用正斜杠路径，如：`plots/diamonds.pdf`
- 绝对路径看起来都不同。在 Windows 中，它们以驱动器号 + 冒号 + 两个反斜杠开头，如 `C:\\servername`；而在 Mac / Linux 中，它们以斜杠开头，如 `/users/hadley`。所以建议不使用绝对路径，以保证代码的兼容性和可共享性。
- `~` 指向的地方也不太相同。它本是通往主目录的便捷方式，但 Windows 并没有这种概念，因此 R 中它指向文档目录。

## RStudio 项目

一个普遍明智的做法是，将与项目关联的所有文件保存在一起，包括输入数据、R 脚本、分析结果和数字。

单击 `文件 > 新建项目` 来创建它：

![rstudio-project-1](https://d33wubrfki0l68.cloudfront.net/87562c4851bf4d0b0c8415dc9d6690493572e362/a6685/screenshots/rstudio-project-1.png)

![rstudio-project-2](https://d33wubrfki0l68.cloudfront.net/0fa791e2621be297cb9c5cac0b2802223e3d7714/57d89/screenshots/rstudio-project-2.png)

![rstudio-project-3](https://d33wubrfki0l68.cloudfront.net/dee6324df1f5c5121d1c1e9eed822ee52c87167b/1f325/screenshots/rstudio-project-3.png)

以后保存文件应该使用如下方式：


```r
library(tidyverse)

ggplot(diamonds, aes(carat, price)) +
    geom_hex()
ggsave("diamonds.pdf")

write_csv(diamonds, "diamonds.csv")
```

