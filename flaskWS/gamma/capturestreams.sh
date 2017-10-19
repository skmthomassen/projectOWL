#/bin/bash

SEGTIME="600"
IP2="192.168.0.202"
IP3="192.168.0.203"
IP2UP=1
IP3UP=1
AUDIOUP=1

SUF=$(date +"%Y%m%d-%H%M%S")
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
mkdir "$SCRIPTPATH/clips/$SUF"
CLIPDIR="$SCRIPTPATH/clips"
SUFDIR="$SCRIPTPATH/clips/$SUF"

#Exits if either camera is unreachable
if ping -c 1 $IP2 &> /dev/null ; then
  IP2UP=$((IP2UP-1))
else echo "No camera at IP:$IP2 was found"
  exit 10
fi
if ping -c 1 $IP3 &> /dev/null ; then
  IP3UP=$((IP3UP-1))
else echo "No camera at IP:$IP3 was found"
  exit 10
fi

parallel  --progress --verbose --joblog $PWD/logs/$SUF.log ::: \
"ffmpeg -hide_banner -loglevel 0 -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP2/av0_0 -f segment \
  -segment_time $SEGTIME -y -c:v copy -segment_format mpegts "$SUFDIR/$SUF-cam2-%03d.ts"" \
"ffmpeg -hide_banner -loglevel 0 -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP3/av0_0 -f segment \
  -segment_time $SEGTIME -y -c:v copy -segment_format mpegts "$SUFDIR/$SUF-cam3-%03d.ts"" \
"ffmpeg -hide_banner -loglevel 0 -thread_queue_size 512 -f alsa -i hw:1 -y -f segment \
  -segment_time $SEGTIME -segment_format aac -acodec aac "$SUFDIR/$SUF-audio-%03d.aac""
wait

tar cf $SUFDIR/$SUF.tar -C $SUFDIR .
wait
cp $SUFDIR/$SUF.tar $CLIPDIR
wait
rm $SUFDIR/$SUF.tar


exit 0
