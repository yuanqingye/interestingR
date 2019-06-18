library(tidyverse)
dat = data.frame(
  id = c(1,1,1,1, 2,2,2,2, 3,3,3,3),
  quarter = rep(c("Jan", "Apr", "Jul", "Oct"), times=3),
  spending = c(22,35,10,64, 55,23,NA,10, 42,NA,NA,18)
)
dat

dat %>% group_by(id) %>% 
summarise(missing=sum(is.na(spending)))

na.omit(dat)

dat %>% 
  group_by(id) %>% 
  mutate(spending_mean = ifelse(is.na(spending), mean(spending, na.rm=T), spending))

dat_fill_down = dat %>% 
  group_by(id) %>% 
  fill(spending, .direction = c("down"))
dat_fill_up = dat %>% 
  group_by(id) %>% 
  fill(spending, .direction = c("up"))