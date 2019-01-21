library(tidyverse)
library(RNHANES)
library(ggsci)
library(Hmisc)
library(ggthemes)

d05 <- nhanes_load_data("BMX_D", "2005-2006") %>% 
  transmute(SEQN=SEQN, BMXBMI=BMXBMI, wave=cycle) %>% 
  left_join(nhanes_load_data("DEMO_D", "2005-2006"), by="SEQN") %>% 
  select(SEQN, BMXBMI, RIDAGEYR, RIAGENDR, wave, RIDEXPRG, WTINT2YR)

d07 <- nhanes_load_data("BMX_E", "2007-2008") %>% 
  transmute(SEQN=SEQN, BMXBMI=BMXBMI, wave=cycle) %>% 
  left_join(nhanes_load_data("DEMO_E", "2007-2008"), by="SEQN") %>% 
  select(SEQN, BMXBMI, RIDAGEYR, RIAGENDR, wave, RIDEXPRG, WTINT2YR)

d09 <- nhanes_load_data("BMX_F", "2009-2010") %>% 
  transmute(SEQN=SEQN, BMXBMI=BMXBMI, wave=cycle) %>% 
  left_join(nhanes_load_data("DEMO_F", "2009-2010"), by="SEQN") %>% 
  select(SEQN, BMXBMI, RIDAGEYR, RIAGENDR, wave, RIDEXPRG, WTINT2YR)

d11 <- nhanes_load_data("BMX_G", "2011-2012") %>% 
  transmute(SEQN=SEQN, BMXBMI=BMXBMI, wave=cycle) %>% 
  left_join(nhanes_load_data("DEMO_G", "2011-2012"), by="SEQN") %>% 
  select(SEQN, BMXBMI, RIDAGEYR, RIAGENDR, wave, RIDEXPRG, WTINT2YR)

d13 <- nhanes_load_data("BMX_H", "2013-2014") %>% 
  transmute(SEQN=SEQN, BMXBMI=BMXBMI, wave=cycle) %>% 
  left_join(nhanes_load_data("DEMO_H", "2013-2014"), by="SEQN") %>% 
  select(SEQN, BMXBMI, RIDAGEYR, RIAGENDR, RIDRETH3, wave, RIDEXPRG, WTINT2YR)

dat = bind_rows(d05,d07,d09,d11,d13)

clean_dat = dat %>%
            filter(!is.na(BMXBMI), RIDAGEYR >= 20, (RIDEXPRG != 1 | is.na(RIDEXPRG)))%>%
            mutate(
              age_group = case_when(
                RIDAGEYR >= 20 & RIDAGEYR < 40 ~ '20-39',
                RIDAGEYR >= 40 & RIDAGEYR < 60 ~ '40-59',
                RIDAGEYR >= 60 ~ "60+"
              ),
              age_group = as.factor(age_group),
              race = recode_factor(RIDRETH3, 
                                   `1` = "Hispanic", 
                                   `2` = "Hispanic", 
                                   `3` = "Non-Hispanic, White", 
                                   `4` = "Non-Hispanic, Black", 
                                   `6` = "Non-Hispanic, Asian",
                                   `7` = "Others"),
              gender = recode_factor(RIAGENDR, 
                                     `1` = "Men", 
                                     `2` = "Women")
            )

clean_dat %>% slice(1:5)

clean_dat %>% 
             filter(wave == '2013-2014') %>%
             group_by(age_group,gender) %>%
             tally()

men = clean_dat %>% 
  filter(gender == "Men") %>% 
  group_by(wave) %>% 
  summarise(
    "5%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.05)),
    "10%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.1)),
    "25%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.25)),
    "50%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.5)),
    "75%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.75)),
    "90%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.90)),
    "95%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.95))
  ) %>% 
  gather("%", bmi, -wave)

men %>% 
  slice(1:5)

women = clean_dat %>% 
  filter(gender == "Women") %>% 
  group_by(wave) %>% 
  summarise(
    "5%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.05)),
    "10%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.1)),
    "25%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.25)),
    "50%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.5)),
    "75%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.75)),
    "90%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.90)),
    "95%" = wtd.quantile(BMXBMI, WTINT2YR, probs=c(.95))
  ) %>% 
  gather("%", bmi, -wave)

as.list(men %>% filter(wave == "2013-2014") %>% select(bmi))

ggplot(men, aes(wave, bmi, fill = `%`, group = `%`)) +
  geom_line(color = "black", size = 0.3) +
  geom_point(colour="black", pch=21, size = 3) +
  scale_fill_jama() +
  theme_hc() +
  theme(text = element_text(family = "serif", size = 11), legend.position="none") +
  labs(
    title = "Weighted Percentiles of Body Mass Index by Survey Cycle",
    subtitle = "Men",
    caption = "Source: NHANES 2005-2014 survey",
    x = "Survey Cycle Years",
    y = "Body Mass Index"
  ) +
  scale_y_continuous(limits=c(15,45), breaks=seq(15,45, by = 5)) +
  annotate("text", 
           x = "2013-2014", 
           y = c(20.7, 22.0, 24.8, 27.8, 31.9, 36.2, 40.3), 
           label = c(" 5%", "10%", "25%", "50%", "75%", "90%", "95%"), 
           hjust = -0.5, colour = "#444444", size = 3)

as.list(women %>% filter(wave == "2013-2014") %>% select(bmi))

ggplot(women, aes(wave, bmi, fill = `%`, group = `%`)) +
  geom_line(color = "black", size = 0.3) +
  geom_point(colour="black", pch=21, size = 3) +
  scale_fill_jama() +
  theme_hc() +
  theme(text = element_text(family = "serif", size = 11), legend.position="none") +
  labs(
    title = "Weighted Percentiles of Body Mass Index by Survey Cycle",
    subtitle = "Women",
    caption = "Source: NHANES 2005-2014 survey",
    x = "Survey Cycle Years",
    y = "Body Mass Index"
  ) +
  scale_y_continuous(limits=c(15,45), breaks=seq(15,45, by = 5)) +
  annotate("text", 
           x = "2013-2014", 
           y = c(19.6, 21.1, 23.7, 28.0, 33.5, 39.8, 43.8), 
           label = c(" 5%", "10%", "25%", "50%", "75%", "90%", "95%"), 
           hjust = -0.5, colour = "#444444", size = 3)
