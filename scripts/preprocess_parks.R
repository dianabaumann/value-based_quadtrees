library(terra)
library(here)
here()

parks_vector <- terra::vect(here("data", "raw", "berlin_green.gpkg"))

parks_cleaned <- subset(parks_vector[ , c(1,2,3,4,183)]) 
parks_cleaned <- parks_cleaned[parks_cleaned$element == "relation", ]

#Align CRS (EPSG: 25833)
parks_cleaned <- project(parks_cleaned, "EPSG:25833")

#parks_cleaned <- aggregate(parks_cleaned)

writeVector(parks_cleaned, 
            "data/cleaned/parks_output.gpkg",
            overwrite = TRUE)


