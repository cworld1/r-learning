# R learning

这是关于 CWorld 学习 R 语言的一些笔记和代码。

[前往阅读](https://r.cworld.top)

## 构建环境

- 前往 [镜像网站](https://cran.r-project.org/mirrors.html) 找到合适的镜像。
- 按自己需要点击 `Download R for xx`，然后点击 `base`，最后点击 `Download R-x.x.x for xx` 下载安装。
- 前往 [RStudio 下载页](https://www.rstudio.com/products/rstudio/download/#download) 下载 RStudio，它将会是你编写 R 语言和发挥创意的绝佳场所。

## 项目运行

前往 RStudio，在 Console 窗口执行下面的代码来安装笔记需要的包：

```R
install.packages(c("tidyverse", "nycflights13", "hexbin", "gapminder", "Lahman", "maps", "feather", "ggrepel"))
```

如果一切安好的话，请保持斗志，认真学习这门优雅又实用的语言吧。

## 贡献

由于作者只是个正在浅学 R 的初学者，所以笔记难免存在明显纰漏，还请读者们多多海涵。此外，也欢迎诸位使用 PR 或 Issues 来改善它们。

## 鸣谢

一些电子教材对作者学习上帮助颇多，没有这些资料，就没有这部笔记。在此对这些教材的原作者深表感谢。读者若对此项目笔记抱有疑惑，也可以仔细阅读以下的教材以作弥补。

- [R for Data Science](https://r4ds.had.co.nz/)
- [R for Data Science 2 Edition](https://r4ds.hadley.nz/workflow-pipes.html)
- [R for Data Science: Exercise Solutions](https://jrnold.github.io/r4ds-exercise-solutions)（[Jeffrey Arnold](https://github.com/jrnold)）
- [Modern Data Science with R](https://mdsr-book.github.io/mdsr2e/)（[Benjamin S. Baumer, Daniel T. Kaplan, and Nicholas J. Horton](https://github.com/mdsr-book/mdsr/graphs/contributors)）
- [bookdown: Authoring Books and Technical Documents with R Markdown](https://bookdown.org/yihui/bookdown/)（[Yihui Xie](https://yihui.org/)）
- [Text Mining with R](https://www.tidytextmining.com/)（[Julia Silge](http://juliasilge.com/) and [David Robinson](http://varianceexplained.org/)）
- [R语言教程](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/index.html)（[李东风](https://www.math.pku.edu.cn/teachers/lidf/)）
- [商业数据分析师-R 语言数据处理](https://bookdown.org/zhongyufei/Data-Handling-in-R/)（Yufei Zhong）
