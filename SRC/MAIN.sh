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



source ./env_sidfex.src

# take date from command-line arguments with default today
todayDate=$(${DATE_CMD} +\%Y\%m\%d)

runDate=${1:-${todayDate}}

# check date format
[[ ${runDate} = [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]] || usage

# get date
analDate=$(${DATE_CMD} +\%Y\%m\%d --date="${runDate}") #MFG

echo "=== We will be working on bulletin's date : ${analDate}"

source ./env_sidfex.src

# SCRIPTS
# get sidfex buoys
echo "######################## CURRENTLY RUNNING: get_buoy_data-auto_DKRZ.sh (GET UPDATED BUOY POSITIONS) ########################"
bash ${DIR_SCRIPTS}/get_buoy_data-auto_DKRZ.sh ${todayDate} ${runDate} ${analDate}

# get nextsim-f data from CMEMS
#echo "######################## CURRENTLY RUNNING: get_nextsim_files.sh (GET NEXTISIM SEA ICEHINCAST AND FORECAST) ########################"
#bash ${DIR_SCRIPTS}get_nextsim_files.sh ${todayDate} ${runDate} ${analDate}

# generate new mesh from the nextsim-f data
#echo "######################## CURRENTLY RUNNING: generate_arctic_mesh.sh ########################"
#bash ${DIR_SCRIPTS}generate_arctic_mesh.sh ${analDate}

# RUN HINDCAST
echo "######################## CURRENTLY RUNNING: hindcast_seeds.sh (HINDCAST FOR INITIAL CONDITIONS AT MIDNIGHT)######"
bash ${DIR_SCRIPTS}hindcast_seeds.sh ${analDate}

#initiate/generate seeding
echo "######################## CURRENTLY RUNNING: generate_sidfex_seeding.sh ########################"
bash ${DIR_SCRIPTS}generate_sidfex_seeding.sh ${analDate}

# RUN FORECAST
# propagate seeds based on the forecasted sea ice velocities 
echo "######################## CURRENTLY RUNNING: propagate_sidfex_seed.sh (FORECAST) ########################"
bash ${DIR_SCRIPTS}propagate_sidfex_seed.sh ${analDate}

# to sidfex - output file
echo "######################## CURRENTLY RUNNING: to_sidfex.sh ########################"
bash ${DIR_SCRIPTS}to_sidfex.sh ${analDate}

# submit outputted ascii-files to the sidfex server
#echo "######################## CURRENTLY RUNNING: submit_file2sidfex.sh ########################"
#bash ${DIR_SCRIPTS}submit_file2sidfex.sh ${analDate}
