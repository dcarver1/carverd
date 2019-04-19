predictors---
layout: post
title:  "Find your ideal habitat"
date:   2019-04-19 10:50:26 -0600
---

# Your Ideal Habitat

I truly believe that as a professional within a given field, if you want to learn something new you have to have a pretty specific reason for doing so. Without a clear objective or question that your trying to reach it is all to easy to get swept away by the continuous flow of new information, new resources, and new content. Learning for learning's sake slowly becomes more and more difficult. I bring this up because as part of my work I help people learn a new resource for engaging with remotely sensed imagery. I’ve come to realize that in order to get folks engaged they need to clearly see the benefit in learning. The post is about building a exercise that should hopefully peak everyone's interest.

We all dream about living elsewhere. Be it from travel experience abroad or vacations in your own country. Yet transforming the place where you vacation into the place you work can be a challenging endeavor and is not always feasible without some drastic changes in your life.
> This understanding made me ask, well even though it is unlikely that I be able to work in southern Chile, is there a place that has a similar character somewhere within the US that might be easier to call home.

So we’re going to try to answer that question using remotely sensed data, spatial modelling methodology, and some logical reasoning to find our ideal habit a bit closer to home.


## Method
This is a walk along lesson using **Google Earth Engine**
Go to the [code editor](https://code.earthengine.google.com/) and copy and paste code as you read through the content. You can test the components yourself.

## How to define the character of a place

Obviously cultural values are an extremely difficult feature to measure quantitatively. Specifically if your going to try to apply a set of parameters consistently across the world. So we're going to focus on the things we can measure.

**Climate**

**Landscape**

**Night Lights**

The big assumption of all this is that places with similar environmental conditions are likely to develop similarities in culture as well. This is not true much of the time but I think we can agree that winter activities in Canada are going to differ from winter activities in Florida. Those activities play a role in defining what it is like to live in a place.

### Environmental Variables
Most ecological modeling uses a comprehensive climatic dataset called [worldclim](http://worldclim.org/version1). We will be doing the same. I found a [USGS Publication](https://pubs.usgs.gov/ds/691/) that gives written interpretation of what the 19 bioclimatic variables of WorldCLim describe ecologically. Some are pretty straight forward but others required a bit more interpretation.

```javascript
//pull in world clim data and define how that would pass a descriptor of what we like about
//climate
/*
BIO1 = Annual Mean Temperature
BIO2 = Mean Diurnal Range (Mean of monthly (max temp - min temp)): general humidity
BIO3 = Isothermality (BIO2/BIO7) (* 100) : diffences in humidity seasonally
BIO4 = Temperature Seasonality (standard deviation *100) : temperature change between seasons
BIO5 = Max Temperature of Warmest Month : Extreme heat
BIO6 = Min Temperature of Coldest Month : Extreme Cold
BIO7 = Temperature Annual Range (BIO5-BIO6) : seasonality
BIO8 = Mean Temperature of Wettest Quarter
BIO9 = Mean Temperature of Driest Quarter
BIO10 = Mean Temperature of Warmest Quarter
BIO11 = Mean Temperature of Coldest Quarter
BIO12 = Annual Precipitation
BIO13 = Precipitation of Wettest Month
BIO14 = Precipitation of Driest Month
BIO15 = Precipitation Seasonality (Coefficient of Variation) : variability in precipitation
BIO16 = Precipitation of Wettest Quarter
BIO17 = Precipitation of Driest Quarter
BIO18 = Precipitation of Warmest Quarter : thunderstorms??
BIO19 = Precipitation of Coldest Quarter : potentially snow???
*/
```

Let's load in the dataset and view it using a print statement

```javascript
var bioClim1 = ee.Image("WORLDCLIM/V1/BIO")
print(bioClim1)
```

**add image of print statement**

Based on my assessment of what climatic conditions are important for who a person enjoys living in a specific place I'm pulling out a subset of the predictors and renaming them so they are easier to work with later. You can change this to match what you think is important.

```javascript
// assign predictors so there are easier to work with and follow
var BIO1 = bioClim.select('bio01').rename("BIO1")
var BIO2 = bioClim.select('bio02').rename("BIO2")
var BIO3 = bioClim.select('bio03').rename("BIO3")
var BIO4 = bioClim.select('bio04').rename("BIO4")
var BIO5 = bioClim.select('bio05').rename("BIO5")
var BIO6 = bioClim.select('bio06').rename("BIO6")
var BIO7 = bioClim.select('bio07').rename("BIO7")
var BIO15 = bioClim.select('bio15').rename("BIO15")
var BIO18 = bioClim.select('bio18').rename("BIO18")
var BIO19 = bioClim.select('bio19').rename("BIO19")

Map.addLayer(BIO1, {}, "mean annual temperature" ,false)

```

#### Topography
I believe that the shape of the land we live on does a lot to define the types of activities that go on there. Also, when I think of cities and towns that have a lot of unique character I think of hilly places like Seattle or Manitou Springs. Outdoor recreation is really closely related to topography and often protected land is where it is because it's difficult to build there. (to steep, to low in elevation)
I found a dataset created by [Conservation Science Partners](https://www.csp-inc.org/) that identifies ecologically relevant landforms. I don't really know if it the best for describing what people like but I figure it's a reasonable place to start.

Let's pull it in and visualize it on the map.

```javascript
var topography1 = ee.Image("CSP/ERGo/1_0/Global/ALOS_mTPI")
print(topography1, 'topography layer')
Map.addLayer(topography1, {bands: ["AVE"],
gamma: 1,
max: 2.76,
min: -2.59,
opacity: 1}, "Topography Features", false)
```
So I don't really know what all the different class are but that's ok. You can go back to the documentation if you really want to. I'm fine leaving it as a unknown because I don't expect people to say "I love this place because it has so many alluvial fans". It's the fact that there are a diversity of landforms that is important.


### Social Variables
The last predictor we are bring in is an attempt to capture the world wide social feature of industrialization. We're doing this through night lights. Areas that are bright at night are typically more industrialized and are more likely to be large urban areas. So this variable so help us understand if people want to live in a city or not.

Again we will call it in and visualize it.

```javascript

//Pull in the night lights dataset and visualize
var nightlights = ee.ImageCollection("NOAA/DMSP-OLS/CALIBRATED_LIGHTS_V4")
  .median()
print(nightlights, 'Night Lights')
Map.addLayer(nightlights,{bands: ["avg_vis"],
gamma: 1,
max: 17.04,
min: -13.80,
opacity: 1}, "night lights", false)
```

With that our potential predictors are set, we can move on to the modeling process.

## Creating our habitat ranges
Were going to create geometry features for our "idealHabitat" and "Background". In this case ideal habitat is where you would like to live, background is the area or country where it is currently easy for you to live.
It's up to you to decide where, I'm going to use the Contiguous 48 of the United States as my background. My idealHabitat in this case is a random spot in Hungary near what seems to be a large lake. Where every you pick be sure to keep you selected area somewhat small. I'd say a 20km square are is about as low as you would want to go. The courses of our predictor variables is 1km so 20km square area gives us a selection of 400 unique locations. This becomes important what defining the number of sampling points to use.


**image of creating a geometry**

With are geometry created and labeled we are going to generate some random points within the features that we will use to extract data from the predictors.

```javascript

// sample data from both locations
// assign a presence/absence value for each
var idealPoints = ee.FeatureCollection.randomPoints({region:idealData, points:500,
seed:123}).map(function(feature) {
  return feature.set('ideal', 1);
});
print(idealPoints, "ideapoints")

var backgroundPoints = ee.FeatureCollection.randomPoints({region:background, points:1000,
seed:123}).map(function(feature) {
  return feature.set('ideal', 0);
});
print(backgroundPoints, "backgroundPoints")

//Merge presence and absence datasets
var samples = idealPoints.merge(backgroundPoints)

```
Print the datasets allows us to view the differences. It also allows you to ensure the structure of the data sets are the same so the merge will work.

### Generating predictors lists

Or next step will be selecting the predictors that we care about.
I'm choosing some features that will tell me what the winter time precipitation will be like
 ** Average temp, cold winter temp, cold month precip, topography, nightlights **
Just comment out the variable you don't want and select the ones you do.

For starters I would keep the total number of predictors to under 5.  It's better to start more generalized then start refining.

```javascript
//create a list of predictors
var predictors = BIO1
//.addBands(BIO2)
//.addBands(BIO3)
//.addBands(BIO4)
//.addBands(BIO5)
//.addBands(BIO5)
.addBands(BIO6)
//.addBands(BIO7)
//.addBands(BIO15)
.addBands(BIO18)
//.addBands(BIO19)
.addBands(nightlights)
.addBands(topography)

```

Where going to generate a quick histogram of our predictors to get a bit of an idea of the range of values that are present.
Again the shape of the curves are more important then the values. It the histograms are really wide, we've selected a diverse predictor are and that will make it hard to refine the model.
This is very much a subjective process so don't stress it too much. This step is really just about building a little more understanding of your data before you push it into a model.

```javascript

// Pre-define some customization options.
var options = {
  title: 'Range of selected predictors',
  fontSize: 20,
  hAxis: {title: 'Value'},
  vAxis: {title: 'number of cells'},
};

// Make the histogram, set the options.
var histogram = ui.Chart.image.histogram(predictors, idealData, 100)
    .setOptions(options);

// Display the histogram.
print(histogram);
```
## modeling process

We're using a randomforest algorithm for the modeling process. This is not ideal because we're not working with presence absence data but presences and pseudo absence. What this means is that the number of background points is going to significantly effect the specificity of the model output. Right not the ratio is
**presence: 500**
**absence: 100**

You can alter these are you start to refine your model. But this is just the first go so let it rip and lets see what happens.

```javascript
//extract values to selected world climate data
var extractedData = predictors.sampleRegions({
  collection: samples,
  properties: ['ideal']
});
print(extractedData,'ideal')

//feed into a classifier
// train our model using random forest
var trainingclassifier = ee.Classifier.randomForest({
                  numberOfTrees: 100,
                  bagFraction: 0.7 ,
                  outOfBagMode: false ,
                  seed:123 }).train({
features: extractedData,
classProperty: 'ideal'});

print(trainingclassifier)
```


## Visualizing the model
The model really becomes valuable to us when we visualize it.
So lets do that.

```javascript
/apply classification
// apply model to imagery using the classifiers
var classified = predictors.classify(trainingclassifier).clip(background);

print(classified, 'classified')

// view modeled result
Map.addLayer(classified, classificationParam, 'classified', true)

```

## Summary

What we did here was the base methodology of a of species distribution model. In this case we were the species, which makes it a bit more fun in my opinion.
There is a lot you can change that will help build your understanding of how each component of the modeling process effects the final output. Try them out if your interested.

1. adjust your "idealHabitat" and "background" areas
2. Change the number of points generated within your two areas
3. adjust the predictors and number of predictors. Starting with one and build is a good process.

All these actions have effects but again you have to have interest in the results to really dive into the details.
So you want to know where your ideal global habitat is in the US, then please continue to test and explore.

Last note:
**You should always rely on ground truthing before trusting your model**
so, I wouldn't suggest packing up and moving based on this model alone.
