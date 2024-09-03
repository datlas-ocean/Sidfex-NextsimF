import sys
import pandas as pd
from datetime import datetime, timedelta

t_buoy = sys.argv[1]

formats = ["%Y-%m-%d %H:%M:%S.%f", "%Y-%m-%d %H:%M:%S"]

def check_format(date_string, formats):
    for fmt in formats:
        try:
            # Try to parse the date string with the current format
            parsed_date = datetime.strptime(date_string, fmt)
            return parsed_date
        except ValueError:
            # If parsing fails, continue to the next format
            continue
    # If none of the formats match, raise an error
    raise ValueError("Date string does not match any of the provided formats.")

tbuoy = check_format(t_buoy, formats)

#tbuoy = datetime.strptime(t_buoy, "%Y-%m-%d %H:%M:%S.%f")
#tbuoy1 = datetime.strptime(t_buoy, "%Y-%m-%d %H:%M:%S")

def nearest_hour(time):

    if time.minute >= 30:
        # Round up to the next hour
        tt = time.replace(minute=0, second=0, microsecond=0) + timedelta(hours=1)
    else:
        # Round down to the current hour
        tt = time.replace(minute=0, second=0, microsecond=0)


    return tt

print(nearest_hour(tbuoy))
