---
layout: post
title: "A Signal and the Noise"
permalink: "signalAndNoise"
categories: trainings
---

# How to Find a What's There

Much of science can be described as an attempt to measure. In the case of my current work were attempting to predict the suitable habitat of a given species. Predictions in this case can be viewed as measuring the likelihood of something. This process is called species distribution modeling, habitation distribution modeling, ecological niche modeling and probably something else as well. We use the term species distribution modelling because the folks we work with are interested in the species. Science is so focus on the measurement that it can sometimes slip our minds that the process were attempting to measure already exists. It's real and is unaffected by our ability to find it. All species have a suitable habitat range. So for us, it's not about searching for the unknown, it's about finding what's already there.  

![Large background area](/assests/worldLundelliana.png)

## Species Distribution Models
Species distribution models(SDM) are used to find suitable habitat ranges for a given species based on known bioclimatic conditions at presence locations and an inferred understanding of the potential bioclimatic condition found across the landscape. The complexity of the process has grown greatly but the core concept remains the same. Based on what we know about the species, identify areas on the landscape that are similar because they can potential contain the species as well. This is a simple question that is not an easy one to answer. Due in part to the dependency of these models on the input datasets of bioclimatic layers and species presence locations. To this, the increased complexity of the SDM processes has resulted in more options and flexibility of model parameters. While these changes are good, validation of the effects of these changes can be a real challenge. The models are prediction across a large spatial scale. The purpose of this write up is examine the effect of one aspect of the species distribution modeling framework, the area in which background points are generated. Background points effect the evaluation statistics, the run time of the model, and most importantly the ecological reality of the model. These effects will be introduced through the signal to noise framework that is common in detection models with instrumentation.

![Medium background area]({{"/assests/biomeLundelliana.png"|absolute_url}})
> A map showing a species distribution model where a large background area was used.

## Signal to Noise
The signal to noise ratio is a metric that is part of many industries. My interest in it comes from my wife's experience with analytical chemistry. The single to noise ration was a metric they used to understand the likelihood that a signal was actually representative of a specific response, not just an artifact of the noise it is a part of. In her work they we're attempting to determine the amount of dextrose, a sugar molecule, within a known mass of biomass like grass or corn stover. The signal for these dextrose molecules was defined by commercially produced standards. So the analyst knew exactly what to look for. The noise is defined by the values emitted by all other molecules present in the sample. Simply biomass such as grass blades are is complex at the molecule level. If there was amply dextrose within the sample, the signal clearly stood out from the noise. Yet as the amount of the molecule is reduced, there comes a level when it is not reasonable to assume the signal is not just a feature of the background noise. In her work there were no options to reduce the noise because it was an inherent part of the plant matter, just like the dextrose. Therefore the signal to noise ratio was used to set the minimal detectable amount within a given sample.

Conceptually, this logic applies well to presence only SDM. The signal in this case is the bioclimatic values that are found at the various presence points. The noise is defined by the bioclimatic values derived by the generation of the background points. Unlike the analytical chemists of the world we have the option to alter both the signal and the noise of our models.

### Signal == Presence Locations
### Noise  == Background

By thinning or spatially sampling the presence points we can alter the range of the signal. Changing this will effect the signals character but the core assumption is that the variability of those signal will fall within an expected range, plants really do have a suitable habitat. Even through these suitable habitat exists, will never have industrially define standards when working at the landscape scale. The best we can hope for is that given proper data we can confidently say we have a representative signal of suitable habitat. Due to this and the fact that quality presence points are generally a limiting factor within a SDM study, our ability to improve model performance through the alteration of the presence signal quickly comes against the concept of diminishing returns.

Knowing the alteration of presence points only allows us to define a signal as precisely as the environmental variability of a given species, we have to look at altering the noise to improve our models potential. Altering the noise can be done in two ways, increasing the number of background points or by limiting the spatial extent from which the background points are generated.

Increasing the number of background points provides a more complete representation of the environmental variability within the landscape. Doing so effectively increases the volume on all the noise. This means that regions that fall with the outside edges of the signal are more likely to be lost to the noise. The challenge within this method is that increasing the number of background points increase the computational time of the models. While unrealistic in most areas, there is still a cap to how many background points can be generated. In general increasing the number of background points goes against a modeling creed of the principle of parsimony.
>  given a set of possible explanations, the simplest explanation is the most likely to be correct.

While increasing the number of background points may improve model performance, it is difficult to connect that action to the ecological logic because species are not directly effected by environments that they do not inhabit. It may make our models numerically more correct but what we really want is a simple and ecologically relevant models not complex and mathematically significant ones.

![Small background area]({{"/assests/ecoLundelliana.png"|absolute_url}})
> A map showing a species distribution model where a small sized background area was used.


# It's in the Noise

Altering the area in which background data is collected seems to both simplify and connection our models to ecological constraints. For example, if we want to predict the location of a montane tree species that has never been found below 2000 feet above sea level, why would one incorporate background points that are outside of that limit. Elevation appears to be an ecological not a theoretical limit. If we sample background from areas below this limit, we are effectively reducing the volume of the noise by spreading it across ecologically insignificant ranges. Yet the mathematically implications of this action will mean that our signal will stand out more within our model because the overall noise has been reduced. Put another way, it is easier to pick out specific apple that is surround by a wide variety of fruit then one surrounded by other varieties of apples. The signal is the same, but the background is more generic.

The trouble becomes how can we justify the method of reducing the background area when the metrics for model performance are going to weight the more generic models.

**Limiting the area in which the background points are generated will effectively increase the volume of noise making the detection of the signal more difficult and more refined**

I think this can be done by evaluating the signal to noise ratio of the models as a unified metric of the difficulty of the modelling task.
Assumptions
- The signal will remain the same regardless of the area from which the background points are generated.

- A signal to noise ratio can be used as a comparison across models because it only measure variability within the background.

- Limits on the area in which a model should be ran can be defined by ecologically significant parameters.

- Signal to noise ration can also be used to define an over simplification of the model, by applying a limit to the size of the area in which the background points are generated when the signal can not be reasonable distinguished from the noise.

- the signal to noise ration can be represented by the relationship between the range in bioclimatic values of the signal (presence locations) and the range in bioclimatic values of the background points.

**Method**
- identify top model predictor

- define range of values with the signal ( presence points )

- define range of values with the noise ( background points )

- calculate signal to noise ration  (signal range / noise range)



We are currently in the method of testing this process to try to understand a few specific processes.

**Questions**
How does comparison between models influence interpretation of model results?
How can you define the signal to noise ratio is to small?

While all these methods are interesting in their own right the real goal is how can we provide the most ecological relevant models of the species we are interested in.
