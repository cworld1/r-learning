# Use the nycflights13 package and the flights
# and planes tables to answer the following questions:

library(tidyverse)
library(nycflights13)

# a. How many planes have a missing date of manufacture?
flights %>%
    anti_join(filter(planes, is.na(year)), by = "tailnum") %>%
    count(tailnum) %>%
    print() %>%
    nrow()
# 3974 planes totaly have a missing date of manufacture.

# b. What are the five most common manufacturers?
planes %>%
    group_by(manufacturer) %>%
    summarise(sum = n()) %>%
    arrange(desc(sum)) %>%
    head(5)

# c. Has the distribution of manufacturer changed over time
# as reflected by the airplanes flying from NYC in 2013?
# (Hint: you may need to use case_when() to recode the manufacturer name
#  and collapse rare vendors into a category called Other.)
flights %>%
    full_join(planes, by = "tailnum") %>%
    filter(!is.na(manufacturer)) %>%
    count(manufacturer) %>%
    arrange(desc(n)) %>%
    mutate(mtype = case_when(
        manufacturer == "BOEING" ~ "1",
        manufacturer == "AIRBUS INDUSTRIE" ~ "2",
        manufacturer == "BOMBARDIER INC" ~ "3",
        manufacturer == "AIRBUS" ~ "4",
        manufacturer == "EMBRAER" ~ "5",
        TRUE ~ "other"
    ))
