8/29/2018
# Network Science in R - A Tidy Approach

## Basics
you can read in csv with nodes and connections to build network

```r
# make the network from the data frame ties and print it
g <- graph_from_data_frame(ties, directed = FALSE, vertices = nodes)
g
# explore the set of nodes
V(g)
# print the number of nodes
vcount(g)
# explore the set of ties
E(g)
# print the number of ties
ecount(g)
```
you can add and rename attributes as if it were a dataframe
```r
# give the name "Madrid network" to the network and print the network `name` attribute
g$name <- "Madrid network"
g$name

# add node attribute id and print the node `id` attribute
V(g)$id <- 1:vcount(g)
V(g)$id
```

You can work with ggplot and dplyr for interpreting and change the graph
The syntax is the same as ggplot but the options are new.
```r
# add an id label to nodes
ggraph(g, layout = "with_kk") +
  geom_edge_link(aes(alpha = weight)) +
  geom_node_point()  +
  geom_node_text(aes(label = id), repel=TRUE)
```
**alpha** adds a transparency
**repel** Insures that labels do not overlap
layouts
**with_kk** places tied nodes at equal distances
**in_circle**
**grid**

``` r
ggraph(g, layout = "grid") +
  geom_edge_link(aes(alpha = weight)) +
  geom_node_point()
```
### centrality
this is often the primary unit that measured by network scientist becaus e it is a means of measuring the significance of a node

networks are stored as a dataframe and graph so you have to make edit to both to engage with thin fully
``` r
# compute the degrees of the nodes
dgr <- degree(g)
# add the degrees to the data frame object
nodes <- mutate(nodes, degree = dgr)
# add the degrees to the network object
V(g)$degree <- dgr
# arrange the terrorists in decreasing order of degree
arrange(nodes, -degree)
```
Dplyr works on the df and standard syntax works on the network

```r
# compute node strengths
stg <- strength(g)
# add strength to the data frame object using mutate
nodes <- mutate(nodes, strength = stg)
# add the variable stg to the network object as strength
V(g)$strength <- stg
# arrange terrorists in decreasing order of strength and then in decreasing order of degree
arrange(nodes, -strength)
arrange(nodes, -degree)
```
anyother example of the process
**degree** number of connections to a node
**strength** sum of weight of connections to a node
**betweenness** number of shortest paths going through a tie

```r
# save the inverse of tie weights as dist_weight
dist_weight <- 1 / E(g)$weight

# compute weighted tie betweenness
btw <- edge_betweenness(g, weights = dist_weight)

# mutate the data frame ties adding a variable betweenness using btw
ties <- ties %>% mutate(betweenness = btw)

# add the tie attribute betweenness to the network
E(g)$betweenness <- btw
```

This get complicated pretty quick. Multiple joins to get at a relationship. Joining based on the to and from catergoies .
they build a new tbl with select and finally arrange the results based on betweenneess
```r
# join ties with nodes
ties_joined <- ties %>%
  left_join(nodes, c("from" = "id")) %>%
  left_join(nodes, c("to" = "id"))

# select only relevant variables and save to ties
ties_selected <- ties_joined %>%
  select(from, to, name_from = nam`e.x, name_to = name.y, betweenness)

# arrange named ties in decreasing order of betweenness
arrange(ties_selected, desc(betweenness))
```

displaying the connection is easy when you have all the informating save in the tbl
```r
# produce the same visualization but set node size proportional to strength
ggraph(g, layout = "with_kk") +
  geom_edge_link(aes(alpha = weight)) +
  geom_node_point(aes(size = strength))
```

Cool functionality of ggraph. you can filter within the AES function
```r
# find median betweenness
q = median(E(g)$betweenness)

# filter ties with betweenness larger than the median
ggraph(g, layout = "with_kk") +
  geom_edge_link(aes(alpha = betweenness, filter = (betweenness > q))) +
  geom_node_point() +
  theme(legend.position="none")
```

weak ties are important to understand in networks we can use dplyr to filter by tie strength
```r
# find number and percentage of weak ties
ties %>%
  group_by(weight) %>%
  summarise(number = n(), percentage = n() / nrow(ties)) %>%
  arrange(-number)
```
Need to find out with this E() function does. Generates a graph maybe
but can can define a new column got the dataframe
```r
# build vector weakness containing TRUE for weak ties
weakness <- E(g)$weight == 1
# check that weakness contains the correct number of weak ties
sum(weakness)

# visualize the network by coloring the weak and strong ties
ggraph(g, layout = "with_kk") +
  geom_edge_link(aes(color = weakness)) +
  geom_node_point()
