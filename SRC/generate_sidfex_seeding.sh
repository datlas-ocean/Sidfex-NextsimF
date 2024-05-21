#!/bin/bash

# TIME
# get today and not one day before today as they did
analDate=$1 
echo "analdate $analDate"
yesterdayDate=$( ${DATE_CMD} +%Y%m%d --date="${analDate} 1 day ago" ) # Initial seeding date
propagateDate=$(${DATE_CMD} +%Y-%m-%d --date="${analDate}") # analDate, but different format



# SYMBOLIC LINK
# Link the text file produced at step 1 with buoys ID and positions to the generic name sidfexloc.dat in same directory as the python script.
# If working: ./sidfexloc.dat should have copied id, lat, lon from ${DIR_buoy}sidfexloc_out_${analDate}.dat, and not be empty
ln -sf ${DIR_buoy}/sidfexloc_out_${analDate}.dat ./sidfexloc.dat # When hindcast is active
#ln -sf ${DIR_buoy}/sidfexloc_${analDate}.dat ./sidfexloc.dat # If hindcast is not used



# erase file if already exist
if [ -f "${DIR_INITSEED}/sitrack_seeding_sidfex_${yesterdayDate}_00.nc" ]; then
rm -f "${DIR_INITSEED}/sitrack_seeding_sidfex_${yesterdayDate}_00.nc"
fi

# RUN
# Generate seeds: sidfex seeds, but for old version
#${PY_CMD} ${DIR_gnrate_mesh}generate_sidfex_seeding.py -d '1996-12-15_00:00:00' --lsidfex 1  -k 0 -S 5 

# Generate seeds: fake seeds (debugseeds)
#${PY_CMD} ${DIR_gnrate_mesh}generate_idealized_seeding.py -d ${propagateDate}_00:00:00

# Generate seeds: sidfex buoys for updated sitrack (for arctic mesh) #MFG
${PY_CMD} ${DIR_gnrate_mesh}generate_sidfex_seeding_vol2.py -d ${propagateDate}_00:00:00  --lsidfex 1
mv ./nc/* ${DIR_INITSEED}/
