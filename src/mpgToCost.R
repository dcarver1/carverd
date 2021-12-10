###
# determine cost distance ratio of engine types
# carverd@colostate.edu 
# 20210922
###


# function that 

### Chevy Gas 2500 extended cab 4.3 litter gas  
engineName <- c("4.3 gas", "6.0 gas", "2.8 diesel") 
baseCostDollars<- c(35195, 37965,40265) 
costPerGallonOfFuel <- c(3.53, 3.53, 3.44)
mpg <- c(17,15,30)
for(i in seq_along(engineName)){
  if(i == 1){
    df <- getCost(engine = engineName[i], baseCost = baseCostDollars[i],
                  costPerGallon = costPerGallonOfFuel[i],
                  milePerGallonHighway = mpg[i])
  }else{
    d1 <- getCost(engine = engineName[i], baseCost = baseCostDollars[i],
                  costPerGallon = costPerGallonOfFuel[i],
                  milePerGallonHighway = mpg[i])
    df <- dplyr::bind_rows(df,d1)
  }
}

fig <- plotly::plot_ly(df, x = ~distance, y = ~cost, color = ~engine) 

fig

getCost <- function(engine, baseCost, costPerGallon, milePerGallonHighway){
  # set range to calculate features 
  interval <-seq(1000, 150000, by = 1000)
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

