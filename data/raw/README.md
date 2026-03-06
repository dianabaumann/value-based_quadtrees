# How to get and pre-process the datasets
This directory is structured by the datasets used:
- simra: contains the link to the raw data due to the large amount
- parks: contains the origins of the parks data

Each directory holds scripts for downloading and/or pre-processing of the data so that it can be further injected into the prototype.

## Parks Data
- Getting parks data from OpenStreetMap (OSM) is done with the script `parks/download-parks-data.py`. The only Python script in this project.
- During the preprocessing, not needed columns were removed from the geopackage. The code can be found in `parks/preprocess_parks.R`.

## SimRa Data
- SimRa data can be obtained from the link in `simra/simra-data-source.txt`.
- The data is organized in separate folders named "01" to "12", for the months January to December. 

### Preprocessing SimRa:
- Remove data that is not from 2024, keep only 01/24 to 12/24.
- Remove corrupt files that are listed in `filelist-corrupt-simra-logs.txt` with `remove-corrupt-files.bash`.
- For each trajectory (log file), keep only the points' coordinates and timestamps with `preprocess_simra.R`.
- Cleaned data can be found in `../clean`