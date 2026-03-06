library(terra)
library(here)
here()

#Read vector
simra_vector <- terra::vect(here("data", "cleaned", "simra_output.gpkg"))

simra_vector <- project(simra_vector, "EPSG:25833")

r <- rast(ext(simra_vector),
          resolution = 5, #in m
          crs = "EPSG:25833")

simra_raster <- rasterize(simra_vector,
                          r,
                          field = 1,
                          fun = "sum")

writeRaster(simra_raster, 
            filename = here("data", "rasters", "simra_raster_res5.tif"), 
            overwrite = TRUE)

