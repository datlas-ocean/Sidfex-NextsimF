#!/bin/bash
# This script loops over latest buoy updated positions and advect to midnight if necessary, based on the sea ice velocities from the hindcast.

# TIME
# get date of today 
analDate=$1 
echo "analdate $analDate"
yesterdayDate=$(${DATE_CMD} +%Y%m%d --date="${analDate} 1 day ago" ) # Initial seeding date
midnightDate=$(${DATE_CMD} +%Y-%m-%d --date="${analDate}") # Date (and format) at which hindcast should finish in sitrack
finalForecastDate=$2 #$(${DATE_CMD} +%Y%m%d --date="${analDate} 8 day") # Date for last forecasted day
analDate_hour=${analDate}000000


# erase output file if already exist
if [ -f "${DIR_buoy}sidfexloc_out_${analDate}.dat" ]; then
rm -f "${DIR_buoy}sidfexloc_out_${analDate}.dat"
fi

# LOOP OVER latest buoy updated positions and advect to midnight if necessary
while read line; do
    # extract buoyID from original sidfexloc
    echo "----------- Extract buoyID from sidfexloc_YMD.dat -----------"
    buoyID=$( echo ${line} | cut -d " " -f 1 )
    lon_sidfexloc=$( echo ${line} | cut -d " " -f 2 )
    lat_sidfexloc=$( echo ${line} | cut -d " " -f 3 )
    
    # read and create variables from buoyID_date-files
    echo "----------- Read buoyID_YMD files from first download and store the variables -----------"
    read -r bID longitude latitude tbuoy < "${DIR_buoy}${buoyID}_${analDate}.dat"

    # CHANGE FORMAT OF TIME OF BUOY UPDATE:
    # to YYYY-MM-DD_hh:mm:ss (format for generate_sidfex_seeeding.py)
    tb=$(${DATE_CMD} +%Y-%m-%d_%H:%M:%S --date="${tbuoy}")

    # For generated seeds file
    t_genNC=$(${DATE_CMD} +%Y%m%d --date="${tbuoy}")
    init_h=$(${DATE_CMD} +%H --date="${tbuoy}")

    # Propagation file needs nearest hour (ex. 13:59 --> 14, to avoid that 13:59 --> 13)
    ${PY_CMD} ${DIR_SCRIPTS}/nearest_hour.py "${tbuoy}" > ${DIR_buoy}${buoyID}_nearesthour.dat
    read -r h_round < "${DIR_buoy}${buoyID}_nearesthour.dat"
    echo "h_round $buoyID : $h_round"
    h_nearest=$(${DATE_CMD} +%H --date="${h_round}")
    echo "h_nearest $buoyID : $h_nearest"

    # For if-statement:
    dt_buoy=$(${DATE_CMD} +%Y%m%d%H%M%S --date="${tbuoy}") #date and time of buoy in a different format
    t_tres=${yesterdayDate}232959 # threshold time for advection

    
    if [[ ${dt_buoy} -le ${t_tres} ]] && [[ ${dt_buoy} -le ${analDate_hour} ]] ; then
        # is this part unneccessary?: && [[ ${dt_buoy} -le ${analDate_hour} ]]
        # Buoy update is more than half an hour before midnight of today and needs to be advected w/ hindcast

        # link to sidfexloc
        echo "----------- IN HINDCAST: Link to sidfexloc -----------"
        ln -sf ${DIR_buoy}${buoyID}_${analDate}.dat ./sidfexloc.dat 
    
        # generate initial seeds #check buoyid, lat, lon, time
        echo "----------- IN HINDCAST: generate initial seed (.py) -------------"
        ${PY_CMD} ${DIR_gnrate_mesh}generate_sidfex_seeding_vol2.py -d ${tb}  --lsidfex 1
	mv ./nc/* ${DIR_INITSEED}


        # Propagate seeds until midnight
        echo "-------------- IN HINDCAST: ADVECT SEEDS ------------"
        #mkdir -p ${DIR_FCSTSEED} ${DIR_ncOUT} #MFG
        #cd ${DIR_ncOUT} #MFG
        ${PY_CMD} ${DIR_sitrack}si3_part_tracker.py -i ${DIR_nextsim}/${yesterdayDate}_${finalForecastDate}_hr-nersc-MODEL-nextsimf-concatenated-ARC-b${analDate}-fv00.0.nc \
                        -m ${DIR_gnrate_mesh}/coordinates_mesh_mask.nc \
                        -s ${DIR_INITSEED}sitrack_seeding_sidfex_${t_genNC}_${init_h}.nc \
                        -e ${midnightDate} -g A -R 3km -u vxsi -v vysi -p 12
        mv ./nc/* ${DIR_INITSEED}

        echo "-------------- IN HINDCAST: CONVERTING NC TO ASCII ------------"
	#infile=data_A-grid_${yesterdayDate}_nersc_tracking_sidfex_seeding_1h_${t_genNC}h*_${analDate}h00_3km.nc
        ${PY_CMD} ${DIR_SCRIPTS}convert_nc_to_ascii.py ${DIR_NC_FCST}/ data_A-grid_${yesterdayDate}_nersc_tracking_sidfex_seeding_1h_${t_genNC}h${h_nearest}_${analDate}h00_3km.nc > ${DIR_buoy}${bID}_pos_mnght_${analDate}.dat
        #${PY_CMD} ${DIR_SCRIPTS}convert_nc_to_ascii.py ${DIR_NC_FCST}/ data_A-grid_${yesterdayDate}_nersc_tracking_sidfex_seeding_1h_${t_genNC}h*_${analDate}h00_3km.nc > ${DIR_buoy}${bID}_pos_mnght_${analDate}.dat
	read -r byID lon_mnght lat_mnght < "${DIR_buoy}${bID}_pos_mnght_${analDate}.dat"
        echo -e "$byID $lon_mnght $lat_mnght" >> "${DIR_buoy}sidfexloc_out_${analDate}.dat"

    elif [[ ${dt_buoy} -ge ${t_tres} ]] && [[ ${dt_buoy} -lt ${analDate_hour} ]] ; then
        # Buoy update is half an hour before midnight of today
        echo -e "${buoyID} ${lon_sidfexloc} ${lat_sidfexloc}" >> "${DIR_buoy}sidfexloc_out_${analDate}.dat"
    else
        # Buoy update is already at midnight
        echo -e "${buoyID} ${lon_sidfexloc} ${lat_sidfexloc}" >> "${DIR_buoy}sidfexloc_out_${analDate}.dat"
    fi
    

done < ${DIR_buoy}sidfexloc_${analDate}.dat

echo '-------------- HINDCAST IS FINISHED ---------------'
