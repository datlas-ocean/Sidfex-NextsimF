#! /bin/bash

#set -ax

#############################################################
#                                                           #
#  Script to get data for calculating SIDFEx trajectories   #
#  using AWI's IABP buoy target details file                #
#                                                           #
#  Date specified as command-line argument                  #
#     - format: YYYYMMDD                                    #
#     - default today                                       #
#                                                           #
#  Assumes today's forecast meaning initial buoy details    #
#  needed for yesterday's analysis                          #
#                                                           #
#  Ed Blockley, July 2018                                   #
#  Edited by Stephanie Leroux 2023                          #
#  Edited by Maren Friele Grung 2024                        #
#                                                           #
# NOTE: it works either with the linux 'date' command 
# (but not with the macOS date command) .
# On a mac you should install gdate (brew install coreutils)                     
# Currently, the script runs with a generic $DATE_CMD command that
# takes date on a linux plateform and gdate on a MacOS plateform 
#############################################################

# SLX get today and not one day before today as they did
runDate=$1
todayDate=$2
analDate=$3 
echo "analdate $analDate"


mkdir -p ${DIR_workdir} ${DIR_buoy}
mkdir -p ${DIR_INITSEED}
outputfile=sidfexloc

# SLX
# erase file if already exist
if [ -f "${DIR_buoy}/${outputfile}_${analDate}.dat" ]; then
rm -f "${DIR_buoy}/${outputfile}_${analDate}.dat"
fi
# create empty one
touch "${DIR_buoy}/${outputfile}_${analDate}.dat"

############################################
# create buoy list from AWI file
#
buoyList=${DIR_buoy}/buoy_list.txt
cd ${DIR_buoy}
echo -e "\nDownloading buoy target details from AWI website...\n" 
wget https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx_index/SIDFEx_targettable.txt # MFG
cat SIDFEx_targettable.txt | grep "^[0-9]" > ${buoyList}_tmp
[[ -f ${buoyList} ]] && rm ${buoyList}

# loop over buoy lines and decide if valid
while read line; do
   # extract buoy details from line
   buoyID=$( echo ${line} | cut -d " " -f 1 )
   buoyStartYEAR=$( echo ${line} | cut -d " " -f 9 )
   buoyStartDAY=$( echo ${line} | cut -d " " -f 10 )
   buoyEndYEAR=$( echo ${line} | cut -d " " -f 11 )
   buoyEndDAY=$( echo ${line} | cut -d " " -f 12 )

   # convert day of year to real buoy start and end dates
   # (NB. the division by 1 with "bc" is the same as a "floor" operation)
   buoyStart=$( ${DATE_CMD} --date="${buoyStartYEAR}-01-01 +$(echo ${buoyStartDAY}/1 | bc) days" +"%Y%m%d" )
   if [[ ${buoyEndYEAR} != "NaN" && ${buoyEndDAY} != "NaN" ]] ; then
      buoyEnd=$( ${DATE_CMD} --date="${buoyEndYEAR}-01-01 +$(echo ${buoyEndDAY}/1 | bc) days" +"%Y%m%d" )
   else
      # dummy future date
      buoyEnd=21000101
   fi  

   # if the buoy is valid for our current date then write to the buoy list
   if [[ ${analDate} -ge ${buoyStart} ]] && [[ ${analDate} -le ${buoyEnd} ]] ; then
      echo ${buoyID} >> ${buoyList}
      #echo -e ${buoyID} ${buoyStartYEAR} ${buoyStartDAY} ${buoyEndYEAR} ${buoyEndDAY} ${buoyEnd}>> ${buoyList_dates} # MFG
   fi  

done < ${buoyList}_tmp
rm ${buoyList}_tmp

############################################
# get buoy data
#
echo -e "\nDownloading buoy details from DKRZ website...\n"

# loop over buoys from file list
numBuoys=0
while read buoyID; do 

   # get data from DKRZ
   #wget http://iabp.apl.washington.edu/WebData/${buoyID}.dat #MFG
   wget https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx_index/observations/${buoyID}.txt 
   # strip off top line
   sed 1d ${buoyID}.txt > tmpFile.txt
   mv tmpFile.txt ${buoyID}.txt #MFG: ${buoyID}.txt instead of .dat

   # extract relevant date and find closest report to 0Z for lat/lon positions
   # save to ascii file 
   ${PY_CMD} ${DIR_SCRIPTS}/derive_buoy_lat-lon_v1.py ${buoyID} ${analDate} > ${buoyID}_${analDate}.dat

   # count number of succesful buoy (non-zero) files and remove zero files that have failed 
   if [[ -s ${buoyID}_${analDate}.dat ]] ; then
      let numBuoys=${numBuoys}+1
      # SLX print in a single file all the successful active buoys with their ID 
      #read -r longitude latitude < "${buoyID}_${analDate}.dat"
      #echo -e "${buoyID} $longitude $latitude" >> "${buoyDIR}/${outputfile}_${analDate}.dat"
      # MFG: adapt for hindcast
      read -r bID longitude latitude tbuoy < "${buoyID}_${analDate}.dat"
      echo -e "${buoyID} $longitude $latitude" >> "${DIR_buoy}/${outputfile}_${analDate}.dat"
else
      rm ${buoyID}_${analDate}.dat
   fi



done < ${buoyList} # read central buoy list

if [[ ${numBuoys} -eq 0 ]] ; then
	echo "$(date '+%Y-%m-%d') Forecast Analysis Date: $analDate, Buoy Count: $numBuoys" >> "$LOG_FILE"
fi

# complain if no valid buoy files counted for today
#if [[ ${numBuoys} -eq 0 ]] ; then

#   echo "**ERROR** no buoys found for this date"

   # if today's date (likely crontab initiated) then send an email warning
#   if [[ ${runDate} == ${todayDate} ]] ; then

      # define email details
#      subject="SIDFEx WARNING : 0 buoys for ${analDate}"
#      EMAIL_ID="maren-friele.grung@univ-grenoble-alpes.fr"
#      textfile="${DIR_buoy}/email_warning_buoys.txt"
#      cat << EOC > ${textfile}
#Hi,
#Your SIDFEx job could not find any buoys or other targets with reports for today's analysis day ${analDate}
#Best

#EOC

      # send the email
      #echo "Sending warning email to ${EMAIL_ID}"
      # SLX
      #/usr/local/bin/mutt -s "${subject}" -i ${textfile} -x -z -n ${EMAIL_ID} << END || status="failed"
#END

#   fi # today

#   exit 9

#fi # no buoys
