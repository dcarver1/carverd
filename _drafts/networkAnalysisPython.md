Eric Ma
Introduction to networks

# introduction to network
Nodes: feature with metadata
Edges: relationship between nodes
for a network called a graph
metadata works by dictionary file format

Will be using NetworkX API

**list comphrehension**
[ output expression for iterator variable in iterable if predicate expression ].

```python
# Use a list comprehension to get the nodes of interest: noi
noi = [n for n, d in T.nodes(data=True) if d['occupation'] == 'scientist']
# Use a list comprehension to get the edges of interest: eoi
eoi = [(u, v) for u, v, d in T.edges(data=True) if d['date'] < date(2010, 1, 1)]
```

list comprehensions are still a little shaky for me, though it's easy to tell their value .

**data=True** : use to return metadata associated with a node or edge


## types of graphs
undirected graphs : no direction to the connection. Friends on facebook

directed graphs: inherent directionality associated with the graph

Multi(Di)Graph : multiple connections between the nodes

Weights: can be used to collapse multiple connection to a weigfhted values

Self Loops: connects back to itself. Left bike terminal and returned

```python

# Set the weight of the edge
T.edge[1][10]['weight'] = 2

# Iterate over all the edges (with metadata)
for u, v, d in T.edges(data=True):

    # Check if node 293 is involved
    if 293 in [u,v]:

        # Set the weight to 1.1
        T.edge[u][v]['weight'] = 1.1
```
Set the weight for all edges
change the weight for all edges associated with node 293

```python
# Define find_selfloop_nodes()
def find_selfloop_nodes(G):
    """
    Finds all nodes that have self-loops in the graph G.
    """
    nodes_in_selfloops = []

    # Iterate over all the edges of G
    for u, v in G.edges():

    # Check if node u and node v are the same
        if u == v:

            # Append node u to nodes_in_selfloops
            nodes_in_selfloops.append(u)

    return nodes_in_selfloops

# Check whether number of self loops equals the number of nodes in self loops
assert T.number_of_selfloops() == len(find_selfloop_nodes(T))
```
something that kinda makes sense!
u is the start node, v is the end node so if they are the same the edge is a loop

## network visualization
matrix plot: nodes are rows and colummns. cells are filled in if connection exists between nodes
 - directed graphs may not be symetrical

arc plots: nodes are order along on axis of the plot, edges are arced between connection.
- if order data, can be used to show connectivity.

Circos Plot: circular version of arc plots.

```python
# Import nxviz
import nxviz as nv

# Create the MatrixPlot object: m
m = nv.MatrixPlot(T)

# Draw m to the screen
m.draw()

# Display the plot
plt.show()
# Convert T to a matrix format: A
A = nx.to_numpy_matrix(T)

# Convert A back to the NetworkX form as a directed graph: T_conv
T_conv = nx.from_numpy_matrix(A, create_using=nx.DiGraph())

# Check that the `category` metadata field is lost from each node
for n, d in T_conv.nodes(data=True):
    assert 'category' not in d.keys()

```
back to confused again, I guess I just missing a flow or connect to this all at the moment. Why are converting the graph to a matrix then back to a graph. I gues maybe for the visualization to work... I'll keep at it.

```python
# Import necessary modules
import matplotlib.pyplot as plt
from nxviz import CircosPlot

# Create the CircosPlot object: c
c = CircosPlot(T)

# Draw c to the screen
c.draw()

# Display the plot
plt.show()
````
this is much more stright forward
call the function on the graph and call it good.


```python
# Import necessary modules
import matplotlib.pyplot as plt
from nxviz import ArcPlot

# Create the un-customized ArcPlot object: a
a = ArcPlot(T)

# Draw a to the screen
a.draw()

# Display the plot
plt.show()

# Create the customized ArcPlot object: a2
a2 = ArcPlot(T, node_order ='category', node_color='category')

# Draw a2 to the screen
a2.draw()

# Display the plot
plt.show()
```

these arc plots are cool.
there are multiple way to catergorize them. The important thing is that the features need to ordered inorder for the plot to make much sense.
