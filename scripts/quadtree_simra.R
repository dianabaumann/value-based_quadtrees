library(terra)
library(quadtree)
library(here)
here()

simra_raster <- terra::rast(here("data", 
                                 "rasters", 
                                 "simra_raster_res5.tif"))

simra_quadtree <- quadtree(simra_raster,
                           0)

write_quadtree(here("data", 
                    "quadtrees", 
                    "simra_quadtree_res5.qtree"), 
               simra_quadtree)