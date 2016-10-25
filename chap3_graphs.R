#Chapter 3 Visualisation and Graphs

library(tidyverse)

?mpg

#plot car engine size vs fuel consumption
#displ = engine displacement, in litres
#hwy = highway miles per gallon

ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))


### AESTHETICS ###

#note: aes function means... aesthetic mapping..

#Exercises: Multipline omm

  "
  1. ggplot(data=mpg)
  
  2. ?mtcars
  3. ?mpg
    
  4.
  ggplot(data=mpg)+
   geom_point(mapping=aes(x=hwy, y=cyl))
  
  5.
  ggplot(data=mpg)+
   geom_point(mapping=aes(x=class, y=drv))
  
    #useless since class is a string value
  "

#Add class as colours (hubrid/compact/suv) to graph
#can use color or colour (british)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,colour = class))

  #thus the outliers are 2 seaters or sportcars!
  
#Add class as size ...
#will get a warning... 
ggplot(data=mpg)+
    geom_point(mapping=aes(x=displ,y=hwy,size = class))

#Alpha/transparency
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,alpha = class))

#Shape. Warning... only 6 distinct values can be handled
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,shape = class))
  
#all blue. note outside the aes (since not giving info about variable)
ggplot(data = mpg)+
    geom_point(mapping = aes(x=displ,y=hwy), color = "blue")

#Other aesthetics of the graph (outside aes function):
#colour, fill, size (in mm), shape (0-24, see table in book)
# hollow shapes (0-14) -> border with 'colour'
# solid shapes (15-18) -> fill with 'colour'
# filled shapes (21-24) -> border = colour, fill = fill
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ,y=hwy), size = 2, color = "red", shape = 2)
             
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ,y=hwy), size = 2, color = "red", shape = 15)

ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ,y=hwy), size = 2, color = "red", fill = "black",  shape = 21)

#Use the stroke aesthetic to modify the width of the border


### FACETS ###

#The first argument of facet_wrap() should be a formula, 
#which you create with ~ followed by a variable name

?facet_wrap

ggplot(data = mpg) + 
  geom_point(mapping = aes(x=displ,y=hwy)) +
  facet_wrap(~class, nrow = 2)

?facet_grid

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)


##Geometric objects ##

ggplot(data = mpg) + 
    geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

#multiple plots combined

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
    show.legend = FALSE
  )

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

  #better way. use global mapping

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

  #different data... between geoms.. 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

?geom_smooth   #se = confidence interval... .default is true



#Statistical transformations: (BAR CHARTS)
#it creates the count variable that it plots... by binning the data. (transforming)

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

?geom_bar

#You can generally use geoms and stats interchangeably. For example, you can recreate the previous plot using stat_count() instead of geom_bar():
#This works because every geom has a default stat; and every stat has a default geom.

ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))


?tribble #create dataframe from small table of data...

#overriding stat.... normal bar chart, no stats needed

demo <- tribble(
  ~a,      ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")


#proportion bar chart

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )


ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )


#list of possible stats
?stat_bin


#colour a barchart

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

#stacked bar charts

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
  
  #position identity not useful for stacked bar charts (overlaps). default for scatter plots

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")



#overplotting on  scatter plot... add noise (jitter) to help see mass of data

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "identity")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

  #OR.. short hand for it
ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy))

#?position_dodge, ?position_fill, ?position_identity, ?position_jitter, and ?position_stack.




##Coordinate functions: ##

#flip chart
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()


#aspect ratio...set it correctly for maps

nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

#polar coord

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


"
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
     mapping = aes(<MAPPINGS>),
     stat = <STAT>, 
     position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>


"
