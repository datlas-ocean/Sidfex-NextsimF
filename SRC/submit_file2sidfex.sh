#!/bin/bash
analDate=$1
DIR=${DIR_workdir}sidfex_output
#filename="igedatlas001_neXtSIM-F-sitrack_"${buoyID}"_"${year}"-"${DOY}"_001.txt"
#DIR_OUTsidfex="/Users/grungm/Documents/MEOM_seaice/sidfex/workdir/working_20240506/sidfex_output"

#curl -XPUT "https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx/incoming/igedatlas001/"${filename}"?temp_url_sig=b3031530d07f4d201ae86a55ff7ff1d19debffb3&temp_url_expires=2029902255&temp_url_prefix=incoming/igedatlas001" --data-binary @${DIR_OUTsidfex}/${filename}


# Check if the target is not a directory
if [ ! -d "$DIR" ]; then
  exit 1
fi

# Loop through files in the target directory
#for file in "$DIR_OUTsidfex"*; do
#  if [ -f "$file" ]; then
#    filename= basename $file
#    echo "$filename"
#  fi
 
#done

#curl -XPUT "https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx/incoming/igedatlas001/"${filename}"?temp_url_sig=b3031530d07f4d201ae86a55ff7ff1d19debffb3&temp_url_expires=2029902255&temp_url_prefix=incoming/igedatlas001" --data-binary @${DIR_OUTsidfex}/${filename}

for file in $(find $DIR -name 'ige*' -type f ); do
    echo $file
    filename=$(basename $file)
    echo $filename
    curl -XPUT "https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx/incoming/igedatlas001/"${filename}"?temp_url_sig=b3031530d07f4d201ae86a55ff7ff1d19debffb3&temp_url_expires=2029902255&temp_url_prefix=incoming/igedatlas001" --data-binary @${DIR}/${filename}
done