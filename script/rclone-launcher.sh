#!/usr/bin/env bash

PROCESS_TSV=$1      ### path of the TSV file with directories to backup and cloud paths

### it test print this output
if [[ "$PROCESS_TSV" == 'test' ]]; then
  echo -e "\n  Your back-clone scripts are working :)\n"
  exit 0
fi

### get the DIR in which this script lives
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
### LOG_FILE is in logs folder and hase the same name of PROCESS_TSV but with log extension
LOG_FILE=$( dirname $SCRIPT_DIR )/logs/$( basename $PROCESS_TSV .tsv ).log

### check TSV file exists
if [ ! -s $PROCESS_TSV ]; then
  echo -e "\n !!! ERROR !!! Specified input TSV does not exists: ${PROCESS_TSV}\n  - Use a valid one. Instructions at: https://github.com/cccnrc/back-clone\n  - exiting ...\n"
  exit 1
fi

### check it is a valid TSV
HEADER=$( head -1 $PROCESS_TSV )
if [[ "${HEADER}" != "#LOCAL_DIR  CLOUD_DIR NAME" ]]; then
  echo -e "\n !!! ERROR !!! Specified input TSV invalid header: ${HEADER}\n  - Use a valid one. Instructions at: https://github.com/cccnrc/back-clone\n  - exiting ...\n"
  exit 1
fi

BODY=$( cat $PROCESS_TSV | grep -v "^#" | wc -l )

if [ $BODY -lt 1 ]; then
  echo -e "\n !!! ERROR !!! Specified input TSV has nothing but header: ${PROCESS_TSV}\n  - Use a valid one. Instructions at: https://github.com/cccnrc/back-clone\n  - exiting ...\n"
  exit 1
fi




### datetime format
NOW=$( date '+%d-%b-%Y@%T' )
echo
echo -e "#  back-clone " > $LOG_FILE
echo -e "#    - analysis start:\t${NOW}" >> $LOG_FILE
echo -e "#    - input TSV file:\t${PROCESS_TSV}\n" >> $LOG_FILE
echo -e "#PROCESS\tPID\tSTART" >> $LOG_FILE
cat $LOG_FILE | head -3     ### print to STDOUT
echo

NROW=1
while read -r LINE; do

  NROW=$(( NROW+1 ))

  ### check all body rows have exactly 3 columns
  NCOL=$( echo "${LINE}" | awk '{ print NF }' )
  if [ $NCOL -lt 2 ]; then
    echo -e "\n !!! ERROR !!! Specified input TSV has some rows (ex. row n. ${NROW}) with less than 2 columns: ${LINE}\n  - Use a valid one. Instructions at: https://github.com/cccnrc/back-clone\n  - exiting ...\n"
    exit 1
  elif [ $NCOL -gt 3 ]; then
    echo -e "\n !!! ERROR !!! Specified input TSV has some rows (ex row n. ${NROW}) with more than 3 columns: ${LINE}\n  - Use a valid one. Instructions at: https://github.com/cccnrc/back-clone\n  - exiting ...\n"
    exit 1
  fi

  ### extract input values
  LOCAL_DIR=$( echo "${LINE}" | awk '{ print $1 }' )
  CLOUD_DIR=$( echo "${LINE}" | awk '{ print $2 }' )
  PROCESS_NAME=$( echo "${LINE}" | awk '{ print $3 }' )

  ### if PROCESS_NAME not passed assign it to LOCAL_DIR name
  LOCAL_DIRNAME=$( basename $LOCAL_DIR )
  PROCESS_NAME="${PROCESS_NAME:-$LOCAL_DIRNAME}"

  ### launch task
  PID=$( $SCRIPT_DIR/rclone-check-PID-launch.sh $LOCAL_DIR $CLOUD_DIR $PROCESS_NAME )

  ### store in LOG file
  NOW=$( date '+%d-%b-%Y@%T' )
  echo -e "${PROCESS_NAME}\t${PID}\t${NOW}" >> $LOG_FILE

  sleep 0.1

done < <( grep -v "^#" $PROCESS_TSV )



tail -n +4 $LOG_FILE











exit 0
