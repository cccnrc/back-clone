#!/usr/bin/env bash

LOG_FILE=$1             ### path of write to write logs
LOCAL_DIR=$2            ### DIR to backup on cloud
CLOUD_DIR=$3            ### cloud backup DIR path and name

### create LOGS DIR if it does not exists
if [ ! -d $( dirname $LOG_FILE ) ]; then
  mkdir -p $( dirname $LOG_FILE )
fi

/usr/bin/rclone copy \
  --update \
  --verbose \
  --transfers 30 \
  --checkers 8 \
  --contimeout 60s \
  --timeout 300s \
  --retries 3 \
  --low-level-retries 10 \
  --stats 1s \
  "${LOCAL_DIR}" \
  "${CLOUD_DIR}" \
    &> ${LOG_FILE} &
PID=$!

echo $PID






















exit 0
