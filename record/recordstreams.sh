#/bin/bash

if [ $# -ne 1 ] ; then
    echo "ERROR: Please supply time to record"
    exit 10
fi

TIME=$1
SEGTIME="5"
REMAINDER=$((60 - $(date +%S) ))
SNOOZE="$((REMAINDER+$TIME))"
NOW=$(date +"%m%d_%H%M")
BEGIN=$(date +%s)

SUF=$(head -n 1 $PWD/suffix)
SUF=$(( $SUF + 1 ))
echo $SUF > $PWD/suffix

for ((n=0;n<2;n++))
do
  l="$(($n+1))"
  IP=$(sed "$l!d" $PWD/camIPs)
  at now +1 minutes <<< "ffmpeg -loglevel error -thread_queue_size 512 \
    -rtsp_transport tcp -i rtsp://192.168.0.$IP/av0_0 -f segment -segment_time $SEGTIME \
    -y -c:v copy -segment_format mpegts -t $TIME "$PWD/clips/$SUF-$IP-%05d.ts"" &
done

at now +1 minutes <<< "ffmpeg -thread_queue_size 512 -f alsa -i hw:1 -y \
  -f segment -segment_time $SEGTIME -segment_format flac -acodec flac \
  -t $TIME "$PWD/clips/$SUF-audio-%05d.flac"" &

wait

#END=$(date +%s)
#TOTALTIME=$(expr $END - $BEGIN)
#echo "Total time of execution: " $TOTALTIME"s || "$(($TOTALTIME/60))"m || "$(($TOTALTIME/3600))"h"

exit 0
