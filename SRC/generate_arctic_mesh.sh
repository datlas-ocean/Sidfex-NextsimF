#! /bin/bash
# This script run the python tool xy_arctic_to_meshmask.py from sitrack to generate a meshmask if needed (to be run only once)

# get today and not one day before today as they did
analDate=$1 # $( gdate +%Y%m%d  )
yesterdayDate=$( date +%Y%m%d --date="${analDate} 1 day ago")
finalForecastDate=$( date +%Y%m%d --date="${analDate} 8 day")
echo "analdate $analDate"
echo "yesterdayDate $yesterdayDate"
echo "forecastEndDate $finalForecastDate"

# test for concatenated .nc of the nextsim files
${PY_CMD} ${DIR_gnrate_mesh}xy_arctic_to_meshmask.py \
    -i ${DIR_nextsim}${yesterdayDate}_${finalForecastDate}_hr-nersc-MODEL-nextsimf-concatenated-ARC-b${analDate}-fv00.0.nc \
    -o ${DIR_gnrate_mesh}/coordinates_mesh_mask.nc
