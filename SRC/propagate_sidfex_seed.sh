#!/bin/bash

# TIME
# get today and not one day before today as they did
analDate=$1 
yesterdayDate=$( ${DATE_CMD} +%Y%m%d --date="${analDate} 1 day ago") # Initial seeding date
finalForecastDate=$( ${DATE_CMD} +%Y%m%d --date="${analDate} 8 day") # Date for last forecasted day
echo "analdate $analDate"

# Concatenated 10 days nextsim file (-i input) automated
${PY_CMD} ${DIR_sitrack}si3_part_tracker.py -i ${DIR_nextsim}/${yesterdayDate}_${finalForecastDate}_hr-nersc-MODEL-nextsimf-concatenated-ARC-b${analDate}-fv00.0.nc \
                      -m ${DIR_gnrate_mesh}/coordinates_mesh_mask.nc \
                      -s ${DIR_INITSEED}sitrack_seeding_sidfex_${analDate}_00.nc \
                      -g A -R 3 -u vxsi -v vysi -p 12


