---
layout: post
date:
categories: perspective
---

# Earth Science and Order of Operations

**order and math**
Earth Science is a very broad category of study that spends many degrees of mathematically dependence.In geographic studies, there or geodisites who focus directly on mathematical abstracts of the Earth in 2 dimensional space right next to cartographers who used but often do not need to interperate complex logic. Most professionals fall somewhere in the middle.

AND

**RS in GEE**

In the world of Remote Sensing, clouds are often the limiting factor due to their distinct able to reflect most electromagnetic radiation. There are many tools to help deal with the effect of clouds and one that has been gain lots of popularity is the idea of a median reducer. This is a function that takes a stack of images and for each locations select the median reflectance value of a given cell. The idea is that clouds have a very high reflectance and shadows ( the other troublesome factor of imagery) has a low reflectance. Pick the middle value and you should avoid both clouds and shadows while maintaining a complete and relatively representative image.

But

**what are the actual effects**

So as Remote Sensing Scientists we have a tools and were sometime guilty of applied that tool before we really understand it completely. This is an example that come up recent in my work. We were applying a median reducer to an image stack and calculating NDVI.

*Do the two paths lead to the same point*

#### Method 1
- Generate image stack
- calculate NDVI
- applied Median Reducer

#### Method 2
- Generate image stack
- applied median Reducer
- calculate NDVI

This is juts a small deviation in the order of operations but the it was not very clear what effect it will hove on the outcome. The conflicting hypothesis to test.
1. As long as the image stacks are the same a median reducer will not alter ndvi values

2. The resulting values of ndiv will vary based on
when the median reducer is applied.

This may seem like a small thing but understand the importance of order of operations is essential it generating reproducible work flows in the long term.

Therefore

**test it out**

So after discussing it with various other nerdy people I finally decided to take the incitive and test it out my self. Below is an example of the code used via Google Earth Engine to test this idea.

# outline   
 - write method one as a function
 - write method two as a function
- call in Landsat 8 image collection filtered by region and time
- apply functions  
- difference the ndvi images
- plot the variance across the images as a histogram.  

```javascript
method1 = fucntion(imageCollection){
  out1 = imageCollection.normalizedDifference(Band5, Band4).median()
  return out1
}

method2 = function(imageCollection){
  out2 = imageCollection.median().normalizedDifference(Band5 , Band4)
  return out2
}

ls8 = ee.imageCollection(LandSat8)
.filterBounds(geomentry)
.filterDate("2017-04-01", "2017-09-01")

ndvi1 = method1(ls8)
ndvi2 = method2(ls8)

rangeRaster = range(ndiv1,ndiv2)

map.AddLayer(rangeRaster)
histogram(rangeRaster)

discRaster = function(image){
  min = raster.min()
  max = raster.max()
  avg = raster.average()
  stdev = raster.standDevation()
  output = [min,max,avg,stdev]
  return output
}

desc1 = discRaster(ndvi1)
print(desc1)
desc2 = discRaster(ndvi2)
print(desc2)


```

### conclude
- are they different
- conduct the same proces with a median reducer
- which one is more representative of the acutal changes on the landscape?
