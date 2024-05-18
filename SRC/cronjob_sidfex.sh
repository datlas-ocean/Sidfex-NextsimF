#!/bin/bash

FILEDIR=/Users/grungm/Documents/MEOM_seaice/sidfex/SCRIPTS/
LOGDIR=/Users/grungm/Documents/MEOM_seaice/sidfex/

MAILTO='maren-friele.grung@univ-grenoble-alpes.fr'

# Users must ensure their scripts have appropriate execute permissions and that the Cron service can access and run scripts in the specified directories.
# m h dom mon dow  command
25 10 * * * /Users/grungm/Documents/MEOM_seaice/sidfex/SCRIPTS/sidfex_chain.sh > $LOGDIR/sidfex_fcst_log.log 2>&1

