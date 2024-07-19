#!/bin/bash

usage1 () 
{
cat << EOC
 **ERROR** You should provide the bulletin's date as an argument
   Usage: ${0##*/} YYYYMMDD
EOC
exit 1
}
usage2 () 
{
cat << EOC
 **ERROR** Provided bulletin's date format should be YYYYMMDD 
   Usage: ${0##*/} YYYYMMDD
EOC
exit 1
}


# Check if an argument is provided
if [ -z "$1" ]; then
    usage1
fi
# Validate the format of runDate
#if [[ ! "$runDate" =~ ^[0-9]{8}$ ]]; then
#    usage2
#fi

# TIME
# get date of today 
analDate=$1
echo $analDate

# Extract the month (MM)
MM=${analDate:4:2}

# Extract the year (YY)
YYYY=${analDate:0:4}

source ./env_sidfex.src 
DIR_sidfex_summer=~/../../SUMMER/DATA_MEOM/DATA_SET/SIDFEX-SeaIce-buoys
DIR_nsim_summer=~/../../SUMMER/DATA_MEOM/DATA_SET/NEXTSIM-F/${YYYY}/${MM}


# copy our sidfex forecasts from FRAZILO to SUMMER storage
echo "copy our sidfex forecasts from FRAZILO to SUMMER storage"
#scp2CAL1 "${DIR_OUTsidfex}*.txt" /mnt/summer/DATA_MEOM/DATA_SET/SIDFEX-SeaIce-buoys/igedatlas-forecast/
cp ${DIR_OUTsidfex}*.txt "${DIR_sidfex_summer}/igedatlas-forecast/"

# copy nextsimf files from FRAZILO to SUMMER storage
echo "copy nextsimf files from FRAZILO to SUMMER storage"
if [ ! -d "$DIR_nsim_summer" ]; then
	mkdir -p $DIR_nsim_summer
fi
cp ${DIR_nextsim}????????_hr-nersc-MODEL-nextsimf-ARC-b${analDate}-fv00.0.nc "${DIR_nsim_summer}"

# copy forecast outputs of sitrack (.nc-files) from FRAZILO to SUMMER storage
echo "copy our sidfex forecasts from FRAZILO to SUMMER storage"
cp ${DIR_NC_FCST}data_A-grid_????????_nersc_tracking_sidfex_seeding_1h_${analDate}h00_????????h00_3km.nc "${DIR_sidfex_summer}/nc/"

# then clean all (ask for confirmation)

# Prompt for confirmation
#echo "Are you sure you want to delete the directory ${DIR_workdir}? (yes/no)"
#read confirmation

# Check the user input
#if [[ "$confirmation" == "yes" ]]; then 
    # Proceed with deletion
#    rm -fr "${DIR_workdir}"
#    echo "Directory ${DIR_workdir} has been deleted."
#else
#    echo "Deletion aborted."
#fi

# Remove workdir without asking
rm -fr "${DIR_workdir}"


# clean nc, npz, seed temporary directories
cd ${DIR_sidfex}
echo "clean"
#echo  ${DIR_sidfex}
rm -fr ./nc ./seed ./npz ./figs ./sidfexloc.dat

