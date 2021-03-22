2019 - 02 - 27

Interactive maps with leaflet course in R

Leaflet is a Javalibray that allows you to create html widgets in R.

Two liner for adding a map
```r
# Load the leaflet library
library(leaflet)

# Create a leaflet map with default map tile using addTiles()
leaflet() %>%
    addTiles()
```


Tricks for accessing provider tiles

There is a really cool function in here
str_detect
```r
# Print the providers list included in the leaflet library
providers

# Print only the names of the map tiles in the providers list
names(providers)

# Use str_detect() to determine if the name of each provider tile contains the string "CartoDB"
str_detect(names(providers), "CartoDB")

# Use str_detect() to print only the provider tile names that include the string "CartoDB"
names(providers)[str_detect(names(providers), "CartoDB")]
```

You can add different tiles to the map by calling an add provider function.
```r
# Create a leaflet map that uses the CartoDB.PositronNoLabels provider tile
leaflet() %>%
    addProviderTiles(provider = "CartoDB.PositronNoLabels")
```

You can set view using lat long values and providing a zoom level

```r
leaflet()  %>%
    addProviderTiles("CartoDB")  %>%
    setView(lat = 40.7, lng = -74.0, zoom = 10)
```

There are some really nice options for setting the map extent.

```r
leaflet(options = leafletOptions(
                    # Set minZoom and dragging
                    minZoom = 12, dragging = TRUE))  %>%
  addProviderTiles("CartoDB")  %>%

  # Set default zoom level
  setView(lng = dc_hq$lon[2], lat = dc_hq$lat[2], zoom = 14) %>%

  # Set max bounds of map
  setMaxBounds(lng1 = dc_hq$lon[2] + .05,
               lat1 = dc_hq$lat[2] + .05,
               lng2 = dc_hq$lon[2] - .05,
               lat2 = dc_hq$lat[2] - .05)
```

There are a few different ways to add points to a map. Baiscally you just need to point it to long lat data. You can do this by reference a dataframe or by hardcoding the coordinates

```r
# Plot DataCamp's NYC HQ with zoom of 12    
leaflet() %>%
    addProviderTiles("CartoDB") %>%
    addMarkers(lng = -73.98575, lat = 40.74856)  %>%
    setView(lng = -73.98575, lat = 40.74856, zoom = 12)    
```

You can save maps as objects and alter those objects using piping
pretty slick
```r
# Store leaflet hq map in an object called map
 map <- leaflet() %>%
          addProviderTiles("CartoDB") %>%
          # Use dc_hq to add the hq column as popups
          addMarkers(lng = dc_hq$lon, lat = dc_hq$lat,
                     popup = dc_hq$hq)

# Center the view of map on the Belgium HQ with a zoom of 5
map_zoom <- map %>%
      setView(lat = 50.881363, lng = 4.717863,
              zoom = 5)

# Print map_zoom
map_zoom
```

## Part 2

You can clear map features if you want to rework the content

```r
# Remove markers, reset bounds, and store the updated map in the m object
map_clear <- map %>%
        clearMarkers() %>%
        clearBounds()

# Print the cleared map
map_clear
```

Simple map where we are filtering a df and adding a set a markers base on lat long values

```r
# Create a dataframe called `ca` with data on only colleges in California
ca <- ipeds %>%
        filter(state == "CA")

# Use `addMarkers` to plot all of the colleges in `ca` on the `m` leaflet map
map %>%
    addMarkers(lng = ca$lng, lat = ca$lat)
```

Anyother simple map with some alteration to the set zoom function
```r
# Set the zoom level to 8 and store in the m object
map_zoom =
    map %>%
    addMarkers(data = ca) %>%
     setView(lat = la_coords$lat, lng = la_coords$lon, zoom = 8)

map_zoom
```

Example of adding circles rather then markers to the map and adjusting the color content
```r
# Change the radius of each circle to be 2 pixels and the color to red
map2 %>%
    addCircleMarkers(lng = ca$lng, lat = ca$lat,
                     radius = 2, color = "red")
```

First look at adding popups to the map. It's a super useful tool

```r
# Add circle markers with popups for college names
map %>%
    addCircleMarkers(data = ca, radius = 2, popup = ~name)

# Change circle color to #2cb42c and store map in map_color object
map_color <- map %>%
    addCircleMarkers(data = ca, radius = 2, color = "#2cb42c", popup = ~name)

# Print map_color
map_color
```

Ok this is awesome!
You can alter the popup information using html tags and the paste0 function.
This will be very helpful

```r
# Make the institution name in each popup bold
map2 %>%
    addCircleMarkers(data = ca, radius = 2,
                     popup = ~paste0("<b>", name, "</b>", "<br/>", sector_label))
```

Anyother example of fancy labeling

```r
# Use paste0 to add sector information to the label inside parentheses
map %>%
    addCircleMarkers(data = ca, radius = 2, label = ~paste0(name, " (", sector_label, ")"))
```
  You can create you own color palette using a ColorFactor function

  ```r
  # Make a color palette called pal for the values of `sector_label` using `colorFactor()`  
# Colors should be: "red", "blue", and "#9b4a11" for "Public", "Private", and "For-Profit" colleges, respectively
pal <- colorFactor(palette = c("red", "blue", "#9b4a11"),
                   levels = c("Public", "Private", "For-Profit"))

# Add circle markers that color colleges using pal() and the values of sector_label
map2 <-
    map %>%
        addCircleMarkers(data = ca, radius = 2,
                         color = ~pal(sector_label),
                         label = ~paste0(name, " (", sector_label, ")"))

# Print map2
map2
```

Easy options for adding legends

```r
# Customize the legend
m %>%
    addLegend(pal = pal,
              values = c("Public", "Private", "For-Profit"),
              # opacity of .5, title of Sector, and position of topright
              opacity = 0.5, title = "Sector", position = "topright")
```
