#/bin/bash

if [ $# -ne 1 ] ; then
    echo "ERROR: Please supply time to record"
    exit 10
fi

TIME=$1
SEGTIME="300"
REMAINDER=$((60 - $(date +%S) ))
SNOOZE="$((REMAINDER+$TIME))"
NOW=$(date +"%m%d_%H%M")
BEGIN=$(date +%s)
IP2="192.168.0.202"
IP3="192.168.0.203"

SUF=$(head -n 1 $PWD/suffix)
SUF=$(( $SUF + 1 ))
echo $SUF > $PWD/suffix

#(echo 'ffmpeg -thread_queue_size 512 -rtsp_transport tcp -i rtsp://192.168.0.202/av0_0 -y -c:v copy -t 15 "$PWD/202-tstP.ts"' && echo \
#'ffmpeg -thread_queue_size 512 -rtsp_transport tcp -i rtsp://192.168.0.203/av0_0 -y -c:v copy -t 15 "$PWD/203-tstP.ts"') | parallel
#parallel echo ::: A B C

parallel --progress --verbose --joblog $PWD/logs/$SUF.log ::: \
"ffmpeg -hide_banner -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP2/av0_0 -f segment -segment_time $SEGTIME -y -c:v copy -segment_format mpegts -t 15 "$PWD/clips/$SUF-202-%05d.ts"" \
"ffmpeg -hide_banner -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP3/av0_0 -f segment -segment_time $SEGTIME -y -c:v copy -segment_format mpegts -t 15 "$PWD/clips/$SUF-203-%05d.ts"" \
'ffmpeg -hide_banner -thread_queue_size 512 -f alsa -i hw:1 -y -f segment -segment_time $SEGTIME -segment_format aac -acodec aac -t $TIME "$PWD/clips/$SUF-audio-%05d.aac"'


exit 0
