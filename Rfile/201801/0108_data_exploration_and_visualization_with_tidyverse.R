library(tidyverse)
library(RNHANES) #NHANES - National Health and Nutrition Examination Survey
d13 = nhanes_load_data("DEMO_H","2013-2014")%>%
      transmute(SEQN = SEQN,wave=cycle,INDFMIN2, RIDRETH1)%>%
      left_join(nhanes_load_data("BMX_H","2013-2014"),by = "SEQN")%>%
      select(SEQN,wave,INDFMIN2, RIDRETH1, BMXBMI)%>%
      mutate(annincome = recode_factor(INDFMIN2,
        '1' = "lowest",
        '2' = "lowest",
        '3' = "lowest",
        '4' = "low", 
        '5' = "low",
        '6' = "low",
        '7' = "medium", 
        '8' = "medium",
        '9' = "medium",
        '10' = "high",
        '12' = "high",
        '13' = "high",
        '14' = "highest",
        '15' = "highest"))%>%
      filter(!is.na(BMXBMI),!is.na(annincome))

      ggplot(data = d13) + 
        geom_bar(aes(annincome))

      d13%>%count(annincome)
      
      ggplot(data = d13) + 
        geom_histogram(aes(BMXBMI),bindwidth = 5)
      
      d13%>%count(cut_width(BMXBMI,5))
      ggplot(data = d13, aes(BMXBMI,color = annincome)) +
        geom_freqpoly(binwidth = 1)
      
      ggplot(data = d13, aes(annincome,BMXBMI)) +
        geom_boxplot()
      
      d13 %>% mutate(race = recode_factor(RIDRETH1,
                                          `1` = "Mexian American",
                                          `2` = "Hispanic",
                                          `3` = "Non-Hispanic, White",
                                          `4` = "Non-Hispanic, Black",
                                          `5` = "Others"))%>%
      count(race,annincome) %>%
      ggplot(aes(race,annincome)) +
      geom_tile(aes(fill = n))
      
      data13 = d13 %>% 
               left_join(nhanes_load_data("TCHOL_H","2013-2014")) %>%
               select(SEQN,wave,INDFMIN2,RIDRETH1,BMXBMI,LBXTC)
      
      ggplot(data = data13) + 
            geom_point(aes(BMXBMI,LBXTC))
      
      ggplot(data = data13) +
            geom_point(aes(BMXBMI,LBXTC),alpha = 1/20)
      
      ggplot(data = data13,aes(BMXBMI,LBXTC)) +
            geom_boxplot(aes(group = cut_number(BMXBMI,20)))
      