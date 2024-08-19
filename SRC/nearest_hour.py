import sys
import pandas as pd
from datetime import datetime, timedelta

t_buoy = sys.argv[1]

tbuoy = datetime.strptime(t_buoy, "%Y-%m-%d %H:%M:%S")

def nearest_hour(time):
#    rnd = pd.Timestamp(tbuoy).round('60min')
#    rnd = pd.Timestamp(tbuoy).ceil('60min')

    if time.minute >= 30:
        # Round up to the next hour
        time = time.replace(minute=0, second=0, microsecond=0) + timedelta(hours=1)
    else:
        # Round down to the current hour
        time = time.replace(minute=0, second=0, microsecond=0)


    return time

print(nearest_hour(tbuoy))
