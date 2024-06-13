# Tutorials

## Directed Acyclic Graphs (DAGs) Tutorial

A Directed Acyclic Graph (DAG) is a finite directed graph with no directed cycles; it providing a clear and visual way to represent and reason about causal relationships among variables. In this tutorial we will look at DAG representation using Graphs.jl library.

### Basic Concepts

- **Node**: A point in the graph where edges meet.
- **Edge**: A directed connection between two nodes.
- **Path**: A sequence of edges that connect a sequence of nodes.
- **Cycle**: A path that starts and ends at the same node. In a DAG, cycles are not allowed.

### Example 1: Simple DAG

Consider a simple DAG with 2 nodes.
In this graph:
- Node `A` has edges to `B`.
- Node `B` has no outgoing edges.
```julia
using Graphs
using GraphPlot #for plotting
using Compose   #for plotting

# Create a directed graph
g = SimpleDiGraph(2)

# Add an edge from vertex 1 to vertex 2
add_edge!(g, 1, 2)

# Define labels for vertices
labels = ["A", "B"]

# Visualize the graph
p = gplot(g, nodelabel=labels)
```
The above code produces this output:

![Alt text](https://raw.githubusercontent.com/studhamza/CausalInference.jl/master/assets/simple_dag.svg)
### Example 2: Complex DAG
Consider a bigger DAG with 6 vertices:
```julia
g = SimpleDiGraph(6)

# Add edges
add_edge!(g, 1, 2)  # A -> B
add_edge!(g, 1, 3)  # A -> C
add_edge!(g, 2, 3)  # B -> C
add_edge!(g, 2, 4)  # B -> D
add_edge!(g, 3, 5)  # C -> E
add_edge!(g, 4, 6)  # D -> F

# Define labels for vertices
labels = ["A", "B","C","D","E","F"]

# Visualize the graph
p = gplot(g, nodelabel=labels)

```
The above code produces this output:

![Alt text](https://raw.githubusercontent.com/studhamza/CausalInference.jl/master/assets/complex_dag.svg)
### Test For DAG
To check whether a graph is a DAG or not, use the `simplecycleslength(dg::DiGraph, ceiling = 10^6)` function. 
```julia
julia> simplecycleslength(g)
([0, 0, 0, 0, 0, 0], 0)
```
No simpled cycles in a directed graph implies that this graph is a DAG.
### Example 3: Relationships between variables
Consider the relationship between smoking and cardiac arrest. We might say that smoking leads to changes in cholesterol levels, which in turn result in cardiac arrest:
```julia
using Graphs
using GraphPlot
using Compose
using Colors

# Create a directed graph
g = SimpleDiGraph(5)


# Add edges
add_edge!(g, 1, 3)  # Smoking -> Cholesterol
add_edge!(g, 4, 3)  # Weight -> Cholesterol
add_edge!(g, 2, 1)  # Unhealthy Lifestyle -> Smoking
add_edge!(g, 2, 4)  # Unhealthy Lifestyle -> Weight
add_edge!(g, 3, 5)  # Cholesterol -> Cardiac Arrest


# Define labels for the nodes
labels = ["Smoking", "Unhealthy Lifestyle", "Cholesterol", "Weight", "Cardiac Arrest"]

# Plot the graph
p = gplot(g, 
      nodelabel=labels, 
      nodefillc=range(colorant"lightblue", stop=colorant"lightgreen", length=nv(g)),
      )
```
![Alt text](https://raw.githubusercontent.com/studhamza/CausalInference.jl/master/assets/variable_relation_dag.svg)

The DAG visually represents the causal relationships between different factors leading to cardiac arrest. Each directed edge (arrow) from one node to another indicates a potential cause-effect relationship.
In this example, unhealthy lifestyle leads to smoking and weight; which both causes a high cholesterol level leading to a cardic arrest.

On the DAG, we assume that a person who smokes is more likely to be someone who engages in other unhealthy behaviors, such as overeating.