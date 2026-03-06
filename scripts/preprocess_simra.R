library(terra)
library(gpkg)
library(dplyr)
library(sf)
library(here)
here()

simra_dir <- here("data", "raw", "simra-data")

files <- list.files(
  path = simra_dir,
  recursive = TRUE,
  full.names = TRUE
)

process_simra_files <- function(file) {
  lines <- readLines(file, warn = FALSE)
  
  lines <- lines[-(1:7)] #data begins at line 7 in the log
  
  points <- strsplit(lines, ",")
  
  points <- Filter(function(p) nchar(p[1]) != 0, points)
  
  points <- lapply(points, function(p) p[c(1, 2, 6)])
  
  points <- lapply(points, function(p) {
    p[1:2] <- sapply(p[1:2], function(x) {
      sprintf("%-7s", substr(x, 1, 8))
    })
    p[1:2] <- gsub(" ", "0", p[1:2])
    p
  })
  
  df <- do.call(rbind, lapply(points, function(p) {
    data.frame(
      lat = as.numeric(p[1]),
      lon = as.numeric(p[2]),
      ts  = as.numeric(p[3])
    )
  }))
  
  df <- df[!is.na(df$lat) & !is.na(df$lon), ]
  if (nrow(df) < 2) return(NULL)
  
  start_time <- as.POSIXct(min(df$ts) / 1000, origin = "1970-01-01", tz = "UTC")
  end_time   <- as.POSIXct(max(df$ts) / 1000, origin = "1970-01-01", tz = "UTC")
  
  geom <- st_linestring(as.matrix(df[, c("lon", "lat")]))
  
  st_sf(
    file_name  = basename(file),
    start_time = start_time,
    end_time   = end_time,
    num_points = nrow(df),
    geometry   = st_sfc(geom, crs = 4326)
  )
}

#traj_list <- lapply(files, process_simra_files)

n_files <- length(files)
counter <- 0

traj_list <- vector("list", n_files)

for (i in seq_along(files)) {
  traj_list[[i]] <- process_simra_files(files[[i]])
  counter <- counter + 1
  
  if (counter %% 10 == 0 || counter == n_files) {
    message(counter, " / ", n_files, " files processed")
  }
}

all_trajectories <- do.call(rbind, traj_list)

simra_output <- st_write(all_trajectories, "data/cleaned/simra_output.gpkg")

