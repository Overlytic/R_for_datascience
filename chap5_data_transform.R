
library(nycflights13)
library(tidyverse)

##overrides some functions in base R
##to use them need full names
## for example:
## stats::filter()
## stats::lag()

?flights

flights
View(flights) ##shows all columns

#tibbles are dataframes... but slightly
#tweaked to work better in tidyverse
#see wrangle section (later)

#types under column names
#dttm = datetime

#Main functions in dplyr:
#1)filter()     pick obs by val
#2)arrange()    reorder rows
#3)select()     pick variables by names
#4)mutate()     create new var from exist
#5)summarise()  summarise values

#1)filter
filter(flights,month == 1, day == 1)
jan1 <- filter(flights,month==1, day==1)
dec25 <- filter(flights,month==12, day==25)

  #in filter: , is an and
  #AND = &
  #OR = |
  #nog = ! .e.g !(x&y)=!x | !y
  #%in%

  #As well as & and |, R also has && and ||. Don’t use them here! You’ll learn when you should use them in conditional execution.


nov_dec <- filter(flights, month %in% c(11,12))
nov_dec


