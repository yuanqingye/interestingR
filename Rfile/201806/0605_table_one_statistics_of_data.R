library(tidyverse)
library(RNHANES)
library(tableone)
library(labelled)

dat = nhanes_load_data("DEMO_F", "2009-2010") %>%
  select(SEQN, RIAGENDR, RIDAGEYR, RIDRETH1) %>%
  left_join(nhanes_load_data("DIQ_F", "2009-2010"), by="SEQN") %>%
  select(SEQN, RIAGENDR,RIDAGEYR, RIDRETH1, DIQ010) %>% 
  left_join(nhanes_load_data("BMX_F", "2009-2010"), by="SEQN") %>% 
  select(SEQN, RIAGENDR,RIDAGEYR, RIDRETH1, DIQ010, BMXBMI ) %>% 
  left_join(nhanes_load_data("VID_F", "2009-2010"), by="SEQN") %>% 
  select(SEQN, RIAGENDR,RIDAGEYR, RIDRETH1, DIQ010, BMXBMI, LBXVIDMS) %>% 
  mutate(gender = recode_factor(RIAGENDR, 
                                `1` = "Males", 
                                `2` = "Females"),
         BMI = as.factor(if_else(BMXBMI >= 25, "Overweight", "Normal weight")),
         dm = recode_factor(DIQ010,  
                            `1` = "Yes", 
                            `2` = "No"),
         race = recode_factor(RIDRETH1, 
                              `1` = "Hispanic", 
                              `2` = "Hispanic", 
                              `3` = "White", 
                              `4` = "Black", 
                              `5` = "Others")) %>% 
  select(SEQN, RIDAGEYR, LBXVIDMS, gender, BMI, dm, race)

dat %>% 
  CreateTableOne(vars = select(dat, -SEQN) %>% names(), data = .) %>% 
  kableone()

var_label(dat) = list(
  RIDAGEYR = "Age, years",
  BMI = "BMI",
  LBXVIDMS = "Vitamin D",
  gender = "Females",
  dm = "Diabetes ")

dat %>% 
  CreateTableOne(
    vars = select(dat, -SEQN) %>% names(), 
    test = FALSE,
    data = .) -> tab_one
print(tab_one, varLabels = TRUE)

dat %>% 
  CreateTableOne(
    vars = select(dat, -SEQN, -gender) %>% names(),
    strata ="gender",
    data = .,
    test = FALSE) -> tab_one
print(tab_one, varLabels = TRUE)

# added in 2019/06/18
library(skimr)
skimr::skim(choco)
