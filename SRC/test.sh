#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS platform
    DATE_CMD="gdate"
    # Ensure gdate is installed
    if ! command -v gdate &> /dev/null; then
        echo "gdate could not be found. Please install it using 'brew install coreutils'."
        exit 1
    else
         echo "MacOS platfeform. gdate is found"
    fi
else
    # Assume Linux platform
    DATE_CMD="date"
    echo "Not a mac. Assume linux platfeform. date is found"
fi

echo ${DATE_CMD}
