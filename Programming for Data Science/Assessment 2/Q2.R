## Programming for Data Science, Autumn 2022
## MATH70094 
## Assessment 2 
## Q2 
## NAME AND CID
## Joana Levtcheva, CID 01252821

##==========================================================================##
## Part A

## A(i)

# scanning salaries.txt to explore its structure and reading only the first 4 rows
v <- scan("salaries.txt", what = "", sep = "\n", nlines = 4)
cat(v, sep = "\n")

## A(ii)

# reading the in salaries.txt into a dataframe
# including the header and specifying the separator
df <- read.table("salaries.txt", header = TRUE, sep = ";")
class(df) # checking that df is indeed a data.frame

##==========================================================================##


##==========================================================================##
## Part B

## B(i)

check_missing <- function(x) {
  df_column_names <- colnames(x) # extracting the dataframe column names
  for (column_name in df_column_names) {
    number_of_na <- sum(is.na(x[,column_name])) # number of missing values in a column
    cat(paste("Col name:", column_name, ", number missing:", number_of_na, "\n"))
  }
  number_of_rows <- nrow(x)
  cat(paste("Number of rows:", number_of_rows))
}
check_missing(x = df)


## B(ii)

mean_salary <- mean(df$salary, na.rm = TRUE) # setting na.rm to TRUE to ignore the nan values
standard_deviatiion_salary <- sd(df$salary, na.rm = TRUE)

# calculating the bounds of the estimated interval of salary values of the form 
# (x - 2*s, x + 2*s) where x is the sample mean, and s is the sample standard deviation
left_bound <- mean_salary - 2 * standard_deviatiion_salary
right_bound <- mean_salary + 2 * standard_deviatiion_salary

# printing the salary intevral with values to two decimal places
# using format() with nsmall=2 for this
cat(paste("Salary interval: (", format(left_bound, nsmall=2), ", ", format(right_bound, 2), ")", sep = ""))

## B(iii)

# replacing any missing salary values with the mean_salay value from above
df$salary[which(is.na(df$salary))] <- mean_salary


## B(iv)

# removing any rows that still contain issing values in any column
df_clean <- df[complete.cases(df), ]
check_missing(x = df_clean)

##==========================================================================##


##==========================================================================##
## Part C


df_clean$date <- as.Date(df_clean$date) # transforming the date column to a Date one
# selecting data for age in [40:49], city London, and responces from 2021
london_subgroup <- df_clean[which(df_clean[,'age']>=40 & df_clean[,"age"]<=49 & df_clean[,"city"] == "London"), ]
london_subgroup <- london_subgroup[format(london_subgroup[,"date"], "%Y")==2021,]

# selecting data for age in [40:49], city Singapore, and responces from 2021
singapore_subgroup <- df_clean[which(df_clean[,'age']>=40 & df_clean[,"age"]<=49 & df_clean[,"city"] == "Singapore"), ]
singapore_subgroup <- singapore_subgroup[format(singapore_subgroup[,"date"], "%Y")==2021,]


##==========================================================================##


##==========================================================================##
## Part D

## D (i)

# calculating the number of rows, mean salary, and standard deviation salary
# for both london_subgroup and singapore_subgroup
london_subgroup_nrow <- nrow(london_subgroup)
london_subgroup_salary_mean <- mean(london_subgroup[,"salary"])
london_subgroup_salary_sd <- sd(london_subgroup[,"salary"])

singapore_subgroup_nrow <- nrow(singapore_subgroup)
singapore_subgroup_salary_mean <- mean(singapore_subgroup[,"salary"])
singapore_subgroup_salary_sd <- sd(singapore_subgroup[,"salary"])

# creating a dataframe containing the information from above as columns 
# as follows: count, salary, std. dev.
# and row names London, Singapore
df_summary <- data.frame(
  "count"=c(london_subgroup_nrow, singapore_subgroup_nrow), 
  "salary"=c(london_subgroup_salary_mean, singapore_subgroup_salary_mean),
  "std. dev."=c(london_subgroup_salary_sd, singapore_subgroup_salary_sd),
  check.names = FALSE,
  row.names=c("London", "Singapore"),
  stringsAsFactors = FALSE
)
print(df_summary)

## D (ii)

# saving the dataframe df_summary as summary.txt following the csv format
write.table(df_summary, file = "summary.txt", sep = ",", col.names = NA, row.names = TRUE, quote=FALSE)

##==========================================================================##
