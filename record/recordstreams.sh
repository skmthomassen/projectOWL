#/bin/bash

if [ $# -ne 1 ] ; then
    echo "ERROR: Please supply time to record"
    exit 10
fi

TIME=$1
SEGTIME="600"
SECONDS=0
IP0="192.168.0.200"
IP1="192.168.0.201"
IP2="192.168.0.202"
IP3="192.168.0.203"
IP2UP=1
IP3UP=1
AUDIOUP=1

SUF=$(head -n 1 $PWD/suffix)
SUF=$(( $SUF + 1 ))
echo $SUF > $PWD/suffix
echo "---Starting recording job no: $SUF---"

#Testing for devices
if ping -c 1 $IP2 &> /dev/null ; then
  IP2UP=$((IP2UP-1))
else echo "No camera at IP:$IP2 was found"
fi
if ping -c 1 $IP3 &> /dev/null ; then
  IP3UP=$((IP3UP-1))
else echo "No camera at IP:$IP3 was found"
fi
if [ "$IP2UP" -eq 1 ] && [ "$IP3UP" -eq 1 ] ; then
  echo "ERROR: No cameras where found"
  echo "No reason to live... Will exit..."
  exit 10
fi

echo "Will record for:" $(($1/86400))" days "$(date -d "1970-01-01 + $1 seconds" "+%H hours %M minutes %S seconds")
echo

parallel --progress --verbose --joblog $PWD/logs/$SUF.log ::: \
"ffmpeg -hide_banner -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP2/av0_0 -f segment \
  -segment_time $SEGTIME -y -c:v copy -segment_format mpegts -t 15 "$PWD/clips/$SUF-202-%03d.ts"" \
"ffmpeg -hide_banner -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP3/av0_0 -f segment \
  -segment_time $SEGTIME -y -c:v copy -segment_format mpegts -t 15 "$PWD/clips/$SUF-203-%03d.ts"" \
"ffmpeg -hide_banner -thread_queue_size 512 -f alsa -i hw:1 -y -f segment \
  -segment_time $SEGTIME -segment_format aac -acodec aac -t $TIME "$PWD/clips/$SUF-audio-%03d.aac""


DUR=$SECONDS
echo "Actual time recorded:" $(($DUR/86400))" days "$(date -d "1970-01-01 + $DUR seconds" "+%H hours %M minutes %S seconds")
echo "---Ending recording job no: $SUF---"

exit 0
