import os, sys
import numpy as np
import xarray as xr
import datetime
import pandas as pd

# Function for filename
def file_name_creator(GroupID,MethodID,TargetID,InitYear,InitDayOfYear,EnsMemNum):
    return str(GroupID)+'_'+str(MethodID)+'_'+str(TargetID)+'_'+ \
            str(InitYear)+'-'+str(int(InitDayOfYear))+'_'+str(EnsMemNum)+'.txt'


# Function to create header for the output file
def header_creator(GroupID,MethodID,TargetID,InitYear,InitDayOfYear,InitLat, InitLon, EnsMemNum):

    header = "GroupID: "+str(GroupID)+ "\n"+"MethodID: "+str(MethodID)+ "\n"+"TargetID: "+str(TargetID)+ \
     "\n"+"InitYear: "+str(InitYear)+ "\n"+"InitDayOfYear: "+str(int(InitDayOfYear))+ "\n"+"InitLat: " \
     +str(InitLat)+ "\n"+"InitLon: "+str(InitLon)+ "\n"+"EnsMemNum: "+str(EnsMemNum)+ "\n"+ \
     "### end of header" \
     + "\n"+"Year"+"\t"+"DayOfYear"+"\t"+"Lat"+"\t"+"Lon"

    return header

def get_variables_from_forecast(DIRnc, nc_filename, GroupID,MethodID, DIRsidfexout,  EnsMemNum = '001', dt = 1):

    da = xr.open_dataset(DIRnc + nc_filename)
    id_buoy = da.id_buoy.values

    for ib in range(0, len(id_buoy)):

        BuoyID = id_buoy[ib]

        # time variables
        Year = da.time[::dt].to_index().year
        InitYear = Year[0]
        doy = da.time[::dt].to_index().dayofyear
        s_h = da.time[::dt].to_index().hour*(60*60) # convert from given hour to seconds that day
        s_day = 60*60*24 # seconds per day
        DOY = doy + (s_h/s_day)
        InitDOY = DOY[0]

        # coordinate variables
        Lat = da.latitude.values[::dt, ib]
        InitLat =  Lat[0]
        # Convert first element of the longitude to the similar writing style as the other elements
        InitLon_hdr = np.array((da.longitude.values[:1:dt, ib]-360)[0])
        InitLon = np.array((da.longitude.values[:1:dt, ib]-360))
        OtherLon = da.longitude.values[1::dt, ib]
        Lon = np.concatenate((InitLon, OtherLon))

        # to file
        name = file_name_creator(GroupID,MethodID, BuoyID, InitYear, InitDOY, EnsMemNum )
        header = header_creator(GroupID,MethodID,BuoyID,InitYear,InitDOY, InitLat, InitLon_hdr, EnsMemNum)
        var_out = np.array([Year, DOY, Lat, Lon]).T 

        # Write to file
        fileout = np.savetxt(DIRsidfexout+name, var_out, fmt = '%4d\t%4.3f\t%4.5f\t%4.5f', delimiter = '   ', newline = '\n', header = header, comments = '')

    return fileout 




DIRfcst = sys.argv[1] #'/Users/grungm/DEV/sitrack/nc/' # change for sys 
file_fcst =  sys.argv[2] #'data_A-grid_20240227_nersc_tracking_sidfex_1h_20240227h00_20240308h00_3km.nc' # change for sys 
GroupID =  sys.argv[3] #'igedatlas001'
MethodID =  sys.argv[4] #'neXtSIM-F-sitrack'
#EnsMemNum =  sys.argv[5] #'001'
DIRsidfexout = sys.argv[5]
fcst = get_variables_from_forecast(DIRfcst, file_fcst, GroupID, MethodID, DIRsidfexout)
