## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## -----------------------------------------------------------------------------
#install.packages("WayFindR")
#install.packages("WayFindR", repos="http://R-Forge.R-project.org")
library(WayFindR)

## ----gpmlfile-----------------------------------------------------------------
gpmlFile <- system.file("pathways/WP3850.gpml", package = "WayFindR")

## ----xmlfile------------------------------------------------------------------
xmlfile <- XML::xmlParseDoc(gpmlFile)

## ----collectEdges-------------------------------------------------------------
edges <- collectEdges(xmlfile)
class(edges)
dim(edges)

## ----exampleEdges-------------------------------------------------------------
head(edges)
tail(edges)

## ----collectNodes-------------------------------------------------------------
nodes <- collectNodes(xmlfile)
class(nodes)
dim(nodes)

## ----exampleNodes-------------------------------------------------------------
head(nodes)
tail(nodes)

## ----collectGroups------------------------------------------------------------
groups <- collectGroups(xmlfile)
class(groups)
names(groups)
groups$nodes
groups$edges

## -----------------------------------------------------------------------------
links <- collectAnchors(xmlfile)
class(links)
links$nodes
links$edges

## ----fig.width = 10, fig.height=8---------------------------------------------
data(edgeColors)
data(edgeTypes)
data(nodeColors)
data(nodeShapes)
if (requireNamespace("Polychrome")) {
  opar <- par(mfrow = c(2,1))
  Polychrome::swatch(edgeColors, main = "Edge Types")
  Polychrome::swatch(nodeColors, main = "Node Types")
} else {
  opar <- par(mfrow = c(1,2))
  plot(0,0, type = "n", xlab="", ylab = "", main = "Edges")
  legend("center", legend = names(edgeColors),  lwd = 3,
         col = edgeColors,  lty = edgeTypes)
  num <- c(rectangle = 15, circle = 16)
  plot(0,0, type = "n", xlab="", ylab = "", main = "Nodes")
  legend("center", legend = names(nodeColors),  cex = 1.5,
         col = nodeColors,  pch = num[nodeShapes])
}
par(opar)

## ----main---------------------------------------------------------------------
G <- GPMLtoIgraph(xmlfile)

## ----fig.width = 10, fig.height = 10------------------------------------------
set.seed(13579)
L <- igraph::layout_with_graphopt
plot(G, layout=L)
nodeLegend("topleft", G)
edgeLegend("bottomright", G)

## -----------------------------------------------------------------------------
cyc <- findCycles(G)
length(cyc)
cyc

## -----------------------------------------------------------------------------
lapply(cyc, interpretCycle, graph = G)

## -----------------------------------------------------------------------------
S <- cycleSubgraph(G, cyc)

## ----fig.width=10, fig.height=10----------------------------------------------
set.seed(93217)
plot(S)
nodeLegend("topleft", S)
edgeLegend("bottomright", S)

