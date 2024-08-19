#!/bin/bash

# DIRECTORIES
source /home/maren/DEV/Sidfex-NextsimF/SRC/env_sidfex.src

# TIME
usage () 
{
cat << EOC
 **ERROR** Date format should be YYYYMMDD 
   Usage: ${0##*/} YYYYMMDD
EOC
exit 1
}

# take date from command-line arguments with default today
todayDate=$(${DATE_CMD} +\%Y\%m\%d)
echo $todayDate
runDate=${1:-${todayDate}}
echo $todayDate
# check date format
[[ ${runDate} = [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]] || usage

# get date
analDate=$(${DATE_CMD} +\%Y\%m\%d --date="${runDate}") #MFG
echo "=== We will be working on bulletin's date : ${analDate}"

# DIRECTORIES updated w/ date
source /home/maren/DEV/Sidfex-NextsimF/SRC/env_sidfex.src

# FUNCTIONS RELATED TO HOW MANY NEXTSIM-F FILES ARE DOWNLOADED AND DATE
# Function to count files
count_files() {
    local file_count
    file_count=$(ls -1 "$DIR_nextsim"/*.nc 2>/dev/null | wc -l)
    echo "$file_count"
}

# Function to retrieve dates from the concatenated file's name
get_forecasting_dates_from_concatenated_file() {
    local concatenated_file
    concatenated_file=$(ls -t "$DIR_nextsim"/*.nc | head -n 1)  # Get the most recent .nc file
    local filename
    filename=$(basename "$concatenated_file")  # Extract just the filename

    if [[ $filename =~ ([0-9]{8})_([0-9]{8})_.*-b([0-9]{8}).*\.nc ]]; then
        #local hindcast_date=${BASH_REMATCH[1]}
        local forecast_end_date=${BASH_REMATCH[2]}
        #local forecast_analysis_date=${BASH_REMATCH[3]}

        export FORECAST_END_DATE="$forecast_end_date"
    else
        echo "No matching concatenated file found or incorrect filename format."
    fi
}



# SCRIPTS
# get sidfex buoys; get the number of buoys downloaded
echo "######################## CURRENTLY RUNNING: get_buoy_data-auto_DKRZ.sh (GET UPDATED BUOY POSITIONS) ########################"
bash ${DIR_SCRIPTS}/get_buoy_data-auto_DKRZ.sh ${todayDate} ${runDate} ${analDate}
#source ${DIR_SCRIPTS}/get_buoy_data-auto_DKRZ.sh ${todayDate} ${runDate} ${analDate}
#nB=$numBuoys
#echo "number of Buoys: $nB"

# get nextsim-f data from CMEMS
echo "######################## CURRENTLY RUNNING: get_nextsim_files.sh (GET NEXTISIM SEA ICEHINCAST AND FORECAST) ########################"
bash ${DIR_SCRIPTS}get_nextsim_files.sh ${todayDate} ${runDate} ${analDate}

# Check number of files downloaded
file_count=$(count_files)

# log if no buoys are active or if not all neXtSIM-F files are downloaded
if [ "$file_count" -le 10 ]; then
    # Log analysis date and file count
    echo "$(date '+%Y-%m-%d') Forecast Analysis Date: $analDate, File Count: $file_count" >> "$LOG_FILE"
fi

if [ "$file_count" -ge 6 ] && [ "$file_count" -le 11 ]; then

  echo "Retrieving forecasting dates from the concatenated file's name..."
  get_forecasting_dates_from_concatenated_file

  # generate new mesh from the nextsim-f data
  #echo "######################## CURRENTLY RUNNING: generate_arctic_mesh.sh ########################"
  #bash ${DIR_SCRIPTS}generate_arctic_mesh.sh ${analDate}

  # RUN HINDCAST
  echo "######################## CURRENTLY RUNNING: hindcast_seeds.sh (HINDCAST FOR INITIAL CONDITIONS AT MIDNIGHT)######"
  bash ${DIR_SCRIPTS}hindcast_seeds.sh ${analDate} ${FORECAST_END_DATE}

  #initiate/generate seeding
  echo "######################## CURRENTLY RUNNING: generate_sidfex_seeding.sh ########################"
  bash ${DIR_SCRIPTS}generate_sidfex_seeding.sh ${analDate}

  # RUN FORECAST
  # propagate seeds based on the forecasted sea ice velocities 
  echo "######################## CURRENTLY RUNNING: propagate_sidfex_seed.sh (FORECAST) ########################"
  bash ${DIR_SCRIPTS}propagate_sidfex_seed.sh ${analDate} ${FORECAST_END_DATE}

  # to sidfex - output file
  echo "######################## CURRENTLY RUNNING: to_sidfex.sh ########################"
  bash ${DIR_SCRIPTS}to_sidfex.sh ${analDate} ${FORECAST_END_DATE}

  # submit outputted ascii-files to the sidfex server
  echo "######################## CURRENTLY RUNNING: submit_file2sidfex.sh ########################"
  bash ${DIR_SCRIPTS}submit_file2sidfex.sh ${analDate}

  # clean on frazilo and move files to summer storage
  echo "######################## CURRENTLY RUNNING: finalcleaningFRAZILO.sh  ########################"
  bash ${DIR_SCRIPTS}finalcleaningFRAZILO.sh ${analDate}

else
    echo "Less than 5 files downloaded. Skipping forecast."

    # Log analysis date and file count
    #echo "$(date '+%Y-%m-%d') Forecast Analysis Date: $analDate, File Count: $file_count" >> "$LOG_FILE"
fi

# log if no buoys are active or if not all neXtSIM-F files are downloaded
#if [[ "$numBuoys" -eq 0 ] || [ "$file_count" -le 10 ]]; then
#if [ "$numBuoys" -eq 0 ]; then
        #echo "number of Buoys: $numBuoys"
    # Log analysis date and file count
#    echo "$(date '+%Y-%m-%d') Forecast Analysis Date: $analDate, File Count: $file_count, Buoy Count: $numBuoys" >> "$LOG_FILE"
    #echo "$(date '+%Y-%m-%d') Forecast Analysis Date: $analDate, Buoy Count: $numBuoys" >> "$LOG_FILE"
#fi
