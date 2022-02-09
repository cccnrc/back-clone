#!/usr/bin/env bash

LOCAL_DIR=$1            ### DIR to backup on cloud
CLOUD_DIR=$2            ### cloud backup DIR fullpath
PROCESS_NAME=$3         ### (optional) name of the backup process


### get PROCESS_NAME or set it to the name of LOCAL_DIR if not set
LOCAL_DIRNAME=$( basename $LOCAL_DIR )
PROCESS_NAME="${PROCESS_NAME:-$LOCAL_DIRNAME}"
### get the DIR in which this script lives
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
### script that actually executes the rclone command
RCLONE_LAUNCH_SCRIPT=$SCRIPT_DIR/rclone-sync.sh
### TSV file in which are stored PROCESS_NAME and relative PID
PID_MAP_FILE=$( dirname $SCRIPT_DIR )/logs/rclone-PID-map.tsv
### get the LOGS dir
LOGS_DIR=$( dirname $SCRIPT_DIR )/logs
LOG_FILE="${LOGS_DIR}/${PROCESS_NAME}.back-clone.log"
### datetime format
NOW=$( date '+%d-%b-%Y@%T' )


### if PID_MAP_FILE does not exists creates it with header
if [ ! -s $PID_MAP_FILE ]; then
  echo -e "PROCESS\tPID\tSTART" > $PID_MAP_FILE
fi

### check if a line for the process exists in PID_MAP_FILE
LAST_PID=$( gawk -F'\t' -vNAME="${PROCESS_NAME}" '$1==NAME { print $2 }' $PID_MAP_FILE )

### if PROCESS_NAME has NO line in PID_MAP_FILE
if [ -z "$LAST_PID" ]; then
  ### launch the rclone backup and store the PID as $PID
  PID=$( bash ${RCLONE_LAUNCH_SCRIPT} \
                              ${LOG_FILE} \
                              ${LOCAL_DIR} \
                              ${CLOUD_DIR} )
  ### store PROCESS_NAME line in PID_MAP_FILE
  echo -e "${PROCESS_NAME}\t${PID}\t${NOW}" >> $PID_MAP_FILE
### if PROCESS_NAME found in PID_MAP_FILE
else
  ### if previous PROCESS_NAME is still running
  if ps -p $LAST_PID > /dev/null; then
    ### return running PID and (running) as PID string
    PID="${LAST_PID} (running)"
  ### if PROCESS_NAME PID in PID_MAP_FILE is terminated
  else
    ### launch the new backup and store it in PID_MAP_FILE
    PID=$( bash ${RCLONE_LAUNCH_SCRIPT} \
                                ${LOG_FILE} \
                                ${LOCAL_DIR} \
                                ${CLOUD_DIR} )
    ### update PID_MAP_FILE PROCESS_NAME line
    sed -i "s/^${PROCESS_NAME}.*/${PROCESS_NAME}\t${PID}\t${NOW}/g" $PID_MAP_FILE
  fi
fi

### return the final PID to STDOUT
echo "${PID}"

exit 0
