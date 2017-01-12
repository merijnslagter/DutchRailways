library(sp)
library(rgeos)
library(rgdal)
require("maptools")
require("ggplot2")
require("plyr")

setwd("/home/merijn/Documents/Wageningen/GeoScripting/week2/lesson1")

unzip(zipfile = 'data/netherlands-places-shape.zip')
unzip(zipfile = 'data/netherlands-railways-shape.zip')

# define CRS
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

# transform places
places <- readOGR(dsn = "data", layer = "places")

placestrans <- spTransform(places, prj_string_RD)

# placesbt <- spTransform(placesbuf, CRS("+proj=longlat +datum=WGS84"))

# plot places

# transform railways

railways <- readOGR(dsn = "data", layer = "railways")

railind <- subset(railways, type == "industrial")
railind2 <- railways[railways$type == 'industrial',]

railindtrans <- spTransform(railind, prj_string_RD)

railindbuf <- gBuffer(railindtrans, byid = TRUE, width = 1000)

railindbuftrans <- spTransform(railindbuf, CRS("+proj=longlat +datum=WGS84"))

# intersect

railplace <- gIntersection(railindbuf, placestrans, byid = TRUE)

railplacetrans <- spTransform(railplace, CRS("+proj=longlat +datum=WGS84"))

# Intersection on 5973

Utrecht <- places['5973', c('name', 'population')]

# Plotting
plot(railindbuftrans)
plot(railplacetrans, add=TRUE, col = "red", pch = 19, cex = 0.2)
title(main = "Utrecht")
box()

# name = Utrecht, population = 100000

