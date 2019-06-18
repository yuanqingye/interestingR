library(tabulizer)
library(dplyr)

# Location of WARN notice pdf file
# location <- 'http://www.edd.ca.gov/jobs_and_training/warn/WARN-Report-for-7-1-2016-to-10-25-2016.pdf'
location = "~/model_data/warn_report.pdf"
# Extract the table
out <- extract_tables(location)

final <- do.call(rbind, out[-length(out)])

# table headers get extracted as rows with bad formatting. Dump them.
final <- as.data.frame(final[2:nrow(final), ])

# Column names
headers <- c('Notice.Date', 'Effective.Date', 'Received.Date', 'Company', 'City', 'County',
             'No.of.Employees', 'Layoff/Closure')

# Apply custom column names
names(final) <- headers

head(final)

# These dplyr steps are not strictly necessary for dumping to <code>csv, but useful if further data 
# manipulation in R is required. 
final <- final %>%
  # Convert date columns to date objects
  mutate_each(funs(as.Date(., format='%m/%d/%Y')), Notice.Date, Effective.Date, Received.Date) %>%
  # Convert No.of.Employees to numeric
  mutate(No.of.Employees = as.numeric(levels(No.of.Employees)[No.of.Employees]))

# Write final table to disk
write.csv(final, file='result_data/CA_WARN.csv', row.names=FALSE)
