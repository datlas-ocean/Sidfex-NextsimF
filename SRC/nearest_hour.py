import sys
import pandas as pd

tbuoy = sys.argv[1]

def nearest_hour(time):
    rnd = pd.Timestamp(tbuoy).round('60min')
    return rnd

print(nearest_hour(tbuoy))