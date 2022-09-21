---
layout: post
title: "Costing Energy"
permalink: "energyProcessor"
image: energy/mushroom.jpg
tags: [perspective, technology, computing]
categories: perspective, technology, computing
---
# Long Term Cost of Computing

A while back I calculated out the long term cost of vehicle ownership based on the cost of fuel. The process emphasized the value of comparing upfront verse long term cost what considering the option. Basically things that require energy to run have a build in use cost for use. That cost, has the chance to grow to something larger then the cost of the initial purchase over time. Electronics fall squarely into that category because they consume energy and energy costs. I took the effort hear to walk through my logic in evaluating the initial verse long term cost of two difference cpus for a home server that I will be building.

### Picking the right parts

There is a lot to consider when building out a new computer system. For a home server, there is the added consideration of run time. While it's not a requirement, much of the benefit of a server is that it is always accessible, and therefore always on. Always running means a constant pull of electricity and that is readily translated to a sustained cost of operation. For simplicity sake I am just comparing two processor in this evaluation but this could be applied to GPU as well.

**Needs of the home server**

I am looking to build a system that I expect to utilize for four to five years. The primary use will be a media server, network attached storage, and personal cloud storage. I'll be running Unraid so I plan to have a windows and linux vm accessible, with one or the other running a R Server so I can get away with traveling without a big processing machine. The last specification was that I wanted a processor that came with a stock air cooler. This is a bit of an arbitrary factor but it seemed like an OK means of keeping thing modest and energy efficient. I'm assuming that pumping water around in a AIO probably takes more energy then a single fan. I'll be transferring a GTX 980 GPU from an older system so I don't need a chip with a integrated graphics card. I'm going with an AMD build because my current work station is AMD and I'm expecting that over time I'll be upgrading workstation components and passing them along to the server. That left me with two options, the Ryzen 5 5600x and the Ryzen 9 3900x. The Ryzen 7 3700x would of been a good one to keep in the mix but the price/performance does line up as well as the other two options.

#### Options


| Processor     | Cost    | Cores   | Processing Power | Full Load Wattage | Idle Wattage | Heat Production |
|---------------|---------|---------|------------------|-------------------|--------------|---------------- |
| Ryzen 5 5600x | 180     | 6       | 3.7 ghz          | 146W              | 82W          | 65W             |
| Ryzen 9 3900x | 270     | 12      | 3.8 Ghz          | 244W              | 91           | 105W            |


*Note: wattage values were pulled from graphs I found on the internet. There is probably some variability around the values.*

#### Trade off

Ryzen 5 has a low cost, lower energy use potential, slightly lower idle energy use and comparable single thread processing power.

-   Lower performance / Higher efficiency

Ryzen 9 has a high cost, higher energy use, double the cores, higher idle, and expected heat production.

-   Higher performance / lower efficiency

At a 90 dollar difference between the two options I have a hard time keeping my eyes off the higher performance option. What I was concerned about was the potential 1.7 times higher energy usage everyday over the life of the system. Was I going to be paying excessively for that extra power over the long run?

### Cost of run time

I had to make a few assumptions to pull this all together. It's framed under two main questions

1.  **What's the average power consumption of the processor actually look like?**

I assumed that for the majority of the time the computer will be running close to idle. On some occasions I might be pushing thing closer to the full energy draw, but the active use tasks would still probably be much closer to idle then max. I fumbled around with how to best represent these assumption and landed on the following very basic assessment.

$totalEnergy = (totalHours*0.8)*idle + (totalHours*0.2)*max$

The majority of the time were at idle and some of the time were maxed. The actual system will probably never run at either of those two extremes but there the only measured values I have to use. I don't know if 30% core utilization scale linearly with power consumption. I'm sure there is some good data out there to bring some nuance to this calculation but for the time being my basic math is good enough for me.

2.  **How does that get related to an electric bill I have to pay?**

The utility organization I receive power from uses a variable rate structure based on the time of day. Basically five hours of the day electricity costs 27 cent per kilo watt hour and the rest of the time it cost 7 cents per kilo watt hour. We can average that.

``` r
mKWH <- mean(c(rep(7,19),rep(27,5)))
print(mKWH)
```

This works out to 11.16 cents per kilo watt hour.

To generate a daily measure in dollars for each processor set we can run the following function.

``` r
getCost <- function(idle,max, kwhCost){
  # determine daily energy use in kwh (watt*hour/1000)
  dailyEnergy <- ((24*0.8)*idle + (24*0.2)*max)/1000
  # determine cost of the daily energy
  dailyCost <- dailyEnergy * kwhCost
  return(dailyCost)
}

ryzen5 <- getCost(idle = 82,max = 146,kwhCost = mKWH)

ryzen9 <- getCost(idle = 91, max = 244, kwhCost = mKWH)
```

Here are the projected operating costs

| Processor     | Daily   | Month  | One year | Four years |
|---------------|---------|--------|----------|------------|
| Ryzen 5 5600x | \$0.254 | \$7.62 | \$92.73  | \$463.66   |
| Ryzen 9 3900x | \$0.326 | \$9.78 | \$118.94 | \$594.80   |

The most interesting way I've found to contextualize these numbers is to determine how long do you have to use the processor in order to match it's initial ticket price with electrical expenditures.

| Processor     | Initial Cost | Electrical cost surpasses ticket price |
|---------------|--------------|----------------------------------------|
| Ryzen 5 5600x | \$180        | 708 days = 1.9 years                   |
| Ryzen 9 3900x | \$270        | 828 days = 2.26 years                  |

### What does it mean?

The main take away of this is that electrical cost of running the machine over the course of years is going to surpass the up front cost of purchasing the processor. That probably isn't too surprising but seeing it laid out helps me think about the choice in a different light.

-   Because the idle power consumption between the two processors are relatively similar there is not a huge difference in the rate of power consumption over time.

-   Usage is costly. Planning on running this system for 5ish years implies paying more then double the upfront cost of the processors. So the true cost of the investment is more my three times the purchase price of the processor.

These two point both push me toward the more powerful and less efficient Ryzen 9 3900x. The high cost of operation over time makes the effort to save 100 dollar in the ticket price less significant. It's not about the different between 180 and 270 but 650 and 860. Raising the overall cost scale reduces the significance of the difference in ticket price. Not absolutely of course, but relatively.

To look at it as an absolute difference I estimate that my savings will be \$221 dollar over 5 years if I went with the less powerful more efficient chipset. That's roughly \$45 a year, less than \$5 a month. At this point I'm willing and able to pony up an extra Lincoln a month to double my processing power. Lucky me.

### What's been left out.

**My energy use calculation could be inaccurate.**

My assumption in the calculation of daily energy use are very large. It is quite possible that the system runs further away from idle more of the time. I don't really know. I've based this assumption most on looking at the CPU utilization while doing internet browsing and text work. It sits around 10% most of the time on a less performant chipset. Still, given the wide range between the top end energy usage, the future from idle use more that efficient chip is going to pay off.

**Cooling costs.**

There is a relationship between energy use and cooling costs. As the chip heats up a fan will need to run to cool it. Because the Ryzen 9 chip can pull so much more energy it's quite likely that the cooler fans will need to run longer and harder to keep it cool.

**Processing time verse power**

If I do end up pushing some major workflows to this server, it possible that there will be some energy balances between the systems that makes the assumptions I laid out a little suspect. The Ryzen 9 should be able to complete disturbed task twice as fast as the Ryzen 5 because it has double the core count. So both chips running at the top end, if the efficient chip takes twice as long to complete a task, well it's going to net more energy use during that period.

**No GPU**

Graphics processing cards can use a huge amount of energy. But I'm not gaming on this server and I'm not installing a high end GPU. In that sense I expect that energy use trends of the cpu will be the best means of evaluating the energy use of the full system.

**Power supply unit**

All this energy talk has made me think a bit more deliberately about the power supply unit as well. In the past I've seen the variation in efficiency between the difference ratings (bronze, gold, titanium) to be small. The nuance that has arrived is that those efficiencies differ based on the total capacity and load on the system. This is something I'll be looking into in more detail in the near future.
