import sys
import xarray as xr
import numpy as np

def read_xr(file, filepath):
    
    f_rd = xr.open_dataset(filepath+file)

    bid = f_rd.sel(buoy=0).id_buoy.values
    lat_mnght = f_rd.sel(buoy=0).isel(time=-1).latitude.values
    lon_mnght = f_rd.sel(buoy=0).isel(time=-1).longitude.values
    print(bid, lon_mnght, lat_mnght)

    return bid, lat_mnght, lon_mnght

out = read_xr(sys.argv[2], sys.argv[1])