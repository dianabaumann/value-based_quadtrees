library(sf)
library(here)
here()

parks_vector <- st_read(here("parks_berlin.gpkg"))


parks_cleaned <- parks_vector[c(1,2,3,4,183)]

parks_output <- st_write(parks_cleaned, "parks_output.gpkg")
