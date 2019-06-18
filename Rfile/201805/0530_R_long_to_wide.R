library(tidyverse)
set.seed(519)
longdata1 <- data.frame(ID = 1:3,
                        expand.grid(Name = c("Dora", "John", "Rob"), Year = 2012:2014),
                        BMI = round(runif(9, 18, 35), 0))
longdata1

wide = longdata1 %>% 
  spread(Year, BMI)
wide

longdata2 <- wide %>% gather("2012","2013","2014",key = year,value = BMI)
longdata2

identical(longdata2$BMI, longdata1$BMI)

set.seed(520)
long3 <- data.frame(ID = 1:3,
                    expand.grid(Name = c("Dora", "John", "Rob"), Year = 2012:2014),
                    BMI = round(runif(9, 18, 35), 0),
                    Cholesterol = round(runif(9, 200, 300), 0)
)
long3

wide2 = long3 %>% 
  spread(Year, BMI)
wide2


long3 %>% 
  group_by(ID) %>% 
  mutate(Visit = 1:n())

long3 %>% 
  group_by(ID) %>% 
  mutate(Visit = 1:n()) %>% 
  gather("Year", "BMI", "Cholesterol", key = variable, value = number)

long3 %>% 
  group_by(ID) %>% 
  mutate(Visit = 1:n()) %>% 
  gather("Year", "BMI", "Cholesterol", key = variable, value = number) %>% 
  unite(combi, variable, Visit)

long3 %>% 
  group_by(ID) %>% 
  mutate(Visit = 1:n()) %>% 
  gather("Year", "BMI", "Cholesterol", key = variable, value = number) %>% 
  unite(combi, variable, Visit) %>% 
  spread(combi, number)
