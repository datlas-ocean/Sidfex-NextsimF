#!/bin/bash
analDate=$1
DIR=${DIR_OUTsidfex}

# Check if the target is not a directory
if [ ! -d "$DIR" ]; then
  exit 1
fi

 


for file in $(find $DIR -name 'ige*' -type f ); do
    echo $file
    filename=$(basename $file)
    echo $filename
    curl -XPUT "https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx/incoming/igedatlas001/"${filename}"?temp_url_sig=b3031530d07f4d201ae86a55ff7ff1d19debffb3&temp_url_expires=2029902255&temp_url_prefix=incoming/igedatlas001" --data-binary @${DIR}/${filename}
done
