#/bin/bash

# DIRECTORIES
source ./env_sidfex.src

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

runDate=${1:-${todayDate}}

# check date format
[[ ${runDate} = [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]] || usage

# get date
analDate=$(${DATE_CMD} +\%Y\%m\%d --date="${runDate}") #MFG
#analDate=20240531
echo "=== We will be working on bulletin's date : ${analDate}"

# DIRECTORIES updated w/ date
source ./env_sidfex.src

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
    #echo "concatenated_file $concatenated_file"
    local filename
    filename=$(basename "$concatenated_file")  # Extract just the filename
    #echo "filename $filename"
    # filename 20240527_20240605_hr-nersc-MODEL-nextsimf-concatenated-ARC-b20240528-fv00.0.nc

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
# get sidfex buoys
echo "######################## CURRENTLY RUNNING: get_buoy_data-auto_DKRZ.sh (GET UPDATED BUOY POSITIONS) ########################"
bash ${DIR_SCRIPTS}/get_buoy_data-auto_DKRZ.sh ${todayDate} ${runDate} ${analDate}

# get nextsim-f data from CMEMS
#echo "######################## CURRENTLY RUNNING: get_nextsim_files.sh (GET NEXTISIM SEA ICEHINCAST AND FORECAST) ########################"
bash ${DIR_SCRIPTS}get_nextsim_files.sh ${todayDate} ${runDate} ${analDate}

# Check number of files downloaded
file_count=$(count_files)

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

  # only submit to server if the full forecast is done
  if [ "$file_count" -eq 11 ]; then
	# submit outputted ascii-files to the sidfex server
	echo "######################## CURRENTLY RUNNING: submit_file2sidfex.sh ########################"
	bash ${DIR_SCRIPTS}submit_file2sidfex.sh ${analDate}
  else
      # Log analysis date and file count
      echo "$(date '+%Y-%m-%d') Forecast Analysis Date: $analDate, File Count: $file_count" >> "$LOG_FILE"
  fi

else
    echo "Less than 5 files downloaded. Skipping forecast."

    # Log analysis date and file count
    echo "$(date '+%Y-%m-%d') Forecast Analysis Date: $analDate, File Count: $file_count" >> "$LOG_FILE"
fi

