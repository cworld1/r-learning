library(tidyverse)

not_cancelled <- filter(
    nycflights13::flights,
    !is.na(dep_delay), !is.na(arr_delay)
)

# 得到航空公司的目的地信息
carrier_dest <- not_cancelled %>%
    group_by(carrier, dest) %>%
    summarise(flights = n())

carrier_dest %>%
    group_by(carrier) %>%
    summarise(dest_number = n()) %>%
    arrange(desc(dest_number))