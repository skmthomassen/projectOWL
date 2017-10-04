#/bin/bash

SEGTIME="600"
IP2="192.168.0.202"
IP3="192.168.0.203"
IP2UP=1
IP3UP=1
AUDIOUP=1

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
CLIPDIR="$SCRIPTPATH/clips"

# SUF=$(head -n 1 $SCRIPTPATH/suffix)
# SUF=$(( $SUF + 1 ))
# echo $SUF > $SCRIPTPATH/suffix
SUF=$(date +"%Y%m%d-%H%M%S")

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
# if [ "$IP2UP" -eq 1 ] && [ "$IP3UP" -eq 1 ] ; then
#   echo "ERROR: No cameras where found"
#   echo "No reason to live... Will exit..."
#   exit 10
# fi

parallel ::: \
"ffmpeg -hide_banner -loglevel 0 -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP2/av0_0 -f segment \
  -segment_time $SEGTIME -y -c:v copy -segment_format mpegts "$CLIPDIR/$SUF-cam2-%03d.ts"" \
"ffmpeg -hide_banner -loglevel 0 -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP3/av0_0 -f segment \
  -segment_time $SEGTIME -y -c:v copy -segment_format mpegts "$CLIPDIR/$SUF-cam3-%03d.ts"" \
"ffmpeg -hide_banner -loglevel 0 -thread_queue_size 512 -f alsa -i hw:1 -y -f segment \
  -segment_time $SEGTIME -segment_format aac -acodec aac "$CLIPDIR/$SUF-audio-%03d.aac""

exit 0
