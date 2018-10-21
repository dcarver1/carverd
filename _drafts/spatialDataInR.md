# Introduction to spatial data in R
**9/10/2018**

This will work with ggplot, tbls, and ggmap.
ggmap downloads layers from web services and displays background.

### ggmap
really easy to bring in base maps

*get_map*
position = list of lon and lat
zoom = view layer between 3-21
scale = resolution of the base map, 1= full resolution
```r
library(ggmap)
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Get map at zoom level 5: map_5
map_5 <- get_map(corvallis, zoom = 5, scale = 1)

# Plot map at zoom level 5
ggmap(map_5)

# Get map at zoom level 13: corvallis_map
corvallis_map <- get_map(corvallis, zoom = 13, scale = 1)

# Plot map at zoom level 13
ggmap(corvallis_map)
```
*adding points*
ggmap defines the base visualization of the map. Because of this it's best to define the data source within the geom_point component. This is different from how things would work using ggplot
```r
# Swap out call to ggplot() with call to ggmap()
ggmap(corvallis_map) +
  geom_point(aes(lon, lat), data = sales)
`

Adding aestatics to the map is  just like ggplot2
```r
# Map color to year_built
ggmap(corvallis_map) +
  geom_point(aes(lon, lat, color = year_built), data = sales)
```
### get_map /ggmap options
uses google map api
maptype and source arguements
?get_map
provides background options
- google, stamen, and osm

*editing the source and map type*
Example for pulling different maps display

```r
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Add a maptype argument to get a satellite map
corvallis_map_sat <- get_map(corvallis, zoom = 13, maptype='satellite')

# Edit to display satellite map
ggmap(corvallis_map_sat) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

# Add source and maptype to get toner map from Stamen Maps
corvallis_map_bw <- get_map(corvallis, zoom = 13, source = 'stamen', maptype = 'toner')

# Edit to display toner map
ggmap(corvallis_map_bw) +
  geom_point(aes(lon, lat, color = year_built), data = sales)
```
*altering the ggplot call to bring in functionality*
This is the structure that is best to work with if your going to be visualizing multiple aspects of the map.
original way
```r
ggmap(corvallis_map) +
  geom_point(aes(lon, lat), data = sales)
```

more functional way
```r
ggmap(corvallis_map,
    base_layer = ggplot(sales, aes(lon, lat))) +
  geom_point()
```

example
```r
# Use base_layer argument to ggmap() to specify data and x, y mappings
ggmap(corvallis_map_bw,
  base_layer = ggplot(sales, aes(lon, lat))) +
  geom_point(aes(color = year_built))+
  facet_wrap(~class)
```
*facet_wrap* this is a function that will produce multiple iterations of the maps based on the factor classes of a column in the original dataset

*qmplot*
a simplified version of the mapping function that allows for the addition ggplot layers without use on the base_layer function.
```r
# Plot house sales using qmplot()
qmplot(lon,lat, data=sales,
  geom = "point" , color = bedrooms)+
  facet_wrap( ~ month)
```
## common types of spatial data
- point, line, polygon, raster
Polygons are trickier; order matters and data is stored as a series of points. so you need to know what group. There is a lot of redundant data as a result of this.
you define this within the aestectics of the layer using
*fill* = what becomes the legend
*group* = how points are connected
it would require some very specific data to generate such things
```r
# Add a point layer with color mapped to ward
ggplot(ward_sales, aes(lon, lat))+ geom_point(aes(color = ward))

# Add a point layer with color mapped to group
ggplot(ward_sales, aes(lon, lat, color= group))+ geom_point(aes(color=group))

# Add a path layer with group mapped to group
ggplot(ward_sales, aes(lon, lat))+ geom_path(aes(group = group))

# Add a polygon layer with fill mapped to ward, and group to group
ggplot(ward_sales, aes(lon, lat)) + geom_polygon(aes(fill = ward, group = group ))
```

### mapping polygons
ggmap options that help with extent issues
*extent* set the extent of the map on the screen
*maprange* binary, should the basemap define x,y extent shown
good examples of the process listed below
```r
# Fix the polygon cropping
ggmap(corvallis_map_bw,
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = ward))

# Repeat, but map fill to num_sales
ggmap(corvallis_map_bw,
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = num_sales))

# Repeat again, but map fill to avg_price
ggmap(corvallis_map_bw,
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = avg_price), alpha = 0.8)
```
### working with raster data
again this is a little bit complicated but as long as the ggplot background is there engaging with this content will go pretty well.
```r
# Add a geom_point() layer
ggplot(preds, aes(lon, lat))+
geom_point()

# Add a tile layer with fill mapped to predicted_price
ggplot(preds, aes(lon, lat))+geom_tile(aes(fill=predicted_price))

# Use ggmap() instead of ggplot()
ggmap(corvallis_map_bw)+
  geom_tile(data= preds, aes(lon, lat, fill=predicted_price), alpha = 0.8)
```

9/12/2018
SP objects
allow you to alter the coordinate data, reduces the redundancy of point line and polygon data
- standard in r for store spatial data
- new spatial packages are built on sp

print, summary, and plot all have specific methods for working with sp data types
You can call str() on the object with a clause of max object that surrarizes the data well.
```r
# Call str() on countries_sp with max.level = 2
str(countries_sp, max.level = 2)
```
With sp objects you have to use @ rather then $
this has to do the underlying data structure of the sp objects.

You can have spatial polygons and spatial polygon dataframe. these have df of information attached to them

sp objects are S4 objects. They have specific parameters of classes and methods.
S4 objects are like lists but have slots. they are recursive, S4 objects in S4 objects
You can access the slot by using the @ symbol and the slot name

method for accessing information from a slot
```r
# 169th element of countries_spdf@polygons: one
one <- countries_spdf@polygons[[169]]

one <- slot(countries_spdf, polygons)[[169]]
#they can get kinda ugly due to the nested structure of the objects
# Call plot on the coords slot of 6th element of one@Polygons
plot(one@Polygons[[6]]@coords)
```
The complex data structure is for the following reason
polygon: contiguous US
Polygons: lower 48, alaska, hawaii
Spatial polygons: contains Polygons and coordinate reference information
spatial polygon dataframe: spatial polygons with extra attribute data

You can subset sp objects just like a dataframe  
```r
# Subset the 169th object of countries_spdf: usa
usa <- countries_spdf[169,]
# Pull out the name column using $
countries_spdf$name
# Pull out the subregion column using [[
countries_spdf[["subregion"]]
```
You can also build in clauses that to subset the datasets
```r
# Create logical vector: is_nz
in_nz <- countries_spdf$name == "New Zealand"

# Subset countries_spdf using is_nz: nz
nz <- countries_spdf[in_nz, ]
```
There is a library called tmap that allows for the quick and eazy generation of cholopleth maps. it requires sp objects
you have to use quotes to define columns

```r
library(tmap)

# Use qtm() to create a choropleth map of gdp
qtm(shp = countries_spdf, fill = "gdp")
```
too options of plots with different stylings
```r
# Add style argument to the tm_fill() call
tm_shape(countries_spdf) +
  tm_fill(col = "population", style = "quantile") +
  # Add a tm_borders() layer
  tm_borders(col="burlywood4")

# New plot, with tm_bubbles() instead of tm_fill()
tm_shape(countries_spdf) +
  tm_bubbles(size = "population", style = "quantile") +
  # Add a tm_borders() layer
  tm_borders(col="burlywood4")
```
You can change projection within the tm_shape method
```r
tm_shape(countries_spdf, projection = "robin") +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") +
  tm_style_classic()
```
This is crazy... You can simple save the map as an html so it is interactive and it builds it on the backend with leaflet!
```r
# Save a static version "population.png"
save_tmap(filename = "population.png")

# Save an interactive version "population.html"
save_tmap(filename = "population.html")
```

## Raster Data in R
use the raster library
writen with the S4 framework
raster has a print method for sp objects. it provides a nice summary to the dataset

**plot** shows a image of the raster
**values** identifies the actual cell values

**Perceptual color space: HCL**
hue - unordered : wavelength
Chroma - ordered: intensity (grey to full color)
Luminesce - ordered: brightness (white to black )

Sequential - ordered ( chroma/Luminesce +  redundant hue)
Diverging - ordered in both directions( chroma/Luminesce + hue)
Qualitative - unordered ( only Hue )

two examples of adding color to raster with different libraries
```r
library(RColorBrewer)
# 9 steps on the RColorBrewer "BuPu" palette: blups
blups <- brewer.pal(9, "BuPu")

# Add scale_fill_gradientn() with the blups palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8) +
  scale_fill_gradientn(colors = blups)

library(viridisLite)
# viridisLite viridis palette with 9 steps: vir
vir <- viridis(9)

# Add scale_fill_gradientn() with the vir palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8) +
  scale_fill_gradientn(colors = vir)

```
You can define a palette with the **palette** argument within the tm_raster call.
**rev()** allows you to reverse the order of the palette
```r
library(viridisLite)
mag <- magma(9)
# Use the mag palette but reverse the order
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = rev(mag)) +
  tm_legend(position = c("right", "bottom"))
```
perceptually uniform: perceiving equivalent color difference to numerical difference
tmap will always bin variables

the library classInt can be used to set breaks within a dataset
this just displays the breaks
```r
library(classInt)

# Create 5 "pretty" breaks with classIntervals()
classIntervals(values(prop_by_age[["age_18_24"]]),
               n = 5, style = "pretty")

# Create 5 "quantile" breaks with classIntervals()
classIntervals(values(prop_by_age[["age_18_24"]]),
               n = 5, style = "quantile")
```


 Example of setting breaks within the tm-raster options
 ```r

# Use 5 "quantile" breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = mag, style = "quantile") +
  tm_legend(position = c("right", "bottom"))

# Create histogram of proportions
hist(values(prop_by_age)[, "age_18_24"])

# Use fixed breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = mag,
    style = "fixed", breaks = c(0.025, 0.05, 0.1, 0.2, 0.25, 0.3, 1))

# Save your plot to "prop_18-24.html"
save_tmap(filename = "prop_18-24.html")
```
with categorical data you can define your own palette when needed
```r
# Examine levels of land_cover
levels(land_cover)

# A set of intuitive colors
intuitive_cols <- c(
  "darkgreen",
  "darkolivegreen4",
  "goldenrod2",
  "seagreen",
  "wheat",
  "slategrey",
  "white",
  "lightskyblue1"
)

# Use intuitive_cols as palette
tm_shape(land_cover) +
  tm_raster(palette= intuitive_cols)+
  tm_legend(position = c("left", "bottom"))
```

## reading in spatial data
You can use rgdal to read in spatial data in R. Shpfiles can be read in using readOGR
**readOGR** takes in a directory and the file name with no extension.
```r
library(sp)
library(rgdal)

# Use dir() to find directory name
dir()

# Call dir() with directory name
dir("nynta_16c")

# Read in shapefile with readOGR(): neighborhoods
neighborhoods <- readOGR(dir(), "nynta")
```
rasters should be called in using the raster library because it returns a raster object
just include a full path to the object
```r
library(raster)
# Use raster() with file path: income_grid
income_grid <- raster("nyc_grid_data/m5602ahhi00.tif")
```
There are libraries that exist for both census data and natural earth data !!!!
This is an easy way to download content directly from a server.
```r
library(rnaturalearth)
library(sp)
library(tigris)

# Call tracts(): nyc_tracts
nyc_tracts <- tracts(state="NY", county = "New York", cb = TRUE)

# Call summary() on nyc_tracts
summary(nyc_tracts)

# Plot nyc_tracts
plot(nyc_tracts)
```

**Coodinate Reference System**
colors
**proj4string()** : return projection information

rgdal::spTransform(spatial obect, coordinate system )
very cool you can do all of this in R, this is quickly becoming a good alterative to the desktop gis

CRS is build on
1. projection
2. datum
3. elipsoid

method for examing the reference system information
```r
library(sp)

# proj4string() on nyc_tracts and neighborhoods
proj4string(nyc_tracts)
proj4string(neighborhoods)

# coordinates() on nyc_tracts and neighborhoods
head(coordinates(nyc_tracts))
head(coordinates(neighborhoods))

# plot() neighborhoods and nyc_tracts
plot(neighborhoods)
plot(nyc_tracts, col="red", add=TRUE)
```
applying a transformation is super easy!
This is great.
```r
library(sp)
library(raster)

# Use spTransform on neighborhoods: neighborhoods
 neighborhoods <- spTransform(neighborhoods, proj4string(nyc_tracts))
```
It's difficult to join data to spatial features, though there are some methods

nice base R functions for checking for duplicates and full matches
```r
# Check for duplicates in nyc_tracts
any(duplicated(nyc_tracts$TRACTCE))

# Check nyc_tracts in nyc_income
all(nyc_tracts$TRACTCE %in% nyc_income$tract)
```

**sp:merge** : function for join data in spatial layers. have parameters to account for different names
```r
library(sp)
# Merge nyc_tracts and nyc_income: nyc_tracts_merge
nyc_tracts_merge <- merge(nyc_tracts, nyc_income, by.x = "TRACTCE", by.y = "tract")
```
more complex map with multple elments
```r
library(tmap)

tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  # Add a water layer, tm_fill() with col = "grey90"
  tm_shape(water)             +
  tm_fill("grey90")              +
  # Add a neighborhood layer, tm_borders()
  tm_shape(neighborhoods)+
  tm_borders()

```
map critque
- data gets the most attention
- useful spatial context: roads to orient not
- clear tible, legend, and labels
- add annotations to highlight aspects

Interesting base R function from replacing characters
```r
# gsub() to replace " " with "\n"
manhat_hoods$name <- gsub("","\n",manhat_hoods$NTAName )
```
Example of a very solid map
```r
library(tmap)

tm_shape(nyc_tracts_merge) +
  # Add title and change palette
  tm_fill(col = "estimate",
          title = "Median Income",
          palette = "Greens") +
  # Add tm_borders()
  tm_borders(col = "grey60", lwd = 0.5) +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  tm_shape(manhat_hoods) +
  # Change col and lwd of neighborhood boundaries
  tm_borders(col = "grey40",lwd = 2 ) +
  tm_text(text = "name", size = 0.5) +
  # Add tm_credits()
  tm_credits("Source: ACS 2014 5-year Estimates, \n accessed via acs package", position = c("right", "bottom"))

# Save map as "nyc_income_map.png"
save_tmap(filename="nyc_income_map.png", width=4,height=7)
```
