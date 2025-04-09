## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----packs--------------------------------------------------------------------
library(WayFindR)
suppressMessages( library(igraph) )

## ----graph--------------------------------------------------------------------
xmlfile <- system.file("pathways/WP3850.gpml", package = "WayFindR")
G <- GPMLtoIgraph(xmlfile)
class(G)

## ----calcmetrics--------------------------------------------------------------
# Calculate metrics
metrics <- data.frame(nVertices = length(V(G)),
                   nEdges = length(E(G)),
                   nNegative = sum(edge_attr(G, "MIM") == "mim-inhibition"),
                   hasLoop = any_loop(G),
                   hasMultiple = any_multiple(G),
                   hasEuler = has_eulerian_cycle(G) | has_eulerian_path(G),
                   nComponents = count_components(G),
                   density = edge_density(G),
                   diameter = diameter(G),
                   radius = radius(G),
                   girth = ifelse(is.null(girth(G)), NA, girth(G)$girth),
                   nTriangles = sum(count_triangles(G)),
                   efficiency = global_efficiency(G),
                   meanDistance = mean_distance(G),
                   cliques = clique_num(G),
                   reciprocity = reciprocity(G))
metrics

## ----cyclesub-----------------------------------------------------------------
cy <- findCycles(G)
length(cy)
S <- cycleSubgraph(G, cy)
cymetrics <- data.frame(nCycles = length(cy),
                         nCyVert = length(V(S)),
                         nCyEdge = length(E(S)),
                         nCyNeg = sum(edge_attr(S, "MIM") == "mim-inhibition"))
cymetrics

## ----fig.width=8, fig.height=8, fig.cap = "Figure 1: Example pathway (WP3850) from WikiPathways."----
set.seed(93217)
plot(S)
nodeLegend("topleft", S)
edgeLegend("bottomright", S)


## ----degree-------------------------------------------------------------------
deg <- degree(G)
summary(deg)
tail(sort(deg))

## ----maxdeg-------------------------------------------------------------------
w <- which(deg == 12)
V(G)[w]$label

## ----splore-------------------------------------------------------------------
A <- adjacent_vertices(G, w, "in")
A

## ----in-genes-----------------------------------------------------------------
ids <- as_ids(A[[1]])
V(G)$label[as_ids(V(G)) %in% ids]

## ----edgeTypes----------------------------------------------------------------
Earg <- as.vector(t(as.matrix(data.frame(Source = ids, Target = names(w)))))
E(G, P = Earg)$MIM

## ----fig.width=7, fig.height=7, fig.cap="Figure 2: Immediate portion of the pathway aronud the mTORC1 complex."----
B <- adjacent_vertices(G, w, "out")
subg <- subgraph(G, c(names(w), ids, as_ids(B[[1]])))
plot(subg, lwd=3)

## ----seven--------------------------------------------------------------------
w <- which(deg == 7)
V(G)[w]$label

## ----fig.width=7, fig.height=7, fig.cap="Figure 3: Immediate portion of the pathway around `FoxO."----
B <- adjacent_vertices(G, w, "all")
subg <- subgraph(G, c(names(w), as_ids(B[[1]])))
plot(subg, lwd=3)

