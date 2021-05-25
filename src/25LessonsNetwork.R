###
# network visualization for 25 lessons blog 
# carverd@colostate.edu
# 20210519
###

#install.packages("networkD3")
library(networkD3)

dfNodes <- data.frame(matrix(nrow = 28, ncol = 3))
names(dfNodes) <- c("name", "group", "size")
dfNodes$name <- c("25 Lessons",
                  "Personal Effectiveness",
                  "Emotions in Decision Making",
                  "1 Showing your work is an individuals ticket to wealth and opportunities",
             "2 Build the plan as you fly it",
             "4 Go smaller",
             "6 Do the thing that doesn't feel like work",
             "7 Create to learn, not to impress someone",
             "9 When you try to be different, you will face social pushback",
             "10 Treat books like a dates",
             "11 The trichotomy of control",
             "15 Accept it, leave it, or change it",
             "17 Compare who you are today against yourself yesterday",
             "19 Reading is information, it takes experience to gain knowledge",
             "20 Writing takes the mental experience of thinking and makes makes it physical - Phase Transitions",
             "21 compound interest ",
             "22 Perfection is a procrastination technique",
             "23 Schedule your day",
             "24 Be very selective in what you consume", 
             "3 actions cure fear", 
             "8 Assume you're below average",
             "12 You're a slave to what you are not aware off",
             "13 Life is too short to spend it in a state of anger",
             "14 Our default is to react to everything that happens around us",
             "15 Happiness is about removing the negative things from your life",
             "18 Seek opportunities that push your comfort zone",
             "25 : A rising tide lifts all those with boats",
             "5 Follow your obsessions, a word on passion")
dfNodes$group <- c(2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,3)
dfNodes$size <- c(20,12,12,6,6,2,4,6,8,4,10,2,10,4,6,4,6,8,4,6,4,8,8,4,8,6,2,6)
dfNodes$size <- dfNodes$size * 4
View(dfNodes)

dfLinks <- data.frame(matrix(nrow = 28, ncol=3))
names(dfLinks) <- c("source", "target", "value")
dfLinks$source <- seq(0, 27, 1)
dfLinks$target <- c(0,0,0,rep(1,16), rep(2,8),0)
dfLinks$value <- c(10,6,6,rep(4,25))


net1 <- forceNetwork(Links = dfLinks, Nodes = dfNodes,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", Nodesize="size", opacity = 1,
             fontSize=12, zoom=T, legend=T,)
net1

### content examples 

View(dfLinks)

data(MisLinks)
data(MisNodes)


Source <- c(1, 1, 2)
Target <- c(2, 3, 3)
Source <- Source - 1
Target <- Target - 1
NetworkData <- data.frame(Source, Target)
simpleNetwork(NetworkData)




links.d3 <- data.frame(from=as.numeric(factor(links$from))-1, 
                       to=as.numeric(factor(links$to))-1 )

The nodes need to be in the same order as the "source" column in links:
  
  nodes.d3 <- cbind(idn=factor(nodes$media, levels=nodes$media), nodes) 

Now we can generate the interactive chart. The Group parameter in it is used to color the nodes. Nodesize is not (as one might think) the size of the node, but the number of the column in the node data that should be used for sizing. The charge parameter controls node repulsion (if negative) or attraction (if positive).

forceNetwork(Links = links.d3, Nodes = nodes.d3, Source="from", Target="to",
             NodeID = "idn", Group = "type.label",linkWidth = 1,
             linkColour = "#afafaf", fontSize=12, zoom=T, legend=T,
             Nodesize=6, opacity = 0.8, charge=-300, 
             width = 600, height = 400)