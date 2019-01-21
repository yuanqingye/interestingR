library(tidyverse)
library(datasets)

dt = esoph
head(dt)
summary(dt)

dt %>% spread(agegp,ncases) %>%slice(1:5)

wide = dt %>% spread(agegp,ncases)
wide %>% gather(agegp,ncases,-alcgp,-tobgp,-ncontrols) %>% filter(!is.na(ncases))

dt %>% separate(agegp,into = c("min","max"),sep = "-") %>% slice(1:5)

dt2 = dt %>% separate(agegp,into = c("min","max"),sep = "-") %>% slice(1:5)

dt2 %>% unite(agegp,min,max,sep = "-")%>%slice(1:5)
