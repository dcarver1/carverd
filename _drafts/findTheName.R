install.packages("combinat")
library(combinat)
library(dplyr)
library(data.table)

vals <- combinat::permn(c("k", "r","d","a","n","i","l"), sort = TRUE)


df <- data.frame(matrix(ncol=1, nrow = length(vals)))
colnames(df) <- "guess"
for(i in 1:length(vals)){
  df$guess[i] <- paste(vals[[i]], collapse = "")
}



dfs <- lapply(vals, data.frame) %>%
  dplyr::bind_rows()
