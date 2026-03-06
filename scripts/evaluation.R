#This script includes the evaluation of quadtrees.
##Case 1 (BASELINE): Queries on vector data (loaded .gpkg-files as is)
##Case 2: Queries on rasterized data (transformation from .gpkg to .geoTIFF)
##Case 3 (Prototype): Queries on quadtrees of rasterized data (transformation from .geoTIFF to quadtrees)

##Benchmarking query latency and accuracy for data of high and low spatial autocorrelation with increasing resolution.
##high spatial autocorrelation - many large areas of similar values (parks, oceans)
##low spatial autocorrelation - lots of "noise", little similarity

#Queries:
#Point-in-Polygon Query (PiP) in Parks


library(terra)
library(quadtree)
library(here)
here()

#Read vectors
simra_vector <- terra::vect(here("data", "cleaned", "simra_output.gpkg"))
parks_vector <- terra::vect(here("data", "cleaned", "parks_output.gpkg"))

#Read raster
parks_raster_res5 <- terra::rast(here("data", "rasters", "parks_raster_res5.tif"))
parks_raster_res10 <- terra::rast(here("data", "rasters", "parks_raster_res10.tif"))
parks_raster_res25 <- terra::rast(here("data", "rasters", "parks_raster_res25.tif"))
parks_raster_res100 <- terra::rast(here("data", "rasters", "parks_raster_res100.tif"))

#Read the quadtree
parks_quadtree_res5 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res5.qtree"))
parks_quadtree_res10 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res10.qtree"))
parks_quadtree_res25 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res25.qtree"))
parks_quadtree_res100 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res100.qtree"))


###
#Create 1M random coordinates that lay within the span of one of the datasets
random_pts <- spatSample(parks_raster_res5, 
                         100000, 
                         as.points = TRUE,
                         xy = TRUE,
                         values = FALSE)

#####
#Query the datasets
#Point-in-Polygon Query (PiP) in Parks
#Run "run" times
#Print to console

pip_all_dur_res5 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_all_dur_res5) <- c("resolution", 
                                "run", 
                                "vector_dur", 
                                "raster_dur", 
                                "quadtree_dur")

pip_vec_res_res5 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_vec_res_res5) <- c("resolution", 
                                "run", 
                                "res")

pip_ras_res_res5 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_ras_res_res5) <- c("resolution", 
                                "run", 
                                "res")

pip_qt_res_res5 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_qt_res_res5) <- c("resolution", 
                               "run", 
                               "res")

res5 <- "res_5"

for (run in 1:30) {
  cat("res5, running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res5, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res5, as.data.frame(random_pts)) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_vec_res_res5 <- rbind.data.frame(pip_vec_res_res5, data.frame("resolution" = res5,
                                                                    "run" = run,
                                                                    "vector_res" = pip_vector))
  
  pip_ras_res_res5 <- rbind.data.frame(pip_ras_res_res5, data.frame("resolution" = res5,
                                                                    "run" = run,
                                                                    "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_qt_res_res5 <- rbind.data.frame(pip_qt_res_res5, data.frame("resolution" = res5,
                                                                  "run" = run,
                                                                  "vector_res" = pip_quadtree_as_df))
  
  pip_all_dur_res5 <- rbind(pip_all_dur_res5, data.frame("resolution" = res5,
                                                         "run" = run,
                                                         "vector_dur" = pip_vector_dur,
                                                         "raster_dur" = pip_raster_dur,
                                                         "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_all_dur_res5, here("results", "pip_all_dur_res5.csv"))
write.csv(pip_vec_res_res5, here("results", "pip_vec_res5.csv"))
write.csv(pip_ras_res_res5, here("results", "pip_ras_res5.csv"))
write.csv(pip_qt_res_res5, here("results", "pip_qt_res5.csv"))


####FROM HERE IT'S JUST DIFFERENT RESOLUTIONS AND DATASETS###


#######res10
pip_all_dur_res10 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_all_dur_res10) <- c("resolution", 
                                 "run", 
                                 "vector_dur", 
                                 "raster_dur", 
                                 "quadtree_dur")

pip_vec_res_res10 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_vec_res_res10) <- c("resolution", 
                                 "run", 
                                 "res")

pip_ras_res_res10 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_ras_res_res10) <- c("resolution", 
                                 "run", 
                                 "res")

pip_qt_res_res10 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_qt_res_res10) <- c("resolution", 
                                "run", 
                                "res")

res10 <- "res_10"

for (run in 1:30) {
  cat("res10, running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res10, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res10, as.data.frame(random_pts)) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_vec_res_res10 <- rbind.data.frame(pip_vec_res_res10, data.frame("resolution" = res10,
                                                                      "run" = run,
                                                                      "vector_res" = pip_vector))
  
  pip_ras_res_res10 <- rbind.data.frame(pip_ras_res_res10, data.frame("resolution" = res10,
                                                                      "run" = run,
                                                                      "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_qt_res_res10 <- rbind.data.frame(pip_qt_res_res10, data.frame("resolution" = res10,
                                                                    "run" = run,
                                                                    "vector_res" = pip_quadtree_as_df))
  
  pip_all_dur_res10 <- rbind(pip_all_dur_res10, data.frame("resolution" = res10,
                                                           "run" = run,
                                                           "vector_dur" = pip_vector_dur,
                                                           "raster_dur" = pip_raster_dur,
                                                           "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_all_dur_res10, here("results", "pip_all_dur_res10.csv"))
write.csv(pip_vec_res_res10, here("results", "pip_vec_res10.csv"))
write.csv(pip_ras_res_res10, here("results", "pip_ras_res10.csv"))
write.csv(pip_qt_res_res10, here("results", "pip_qt_res10.csv"))


#######res25
pip_all_dur_res25 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_all_dur_res25) <- c("resolution", 
                                 "run", 
                                 "vector_dur", 
                                 "raster_dur", 
                                 "quadtree_dur")

pip_vec_res_res25 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_vec_res_res25) <- c("resolution", 
                                 "run", 
                                 "res")

pip_ras_res_res25 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_ras_res_res25) <- c("resolution", 
                                 "run", 
                                 "res")

pip_qt_res_res25 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_qt_res_res25) <- c("resolution", 
                                "run", 
                                "res")

res25 <- "res_25"

for (run in 1:30) {
  cat("res25, running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res25, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res25, as.data.frame(random_pts)) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_vec_res_res25 <- rbind.data.frame(pip_vec_res_res25, data.frame("resolution" = res25,
                                                                      "run" = run,
                                                                      "vector_res" = pip_vector))
  
  pip_ras_res_res25 <- rbind.data.frame(pip_ras_res_res25, data.frame("resolution" = res25,
                                                                      "run" = run,
                                                                      "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_qt_res_res25 <- rbind.data.frame(pip_qt_res_res25, data.frame("resolution" = res25,
                                                                    "run" = run,
                                                                    "vector_res" = pip_quadtree_as_df))
  
  pip_all_dur_res25 <- rbind(pip_all_dur_res25, data.frame("resolution" = res25,
                                                           "run" = run,
                                                           "vector_dur" = pip_vector_dur,
                                                           "raster_dur" = pip_raster_dur,
                                                           "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_all_dur_res25, here("results", "pip_all_dur_res25.csv"))
write.csv(pip_vec_res_res25, here("results", "pip_vec_res25.csv"))
write.csv(pip_ras_res_res25, here("results", "pip_ras_res25.csv"))
write.csv(pip_qt_res_res25, here("results", "pip_qt_res25.csv"))


#######res100
pip_all_dur_res100 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_all_dur_res100) <- c("resolution", 
                                  "run", 
                                  "vector_dur", 
                                  "raster_dur", 
                                  "quadtree_dur")

pip_vec_res_res100 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_vec_res_res100) <- c("resolution", 
                                  "run", 
                                  "res")

pip_ras_res_res100 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_ras_res_res100) <- c("resolution", 
                                  "run", 
                                  "res")

pip_qt_res_res100 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_qt_res_res100) <- c("resolution", 
                                 "run", 
                                 "res")

res100 <- "res_100"

for (run in 1:30) {
  cat("res100, running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res100, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res100, as.data.frame(random_pts)) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_vec_res_res100 <- rbind.data.frame(pip_vec_res_res100, data.frame("resolution" = res100,
                                                                        "run" = run,
                                                                        "vector_res" = pip_vector))
  
  pip_ras_res_res100 <- rbind.data.frame(pip_ras_res_res100, data.frame("resolution" = res100,
                                                                        "run" = run,
                                                                        "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_qt_res_res100 <- rbind.data.frame(pip_qt_res_res100, data.frame("resolution" = res100,
                                                                      "run" = run,
                                                                      "vector_res" = pip_quadtree_as_df))
  
  pip_all_dur_res100 <- rbind(pip_all_dur_res100, data.frame("resolution" = res100,
                                                             "run" = run,
                                                             "vector_dur" = pip_vector_dur,
                                                             "raster_dur" = pip_raster_dur,
                                                             "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_all_dur_res100, here("results", "pip_all_dur_res100.csv"))
write.csv(pip_vec_res_res100, here("results", "pip_vec_res100.csv"))
write.csv(pip_ras_res_res100, here("results", "pip_ras_res100.csv"))
write.csv(pip_qt_res_res100, here("results", "pip_qt_res100.csv"))


#####SIMRA (less autocorrelated spatial data)
#Read vectors
simra_vector <- terra::vect(here("data", "cleaned", "simra_output.gpkg"))

#Read raster
simra_raster_res5 <- terra::rast(here("data", "rasters", "simra_raster_res5.tif"))

#Read the quadtree
simra_quadtree_res5 <- read_quadtree(here("data", "quadtrees", "simra_quadtree_res5.qtree"))

###
#Create 1M random coordinates that lay within the span of one of the datasets
random_pts <- spatSample(simra_raster_res5, 
                         100000, 
                         as.points = TRUE,
                         xy = TRUE,
                         values = FALSE)


#####
#Query the datasets
#Point-in-Polygon Query (PiP) in SimRa
#Run "run" times
#Print to console

pip_all_dur <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_all_dur) <- c("resolution", 
                           "run", 
                           "vector_dur", 
                           "raster_dur", 
                           "quadtree_dur")

pip_vec_res <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_vec_res) <- c("resolution", 
                           "run", 
                           "res")

pip_ras_res <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_ras_res) <- c("resolution", 
                           "run", 
                           "res")

pip_qt_res <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_qt_res) <- c("resolution", 
                          "run", 
                          "res")

res5 <- "res_5"

for (run in 1:30) {
  cat("res5, running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(simra_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(simra_raster_res5, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(simra_quadtree_res5, as.data.frame(random_pts)) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_vec_res <- rbind.data.frame(pip_vec_res, data.frame("resolution" = res5,
                                                          "run" = run,
                                                          "vector_res" = pip_vector))
  pip_ras_res <- rbind.data.frame(pip_ras_res, data.frame("resolution" = res5,
                                                          "run" = run,
                                                          "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_qt_res <- rbind.data.frame(pip_qt_res, data.frame("resolution" = res5,
                                                        "run" = run,
                                                        "vector_res" = pip_quadtree_as_df))
  
  pip_all_dur <- rbind(pip_all_dur, data.frame("resolution" = res5,
                                               "run" = run,
                                               "vector_dur" = pip_vector_dur,
                                               "raster_dur" = pip_raster_dur,
                                               "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_all_dur, here("results", "pip_all_dur_simra_res5.csv"))
write.csv(pip_vec_res, here("results", "pip_vec_simra_res5.csv"))
write.csv(pip_ras_res, here("results", "pip_ras_simra_res5.csv"))
write.csv(pip_qt_res, here("results", "pip_qt_simra_res5.csv"))



#####
##Intersection of SimRa and Parks
intersect_vec_res5 <- terra::intersect(parks_vector, simra_vector)
intersect_ras_res5 <- terra::intersect(parks_raster_res5, simra_raster_res5)

library(quadtree)

intersect_qt_res5 <- quadtree(intersect_ras_res5,
                                           1)

#####
#Query the datasets
#Point-in-Polygon Query (PiP) in SimRa
#Run "run" times
#Print to console

pip_intersect_dur <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_intersect_dur) <- c("resolution", 
                           "run", 
                           "vector_dur", 
                           "raster_dur", 
                           "quadtree_dur")

pip_intersect_vec_res <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_intersect_vec_res) <- c("resolution", 
                           "run", 
                           "res")

pip_intersect_ras_res <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_intersect_ras_res) <- c("resolution", 
                           "run", 
                           "res")

pip_intersect_qt_res <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_intersect_qt_res) <- c("resolution", 
                          "run", 
                          "res")

res5 <- "res_5"

for (run in 1:30) {
  cat("res5, running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(intersect_vec_res5, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(intersect_ras_res5, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(intersect_qt_res5, as.data.frame(random_pts)) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_intersect_vec_res <- rbind.data.frame(pip_intersect_vec_res, data.frame("resolution" = res5,
                                                          "run" = run,
                                                          "vector_res" = pip_vector))
  pip_intersect_ras_res <- rbind.data.frame(pip_intersect_ras_res, data.frame("resolution" = res5,
                                                          "run" = run,
                                                          "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_intersect_qt_res <- rbind.data.frame(pip_intersect_qt_res, data.frame("resolution" = res5,
                                                        "run" = run,
                                                        "vector_res" = pip_quadtree_as_df))
  
  pip_intersect_dur <- rbind(pip_intersect_dur, data.frame("resolution" = res5,
                                               "run" = run,
                                               "vector_dur" = pip_vector_dur,
                                               "raster_dur" = pip_raster_dur,
                                               "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_intersect_dur, here("results", "pip_intersect_dur_res5.csv"))
write.csv(pip_intersect_vec_res, here("results", "pip_intersect_vec_res5.csv"))
write.csv(pip_intersect_ras_res, here("results", "pip_intersect_ras_res5.csv"))
write.csv(pip_intersect_qt_res, here("results", "pip_intersect_qt_res5.csv"))



##### PiP queries on the borders only
#Extract border of the polygon only for the random sampling

#Read vectors
simra_vector <- terra::vect(here("data", "cleaned", "simra_output.gpkg"))
parks_vector <- terra::vect(here("data", "cleaned", "parks_output.gpkg"))

#Read raster
parks_raster_res5 <- terra::rast(here("data", "rasters", "parks_raster_res5.tif"))
parks_raster_res10 <- terra::rast(here("data", "rasters", "parks_raster_res10.tif"))
parks_raster_res25 <- terra::rast(here("data", "rasters", "parks_raster_res25.tif"))
parks_raster_res100 <- terra::rast(here("data", "rasters", "parks_raster_res100.tif"))

#Read the quadtree
parks_quadtree_res5 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res5.qtree"))
parks_quadtree_res10 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res10.qtree"))
parks_quadtree_res25 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res25.qtree"))
parks_quadtree_res100 <- read_quadtree(here("data", "quadtrees", "parks_quadtree_res100.qtree"))


###
#Create 1M random coordinates that lay within on the borders of the polygons
borders <- as.lines(parks_vector)
random_pts <- spatSample(
                borders,
                size = 100000,
                method = "random"
              )

#Query the datasets
#Point-in-Polygon Query (PiP) in Parks
#Run "run" times
#Print to console

pip_borders_dur_res5 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_borders_dur_res5) <- c("resolution", 
                                "run", 
                                "vector_dur", 
                                "raster_dur", 
                                "quadtree_dur")

pip_borders_vec_res_res5 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_vec_res_res5) <- c("resolution", 
                                "run", 
                                "res")

pip_borders_ras_res_res5 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_ras_res_res5) <- c("resolution", 
                                "run", 
                                "res")

pip_borders_qt_res_res5 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_qt_res_res5) <- c("resolution", 
                               "run", 
                               "res")

res5 <- "res_5"

for (run in 1:30) {
  cat("res5, running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res5, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res5, as.data.frame(random_pts, geom = "xy")) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_borders_vec_res_res5 <- rbind.data.frame(pip_borders_vec_res_res5, data.frame("resolution" = res5,
                                                                    "run" = run,
                                                                    "vector_res" = pip_vector))
  
  pip_borders_ras_res_res5 <- rbind.data.frame(pip_borders_ras_res_res5, data.frame("resolution" = res5,
                                                                    "run" = run,
                                                                    "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_borders_qt_res_res5 <- rbind.data.frame(pip_borders_qt_res_res5, data.frame("resolution" = res5,
                                                                  "run" = run,
                                                                  "vector_res" = pip_quadtree_as_df))
  
  pip_borders_dur_res5 <- rbind(pip_borders_dur_res5, data.frame("resolution" = res5,
                                                         "run" = run,
                                                         "vector_dur" = pip_vector_dur,
                                                         "raster_dur" = pip_raster_dur,
                                                         "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_borders_dur_res5, here("results", "pip_borders_dur_res5.csv"))
write.csv(pip_borders_vec_res_res5, here("results", "pip_borders_vec_res_res5.csv"))
write.csv(pip_borders_ras_res_res5, here("results", "pip_borders_ras_res_res5.csv"))
write.csv(pip_borders_qt_res_res5, here("results", "pip_borders_qt_res_res5.csv"))


###
pip_borders_dur_res10 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_borders_dur_res10) <- c("resolution", 
                                    "run", 
                                    "vector_dur", 
                                    "raster_dur", 
                                    "quadtree_dur")

pip_borders_vec_res_res10 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_vec_res_res10) <- c("resolution", 
                                        "run", 
                                        "res")

pip_borders_ras_res_res10 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_ras_res_res10) <- c("resolution", 
                                        "run", 
                                        "res")

pip_borders_qt_res_res10 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_qt_res_res10) <- c("resolution", 
                                       "run", 
                                       "res")

res <- "res_10"

for (run in 1:30) {
  cat(res, " , running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res10, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res10, as.data.frame(random_pts, geom = "xy")) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_borders_vec_res_res10 <- rbind.data.frame(pip_borders_vec_res_res10, data.frame("resolution" = res,
                                                                                    "run" = run,
                                                                                    "vector_res" = pip_vector))
  
  pip_borders_ras_res_res10 <- rbind.data.frame(pip_borders_ras_res_res10, data.frame("resolution" = res,
                                                                                    "run" = run,
                                                                                    "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_borders_qt_res_res10 <- rbind.data.frame(pip_borders_qt_res_res10, data.frame("resolution" = res,
                                                                                  "run" = run,
                                                                                  "vector_res" = pip_quadtree_as_df))
  
  pip_borders_dur_res10 <- rbind(pip_borders_dur_res10, data.frame("resolution" = res,
                                                                 "run" = run,
                                                                 "vector_dur" = pip_vector_dur,
                                                                 "raster_dur" = pip_raster_dur,
                                                                 "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_borders_dur_res10, here("results", "pip_borders_dur_res10.csv"))
write.csv(pip_borders_vec_res_res10, here("results", "pip_borders_vec_res_res10.csv"))
write.csv(pip_borders_ras_res_res10, here("results", "pip_borders_ras_res_res10.csv"))
write.csv(pip_borders_qt_res_res10, here("results", "pip_borders_qt_res_res10.csv"))

###
pip_borders_dur_res25 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_borders_dur_res25) <- c("resolution", 
                                     "run", 
                                     "vector_dur", 
                                     "raster_dur", 
                                     "quadtree_dur")

pip_borders_vec_res_res25 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_vec_res_res25) <- c("resolution", 
                                        "run", 
                                        "res")

pip_borders_ras_res_res25 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_ras_res_res25) <- c("resolution", 
                                        "run", 
                                        "res")

pip_borders_qt_res_res25 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_qt_res_res25) <- c("resolution", 
                                        "run", 
                                        "res")

res <- "res_25"

for (run in 1:30) {
  cat(res, " , running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res25, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res25, as.data.frame(random_pts, geom = "xy")) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_borders_vec_res_res25 <- rbind.data.frame(pip_borders_vec_res_res25, data.frame("resolution" = res,
                                                                                      "run" = run,
                                                                                      "vector_res" = pip_vector))
  
  pip_borders_ras_res_res25 <- rbind.data.frame(pip_borders_ras_res_res25, data.frame("resolution" = res,
                                                                                      "run" = run,
                                                                                      "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_borders_qt_res_res25 <- rbind.data.frame(pip_borders_qt_res_res25, data.frame("resolution" = res,
                                                                                    "run" = run,
                                                                                    "vector_res" = pip_quadtree_as_df))
  
  pip_borders_dur_res25 <- rbind(pip_borders_dur_res25, data.frame("resolution" = res,
                                                                   "run" = run,
                                                                   "vector_dur" = pip_vector_dur,
                                                                   "raster_dur" = pip_raster_dur,
                                                                   "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_borders_dur_res25, here("results", "pip_borders_dur_res25.csv"))
write.csv(pip_borders_vec_res_res25, here("results", "pip_borders_vec_res_res25.csv"))
write.csv(pip_borders_ras_res_res25, here("results", "pip_borders_ras_res_res25.csv"))
write.csv(pip_borders_qt_res_res25, here("results", "pip_borders_qt_res_res25.csv"))

###
pip_borders_dur_res100 <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(pip_borders_dur_res100) <- c("resolution", 
                                     "run", 
                                     "vector_dur", 
                                     "raster_dur", 
                                     "quadtree_dur")

pip_borders_vec_res_res100 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_vec_res_res100) <- c("resolution", 
                                         "run", 
                                         "res")

pip_borders_ras_res_res100 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_ras_res_res100) <- c("resolution", 
                                         "run", 
                                         "res")

pip_borders_qt_res_res100 <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(pip_borders_qt_res_res100) <- c("resolution", 
                                        "run", 
                                        "res")

res <- "res_10"

for (run in 1:30) {
  cat(res, ", running:", run, "\n")
  
  start <- Sys.time()
  pip_vector <- terra::extract(parks_vector, random_pts)#On vector 
  end <- Sys.time()
  pip_vector_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_raster <- terra::extract(parks_raster_res100, random_pts) #On raster
  end <- Sys.time()
  pip_raster_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  start <- Sys.time()
  pip_quadtree <- quadtree::extract(parks_quadtree_res100, as.data.frame(random_pts, geom = "xy")) #On quadtree
  end <- Sys.time()
  pip_quadtree_dur <- as.numeric(difftime(end, start, units = "secs"))
  
  pip_borders_vec_res_res100 <- rbind.data.frame(pip_borders_vec_res_res100, data.frame("resolution" = res,
                                                                                      "run" = run,
                                                                                      "vector_res" = pip_vector))
  
  pip_borders_ras_res_res100 <- rbind.data.frame(pip_borders_ras_res_res100, data.frame("resolution" = res,
                                                                                      "run" = run,
                                                                                      "vector_res" = pip_raster))
  
  pip_quadtree_as_df <- as.data.frame(pip_quadtree)
  pip_quadtree_as_df$id <- seq_len(nrow(pip_quadtree_as_df))
  pip_quadtree_as_df <- pip_quadtree_as_df[, c(2,1)]
  
  pip_borders_qt_res_res100 <- rbind.data.frame(pip_borders_qt_res_res100, data.frame("resolution" = res,
                                                                                    "run" = run,
                                                                                    "vector_res" = pip_quadtree_as_df))
  
  pip_borders_dur_res100 <- rbind(pip_borders_dur_res100, data.frame("resolution" = res,
                                                                   "run" = run,
                                                                   "vector_dur" = pip_vector_dur,
                                                                   "raster_dur" = pip_raster_dur,
                                                                   "quadtree_dur" = pip_quadtree_dur))
  
  cat("Duration (vector, raster, quadtree): ", 
      pip_vector_dur,
      pip_raster_dur,
      pip_quadtree_dur, "\n")
}

#Write results to disk
write.csv(pip_borders_dur_res100, here("results", "pip_borders_dur_res100.csv"))
write.csv(pip_borders_vec_res_res100, here("results", "pip_borders_vec_res_res100.csv"))
write.csv(pip_borders_ras_res_res100, here("results", "pip_borders_ras_res_res100.csv"))
write.csv(pip_borders_qt_res_res100, here("results", "pip_borders_qt_res_res100.csv"))