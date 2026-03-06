# quadtree-on-raster-code
Code base repo for the paper "Spatial Analysis on Value-Based Quadtrees of Rasterized Vector Data" submitted for MDM'26.

Abstract:
Mobility data science offers insights into the complex interconnections of spatial data of moving objects and their surroundings, often based on a combination of vector and raster data. For example, mobility traces are usually in vector format, weather data are often in raster format. Yet, available spatial analysis tools for exploratory data science push data scientists towards one or the other, providing only limited support for the respective other.
    
In this paper, we contribute to this problem space with a value-based quadtree index, which serves as a bridge builder to support joint spatial analysis on vector and raster data leveraging their unique autocorrelation property. We achieve a 90% reduction in median Point-in-Polygon (PiP) query latency, while keeping the accuracy of query responses at equal level.


Repo Organization:
- Scripts: main.R includes all the pipeline steps organized in separate R-scripts.
- Data: holds raw and clean data including instructions on how to get the publicly available data including the results from the individual scripts (need to be unpacked).
- Results: place holder to store results from the data pipeline.