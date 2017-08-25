#/bin/bash

if [ $# -ne 2 ] ; then
    echo "ERROR: Incorrect number of arguments supplied"
    echo "Please supply IP and time to record"
    exit 10
fi

THISIP=$1
TIME=$2
SUF=$(head -n 1 $PWD/suffix)

#echo "IPCAM 202 will now record for time: " $TIME
ffmpeg -loglevel error -thread_queue_size 512 -rtsp_transport tcp -i rtsp://192.168.0.$THISIP/av0_0 -y -t $TIME "$PWD/clips/$SUF-$THISIP.ts"

exit 0
