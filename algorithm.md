#$H$ matrix as a evidence flow graph $G$
We introduce $H$ matrix
In simple meta-analysis $H$ matrix contributions or leverages of the direct evidence in the formation of the network estimate,
In NMA this is not true since each row does not add up to 1.
By adopting the idea of evidence flow introduced by König et. al. \cite{konig},
we introduced a method to calculate the proportional contribution of each direct comparison to a given NMA comparison.

#Comments on the process
- One can follow the same process for networks containing multi-arm studies by following Rücker's of constructing $H$ matrix.
- Each row $H_{XY}$ has to be transformed to its corresponding flow graph $G_{XY}$.

#$H_{XY}$ row transformation to network $G_{XY}$
We present the algorithm to derive the proportional contribution for comparison \`$Y$ vs $X$\` from the corresponding $H_{XY}$ row of the $H$ matrix:


1. Create network $G_{XY}$ from $H_{XY}$ matrix:
  Let $G_{XY} = (V, E)$ be the network (flow graph), where $V = \{x,y,z,\ldots \}$ denotes the set of nodes (vertices) corresponding to $\Omega = \{X,Y,Z,\ldots \}$ the set of  treatments and $E$ is the set of directed edges $E = \{(u,v)| u,v \in V , h_{UV \rightarrow XY}>0 \}$ corresponding to direct comparisons.
  We define as *evidence flow* or just flow of an edge the mapping $f : E → \mathbb{R}^+$, where the flow of an edge $f(u,v)$ or $f_{uv}$ equals the corresponding value of the $H$ matrix: $f_{uv}=h_{UV \rightarrow XY}$.

  As shown by Rucker et al. \cite{electrical} as well as König et al. \cite{koening} $G_{XY}$ constitutes a valid flow graph with source vertex $x$ and sink $y$, since:

  * a. The sum of outflows out of node X is 1. $\sum\limits_{u \in V}f_{xu}=1$
  * b. The sum of inflows into node Y is 1. $\sum\limits_{u \in V}f_{uy}=1$
  * c. The flow passing through each internal node is conserved, alternatively put, the inflow equals the outflow of a node: $\forall z \in V \setminus \{x,y\}, \sum\limits_{z \in V} f_{zu} = \sum\limits_{v \in V} f_{vz}$
  * d. $G_{XY}$ is acyclic or else a directed acyclic graph *(DAG)*.

Given the above properties we are able to decompose the flow into independent paths (routes) from $x$ to $y$ which we will call *streams*.
A *stream* $s_i$ is therefore defined by its flow $φ_i$ path $π_i$.

$s_i = (φ_i,π_i) , π_i \in \{ (x,u), \ldots, (z,y)\} \subseteq E$, π_i could also be the direct $(x,y)$ if that direct comparison exists.
The sum of the stream flow is $1$: $\sum\limits_i φ_i =1$ and also the flow of the streams traversing an edge $(u,v)$ equals the flow of that edge:
$\sum\limits_{i|(u,v)\in π_i} φ_i{(u,v)}=f(u,v)$
We translate the flow of an edge, ie the $H$ element of the corresponding direct comparison, by adding the contribution of each stream containing that edge.
In order to do that we impose the following conditions concerning each stream.
* Stream proportionality which dictates that
a stream's $s_i$ contribution $c_i$ equals its flow $c_i=φ_i$. figure 1a
* Edge equality: the contribution of each edge in a stream is the same, so the contribution of an edge equals the flow of the stream divided by its length, $c_i(u,v) = φ_i / |π_i|$. figure 1b

We can finally calculate the contribution of an edge $c_i(u,v)$ to the $Y$ vs $X$ comparison , from the streams $s_i$ as
$c_i(u,v) = \sum\limits_{i|(u,v)\in π_i} f_i/|π_i|$.
The total contribution is given by summing each stream's contribution $c(u,v)= \sum\limits_n c_i(u,v)$.

#Algorithm
As mentioned above we reduced the problem of calculating the contributions of direct comparisons of the '$Y$ vs $X$' comparison, to evaluating the independent paths of flow or streams $s_i$ in the network $G_{XY}$.
The process is similar to the maximum flow Edmonds Karp algorithm \cite{edmondskarp}, of finding the shortest path between source and sink, but instead of increasing we subtract flow.
The algorithm is iterative with each step finding a stream until all flow is accounted for.

We present the algorithm for the flow decomposition of a graph $G_{XY}$:

0. Set initial graph $G_0 = G_{XY}$ and contribution of edges $c_0(u,v)=0 \, \forall \, (u,v) \in E_0$.

Then by following the bellow process $n$ times until $f_n(u,v)=0 \, \forall \, (u,v) \in E_n$.
1. Remove the edges with no flow $E_i =  E_{i-1} \setminus (u,v) | f_{i-1}(u,v)=0$.
2. Calculate the weights $w_i(u,v)$ of each edge $(u,v)$ as follows:
  $w_i(u,v) = 2 - f_{i-1}(u,v)$
3. Find the minimum weighted path from $x$ to $y$ in $G_i$. This path constitutes the stream $s_i=(φ_i,π_i)$,
 with flow  $φ_i=min(f_{i-1}(u,v)), (u,v) \in π_i$ equal to the minimum flow of the edges in the path.
 The weights assure that this is the shortest path with the maximum sum of flow.
4. Recalculate the flow by subtracting $φ_i$ fom the edges of the stream found: $f_i(u,v)=f_{i-1}(u,v)-φ_i \, \forall \, (u,v) \in π_i$ the rest flow remain unchanged: $f_i(u,v)=f_{i-1}(u,v)\, \forall \, (u,v) \notin π_i$.
5. Calculate the contributions: $c_i(u,v)=c_{i-1}(u,v)+f_i/|π_i|$.

The final contribution of edge $(u,v)$ is therefor $c(u,v) = c_n(u,v)$.
By having all $c(u,v)$ we can construct the contribution matrix $P$ with the same structure of $H$ where an element in the $XY$ row is $p_{UV \rightarrow XY} = c(u,v)$.

The algorithm guarantees that $\sum\limits_{UV : direct }p_{UV \rightarrow XY} = 1$ and also
that the contribution of the direct is $1$ minus the contribution of the indirect comparisons, as is expected from the contribution matrix.
