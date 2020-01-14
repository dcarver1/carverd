---
layout: post
title: "A Signal and the Noise"
permalink: "signalAndNoise"
categories: trainings
---

---
# How to Find What's There

Attempting to measure is an essential part of the scientific process. In the case of my current work, we're predicting the suitable habitat of a given species. This process is called species distribution modeling, habitation distribution modeling, ecological niche modeling , and probably something else as well. We use the term species distribution modelling because the folks we work with are interested in the species. The process is all about measuring the likelihood of finding a species at a given location on the planet.

Yet if you focus so much on the process of measurement, the reality that the process we are attempting to measure already exists can slip one's mind. Our species are real and unaffected by our ability to find it. All species have a suitable habitat range. So for us, it's not about searching for the unknown, it's about finding what's already there.  

![Large background area](/assests/worldLundelliana.png)

## Species Distribution Models
Species distribution models(SDM) are used to find suitable habitat ranges for a given species based on known bioclimatic conditions at presence locations. The complexity of the process has grown dramatically, but the core concept remains the same. Based on what we know about the species' current habitat, identify areas on the landscape that are similar because they can potentially contain the species as well.
The SDM process has evolved with a dependency on data availability. Without dramatic increases in predictor variables of presence datasets, the community has focused growth of the science on the modeling algorithms themselves. These are elements that are created by and controlled by people. So we have a lot of control over them. This has resulted in more options and flexibility of model parameters. While these changes are good, validation of the effects of these changes can be a real challenge. Most SDMs are predicted across a large spatial scale. How do you efficiently field verify a map that contains half the country?
 The purpose of this write up is to examine the effect of one aspect of the species distribution modeling framework, the area in which background points are generated. Background points affect the evaluation statistics, the run time of the model, and most importantly, the ecological reality of the model. To conceptualize some of these effects I will describe them using the idea of signal and noise.

![Medium background area]({{"/assests/biomeLundelliana.png"|absolute_url}})
> A map showing a species distribution model where a large background area was used.

## Signal to Noise
I first heard about this concept from my wife's experience with analytical chemistry. The single to noise ration was a metric they used to understand the likelihood that a signal was representative of a specific response, not just an artifact of the noise it is a part of. In her work, they were attempting to determine the amount of dextrose, a sugar molecule, within a known mass of biomass like grass or corn stover. Commercially produced standards defined the signal for these dextrose molecules. So the analyst knew exactly what to look for when attempt to find the dextrose signal. The noise is simply all the other values emitted by all other molecules present in the sample.
If there was amply dextrose within a sample, the signal stood out from the noise. Yet as the amount of the dextrose molecule diminished, there comes a point when it is not reasonable to assume the signal is not just a feature of the background noise. In her work, there were no options to reduce the noise because it was an inherent part of the plant matter, just like the dextrose. Therefore the signal to noise ratio was used to set the minimum detectable amount within a given sample.

Conceptually, this logic applies well to presence only species distribution modeling. The signal, in this case, is the bioclimatic values that are found at the various presence points. The noise is defined by the bioclimatic values derived by the generation of the background points. Unlike the analytical chemists of the world, we have the option to alter both the signal and the noise of our models.

### Signal == Presence Locations
### Noise  == Background

By thinning or spatially sampling the presence points, we can alter the range of the signal. Changing this will affect the signals character, but the core assumption is that the variability of those signal will fall within an expected range as plants really do have a suitable habitat. Even though this suitable habitat exists, we will never have industrially define standard when working at the landscape scale. The best we can hope for is that given proper data, we can confidently say we have a representative signal of suitable habitat. Due to this and the fact that quality presence points are generally a limiting factor within a SDM study, our ability to improve model performance through the alteration of the presence signal quickly comes against the concept of diminishing returns. Therefore, we have to look at altering the noise to improve our models.

Altering the noise can be done in two ways, increasing the number of background points or by limiting the spatial extent from which the background points are generated.

Increasing the number of background points provides a more complete representation of the environmental variability within the landscape. Doing so increases the volume of all the noise. This means that regions that fall with the outside edges of the signal are more likely to be lost to the noise. The challenge within this method is that increasing the number of background points increases the computational time of the models. While unrealistic in most areas, there is still a cap to how many background points can be generated before duplication of values comes in. In general, increasing the number of background points goes against a modeling creed of the principle of parsimony.

>  given a set of possible explanations, the simplest explanation is the most likely to be correct.

While increasing the number of background points may improve model performance, it is difficult to connect that action to the ecological logic because species are not directly affected by environments that they do not inhabit. It may make our models numerically more correct; what we really want is a simple and ecologically relevant model, not complex and mathematically significant ones.

![Small background area]({{"/assests/ecoLundelliana.png"|absolute_url}})
> A map showing a species distribution model where a small sized background area was used.


# It's in the Noise

Altering the area in which background data is collected seems to both simplify and connection our models to actual ecological constraints. For example, if we want to predict the location of a montane tree species that has never been found below 2000 feet above sea level, why would one incorporate background points that are outside of that limit. Elevation appears to be an ecological, not a theoretical limit. If we include these areas from the background point generation, we are effectively reducing the volume of the noise by spreading it across ecologically insignificant ranges. Yet the mathematically implications of this action will mean that our signal will stand out more within our model because the overall noise has been reduced. Put another way; it is easier to pick out a specific apple that is surrounded by a wide variety of fruit than one surrounded by other varieties of apples. The signal is the same, but the background is more generic.

The trouble becomes how can we justify the method of reducing the background area when the metrics for model performance are going to more favorable weight the generic models.

**Limiting the area in which the background points are generated will effectively increase the volume of noise making the detection of the signal more difficult to distinguish**

I think this can be done by evaluating the signal to noise ratio of the models as a unified metric of the difficulty of the modeling task.

Assumptions
- The signal will remain the same regardless of the area from which the background points are generated.

- A signal to noise ratio can be used as a comparison across models because it only measures the variability within the background.

- Limits on the area in which a model should be ran can be defined by ecologically significant parameters.

- Signal to noise ration can also be used to define an oversimplification of the model by applying a limit to the size of the area in which the background points are generated when the signal can not be reasonably distinguished from the noise.

- the signal to noise ration can be represented by the relationship between the range in bioclimatic values of the signal (presence locations) and the range in bioclimatic values of the background points.

**Method**
- identify top model predictor

- define the range of values with the signal ( presence points )

- define the range of values with the noise ( background points )

- calculate signal to noise ration  (signal range / noise range)



We are currently in the method of testing this process to try to understand a few specific processes.

**Questions**
How does the comparison between models influence the interpretation of model results?

How can you define the signal to noise ratio is to small?

While all these methods are interesting in their own right, the real goal is how can we provide the most ecological relevant models of the species we are interested in.
The hope is that this path helps us better measure what already exist right before our eyes.