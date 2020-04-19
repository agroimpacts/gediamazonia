##READ IN PACKAGES##
library(dplyr)
library(leaflet)
library(sf)
library(rGEDI)
library(ggplot2)


##READ IN SHAPEFILES AS OGR DATA##
data(studyarea)
#plot_aoi <- readOGR("F:\\R_Project\\AOI.shp")
buffer <- studyarea$buffer
cacao_zone <- studyarea$cacao_zone
aoi <- studyarea$aoi



##MAKE LEAFLET MAP OF BASE FILES##
buffer_df <- as.data.frame(buffer, region = "id")
map1 <- leaflet(buffer) %>% 
  addPolygons(data = buffer, noClip = T,
              weight = 4,
              dashArray = "5, 1",
              color = "blue",
              fillOpacity = .01,
              smoothFactor = 0) %>%
  addPolygons(data = aoi, noClip = T,
              weight = 4,
              dashArray = "5, 1",
              color = "black",
              fillOpacity = .01,
              smoothFactor = 0) %>% 
  addPolygons(data = cacao_zone, noClip = T,
              weight = 4,
              dashArray = "5, 1",
              color = "red",
              fillOpacity = .01,
              smoothFactor = 0) %>%
  addCircleMarkers(level2AM_clip_bb$lon_lowestmode,
                   level2AM_clip_bb$lat_lowestmode,
                   radius = 1,
                   opacity = 1,
                   color = "green") %>% 
  setView(lng = -75.81374, lat = -7.607134, zoom = 7) %>% 
  addTiles()  # Add default OpenStreetMap map tiles
map1

##FIND COMMOON INTERSECTING AREA
aoi_buffer <- st_intersection(aoi, buffer)
transect <- st_intersection(aoi_buffer, cacao_zone)

map2 <- leaflet(buffer) %>% 
  addPolygons(data = transect,
              weight = 4,
              stroke = TRUE,
              fill = TRUE,
              color = "red",
              fillOpacity = .01,
              smoothFactor = 0) %>% 
  addCircleMarkers(level2AM_clip_bb$lon_lowestmode,
                   level2AM_clip_bb$lat_lowestmode,
                   radius = 1,
                   opacity = 1,
                   color = "green") %>% 
  setView(lng = -75.81374, lat = -7.607134, zoom = 7) %>% 
  addTiles()
map2
