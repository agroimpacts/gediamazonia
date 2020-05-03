library(dplyr)
library(sf)

dirs <- dir("external/data/roads", full.names = TRUE)
fs <- dir(dirs[-grep("txt", dirs)], full.names = TRUE, pattern = "shp$")

# combine all three areas
area_union <- st_union(st_union(studyarea$aoi, studyarea$np), 
                       st_buffer(studyarea$buffer, dist = 0.001))
# area_union %>% st_geometry %>% plot()

roads <- lapply(1:length(fs), function(x) { # x <- fs[4]
  road_sf <- st_read(fs[x])
  if(st_crs(road_sf) != st_crs(4326)) {
    road_sf <- st_transform(road_sf, crs = 4326)
  }
  road_ai <- st_intersection(road_sf, area_union)
  road_ai %>% dplyr::mutate(grp = as.character(x)) %>% 
    dplyr::select(grp, geometry)
}) %>% do.call(rbind, .)

# look at road groups (show roads)
# ggplot(studyarea$aoi) + geom_sf() +
#   # geom_sf(data = roads %>% dplyr::filter(grp < 4), aes(color = grp)) + 
#   geom_sf(data = studyarea$np, fill = "grey40") + 
#   geom_sf(data = studyarea$buffer, fill = "grey90") + 
#   geom_sf(data = roads, aes(color = grp))

roads <- roads %>% dplyr::filter(grp < 4) %>% 
  dplyr::mutate(length = units::set_units(st_length(.), "km")) %>% 
  dplyr::group_by(grp) %>% dplyr::summarize(length = sum(length)) %>% 
  dplyr::select(grp)
  
usethis::use_data(roads, overwrite = TRUE)  



