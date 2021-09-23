###
# determine ocst distance ratio of engine types
# carverd@colostate.edu 
# 20210922
###


# function that 

### Chevy Gas 2500 extended cab 4.3 litter gas  
engine <- "4.3 gas"
baseCost<- 35195
costPerGallon <- 3.427
milePerGallonHighway <- 17 
df <- getCost(engine = engine, baseCost = baseCost,
              costPerGallon = costPerGallon,
              milePerGallonHighway = milePerGallonHighway)
### chevy Gas 2500 extendedcab 6.0 liter gas 
engine <- "6.0 gas"
baseCost<- 37965
costPerGallon <- 3.427
milePerGallonHighway <- 15  
df1 <- getCost(engine = engine, baseCost = baseCost,
              costPerGallon = costPerGallon,
              milePerGallonHighway = milePerGallonHighway)


### chevy Gas 2500 extendedcab 2.8 liter diesel  
engine <- "2.8 diesel"
baseCost<- 40265
costPerGallon <- 3.35
milePerGallonHighway <- 30 
df2 <- getCost(engine = engine, baseCost = baseCost,
              costPerGallon = costPerGallon,
              milePerGallonHighway = milePerGallonHighway)

data <- dplyr::bind_rows(df,df1,df2)

fig <- plotly::plot_ly(data, x = ~distance, y = ~cost, color = ~engine) 

getCost <- function(engine, baseCost, costPerGallon, milePerGallonHighway){
  # set range to calculate features 
  interval <-seq(1000, 100000, by = 1000)
  df <- data.frame(matrix(nrow=length(interval), ncol = 3))
  names(df) <- c("engine","distance", "cost")
  df$distance <- interval
  df$engine <- engine 
  # 
  for(i in 1:length(interval)){
    miles <- interval[i]
    
    df[i,3] <- baseCost + ((miles/milePerGallonHighway) * costPerGallon)
    
  }
  return(df)
}

