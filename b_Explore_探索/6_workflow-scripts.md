# 6 Workflow: scripts

到目前为止，我们一直在使用 Console 控制台来运行代码。但当我们创建更复杂的 ggplot2 图和 dplyr 管道时，我们会发现它很快就会变得狭窄。为了给自己更多的工作空间，使用脚本编辑器是个好主意。

通过单击 “文件” 菜单，然后选择 “新建文件” ，然后选择 “R 脚本”，或使用键盘快捷键 Cmd/Ctrl + Shift + N 将其打开。现在，我们将看到四个窗格：

![rstudio-editor](https://d33wubrfki0l68.cloudfront.net/8a64bb047429d7ae0e2acae35c40e421e6439bf6/80e5d/diagrams/rstudio-editor.png)

## 运行代码

脚本编辑器也是构建复杂的 ggplot2 图或长序列 dplyr 操作的好地方。一个最重要的快捷键：`Cmd / Ctrl + Enter`。这将在控制台中执行当前 R 表达式。选中代码时执行选中部分，否则它将自动执行光标所在的那一小段代码，然后自动将光标挪到下一段。

除了逐个表达式运行之外，快捷键：`Cmd/Ctrl + Shift + S` 用于执行整个当前文件。

## RStudio 诊断

脚本编辑器还将在侧边栏中用红色波浪线和红色的错误图标突出显示语法错误：

![rstudio-diagnostic](https://d33wubrfki0l68.cloudfront.net/2c70225e177adb09fd2c71641881d91a2a44b84f/1aee8/screenshots/rstudio-diagnostic.png)

将鼠标悬停在对应代码上以查看问题所在：

![rstudio-diagnostic-tip](https://d33wubrfki0l68.cloudfront.net/3cb10a911ed68521d7fc9b1f7a8f40806c5cc640/f3daa/screenshots/rstudio-diagnostic-tip.png)

RStudio 还会让你了解潜在的问题：

![rstudio-diagnostic-warn](https://d33wubrfki0l68.cloudfront.net/6f50e3e61d68a0e450e12904754e5b9cfa7ff275/54508/screenshots/rstudio-diagnostic-warn.png)

## 使用 Visual studio code 编写 R

这是激动人心的 —— 这款号称 “21 世纪最伟大的编辑器” 的通用代码编辑器成功让 R 运作起来了。但我们说，事情往往伴随着代价。在 VSCode 上，你可能需要一些基础去调整好它。它需要的核心是 [Radian](https://github.com/randy3k/radian) -- A 21 century R console。

合理地使用 VScode，能提高我们的工作效率。而且控制台历史记录、查询、工作区与变量管理、智能装包、强大的帮助系统、缩进与格式化代码等功能它都不曾欠缺。相信聪明的读者应该有着更聪慧的头脑，在选择方面做出更为理智的决定吧。