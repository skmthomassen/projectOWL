#/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
THUMBDIR="$SCRIPTPATH/static/thumbs"

while true
do
 parallel ::: \
   "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.202/av0_1 -frames 1 $THUMBDIR/202left.png" \
   "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.203/av0_1 -frames 1 $THUMBDIR/203right.png"
   sleep 3
done

exit 0
