# R learning

[![R language](https://img.shields.io/badge/R-276DC3?style=flat-square&logo=r)](https://www.r-project.org/)
[![GitHub stars](https://img.shields.io/github/stars/cworld1/r-learning?style=flat-square)](https://github.com/cworld1/r-learning/stargazers)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/cworld1/r-learning?label=commits&style=flat-square)](https://github.com/cworld1/r-learning/commits)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/cworld1/r-learning/Render%20Book?label=workflow&style=flat-square)](https://github.com/cworld1/r-learning/actions/workflows/main.yml)
[![GitHub license](https://img.shields.io/github/license/cworld1/r-learning?style=flat-square)](https://github.com/cworld1/r-learning/blob/master/LICENSE)

这是关于 CWorld 学习 R 语言的一些笔记和代码。

[前往阅读](https://r.cworld.top)

## 项目介绍

本项目使用 `bookdown` 构建，包含 [gitbook](https://r.cworld.top/)、[epub_book](https://r.cworld.top/R-Learning.epub) 和 [pdf_book](https://r.cworld.top/R-Learning.pdf) 三种构建成品。

实际学习上，我们更推荐将项目打包下载，或使用 `git clone` 到本地方便随时运行它们的任意一部分，而不是反复使用复制和粘贴。本笔记的 R 笔记源码针对大纲进行了优化，使用支持更友好的编辑器，很大程度上方便读者理清节点关系与数据生成始末。这里推荐使用 RStudio 或 Visual Studio Code，但理论上应该也有让你阅读更愉快的编辑器，在此不做敷述。

## 项目运行

首先请保证自己已经有了 R 本地环境，并把 RScript 加入了全局变量。

- 安装运行代码需要的包：

```sh
Rscript -e 'install.packages(c("tidyverse", "nycflights13", "hexbin", "gapminder", "Lahman", "maps", "feather", "ggrepel"))'
```

- 安装构建本书需要的包（如果你需要的话）：

```sh
Rscript -e 'install.packages(c("rmarkdown", "bookdown"))'
Rscript -e 'tinytex::install_tinytex()'
```

- 开始构建（如果你需要的话）：

```sh
set -ev
cd book
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
```

## 贡献

由于作者只是个正在浅学 R 的初学者，所以笔记难免存在明显纰漏，还请读者们多多海涵。此外，也欢迎诸位使用 PR 或 Issues 来改善它们。

## 鸣谢

一些电子教材对作者学习上帮助颇多，没有这些资料，就没有这部笔记。在此对这些教材的原作者深表感谢。读者若对此项目笔记抱有疑惑，也可以仔细阅读以下的教材以作弥补。

- [R for Data Science](https://r4ds.had.co.nz/)
- [R for Data Science 2 Edition](https://r4ds.hadley.nz/)
- [R for Data Science: Exercise Solutions](https://jrnold.github.io/r4ds-exercise-solutions)（[Jeffrey Arnold](https://github.com/jrnold)）
- [Modern Data Science with R](https://mdsr-book.github.io/mdsr2e/)（[Benjamin S. Baumer, Daniel T. Kaplan, and Nicholas J. Horton](https://github.com/mdsr-book/mdsr/graphs/contributors)）
- [bookdown: Authoring Books and Technical Documents with R Markdown](https://bookdown.org/yihui/bookdown/)（[Yihui Xie](https://yihui.org/)）
- [Text Mining with R](https://www.tidytextmining.com/)（[Julia Silge](http://juliasilge.com/) and [David Robinson](http://varianceexplained.org/)）
- [R 语言教程](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/index.html)（[李东风](https://www.math.pku.edu.cn/teachers/lidf/)）
- [商业数据分析师-R 语言数据处理](https://bookdown.org/zhongyufei/Data-Handling-in-R/)（Yufei Zhong）

## License

[![知识共享许可协议](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.zh)

The MIT License.

本作品采用 [知识共享署名-非商业性使用-相同方式共享 4.0 国际许可协议](http://creativecommons.org/licenses/by-nc-sa/4.0/) 进行许可。
