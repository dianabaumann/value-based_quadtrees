#Script to clean the logs

library(dplyr)
library(here)
here()

#Query latency
#Merge all query duration results into one csv.
#One plot (resolution, latency); for each resolution three boxes (one per query target: vector, raster, quadtree) each indicating how long the PiP-Query took
#The experiment ran on an spatially autocorrelated datasets (Berlin Parks)
#with 100K points being inserted into the query
#repeated 30 times each
pip_all_dur <- bind_rows(
  read.csv(here("results", "pip_all_dur_res5.csv")),
  read.csv(here("results", "pip_all_dur_res10.csv")),
  read.csv(here("results", "pip_all_dur_res25.csv"))
) %>%
  select(2:6) %>%
  mutate(across(3:5, ~ round(.x, 5)))

write.csv(pip_all_dur, here("results/cleaned", "pip_all_dur.csv"))

#The same experiment has been conducted on a non-spatially autocorrelated dataset (SimRa)
#One plot (query target, latency) with a box for each query target (vector, raster, qt)
pip_all_dur_simra_res5 <- read.csv(here("results", "pip_all_dur_simra_res5.csv")) %>%
  select(2:6) %>%
  mutate(across(3:5, ~ round(.x, 5)))

write.csv(pip_all_dur_simra_res5, here("results/cleaned",  "pip_all_dur_simra_res5.csv"))


#POSTPROCESS RESULTS

###TESTING
##Vector
pip_vec_res5 <- read.csv(here("results", "pip_vec_res5.csv"))
pip_vec_res5 <- subset.data.frame(pip_vec_res5[c(2:8)]) #remove first col
colnames(pip_vec_res5) <- c("resolution", "run", "pointID", "parkElement", "parkID", "parkLeisure", "parkName") #rename cols
pip_vec_res5[is.na(pip_vec_res5)] <- 0 #change NAs to 0
pip_vec_res5 <- pip_vec_res5[pip_vec_res5$parkID != 0, ] #keep hits only

pip_vec_res5_clean <- pip_vec_res5 %>%
  mutate(info_score = (parkLeisure != 0) + (parkName != 0)) %>%
  arrange(resolution, run, pointID, desc(info_score)) %>%
  distinct(resolution, run, pointID, .keep_all = TRUE) %>%
  select(-info_score)

##Raster:
pip_ras_res5 <- read.csv(here("results", "pip_ras_res5.csv"))
pip_ras_res5 <- subset.data.frame(pip_ras_res5[c(2:5)]) #remove first col
colnames(pip_ras_res5) <- c("resolution", "run", "pointID", "r_parkID") #rename cols
pip_ras_res5[is.na(pip_ras_res5)] <- 0 #change NAs to 0
pip_ras_res5 <- pip_ras_res5[pip_ras_res5$r_parkID != 0, ] #keep hits only

pip_ras_res10 <- read.csv(here("results", "pip_ras_res10.csv"))
pip_ras_res10 <- subset.data.frame(pip_ras_res10[c(2:5)]) #remove first col
colnames(pip_ras_res10) <- c("resolution", "run", "pointID", "r_parkID") #rename cols
pip_ras_res10[is.na(pip_ras_res10)] <- 0 #change NAs to 0
pip_ras_res10 <- pip_ras_res10[pip_ras_res10$r_parkID != 0, ] #keep hits only

pip_ras_res25 <- read.csv(here("results", "pip_ras_res25.csv"))
pip_ras_res25 <- subset.data.frame(pip_ras_res25[c(2:5)]) #remove first col
colnames(pip_ras_res25) <- c("resolution", "run", "pointID", "r_parkID") #rename cols
pip_ras_res25[is.na(pip_ras_res25)] <- 0 #change NAs to 0
pip_ras_res25 <- pip_ras_res25[pip_ras_res25$r_parkID != 0, ] #keep hits only

pip_ras_res100 <- read.csv(here("results", "pip_ras_res100.csv"))
pip_ras_res100 <- subset.data.frame(pip_ras_res100[c(2:5)]) #remove first col
colnames(pip_ras_res100) <- c("resolution", "run", "pointID", "r_parkID") #rename cols
pip_ras_res100[is.na(pip_ras_res100)] <- 0 #change NAs to 0
pip_ras_res100 <- pip_ras_res100[pip_ras_res100$r_parkID != 0, ] #keep hits only

##Quadtree:
pip_qt_res5 <- read.csv(here("results", "pip_qt_res5.csv"))
pip_qt_res5 <- subset.data.frame(pip_qt_res5[c(2:5)]) #remove first col
colnames(pip_qt_res5) <- c("resolution", "run", "pointID", "qt_parkID") #rename cols
pip_qt_res5[is.na(pip_qt_res5)] <- 0 #change NAs to 0
pip_qt_res5 <- pip_qt_res5[pip_qt_res5$qt_parkID != 0, ] #keep hits only

pip_qt_res10 <- read.csv(here("results", "pip_qt_res10.csv"))
pip_qt_res10 <- subset.data.frame(pip_qt_res10[c(2:5)]) #remove first col
colnames(pip_qt_res10) <- c("resolution", "run", "pointID", "qt_parkID") #rename cols
pip_qt_res10[is.na(pip_qt_res10)] <- 0 #change NAs to 0
pip_qt_res10 <- pip_qt_res10[pip_qt_res10$qt_parkID != 0, ] #keep hits only

pip_qt_res25 <- read.csv(here("results", "pip_qt_res25.csv"))
pip_qt_res25 <- subset.data.frame(pip_qt_res25[c(2:5)]) #remove first col
colnames(pip_qt_res25) <- c("resolution", "run", "pointID", "qt_parkID") #rename cols
pip_qt_res25[is.na(pip_qt_res25)] <- 0 #change NAs to 0
pip_qt_res25 <- pip_qt_res25[pip_qt_res25$qt_parkID != 0, ] #keep hits only

pip_qt_res100 <- read.csv(here("results", "pip_qt_res100.csv"))
pip_qt_res100 <- subset.data.frame(pip_qt_res100[c(2:5)]) #remove first col
colnames(pip_qt_res100) <- c("resolution", "run", "pointID", "qt_parkID") #rename cols
pip_qt_res100[is.na(pip_qt_res100)] <- 0 #change NAs to 0
pip_qt_res100 <- pip_qt_res100[pip_qt_res100$qt_parkID != 0, ] #keep hits only



pip_v <- pip_vec_res5_clean
pip_r <- pip_ras_res5
pip_q <- pip_qt_res5

pip_rq <- full_join(
  pip_r, pip_q,
  by = c("resolution", "run", "pointID"),
  suffix = c("_r", "_qt")
)

pip_vrq <- full_join(
  pip_v, pip_rq,
  by = c("resolution", "run", "pointID"),
  suffix = c("_v", "_rq")
)


#Accuracy scores:
tp_vr_res5 <- nrow(pip_vrq |> filter(parkID != 0, r_parkID != 0)) #true positives
fn_vr_res5 <- nrow(pip_vrq |> filter(parkID != 0, r_parkID == 0)) #false negatives

acc_vr_res5 <- tp_vr_res5 / (tp_vr_res5 + fn_vr_res5)

tp_vqt_res5 <- nrow(pip_vrq |> filter(parkID != 0, qt_parkID != 0)) #true positives
fn_vqt_res5 <- nrow(pip_vrq |> filter(parkID != 0, qt_parkID == 0)) #false negatives

acc_vqt_res5 <- tp_vqt_res5 / (tp_vqt_res5 + fn_vqt_res5)


#res10:
pip_v_res10 <- pip_vec_res5_clean
pip_v_res10$resolution = "res_10" #change value for join

pip_r_res10 <- pip_ras_res10
pip_q_res10 <- pip_qt_res10

pip_rq_res10 <- full_join(
  pip_r_res10, pip_q_res10,
  by = c("resolution", "run", "pointID"),
  suffix = c("_r", "_qt")
)

pip_vrq_res10 <- full_join(
  pip_v_res10, pip_rq_res10,
  by = c("resolution", "run", "pointID"),
  suffix = c("_v", "_rq")
)


#Accuracy scores:
tp_vr_res10 <- nrow(pip_vrq_res10 |> filter(parkID != 0, r_parkID != 0)) #true positives
fn_vr_res10 <- nrow(pip_vrq_res10 |> filter(parkID != 0, r_parkID == 0)) #false negatives

acc_vr_res10 <- tp_vr_res10 / (tp_vr_res10 + fn_vr_res10)

tp_vqt_res10 <- nrow(pip_vrq_res10 |> filter(parkID != 0, qt_parkID != 0)) #true positives
fn_vqt_res10 <- nrow(pip_vrq_res10 |> filter(parkID != 0, qt_parkID == 0)) #false negatives

acc_vqt_res10 <- tp_vqt_res10 / (tp_vqt_res10 + fn_vqt_res10)


#res25:
pip_v_res25 <- pip_vec_res5_clean
pip_v_res25$resolution = "res_25" #change value for join

pip_r_res25 <- pip_ras_res25
pip_q_res25 <- pip_qt_res25

pip_rq_res25 <- full_join(
  pip_r_res25, pip_q_res25,
  by = c("resolution", "run", "pointID"),
  suffix = c("_r", "_qt")
)

pip_vrq_res25 <- full_join(
  pip_v_res25, pip_rq_res25,
  by = c("resolution", "run", "pointID"),
  suffix = c("_v", "_rq")
)

pip_vrq_res25[is.na(pip_vrq_res25)] <- 0 #change NAs to 0


#Accuracy scores:
tp_vr_res25 <- nrow(pip_vrq_res25 |> filter(parkID != 0, r_parkID != 0)) #true positives
fn_vr_res25 <- nrow(pip_vrq_res25 |> filter(parkID != 0, r_parkID == 0)) #false negatives

acc_vr_res25 <- tp_vr_res25 / (tp_vr_res25 + fn_vr_res25)

tp_vqt_res25 <- nrow(pip_vrq_res25 |> filter(parkID != 0, qt_parkID != 0)) #true positives
fn_vqt_res25 <- nrow(pip_vrq_res25 |> filter(parkID != 0, qt_parkID == 0)) #false negatives

acc_vqt_res25 <- tp_vqt_res25 / (tp_vqt_res25 + fn_vqt_res25)





#res100:
pip_v_res100 <- pip_vec_res5_clean
pip_v_res100$resolution = "res_100" #change value for join

pip_r_res100 <- pip_ras_res100
pip_q_res100 <- pip_qt_res100

pip_rq_res100 <- full_join(
  pip_r_res100, pip_q_res100,
  by = c("resolution", "run", "pointID"),
  suffix = c("_r", "_qt")
)

pip_vrq_res100 <- full_join(
  pip_v_res100, pip_rq_res100,
  by = c("resolution", "run", "pointID"),
  suffix = c("_v", "_rq")
)

pip_vrq_res100[is.na(pip_vrq_res100)] <- 0 #change NAs to 0

#Accuracy scores:
tp_vr_res100 <- nrow(pip_vrq_res100 |> filter(parkID != 0, r_parkID != 0)) #true positives
fn_vr_res100 <- nrow(pip_vrq_res100 |> filter(parkID != 0, r_parkID == 0)) #false negatives

acc_vr_res100 <- tp_vr_res100 / (tp_vr_res100 + fn_vr_res100)

tp_vqt_res100 <- nrow(pip_vrq_res100 |> filter(parkID != 0, qt_parkID != 0)) #true positives
fn_vqt_res100 <- nrow(pip_vrq_res100 |> filter(parkID != 0, qt_parkID == 0)) #false negatives

acc_vqt_res100 <- tp_vqt_res100 / (tp_vqt_res100 + fn_vqt_res100)