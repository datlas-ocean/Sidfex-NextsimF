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
if [[ ! "$runDate" =~ ^[0-9]{8}$ ]]; then
    usage
fi

# TIME
# get date of today 
analDate=$1
echo $analDate

# Extract the month (MM)
MM=${analDate:4:2}

# Extract the year (YY)
YYYY=${analDate:0:4}

source ./env_sidfex.src 

# copy our sidfex forecasts from FRAZILO to SUMMER storage
#echo "copy our sidfex forecasts from FRAZILO to SUMMER storage"
scp2CAL1 "${DIR_OUTsidfex}*.txt" /mnt/summer/DATA_MEOM/DATA_SET/SIDFEX-SeaIce-buoys/igedatlas-forecast/

# copy nextsimf files from FRAZILO to SUMMER storage
echo "copy nextsimf files from FRAZILO to SUMMER storage"
scp2CAL1 "${DIR_nextsim}????????_hr-nersc-MODEL-nextsimf-ARC-b${analDate}-fv00.0.nc" /mnt/summer/DATA_MEOM/DATA_SET/NEXTSIM-F/${YYYY}/${MM}/

# then clean all (ask for confirmation)

# Prompt for confirmation
echo "Are you sure you want to delete the directory ${DIR_workdir}? (yes/no)"
read confirmation

# Check the user input
if [[ "$confirmation" == "yes" ]]; then
    # Proceed with deletion
#    rm -fr "${DIR_workdir}"
    echo "Directory ${DIR_workdir} has been deleted."
else
    echo "Deletion aborted."
fi

# clean nc, npz, seed temporary directories
cd ${DIR_sidfex}
echo "clean"
echo  ${DIR_sidfex}
rm -fr ./nc ./seed ./npz ./figs ./sidfexloc.dat

