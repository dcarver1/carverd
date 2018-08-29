---
layout: post
title: "Median Reducer and Order of Operations"
permalink: "MedianReducer"
categories: trainings
---

# Earth Science and Order of Operations


Earth Science is a very broad category of study that spans many degrees of mathematically dependence. In geographic studies, there or geodesist who focus directly on mathematical description of the Earth in 2 dimensional space right next to cartographers who used but often do not need to interpreter complex mathematical logic. Most professionals fall somewhere in the middle. The truth of the matter is that like it or not you will need to engage with mathematical logic as a professional is the field of Earth Science. I've recently had that experience and learned quite a bit from the process.

In the world of Remote Sensing, clouds are often the limiting factor due to their distinct ability to reflect most electromagnetic radiation. There are many tools to help deal with the effect of clouds and one that has been gaining lots of popularity is the idea of a median reducer. This is a function that takes a stack of images and for location selects and the median reflectance value of a given pixel. The idea is that clouds have a very high reflectance and shadows ( the other troublesome factor of imagery) have a low reflectance. Pick the middle value and you should avoid both clouds and shadows while maintaining a complete and relatively representative image. This method work well if your interest in generating an image that is representative of a time period of 2 or 3 months where the landscape can be assumed to be similar. For example riparian ecosystems in Colorado from June to August will be green and growing.  


I'll be the first to admit that I'm guilty of using tools before I really understand it completely. My experience with using median reducers is a perfect example. We knew we were making assumptions in applying the method and now I've gone back to test those assumptions to learn from them moving forward.

**Do the two paths lead to the same point**

Like most end goals, there is more then one way to get to the desired outcome. We will examine two methods below where using to apply a median reducer to an image stack and calculating NDVI.

#### Method 1
- Generate image stack
- applied median Reducer
- calculate NDVI

#### Method 2
- Generate image stack
- calculate NDVI
- applied Median Reducer

This is just a small deviation in the order of operations but the it was not very clear what effect it would have on the outcome. The hypothesis to test is.

*hypothesis*

1. As long as the image stacks are the same a median reducer will not alter ndvi values

*null hypothesis*
2. The resulting values of ndvi will vary based on when the median reducer is applied.

This may seem like a small thing but understand the importance of order of operations is essential in generating reproducible work flows in the long term.

### Test it out
Below is an example of the code used via Google Earth Engine to test this idea.If you want to follow allow simple copy and paste the code into Earth Engine on your own machine.
You can also view the finished code at this [link](https://code.earthengine.google.com/f0c3fade0af6eb7dcafb639322a6d2d2)

```javascript
/*
This goal of this script is to test the effect of order of opperations on the end result of
a image. In this case we're looking the the follow
1. ImageCollection - median Reducer on reflectance values - calculate NDVI
2. ImageCollection - Calculate NDVI - median reducer on NDVI values

GEE really forces the use of the first method because reducers can only be applied to
image collections and normalizaed differences can only be applied to
*/

// Define varibles needed
// image Collection, point location, area
var LS8Collection = ee.ImageCollection('LANDSAT/LC08/C01/T1_SR')
var pointGeom = ee.Geometry.Point([-95.83720703124999,41.285813161594454])
var areaGeom = ee.Geometry.Polygon([[-96.05602209211661,42.03328289352704],
  [-96.06588537336661,41.035485461252175],
  [-95.53141271711661,41.06819214744852],
  [-95.53702795149161,41.03807181816901],
  [-95.56188146711661,42.011148453731104],
  [-96.05602209211661,42.03328289352704]])

// add geometries to the map to visualize location
Map.addLayer(pointGeom)
Map.addLayer(areaGeom)

```
Now that we have our first three components we can start filtering down our data. In this case were going to look at ndvi across the growing season months around Omaha Nebraska.

```Javascript
// filter imagery
var ls8 = LS8Collection
  .filterDate("2017-04-05","2017-10-04")
  .filterBounds(pointGeom)
// print to see how many features are included
print(ls8, "landsat collection")
```
From our print statement we can see that we have 10 images from a single path row.
<br>
<br>
![Print Statement]({{"/assests/geePrint1.png"|absolute_url}})
<br>
<br>
### Method 1: reduce then normalized difference
This is a straightforward process of function chaining

```javascript
//Method 1: reduce then normalizedDifference
var ndvi1 = ls8.median().normalizedDifference(["B5" , "B4"])
Map.addLayer(ndvi1, {}, "ndvi1")
```
We end up with a reasonable looking image where dense urban areas and water are dark and riparian vegetation is bright.
This image shows the area around Omaha Nebraska. To the west of the river on the north is the airport on the south end is a protected deciduous forest.
<br>
<br>
![Omaha NDVI 1]({{"/assests/omaha1.PNG"|absolute_url}})
![Print Statement]({{"/assests/geePrint1.png"|absolute_url}})
<br>
<br>
### Method 2: reduce then normalized difference
In GEE you can only reduce an image collection. So we need to first convert our images to NDVI then reduce. We do this by mapping a function over the image stack.

 ```Javascript
 // A function to compute NDVI for Landsat 8.
var NDVI8 = function(image) {
  return ee.Image(image).normalizedDifference(["B5","B4"]).rename("NDVI");
};
// map the function across the image collection then reduce
var ndvi2 = ls8.map(NDVI8).median()
Map.addLayer(ndvi2,{} ,"ndvi2")
```
Just looking at the images it's a little difficult to tell exactly what is different. It does appear that some of the fields to the east of the river are a bit darker.
<br>
<br>
![Omaha NDVI 2]({{"/assests/omaha2.PNG"|absolute_url}})
<br>
<br>
To get a better feeling for where the differences are lets just take the difference between the images and display that on the map.
```Javascript
var rangeVis = {
  bands: ["nd"]
  gamma: 0.35
  max: 0.3027380806715235
  min: -0.12764804644249095
  opacity: .75
}
// produce a difference raster for visualization purposes
var rangeRaster = ndvi1.subtract(ndvi2)
Map.addLayer(rangeRaster, rangeVis, "range")
```
To see the differences we applied a stretch and lower the gamma. This highlights areas where the greatest difference is present. By the looks of it the differences are most prevalent in agricultural areas. Because this image is highly altered to show these difference it not really appropriate to use this as a quantitative measure of the difference. It does suggest that the order of operations is making a difference and just what that difference is should be accessed.
<br>
<br>
![Omaha NDVI Difference]({{"/assests/omaha3.PNG"|absolute_url}})
<br>
<br>
I really wanted a summary statistics like function in GEE but I want not able to find one that really matched what I needed so I just wrote one up. It's a bit clunky but it'll do the trick. This function will tell use the min, max, mean, and standard deviation of an area. We can use this to better understand just how different these regions are.
```javascript
// Big ugly summary statistics function...
var descRaster = function(image, area){
  var min = image.reduceRegion(
    {
      reducer: ee.Reducer.min(),
      geometry: area,
      scale: 30,
      maxPixels: 1e9
    })
  var max = image.reduceRegion(
    {
      reducer: ee.Reducer.max(),
      geometry: area,
      scale: 30,
      maxPixels: 1e9
    })
  var avg = image.reduceRegion(
    {
      reducer: ee.Reducer.mean(),
      geometry: area,
      scale: 30,
      maxPixels: 1e9
    })
  var stdev = image.reduceRegion(
    {
      reducer: ee.Reducer.stdDev(),
      geometry: area,
      scale: 30,
      maxPixels: 1e9
    })
  var output = {min: min,max: max, avg: avg,stddev: stdev}
  return output
}

// apply function and print results
var sum1 = descRaster(ndvi1,areaGeom)
print(sum1, "NDVI1 Summery")
var sum2 = descRaster(ndvi2, areaGeom)
print(sum2, "NDVI2 Summary")
```
The output is interesting.
The min and max values are similar for both images, yet the mean and stddev vary slightly between the two images. The first method where the images were reduce first produce a tighter distribution with less variance.
<br>
<br>
![Omaha NDVI Difference]({{"/assests/omahaSummary.PNG"|absolute_url}})
<br>
<br>
Again this is still a bit of a puzzler to me so the final step to take is to produce histograms of the NDVI value for both methods to see what the change in distribution is. This involves defining some visualization parameters and building the histogram.

```Javascript
//CREATE a histogram of values from clipped regions
// Pre-define some customization options.
var options1 = {
  title: 'distribution of NDVI1 values',
  fontSize: 20,
  hAxis: {title: 'ndvi value '},
  vAxis: {title: 'count of value'},
  series: {
    0: {color: 'blue'}}
};
var options2 = {
  title: 'distribution of NDVI2 values',
  fontSize: 20,
  hAxis: {title: 'ndvi value '},
  vAxis: {title: 'count of value'},
  series: {
    0: {color: 'green'}}
};

// Make the histogram, set the options.
var histoNDVI1 = ui.Chart.image.histogram(ndvi1, area, 30)
    .setSeriesNames(['ndvi1'])
    .setOptions(options1);

print(histoNDVI1)

// Make the histogram, set the options.
var histoNDVI2 = ui.Chart.image.histogram(ndvi2, area, 30)
    .setSeriesNames(['ndvi2'])
    .setOptions(options2);

print(histoNDVI2)
```

This really tells the tale.
<br>
<br>
![Omaha Histograms]({{"/assests/omahaHisto.PNG"|absolute_url}})
<br>
<br>
The distributions of values is very different. The first method produced a more normal histogram relative to the second method.

### The walk away
Ok, so this little foray into the order of operations told us a lot. The most import thing being that when the reducer is applied makes a big difference in what data comes out. While that is great to know it opens up another important question, which one is more representative of the actually characteristics of the landscape. Because while this essentially is about a mathematical concept, at the end of the day it's the application that matters. Through some discussion with other Remote Sensing Scientist (big thanks to Steven Filippelli @ CSU) method two is easier to defend. Here's why.  
#### method 1
> ImageCollection - median Reducer on reflectance values - calculate NDVI

#### method 2
> ImageCollection - Calculate NDVI - median reducer on NDVI values

Because method two calculates NDVI on the individuals images all the values that are generated by the reducer represent an actually measurement of NDVI at one point in time. So it's a real measurement.
Method one on the other hand generates a reduced image bases on reflectance values and then applies NDVI. This means that an NDVI could be calculated based on a red reflectance from June and a Near Inferred reflectance from July. This is not a value that was actually measure by a sensor at any point. The likelihood of that happening increase as you increase the data range of your analysis.

So if your applied the median reducer just as a method to limit the effect of clouds and shadows it's best to go with method 2 and maintain the understanding that all values presented were measured.

Still I feel some draw to method one based on the characteristic of it's histogram. It's a more normal distribution, and yes there is some serious abstraction going on but something makes me think there may be some truth hidden in that abstraction. Something else to look into down the line.
