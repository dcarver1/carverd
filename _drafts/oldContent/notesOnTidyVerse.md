8/22/2018
The first chapter seems to be a review of the dplyr package taking limited notes

#ggplot2
**foundation of ggplot**
three main components
- data
- aesthetic quality
- type of plot

```r
# data
ggplot(gapminder_1952,
#aesthetic
  aes(x = pop, y = gdpPercap)) +
#type of plot
  geom_point()
```

**log scale**
you can add scaling value within a +
```r
ggplot(gapminder_1952,
  aes(x = pop, y = gdpPercap)) +
  geom_point()+
  scale_x_log10()
```

**additional Aesthetic**
Color and size

``` r
# Add the size aesthetic to represent a country's gdpPercap
ggplot(gapminder_1952, aes(x = pop, y = lifeExp, color = continent,
size=gdpPercap)) +
  geom_point() +
  scale_x_log10()  
```
**faceting**
dividing plots into subplots
~ usually means by in R
```r
# Scatter plot comparing pop and lifeExp, faceted by continent
ggplot(gapminder_1952,
  aes(x=pop,
    y=lifeExp))+
    geom_point()+
    scale_x_log10()+
    facet_wrap(~continent)
#generated 5 unique plots based on individual continent
```
crazy data rich plot
```r
# Scatter plot comparing gdpPercap and lifeExp, with color representing continent
# and size representing population, faceted by year
# Scatter plot comparing pop and lifeExp, faceted by continent
ggplot(gapminder, aes(x=gdpPercap,y=lifeExp,color=continent, size=pop ))+
    geom_point()+
    scale_x_log10()+
    facet_wrap(~year)
```
It's easy to take your summarized data and plot it
```r
# Create a scatter plot showing the change in medianLifeExp over time
ggplot(by_year, aes(x=year,y=medianLifeExp,expand_limits(y=0)))+
  geom_point()
```

**group_by**
this works in order of feature feed into it.
in this example continent then year. year is essential the tie breaker for the continent column.
``` r
by_year_continent <- gapminder %>%
  group_by(continent, year)
```

**line plots**
same structure as the scatter plots but new geom feature
the expand_limits plot ensures that the line plots start at y=0
```r
ggplot(year_continent, aes(x = year, y = meanLifeExp, color = continent)) +
  geom_line() +
  expand_limits(y = 0)
```

**bar plot**

```r
ggplot(by_continent, aes(x = continent, y = meanLifeExp)) +
  geom_col()
```

**histograms**
distribution of a value within a single class
```r
ggplot(gapminder_2007, aes(x = lifeExp)) +
  geom_histogram(binwidth = 5)+
  scale_x_log10()
```

**boxplots** 
distribution of value within a class

```r
ggplot(gapminder_2007, aes(x = continent, y = lifeExp)) +
  geom_boxplot()
```
