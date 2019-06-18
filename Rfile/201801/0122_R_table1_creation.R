dt1 = read.csv(file.choose(),header = TRUE,sep = ',')
library(tableone)

#Create a variable list which we want in Table 1
listVars <- c("Age", "Gender", "Cholesterol", "SystolicBP", "BMI", "Smoking", 
              "Education")

#Define categorical variables
catVars <- c("Gender","Smoking","Education")
table_0122 = CreateTableOne(vars = listVars,data = dt1,factorVars = catVars)
table_0122

listVars <- c("Age","Cholesterol", "SystolicBP", "BMI", "Smoking", "Education")
table_0122 = CreateTableOne(vars = listVars,strata = c("Gender"),data = dt1,factorVars = catVars)
table_0122

table_0122 <- print(table_0122)

# Load the packages
library(ReporteRs)
library(magrittr)

# The script
docx( ) %>% 
  addFlexTable(table_0122 %>%
                 FlexTable(header.cell.props = cellProperties( background.color = "#003366"),
                           header.text.props = textBold( color = "white" ),
                           add.rownames = TRUE ) %>%
                 setZebraStyle( odd = "#DDDDDD", even = "#FFFFFF" ) ) %>%
  writeDoc(file = "table_0122.docx")
