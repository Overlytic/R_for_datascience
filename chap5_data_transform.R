#Chapter 5: Data Transformation

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

#Other Variable types
  #dttm = datetime
  #date
  #lgl = boolean
  #fctr = factors / categorical variables for fixed possible values


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
  #AND &
  #OR |
  #not ! .e.g !(x&y)=!x | !y
  #%in%

  #As well as & and |, R also has && and ||. Don’t use them here! You’ll learn when you should use them in conditional execution.


  #floating point comparison
  sqrt(2) ^ 2 == 2 #gives false... floating point error
  near(sqrt(2) ^ 2, 2) #gives true :)
  
  1/49 * 49 == 1 #gives false... floating point error
  near(1/49 * 49 == 1, 0) # gives true
  near(1/49 * 49 == 1, 1) # ERROR? gives false????
  round(1/49*49-1,3)      # gives 0... not sure why near(,1) fails!!
  
  nov_dec <- filter(flights, month %in% c(11,12))
  filter(flights, !(arr_delay > 120 | dep_delay > 120))
  
  #Whenever you start using complicated, multipart expressions in filter(), consider making them explicit variables instead
  
  "Not Assigned Values / NA / Missing
  
    is.na(NA > 5) #NA
    is.na( 10 == NA) #NA
    is.na(NA + 10) #NA
    is.na(NA / 2) #NA
    is.na(NA == NA) #NA
  "  

  #NOTE: filter excludes FALSE and NA.
  
  df <- tibble(x = c(1, NA, 3))
  
  filter(df, x > 1)
  filter(df, is.na(x) | x > 1)
  
#2) arrange (basically sort)
  
  arrange(flights, year, month, day) #ascending year, then month, then day
  arrange(flights, desc(arr_delay)) 
  
  # missing values always sorted at the end
  
  arrange(df, x)
  arrange(df, desc(x))
  
#3) select (zoom oin on a useful subset of dataset)
  
  select(flights, year, month, day)
  select(flights, year:day)
  select(flights, -(year:day)) #drops year:day
  
  #?select -> see starts_with, ends_wth, contains, matches, num_range
  
  select(flights, year:day)
  select(flights, year:day, -month) #gives year and month
  
  rename(flights, tail_num=tailnum)#keeps all variables not explicitly mentioned
  
  select(flights, time_hour, air_time, everything())
  
#4) mutate: adds new col at end of dataset. use view to see easily
  
  flights_sml <- select(flights, 
                        year:day, 
                        ends_with("delay"),
                        distance,
                        air_time
  )
  
  #add new cols
  mutate(flights_sml,
         gain = arr_delay - dep_delay,
         speed = distance / air_time * 60,
         hours = air_time / 60,
         gains_per_hour = gain / hours #even reference col just created
  )
  
  view(flights_sml)
  
  #only new cols in a new tibble
  transmute(flights_sml,
            gain = arr_delay - dep_delay,
            speed = distance / air_time * 60,
            hours = air_time / 60,
            gains_per_hour = gain / hours
  )
  
  # %/% --> integer division
  # %% --> mod
  #log(), log2(), log(10)
  
  #lead(), lag() --> useful with group_by()
  
  x <- 1:10
  lag(x)
  lead(x)
  cumsum(x)
  cumprod(x)
  cummin(x)
  cummean(x)#also see rcpproll package.. rolling window average
  
  y<-c(1,2,2,NA,3,3,4)
  min_rank(y) #e.g. 1st 2nd 2nd 4th 4th 6th
  min_rank(desc(y)) 
  
  #other ranking functions
  row_number(y)
  dense_rank(y)
  percent_rank(y)
  cume_dist(y)
  ntile(y)
  
#5) summarise: collapses data frame to a single row
  
  summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

  #adding group by.. making much more useful  
  by_day <- group_by(flights,year,month,day)
  summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
  
  #combining multiple operations with pipe
  by_dest <-group_by(flights,dest)
  delay <- summarise(by_dest,
                    count=n(),
                    dist=mean(distance,na.rm=TRUE),
                    delay=mean(arr_delay,na.rm=TRUE)
  )
    
    # ** Filter to remove noisy points and Honolulu airport, which is almost twice as far away as the next closest airport.
  
  delay <- filter(delay, count > 20, dest != "HNL")
  
    # It looks like delays increase with distance up to ~750 miles 
    # and then decrease. Maybe as flights get longer there's more 
    # ability to make up delays in the air?
  
  ggplot(data = delay, mapping = aes(x = dist, y = delay))+
  geom_point(aes(size=count), alpha = 1/3)+
  geom_smooth(se = FALSE)
  
  #Better way to do this with pipe: %>%
  
  delays <- flights %>%
    group_by(dest) %>%
    summarise(
      count=n(),
      dist=mean(distance, na.rm = TRUE),
      delay=mean(arr_delay,na.rm=TRUE)
    ) %>%
    filter(count>20,dest != "HNL")
  
  #Behind the scenes: x %>% f(y) turns into F(x,y)
  # and f(y) %>% g(z) -> g(f(x,y),z)
  
  #pipes used everywhere in tidyverse... except ggplot2 (done before pipe added)
  
  
  #Missing values
  #Aggregate functions will give NA!!
  
  flights %>%
    group_by(year, month,day) %>%
    summarise(mean=mean(dep_delay))
  
  flights %>%
    group_by(year, month,day) %>%
    summarise(mean=mean(dep_delay, na.rm = TRUE))
  
  #try removing cancelled flights
  not_cancelled <- flights %>% 
    filter(!is.na(dep_delay),!is.na(arr_delay))
  
  not_cancelled %>%
    group_by(year,month,day) %>%
    summarise(mean=mean(dep_delay))
  
  
  #COUNTS:
  #always a good idea to include a count
  #count = n()
  #or count of non-missing values
  #    sum(!is.na(x))     
  #useful to ensure not drawing conclusions from
  #small amounts of data
  
  delays <- not_cancelled %>%
    group_by(tailnum) %>%
    summarise(
      delay = mean(arr_delay)
    )
  
  ggplot(data = delays, mapping = aes(x = delay))+
    geom_freqpoly(binwidth = 10)
  
  #looks like some planes had a upto 300 minute average delay!
  #but story actually more nuanced
  
  delays <- not_cancelled %>%
    group_by(tailnum) %>%
    summarise(
      delay = mean(arr_delay, na.rm = TRUE),
      n = n()
    )
  
  delays
  
  ggplot(data=delays, mapping = aes(x = n, y=delay))+
  geom_point(alpha = 1/10)
  
  ?geom_freqpoly
  
  #often useful to filter out the groups with the smallest number of observations
  #check the change from %>% to +.. have to get used to
  
  delays %>%
    filter(n > 25) %>%
    ggplot(mapping = aes(x = n, y = delay)) +
    geom_point(alpha = 1/10)
    
  #useful tip: ctl+shift+P. resends previous block of text.
  #when exploring the value of n in the example above
  #change n and then press shortcut to resend
  
  
  #batting <- as_tibble(Lahman:Batting)
  #SEE: 
  
  # You can find a good explanation of this problem at 
  # http://varianceexplained.org/r/empirical_bayes_baseball/ and 
  # http://www.evanmiller.org/how-not-to-sort-by-average-rating.html.
  
  
  
  #Useful summary functions:
  #mean, count, sum
  #median
  #subsetting e.g. mean(arr_delay[arr_delay > 0])
  
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(
      avg_delay1 = mean(arr_delay),
      avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
    )
  #spread measures: 
  # sd(x) : std dev
  # IQR(x): interquartile range
  # mad(x): median absolute deviation
  
  not_cancelled %>% 
    group_by(dest) %>% 
    summarise(distance_sd = sd(distance)) %>% 
    arrange(desc(distance_sd))
  
  #measures of rank:
  # min(x)
  #quantile(x,0.25)
  # max(x)
  
  # When do the first and last flights leave each day?
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(
      first = min(dep_time),
      last = max(dep_time)
    )
  
  #Measures of position:
  # first(x), nth(x,2), last(x)
  # work similarly to x[1],x[2] 
  # but with a defaut value if pos doesnt exist e.g. x[3] if only 2 
  
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    summarise(
      first_dep = first(dep_time), 
      last_dep = last(dep_time)
    )
  
  not_cancelled %>% 
    group_by(year, month, day) %>% 
    mutate(r = min_rank(desc(dep_time))) %>% 
    filter(r %in% range(r))
  
  
  #Counts: n(), sum(!is.na(x)), 
  #        n_distinct(x) -> count distinct values
  
    # Which destinations have the most carriers?
    not_cancelled %>% 
      group_by(dest) %>% 
      summarise(carriers = n_distinct(carrier)) %>% 
      arrange(desc(carriers))
    
    #useful shorthand for count
    
    not_cancelled %>% 
      count(dest)
  
    #can also add a weight...
    #thus count or sum total number of miles plane flew
    not_cancelled %>% 
      count(tailnum, wt = distance)
  
  
    
    # How many flights left before 5am? (these usually indicate delayed
    # flights from the previous day)
    not_cancelled %>% 
      group_by(year, month, day) %>% 
      summarise(n_early = sum(dep_time < 500))  
      
    
    # What proportion of flights are delayed by more than an hour?
    not_cancelled %>% 
      group_by(year, month, day) %>% 
      summarise(hour_perc = mean(arr_delay > 60, na.rm = TRUE))
    
  #Grouping by multiple variables
    
    daily <- group_by(flights, year, month, day)
    (per_day   <- summarise(daily, flights = n()))
    (per_month <- summarise(per_day, flights = sum(flights)))
    (per_year  <- summarise(per_month, flights = sum(flights)))
    
  #Ungrouping
    
    daily %>% 
      ungroup() %>%             # no longer grouped by date
      summarise(flights = n())  # all flights
    
    
  # Grouped Mutates (Go through again)
    
    #Find the worst members of each group:
    flights_sml %>% 
      group_by(year, month, day) %>%
      filter(rank(desc(arr_delay)) < 10)
  
    
    #Find all groups bigger than a threshold:
    popular_dests <- flights %>% 
      group_by(dest) %>% 
      filter(n() > 365)
    popular_dests
    
    #Standardise to compute per group metrics:
    popular_dests %>% 
      filter(arr_delay > 0) %>% 
      mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
      select(year:day, dest, arr_delay, prop_delay)
    
    "
    A grouped filter is a grouped mutate followed by an ungrouped filter. 
    I generally avoid them except for quick and dirty manipulations: 
    otherwise it’s hard to check that you’ve done the manipulation correctly.
    "
  