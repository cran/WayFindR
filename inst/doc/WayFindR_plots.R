## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----packs--------------------------------------------------------------------
library(WayFindR)
suppressMessages( library(igraph) )

## ----graph--------------------------------------------------------------------
xmlfile <- system.file("pathways/WP3850.gpml", package = "WayFindR")
G <- GPMLtoIgraph(xmlfile)
class(G)

## ----fig.width = 10, fig.height = 10, fig.cap = "Figure 1: Circles and rectangles; layout with graphopt."----
set.seed(13579)
L <- igraph::layout_with_graphopt
plot(G, layout=L)
title("WP3850")
nodeLegend("topleft", G)
edgeLegend("bottomright", G)

## ----fig02, fig.keep='last', fig.width=10, fig.height=10, fig.cap =  "Figure 2: Resized ellipses."----
wc <- which(V(G)$shape == "circle")
G <- set_vertex_attr(G, "shape", index = wc, value = "ellipse")
plot(0,0, type = "n")
opar <- par(mai = c(0.05, 0.05, 1, 0.05))
sz <- (strwidth(V(G)$label) + strwidth("oo")) * 92
G <- set_vertex_attr(G, "size", value = sz)
G <- set_vertex_attr(G, "size2", value = strheight("I") * 2 * 92)
set.seed(13579)
L <- layout_with_graphopt(G)
plot(G, layout = L)
title("WP3850")
edgeLegend("bottomleft", G)
nodeLegend("bottomright", G)
par(opar)

## ----fig03, fig.width = 10, fig.height=10,  fig.cap =  "Figure 3: Two=step layout."----
set.seed(12345)
L <- layout_nicely(G)
L2 <- layout_with_kk(G, coords=L)
plot(G, layout = L2)
title("WP3850")
edgeLegend("bottomleft", G)
nodeLegend("bottomright", G)
par(opar)

## ----fig04, fig.width = 10, fig.height=10,  fig.cap =  "Figure 4: Plot after conversion ot graphNEL."----
GN <- as.graphNEL(G)
suppressMessages( library(Rgraphviz) )
plot(GN)

## ----fig05, fig.width = 10, fig.height=10,  fig.cap =  "Figure 5: Rgraphviz plot with 'twopi' layout.", warning=FALSE----
plot(GN, "twopi")

