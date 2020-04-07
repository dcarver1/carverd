install.packages('scholar')
library(scholar)
library(dplyr)
install.packages("visNetwork")
library(naniar)
library(visNetwork)
dc <- "pNkU3ikAAAAJ&hl"

l <- scholar::get_profile(dc)
l
g <- scholar::get_publications(id = dc)
View(g)
j <- scholar::get_complete_authors (id = dc, pubid = "zYLM7Y9cAGgC")
j
View(j)

lists <- as.character(c(1:10))

i2 <- g %>%
  dplyr::select(author) %>%
  tidyr::separate(col = author, into = lists, sep=",")

#View(i2)
#find all unique names 
vals <- unique(as.vector(as.matrix(i2)))

# replace duplicates / misspellings 
i2[i2 == "DP Carver"] <- " D Carver"
i2[i2 == "D CARVER Jr"] <- " D Carver"
i2[i2 == " A Vorster"] <- " T Vorster"  
i2[i2 == " JM BEETON"] <- " JM Beeton"
i2[i2 == " M van Zonneveld"] <- " M Van Zonneveld"
i2[i2 == "P Evangelista"] <- " P Evangelista"
i2[i2 == "CK Khoury"] <- " CK Khoury"
i2[i2 == "B Woodward"] <- " B Woodward"

# create node DF
nodes <- as.data.frame(matrix(nrow = length(vals),ncol = 1))
nodes$id <- vals
nodes <- nodes %>% select(id)

# build a edge dataframe 
# unique node, unique connection, count 
edges <- as.data.frame(matrix(nrow=0,ncol = 2))
# for element in nodes 
for(i in vals){
  # move through all rows
  for(j in 1:nrow(i2)){
    # select first row and drop all NA values 
    val2 <- i2[j,][!is.na(i2[j,])]
    #test if element is in list 
    if(i %in% val2){
      # replace all values that equal element with NA 
      val2 <- val2[val2 != i]
      # convert to vect and apply as connection in df, rep node based on lenght of unique connectin 
      temp1 <- as.data.frame(matrix(nrow=length(val2), ncol = 2))
      temp1$V2 <- val2
      temp1$V1 <- rep(i,length(val2))
      # add values to df for compiling 
      edges <- dplyr::bind_rows(edges, temp1)
    }
  }
  # drop name from 
  i2[i2 == i] <- NA 
}


edges1 <- edges[!edges[,2] == " ...",]
edges1 <- edges1[!edges1[,1] == " ...",]

edge2 <- edges1 %>%
  dplyr::group_by(V1, V2)%>%
  dplyr::summarise(weight = n())

colnames(edge2) <- c("from", "to")

links <- i2 %>%
  dplyr::group_by(`1`,`2`,`3`,`4`,`5`,`6`) %>%
  summarise(weight = n()) %>%
  ungroup
#View(links)

n2 <- network::network(x = edge2, vertex.attr = nodes, matrix.type="edgelist")

plot(n2, vertex.cex = 3)

n3 <- visNetwork(nodes = nodes, edges = edge2 )
n3
