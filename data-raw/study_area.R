## code to prepare `DATASET` dataset goes here
library(dplyr)
pilot_area <- sf::st_read("external/data/pilot_aoi_v1.geojson")
pilot_area <- pilot_area %>% 
  filter(grepl("cacao|pinto|buffer|cordillera", name))

pat <- c("cacao", "pinto", "buffer", "cordillera")
studyarea <- lapply(pat, function(x) pilot_area %>% filter(grepl(x, name)))
names(studyarea) <- c("cacao_zone", "aoi", "buffer", "np")

usethis::use_data(studyarea)
