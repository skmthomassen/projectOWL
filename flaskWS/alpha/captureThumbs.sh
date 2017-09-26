#/bin/bash

while true
do
  parallel ::: \
    "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.202/av0_1 -frames 1 $PWD/static/thumbs/202left.png" \
    "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.203/av0_1 -frames 1 $PWD/static/thumbs/203right.png"
    sleep 3

done

exit 0
