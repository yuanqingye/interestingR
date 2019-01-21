# df <- expand.grid(x = 0:5, y = 0:5)
# df$z <- runif(nrow(df))
library(tidyverse)
library(tibble)
library(dplyr)
library(ggplot2)
data_01_12 = dt %>%
             tibble::rownames_to_column("ID") %>%
             slice(1:3)

mtcars %>% 
  tibble::rownames_to_column('Car') %>% 
  slice(1:3)

mtcars %>% 
  tibble::rownames_to_column('Car') %>%
  tidyr::separate('Car',c('brand','model'),remove = FALSE) %>%
  slice(1:5)

mtcars %>% 
  tibble::rownames_to_column('Car') %>%
  tidyr::separate('Car',c('brand','model'),remove = FALSE) %>%
  group_by(brand) %>%
  summarise(avg_mpg = mean(mpg)) %>%
  ggplot() + geom_bar(aes(reorder(brand,avg_mpg),avg_mpg),stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90,hjust = 1))
