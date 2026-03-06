library(terra)
library(here)
here()

#Read vector
simra_vector <- terra::vect(here("data", "cleaned", "simra_output.gpkg"))
parks_vector <- terra::vect(here("data", "cleaned", "parks_output.gpkg"))

r <- rast(ext(simra_vector), #Rasterize to the same template raster as the first dataset
          resolution = 100, #in m
          crs = "EPSG:25833")

parks_raster <- rasterize(parks_vector,
                          r,
                          field = "id")

writeRaster(parks_raster, 
            filename = here("data", 
                            "rasters", 
                            "parks_raster_res100.tif"), 
            overwrite = TRUE)
