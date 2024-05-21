#!/bin/bash


# TIME
# get date of today 
analDate=$1 
yesterdayDate=$(${DATE_CMD} +%Y%m%d --date="${analDate} 1 day ago") # Initial seeding date
forecastEndDate=$(${DATE_CMD} +%Y%m%d --date="${analDate} 9 day") # Date at the end of the forecast as forecast ends at midnight

#DIRnc=${DIR_NC_FCST}
ncin='data_A-grid_'${yesterdayDate}'_nersc_tracking_sidfex_seeding_1h_'${analDate}'h00_'${forecastEndDate}'h00_3km.nc'
GroupID='igedatlas001'
MethodID='neXtSIM-F-sitrack'

mkdir -p ${DIR_OUTsidfex}

${PY_CMD} ${DIR_SCRIPTS}to_sidfex.py ${DIR_NC_FCST} ${ncin} ${GroupID} ${MethodID} ${DIR_OUTsidfex} 
