#! /bin/bash

#####################################################################
#                                                                   #
# Shell script to download the files of neXtSIM-F from CMEMS        #
#                                                                   #
# NOTICE: The very first run requires manual login to copernicus \  #
#         marine in the terminal when running this script. Thus  \  #
#         need to uncomment line 8 in get_nextsim.py, then comment \#
#         it for later runs.                                        #
#                                                                   #
# Download for today's date:                                        #
#    - can be modified in the python script                         #
#    - format:YYYYMMDD                                              #
#                                                                   #
#  - Maren Friele Grung, 2024                                       #
#####################################################################

# to avoid the error: OSError: [Errno 24] Too many open files:
ulimit -n 1024

# TIME
# get today
runDate=$1
todayDate=$2
analDate=$3 
echo "analdate $analDate"

yesterdayDate=$( date +%Y%m%d --date="${analDate} 1 day ago" )

mkdir -p ${DIR_workdir} ${DIR_nextsim}


# DOWNLOAD FROM CMEMS
echo -e "\nDownloading forecasting files of neXtSIM-F from CMEMS website...\n" # MFG
${PY_CMD} ${DIR_SCRIPTS}get_nextsim.py ${analDate} ${DIR_nextsim} # MFG

# FUNCTION TO GET DATE OF THE LAST FORECAST FILE
get_date_of_latest_nextsimf_file() {
    local last_file
    last_file=$(ls -t "$DIR_nextsim"/*.nc | head -n 1)  # Get the most recent .nc file
    local filename
    filename=$(basename "$last_file")  # Extract just the filename

    if [[ $filename =~ ([0-9]{8})_.*-b([0-9]{8}).*\.nc ]]; then
        local last_forecast_date=${BASH_REMATCH[1]}
        echo "Last Forecast Date: $last_forecast_date"

        export LAST_FORECAST_DATE="$last_forecast_date"
    fi
}

get_date_of_latest_nextsimf_file


# CONCATENATE FILES
ncrcat -v vxsi,vysi,siconc,sithick ${DIR_nextsim}/*_hr-nersc-MODEL-nextsimf-ARC-b${analDate}-fv00.0.nc -o ${DIR_nextsim}/${yesterdayDate}_${LAST_FORECAST_DATE}_hr-nersc-MODEL-nextsimf-concatenated-ARC-b${analDate}-fv00.0.nc


#
#
#

# COUNT NUMBER OF FILES IN DIRECTORY AND SEND EMAIL WARNING IF NOT 11 FILES

#file_count=$(ls -1 "$DIR_nextsim"/*.nc 2>/dev/null | wc -l)

#echo -e "\nTotal number of neXtSIM-F files is ${file_count}\n"

# complain if no valid nextsim files counted for today
#if [ ${file_count} -ne 11 ] ; then
#
#   echo "**ERROR** no neXtSIM-F forecasting files found for this date"
#
#   # if today's date (likely crontab initiated) then send an email warning
#   if [[ ${runDate} == ${todayDate} ]] ; then
#
#      # define email details
#      subject="neXtSIM-F download from CMEMS WARNING : ${file_count} files for ${analDate}"
#      EMAIL_ID="maren-friele.grung@univ-grenoble-alpes.fr"
#      textfile="${DIR_nextsim}/email_warning_neXtSIM-F.txt" #CReate own folder for all email warnings?
#      cat << EOC > ${textfile}
#Hi,
#Your neXtSIM-F downloading job from CMEMS has not been downloading all forecsting files for today's analysis day ${analDate}.\
#The number of files in directory is currently ${file_count}, not 11 (1 day hindcast, 9 days forecast and 1 concatenated file).
#
#Best
#
#EOC

      # send the email
      #echo "Sending warning email to ${EMAIL_ID}"
      #/usr/local/bin/mutt -s "${subject}" -i ${textfile} -x -z -n ${EMAIL_ID} << END || status="failed"
#END

#   fi # today
#
#   exit 9
#
#fi # no buoys

