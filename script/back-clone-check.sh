#!/usr/bin/env bash

PROCESS_NAME=$1       ### name assigned to the backup job you want to check (as per logs/rclone-PID-map.tsv)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOG_TSV=$( dirname $SCRIPT_DIR )/logs/rclone-PID-map.tsv

NUM_JOBS=$( wc -l $LOG_TSV | awk '{ print $1 }' )
echo
echo " ----------------------------- "
echo " ------ back-clone chek ------ "
echo " ----------------------------- "
echo

### if PROCESS_NAME is set extract ONLY its job
INPUT_FILE=$LOG_TSV
if [ ! -z $PROCESS_NAME ]; then
  awk -vPROCESS_NAME="${PROCESS_NAME}" '$1 == PROCESS_NAME' $LOG_TSV > /tmp/back-clone.input
  INPUT_FILE=/tmp/back-clone.input
fi

i=0
while read -r LINE; do
  i=$((i+1))
  PROCESS_NAME=$( echo "$LINE" | awk '{ print $1 }' )
  PID=$( echo "$LINE" | awk '{ print $2 }' )
  START=$( echo "$LINE" | awk '{ print $3 }' )
  WORKING=$( ps aux | awk -vPID=$PID '$2==PID' | wc -l | awk '{ print $1 }' )
  if [ $WORKING -gt 0 ]; then
    STATUS='running'
  else
    STATUS='completed'
  fi
  echo
  echo -e "${i}. job description:"
  echo -e "    - name:\t${PROCESS_NAME}"
  echo -e "    - PID:\t${PID}"
  echo -e "    - start:\t${START}"
  echo -e "    - status:\t${STATUS}"
  echo
done < <( grep -v "^#" $INPUT_FILE )

echo " ----------------------------- "
echo " -------- check end ---------- "
echo " ----------------------------- "
echo


exit 0
