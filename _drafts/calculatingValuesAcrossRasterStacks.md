---
layout: post
title:  "Math Across Raster Stacks"
categories: trainings
permalink: "rasterStacks"
---


*The goal of this doc is to generate some tutorials for applied math across the raster stacks.*
*I want to showcase*
1. appears
2. arcmap
3. Arcpy
4. R - raster
5. numpy arrays
6. Google Earth Engine

*Needs, a set of small rasters to include with this tutorial*

# AppEEARS
The Application for Extracting and Exploring Analysis Ready Samples  is an incredible resource for quick interpretation of change over time values.

![AppEEARS]({{"/assests/appearHome.png"|absolute_url}})  


 It is hosted by the LP-DAAC and allows for the selection of an area, so you don't need to download full scenes. I like starting here because this tool promotes the idea of limiting your data acquisition to what you actually need. This is certainly a trend in data analysis in general. Do as much processing on cloud based platforms and only download what you really need.

Using the tool is pretty straightforward but is helps to know what your looking for. For this tutorial we are going to be looking at 16 day NDVI MODIS composites for an agricultural region in the San Luis Valley in Colorado. The output of the tool allows you to download the data or view a summary of the data in you browser.

![Summary]({{"/assests/modisSummary.png"|absolute_url}})  
