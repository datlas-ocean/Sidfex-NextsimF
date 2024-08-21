import sys
import pandas as pd
from datetime import datetime, timedelta

t_buoy = sys.argv[1]

tbuoy = datetime.strptime(t_buoy, "%Y-%m-%d %H:%M:%S.%f")

def nearest_hour(time):
#    rnd = pd.Timestamp(tbuoy).round('60min')
#    rnd = pd.Timestamp(tbuoy).ceil('60min')

    if time.minute >= 30:
        # Round up to the next hour
        tt = time.replace(minute=0, second=0, microsecond=0) + timedelta(hours=1)
    else:
        # Round down to the current hour
        tt = time.replace(minute=0, second=0, microsecond=0)


    return tt

print(nearest_hour(tbuoy))
