#Chapter 7 Explore Data Analysis

#Using visualisation and transformation to explore data
#in a systematic way

#EDA:Exploratory Data Analysis

#1. Generate Questions about Data
#2. Search for answers by visualising, transforming,
#   and modelling your data
#3. Use what you learn to refine questions and generate
#   new questions

#FREEDOM TO EXPLORE. ITS A STATE OF MIND!

library(tidyverse)

#“Far better an approximate answer to the right question,
# which is often vague, than an exact answer to the wrong 
# question, which can always be made precise.” 
# John Tukey

#Key to Quality Questions -> Generate LARGE quantity!

#Two type of questions alwyas useful for making 
#discoveries in your data.
#
#1. What type of variation occurs in my variables?
#2. What type of covariation occurs between 
#   my variables?

### Variation: ###

#Visualising Distributions:

ggplot(data = diamonds)+
  geom_bar(mapping=aes(x=cut))

diamonds %>%
  count(cut)

ggplot(data=diamonds)+
  geom_histogram(mapping = aes(x=carat), binwidth=0.5)

diamonds %>%
  count(cut_width(carat,0.5))

#Explore different binwidths when working with 
# histograms... can show different features of the
# data

smaller <- diamonds %>%
  filter(carat < 3)

ggplot(data=smaller, mapping = aes(x=carat))+
  geom_histogram(binwidth = 0.1)

#Multiple histograms in the same plot.. 
#use geom_freqpoly(). Much easier understand
#overlappning lines than bars

ggplot(data=smaller, mapping=aes(carat, colour=cut))+
  geom_freqpoly(binwidth=0.1)

#good follow up questions: 
#1. what want to learn more about? curiosity
#2. How could this be misleading? skepticism


ggplot(data=smaller, mapping=aes(x = carat))+
  geom_histogram(binwidth = 0.01)

#Example questions:

"

    Why are there more diamonds at whole carats and 
    common fractions of carats?

    Why are there more diamonds slightly to the right 
    of each peak than there are slightly to the left of 
    each peak?

    Why are there no diamonds bigger than 3 carats?
"

#clusters of similar values suggest subgroups in
# the data.

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)

#looks like 2 groups and little in middle. 
#Maybe another variable can explain

?faithful

#Unusual Values:

#Outliers sometimes hard to see in a histogram
#with many observations.

ggplot(diamonds)+
  geom_histogram(mapping=aes(x=y), binwidth=0.5)

#only outliers evidence is wide x-axis

diamonds %>%
  count(cut_width(y,0.5))

#can also zoom into graph
ggplot(diamonds)+
  geom_histogram(mapping=aes(x=y), binwidth=0.5)+
  coord_cartesian(ylim = c(0,50))

#pluck out unusual values with dplyr (DATA PLY R!)
unusual <- diamonds %>%
  filter(y<3 | y > 20) %>%
  arrange(y)

unusual #doesnt look good. 0 size. 59mm low prize

#option1. Not recommended. Might have no data after
#gone through all variables.
diamonds2 <- diamonds %>%
  filter(between(y,3,20))

#option2. 
diamonds2 <- diamonds %>%
  mutate(y=ifelse(y < 3 | y > 20, NA, y))

ggplot(data = diamonds2, mapping=aes(x=x,y=y))+
         geom_point()

#to suppress NA warning (9 values)

ggplot(data = diamonds2, mapping=aes(x=x,y=y))+
  geom_point(na.rm = TRUE)

#other example: understanding what makes missing values different
#missing values in nycflights13::flights -> dep_time
#shows that flight was cancelled.
#can compare scheduled departure times for cancelled
# and non-cancelled

nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour+sched_min / 60
  ) %>%
  ggplot(mapping=aes(sched_dep_time))+
    geom_freqpoly(mapping=aes(colour=cancelled), binwidth=1/4)
    
#must improve the plot... too many non-cancelled flights


## Covariation:variation between variables ##





