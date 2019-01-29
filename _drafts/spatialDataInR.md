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

# vector and raster spatial data in R

st_write and rsater_right both allow to write out data

reading in vector data is very stright foward with the sf packages
```r
# Load the sf package
library("sf")

# Read in the trees shapefile
trees <- st_read("trees.shp")
```
raster package is used for loading in raster data
**raster()**: brings in single images
**brick()**: brings in stacked images

 ```r
 # Load the raster package
library("raster")

# Read in the tree canopy single-band raster
canopy <- raster("canopy.tif")

# Read in the manhattan Landsat image multi-band raster
manhattan <- brick("manhattan.tif")

# Get the class for the new objects
class(canopy)
class(manhattan)

# Identify how many layers each object has
nlayers(canopy)
nlayers(manhattan)
```
sf objects are stored as dataframes
geometrys are stored as list column
list columns allow for the storage of multiple varables within is list in one positon on the DataFrame

once you read in a st object you can allow dpylr manipulations to it
```r
# Load the dplyr and sf packages
library("dplyr")
library("sf")

# Read in the trees shapefile
trees <- st_read("trees.shp")

# Use filter() to limit to honey locust trees
honeylocust <- trees %>% filter(species == "honeylocust")
```

There are a lot of tools for getting data out of sf objects. The important thing to remember in that the values taken from the data will have units based on the projection. the unclass function helps to make comparisons
```r
# Read in the parks shapefile
parks <- st_read("parks.shp")

# Compute the areas of the parks
areas <- st_area(parks)

# Create a quick histogram of the areas using hist
hist(areas, xlim = c(0, 200000), breaks = 1000)

# Filter to parks greater than 30000 (square meters)
big_parks <- parks %>% filter(unclass(areas) > 30000)

# Plot just the geometry of big_parks
plot(st_geometry(big_parks))
```

the plot function is the basic method for viewing data. because of the complexity of spatial objects using thing often result in more data then what is really wanted.
Below are methods for reducing what is shown

```r
# Plot the parks object using all defaults
plot(parks)

# Plot just the acres attribute of the parks data
plot(parks['acres'])

# Create a new object of just the parks geometry
parks_geo <- st_geometry(parks)

# Plot the geometry of the parks data
plot(parks_geo)
```
the raster package does not read in all the components of the data
**file.size** defines the size of the raster layer
**object.size** defines the memory used by the raster layer
**inMemory** will define if the raster in memory and will return TRUE FALSE
**getValues()** returns all values in a vector for single band or a matrix for multiple band rasters

useful functions for defining aspects of the raster
```r
# Load the raster package
library("raster")

# Read in the rasters
canopy <- raster("canopy.tif")
manhattan <- brick("manhattan.tif")

# Get the extent of the canopy object
extent(canopy)

# Get the CRS of the manhattan object
crs(manhattan)

# Determine the number of grid cells in both raster objects
ncell(manhattan)

# Check if the data is in memory
inMemory(canopy)

# Use head() to peak at the first few records
head(canopy)

# Use getValues() to read the values into a vector
vals <- getValues(canopy)

# Use hist() to create a histogram of the values
hist(vals)

```
The vals to hist is pretty nice. Quick look at the distribution

Plot works well for simple displays of data, particularly single images
There is a built in RGB function for the displying a true color. Not sure how it is identifying those

```r
# Plot the canopy raster (single raster)
plot(canopy)

# Plot the manhattan raster (as a single image for each layer)
plot(manhattan)

# Plot the manhattan raster as an image
plotRGB(manhattan)
```

## 19/1/1
Working with projections


Rasters and SF packages have option for creating transformation.

```r
# Determine the CRS for the neighborhoods and trees vector objects
st_crs(neighborhoods)
st_crs(trees)

# Assign the CRS to trees
crs_1 <- "+proj=longlat +ellps=WGS84 +no_defs"
st_crs(trees) <- crs_1

# Determine the CRS for the canopy and manhattan rasters
crs(canopy)
crs(manhattan)

# Assign the CRS to manhattan
crs_2 <- "+proj=utm +zone=18 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
crs(manhattan) <- crs_2
```
Projecting rasters
using the transforamtion to change projections
```r
# Get the CRS from the canopy object
the_crs <- crs(canopy, asText = TRUE)

# Project trees to match the CRS of canopy
trees_crs <- st_transform(trees, crs = the_crs)

# Project neighborhoods to match the CRS of canopy
neighborhoods_crs <- st_transform(neighborhoods, crs = the_crs)

# Project manhattan to match the CRS of canopy
manhattan_crs <- projectRaster(manhattan, crs = the_crs, method = "ngb")

# Look at the CRS to see if they match
st_crs(trees_crs)
st_crs(neighborhoods_crs)
crs(manhattan_crs)
```

Ploting multiple features : use add =TRUE and run both lines at the same time

You need to use the right library for vector(st) and raster(raster)
```r
# Plot canopy and neighborhoods (run both lines together)
# Do you see the neighborhoods?
plot(canopy)
plot(neighborhoods, add = TRUE)

# See if canopy and neighborhoods share a CRS
st_crs(neighborhoods)
crs(canopy)

# Save the CRS of the canopy layer
the_crs <- crs(canopy, asText = TRUE)

# Transform the neighborhoods CRS to match canopy
neighborhoods_crs <- st_transform(neighborhoods, crs = the_crs)

# Re-run plotting code (run both lines together)
# Do the neighborhoods show up now?
plot(canopy)
plot(neighborhoods_crs, add = TRUE)

# Simply run the tmap code
tm_shape(canopy) +
    tm_rgb() +
    tm_shape(neighborhoods_crs) +
    tm_polygons(alpha = 0.5)

```
SF and DPLYR


sf store data as a dataframe within the spatial object.
You cvan use dplyr function on spatial objects

sf allows you to remove geometry from features if only the spatial data is needed.

```r
# Create a data frame of counts by species
species_counts <- count(trees, species)

# Arrange in descending order
species_counts_desc <- arrange(species_counts, desc(n))

# Use head to see if the geometry column is in the data frame
head(species_counts_desc)

# Drop the geometry column
species_no_geometry <- st_set_geometry(species_counts_desc, NULL)

# Confirm the geometry column has been dropped
head(species_no_geometry)
```

Important example !!!

Joining spatial data with dplyr

inner join with various column names

```r
# Limit to the fields boro_name, county_fip and boro_code
boro <- select(neighborhoods, boro_name, county_fip, boro_code)

# Drop the geometry column
boro_no_geometry <- st_set_geometry(boro, NULL)

# Limit to distinct records
boro_distinct <- distinct(boro_no_geometry)

# Join the county detail into the trees object
trees_with_county <- inner_join(trees, boro_distinct, by = c("boroname" = "boro_name"))

# Confirm the new fields county_fip and boro_code exist
head(trees_with_county)
```

Simplifying geometrys

measuring points with plyr : object_size

```r
# Plot the neighborhoods geometry
plot(st_geometry(neighborhoods), col = "grey")

# Measure the size of the neighborhoods object
object_size(neighborhoods)

# Compute the number of vertices in the neighborhoods object
pts_neighborhoods <- st_cast(neighborhoods$geometry, "MULTIPOINT")
cnt_neighborhoods <- sapply(pts_neighborhoods, length)
sum(cnt_neighborhoods)

# Simplify the neighborhoods object
neighborhoods_simple <- st_simplify(neighborhoods,
                                    preserveTopology = TRUE,
                                    dTolerance = 100)

# Measure the size of the neighborhoods_simple object
object_size(neighborhoods_simple)

# Compute the number of vertices in the neighborhoods_simple object
pts_neighborhoods_simple <- st_cast(neighborhoods_simple$geometry, "MULTIPOINT")
cnt_neighborhoods_simple <- sapply(pts_neighborhoods_simple, length)
sum(cnt_neighborhoods_simple)

# Plot the neighborhoods_simple object geometry
plot(st_geometry(neighborhoods_simple), col = "grey")
```

sp is the earlier sptail data package
sf is replacing it
this is how you convert between the two

```r
# Read in the trees data
trees <- st_read("trees.shp")

# Convert to Spatial class
trees_sp <- as(trees, Class = "Spatial")

# Confirm conversion, should be "SpatialPointsDataFrame"
class(trees_sp)

# Convert back to sf
trees_sf <- st_as_sf(trees_sp)

# Confirm conversion
class(trees_sf)
```

writing out data as csvs

```r
# Read in the CSV
trees <- read.csv("trees.csv")

# Convert the data frame to an sf object
trees_sf <- st_as_sf(trees, coords = c("longitude","latitude"), crs = 4326)

# Plot the geometry of the points
plot(st_geometry(trees_sf))

# Write the file out with coordinates
st_write(trees_sf, "new_trees.csv",  layer_options = "GEOMETRY=AS_XY", delete_dsn = TRUE)

# Read in the file you just created and check coordinates
new_trees <- read.csv("new_trees.csv")
head(new_trees)
```

raster data

downsampling with aggergate

res() finding the resolution of the raster

```r
# Read in the canopy layer
canopy <- raster("canopy.tif")

# Plot the canopy raster
plot(canopy)

# Determine the raster resolution
res(canopy)

# Determine the number of cells
ncell(canopy)

# Aggregate the raster
canopy_small <- aggregate(canopy, fact = 10)

# Plot the new canopy layer
plot(canopy_small)

# Determine the new raster resolution
res(canopy_small)

# Determine the number of cells in the new raster
ncell(canopy_small)
```

reclassify,
dont quite fully grasp this yet

basically define the reclassifcation aspect later

```r
# Plot the canopy layer to see the values above 100
plot(canopy)

# Set up the matrix
vals <- cbind(100, 300, NA)

# Reclassify
canopy_reclass <- reclassify(canopy, rcl = vals)

# Plot again and confirm that the legend stops at 100
plot(canopy_reclass)
```


### 19/1/2
creating spatil object
projecting
transformation
buffer
plot mutile features

```r
# Review df
df

# Convert the data frame to an sf object             
df_sf <- st_as_sf(df, coords = c("longitude", "latitude"), crs = 4326)

# Transform the points to match the manhattan CRS
df_crs <- st_transform(df_sf, crs = crs(manhattan, asText = TRUE))

# Buffer the points
df_buf <- st_buffer(df_crs, dist = 1000)

# Plot the manhattan image (it is multi-band)
plotRGB(manhattan)
plot(st_geometry(df_buf), col = "firebrick", add = TRUE)
plot(st_geometry(df_crs), pch = 16, add = TRUE)
```

transform
find centroid
map two features

```r
# Read in the neighborhods shapefile
neighborhoods <- st_read("neighborhoods.shp")

# Project neighborhoods to match manhattan
neighborhoods_tf <- st_transform(neighborhoods, crs = 32618)

# Compute the neighborhood centroids
centroids <- st_centroid(neighborhoods_tf)

# Plot the neighborhood geometry
plot(st_geometry(neighborhoods_tf), col = "grey", border = "white")
plot(centroids, pch = 16, col = "firebrick", add = TRUE)
```


Bounding box
Bounding coodinates


```r
# Plot the neighborhoods and beech trees
plot(st_geometry(neighborhoods), col = "grey", border = "white")
plot(beech, add = TRUE, pch = 16, col = "forestgreen")

# Compute the coordinates of the bounding box
st_bbox(beech)

# Create a bounding box polygon
beech_box <- st_make_grid(beech, n = 1)

# Plot the neighborhoods, add the beech trees and add the new box
plot(st_geometry(neighborhoods), col = "grey", border = "white")
plot(beech, add = TRUE, pch = 16, col = "forestgreen")
plot(beech_box, add = TRUE)
```
Buffer points
st_union : effectively a desolve. They must be a mutli feature object to work

```r
# Buffer the beech trees by 3000
beech_buffer <- st_buffer(beech, 3000)

# Limit the object to just geometry
beech_buffers <- st_geometry(beech_buffer)

# Compute the number of features in beech_buffer
length(beech_buffers)

# Plot the tree buffers
plot(beech_buffers)

# Dissolve the buffers
beech_buf_union <- st_union(beech_buffers)

# Compute the number of features in beech_buf_union
length(beech_buf_union)

# Plot the dissolved buffers
plot(beech_buf_union)
```

convex hull
needs to a single object to work
use st_union to achomplish this.

```r
# Look at the data frame to see the type of geometry
head(beech)

# Convert the points to a single multi-point
beech1 <- st_union(beech)

# Look at the data frame to see the type of geometry
head(beech1)

# Confirm that we went from 17 features to 1 feature
length(beech)
length(beech1)

# Compute the tight bounding box
beech_hull <- st_convex_hull(beech1)

# Plot the points together with the hull
plot(beech_hull, col = "red")
plot(beech1, add = TRUE)
```

create an SF object from a dataframe
apply a spatial join
st_join

```r
# Plot the beech on top of the neighborhoods
plot(st_geometry(neighborhoods))
plot(beech, add = TRUE, pch = 16, col = "red")

# Determine whether beech has class data.frame
class(beech)

# Convert the beech geometry to a sf data frame
beech_df <- st_sf(beech)

# Confirm that beech now has the data.frame class
class(beech_df)

# Join the beech trees with the neighborhoods
beech_neigh <- st_join(beech_df, neighborhoods)

# Confirm that beech_neigh has the neighborhood information
head(beech_neigh)
```
More spatial joins

st_intersect : within or cross boundaries
st_contains: found within the object
st_intersection: essentailly a clip function

Shoulduse these to replace existing SP fuctions in AICHI

```r
# Identify neighborhoods that intersect with the buffer
neighborhoods_int <- st_intersects(buf, neighborhoods)

# Identify neighborhoods contained by the buffer
neighborhoods_cont <- st_contains(buf, neighborhoods)

# Get the indexes of which neighborhoods intersect
# and are contained by the buffer
int <- neighborhoods_int[[1]]
cont <- neighborhoods_cont[[1]]

# Get the names of the names of neighborhoods in buffer
neighborhoods$ntaname[int]

# Clip the neighborhood layer by the buffer (ignore the warning)
neighborhoods_clip <- st_intersection(buf, neighborhoods)

# Plot the geometry of the clipped neighborhoods
plot(st_geometry(neighborhoods_clip), col = "red")
plot(neighborhoods[cont,], add = TRUE, col = "yellow")
```

calculate distance from a point
determine the nearest point
indexing the features

which.min() : this a cool feature fro finding the minimun in a list.

```r

# Read in the parks object
parks <- st_read("parks.shp")

# Test whether the CRS match
st_crs(empire_state) == st_crs(parks)

# Project parks to match empire state
parks_es <- st_transform(parks, crs = st_crs(empire_state))

# Compute the distance between empire_state and parks_es
d <- st_distance(empire_state, parks_es)

# Take a quick look at the result
head(d)

# Find the index of the nearest park
nearest <- which.min(d)

# Identify the park that is nearest
parks_es[nearest, ]
```

raster overlay tools
raster library only works with the sp objects
use
as(object, "spatial")

lots of functions
calculate area
unclass(): remove the class of the object
filtering based on area
masking by a sp object

```r

# Project parks to match canopy
parks_cp <- st_transform(parks, crs = crs(canopy, asText = TRUE))

# Compute the area of the parks
areas <- st_area(parks_cp)

# Filter to parks with areas > 30000
parks_big <- filter(parks_cp, unclass(areas) > 30000)

# Plot the canopy raster
plot(canopy)

# Plot the geometry of parks_big
plot(st_geometry(parks_big))

# Convert parks to a Spatial object
parks_sp <- as(parks_big, "Spatial")

# Mask the canopy layer with parks_sp and save as canopy_mask
canopy_mask <- mask(canopy, mask = parks_sp)

# Plot canopy_mask -- this is a raster!
plot(canopy_mask
```
crop function
crop remove all values outside of the bounding box area

```r
# Convert the parks_big to a Spatial object
parks_sp <- as(parks_big, "Spatial")

# Mask the canopy with the large parks
canopy_mask <- mask(canopy, mask = parks_sp)

# Plot the mask
plot(canopy_mask)

# Crop canopy with parks_sp
canopy_crop <- crop(canopy, parks_sp)

# Plot the cropped version and compare
plot(canopy_crop)
```
extract values from rasters
points will be extracted as single values
polygons: all values or a function can be passed as a reducer

```r
# Project the landmarks to match canopy
landmarks_cp <- st_transform(landmarks, crs = crs(canopy, asText = TRUE))

# Convert the landmarks to a Spatial object
landmarks_sp <- as(landmarks_cp, "Spatial")

# Extract the canopy values at the landmarks
landmarks_ex <- extract(canopy, landmarks_sp)

# Look at the landmarks and extraction results
landmarks_cp
landmarks_ex
```

overlay: mechinism for conductiong raster math.
You can pass a function so you can generate conditional statemnest

```r
# Read in the canopy and impervious layer
canopy <- raster("canopy.tif")
impervious <- raster("impervious.tif")

# Function f with 2 arguments and the raster math code
f <- function(rast1, rast2) {
  rast1 < 20 & rast2 > 80
}

# Do the overlay using f as fun
canopy_imperv_overlay <- overlay(canopy, impervious, fun = f)

# Plot the result (low tree canopy and high impervious areas)
plot(canopy_imperv_overlay)
```
