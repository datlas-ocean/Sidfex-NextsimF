#!/bin/bash


# TIME
usage () 
{
cat << EOC
 **ERROR** Date format should be YYYYMMDD 
   Usage: ${0##*/} YYYYMMDD
EOC
exit 1
}


# DETECT IF date or gdate command should be used, based on which plateform
# Detect the platform
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS platform
    DATE_CMD="gdate"
    # Ensure gdate is installed
    if ! command -v gdate &> /dev/null; then
        echo "gdate could not be found. Please install it using 'brew install coreutils'."
        exit 1
    else
         echo "OK, we're on a MacOS platfeform. The gdate command was found. Everything is bon."
    fi
else
    # Assume Linux platform
    DATE_CMD="date"
    echo "Ok, we're not on a macOS plateform, so we assume it's a linux platfeform. The date was command is found.  Everything is bon."
fi
export DATE_CMD

# take date from command-line arguments with default today
todayDate=$(${DATE_CMD} +\%Y\%m\%d)
runDate=${1:-${todayDate}}

# check date format
[[ ${runDate} = [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]] || usage

# get date
analDate=$(${DATE_CMD} +\%Y\%m\%d --date="${runDate}") #MFG
echo ${todayDate} ${runDate} ${analDate}

source ./env_sidfex.src

# SCRIPTS
# get sidfex buoys
#echo "######################## CURRENTLY RUNNING: get_buoy_data-auto_DKRZ.sh (GET UPDATED BUOY POSITIONS) ########################"
#bash ${DIR_SCRIPTS}/get_buoy_data-auto_DKRZ.sh ${todayDate} ${runDate} ${analDate}

# get nextsim-f data from CMEMS
#echo "######################## CURRENTLY RUNNING: get_nextsim_files.sh (GET NEXTISIM SEA ICEHINCAST AND FORECAST) ########################"
#bash ${DIR_SCRIPTS}get_nextsim_files.sh ${todayDate} ${runDate} ${analDate}

# generate new mesh from the nextsim-f data
#echo "######################## CURRENTLY RUNNING: generate_arctic_mesh.sh ########################"
#bash ${DIR_SCRIPTS}generate_arctic_mesh.sh ${analDate}

# RUN HINDCAST
#echo "######################## CURRENTLY RUNNING: hindcast_seeds.sh (HINDCAST FOR INITIAL CONDITIONS AT MIDNIGHT)######"
#bash ${DIR_SCRIPTS}hindcast_seeds.sh ${analDate}

# initiate/generate seeding
#echo "######################## CURRENTLY RUNNING: generate_sidfex_seeding.sh ########################"
#bash ${DIR_SCRIPTS}generate_sidfex_seeding.sh ${analDate}

# RUN FORECAST
# propagate seeds based on the forecasted sea ice velocities 
#echo "######################## CURRENTLY RUNNING: propagate_sidfex_seed.sh (FORECAST) ########################"
#bash ${DIR_SCRIPTS}propagate_sidfex_seed.sh ${analDate}

# to sidfex - output file
#echo "######################## CURRENTLY RUNNING: to_sidfex.sh ########################"
bash ${DIR_SCRIPTS}to_sidfex.sh ${analDate}

# submit outputted ascii-files to the sidfex server
#echo "######################## CURRENTLY RUNNING: submit_file2sidfex.sh ########################"
#bash ${DIR_SCRIPTS}submit_file2sidfex.sh ${analDate}
