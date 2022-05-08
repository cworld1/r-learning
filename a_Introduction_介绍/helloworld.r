# -------- 热身：学会基础运算 --------
1 + 2

# -------- 热身：学会约定俗成的代码形式 --------
# 函数后面带括号
sum(c(1, 2))
# 对象直接书写
flights
# 不加载包直接调用
dplyr::mutate() # mutate() 函数
nycflights13::flights # flights 数据集

# -------- 热身：学会基础功能 --------
library(tidyverse) # 加载之前安装的包
tidyverse_update() # 更新 tidyverse 包内的附带包
dput(mtcars) # 查看数据集的更多信息
sessionInfo(c("tidyverse")) # 查看本地 R 及相关信息