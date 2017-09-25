#/bin/bash

#FFMPEG202 = "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.202 -frames 1 202left.png"
#FFMPEG203 = "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.203 -frames 1 203right.png"

#echo "MINE: " $$

while true
do
  parallel ::: \
    "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.202 -frames 1 $PWD/static/thumbs/202left.png" \
    "ffmpeg -y -hide_banner -loglevel -8 -i rtsp://192.168.0.203 -frames 1 $PWD/static/thumbs/203right.png"
    sleep 3

done



#myprogram &
#echo "$!"  > /tmp/pid

#myCommand & echo $!



exit 0
