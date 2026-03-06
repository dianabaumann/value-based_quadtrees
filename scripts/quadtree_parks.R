library(terra)
library(quadtree)
library(here)
here()

parks_raster <- terra::rast(here("data", 
                                 "rasters", 
                                 "parks_raster_res100.tif"))

parks_quadtree <- quadtree(parks_raster,
                           1,
                           adj_type = "expand")

write_quadtree(here("data", 
                    "quadtrees", 
                    "parks_quadtree_res100.qtree"), 
               parks_quadtree)

