#############################################################
#                                                           #
#  Script to read in IABP buoy report lists and locate      #
#  the nearest date-time combination to the initial date.   #
#                                                           #
#  Script complains if the nearest date-time report is      #
#  not within 1 day of the initial date.                    # 
#                                                           #
#  Buoy ID and initial date are provided via command line.  #
#                                                           #
#  Ed Blockley, July 2018                                   #
#                                                           #
#############################################################

import numpy as np
import datetime as dt
import sys
import os
import re

# function to print errors/warnings to standard error
def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

# function to calculate the nearest item in a list/array to a given item
# here we use for datetime objects
def nearest(items, pivot):
    return min(items, key=lambda x: abs(x - pivot))

# get buoy file and date from command line
if len(sys.argv) != 3 or not re.match("^([0-9]){8}$", sys.argv[2]):
   path, fname = os.path.split(sys.argv[0])
   eprint("\n**ERROR** Incorrect command-line options specified")
   eprint("  Usage : "+fname+" BUOYNUM YYYYMMDD\n")
   sys.exit(9)

thisBuoyStr = sys.argv[1]
thisDateStr = sys.argv[2]

# read in list of buoy reports
buoyList = np.genfromtxt(open(thisBuoyStr+".dat", "rb"), delimiter='   ') # MFG 3 space delimiter instead of 5

# derive correct date/time entries
realDates = np.empty(len(buoyList), dtype=object)
for i in range(0, len(realDates)):
   realDates[i] = (dt.datetime( int(buoyList[i,1]), 1, 1 )    \
                    + dt.timedelta( days=buoyList[i,5]-1))

# create datetime structure for this date
thisDate = dt.datetime( int(thisDateStr[0:4]),  \
                        int(thisDateStr[4:6]),  \
                        int(thisDateStr[6:8]))  

# find the nearest date in realDates to thisDate
bestDate = nearest(realDates, thisDate)


# complain if this bestDate is not less than 1 day away from thisDate
thisDelta = abs(bestDate - thisDate).days
if thisDelta >= 1:
   eprint("\n**WARNING** date entry for "+thisDateStr+" not found in "+thisBuoyStr+".dat")
   eprint(  "            best found was "+bestDate.strftime("%Y%m%d"))
   sys.exit(9)


# locate the nearest date in the realDates array
mask = (realDates == bestDate)

# output mean lon and lat entries for this day
lon = buoyList[mask,7][0]
lat = buoyList[mask,6][0]

print(thisBuoyStr, lon,lat, bestDate) # MFG used for run with forecast (final edition)

# To check time of update
#print(lon,lat, 'thisDate', thisDate, 'bestDate', bestDate)



