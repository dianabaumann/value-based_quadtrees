import osmnx as ox
from osmnx import features

tags = {
    "leisure": ["park", "garden"],
    "landuse": ["forest"],
}
green_areas = ox.features_from_place("Berlin, Germany", tags)
green_areas = green_areas[green_areas.geom_type.isin(["Polygon", "MultiPolygon"])]

green_areas.to_file("../parks_berlin.gpkg", layer="green_areas", driver="GPKG")