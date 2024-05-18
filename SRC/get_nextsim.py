# Import libraries
import os, sys
import datetime
#import copernicus_marine_client as copernicusmarine
import copernicusmarine as copernicusmarine

# login to CMEMS: credentials only needs to be entered once through below line
#copernicusmarine.login()

# date the model is run
analDate = sys.argv[1]
#convert to CMEMS date format yymmdd
runDate = datetime.datetime.strptime(str(analDate), '%Y%m%d').strftime('%y%m%d')
print(runDate)

def get_nextsim_forecast_hourlymean(datasetID, outputDIR):
    
    get_nsim_hm = copernicusmarine.get(dataset_id = datasetID, \
        filter = '*'+str(runDate)+'*.nc', \
        no_directories = True, \
        output_directory = outputDIR, force_download = True) #, username = username_cmems, password = password_cmems )


    return get_nsim_hm



dataset_id_hm = 'cmems_mod_arc_phy_anfc_nextsim_hm'
output_directory = sys.argv[2] #"/Users/grungm/Documents/nextsim_f_cmems"

get_nextsim_forecast_hourlymean(dataset_id_hm, output_directory)
