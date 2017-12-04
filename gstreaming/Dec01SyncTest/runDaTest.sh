#!/bin/bash

DAYANDTIME=$(date +"%Y%m%d-%H%M%S")
starttime=`date +%s`

#camera network addresses
URLA='rtsp://root:hest1234@192.168.130.200/axis-media/media.amp'
URLB='rtsp://root:hest1234@192.168.130.201/axis-media/media.amp'
RTSPSRC_SETTINGS='ntp-sync=true protocols=GST_RTSP_LOWER_TRANS_TCP ntp-time-source=1'

RECORDTIME='7200'

GST_DEBUG=3 gst-launch-1.0  -ev \
  matroskamux name=mux ! filesink location=$DAYANDTIME-rec-t$RECORDTIME.mkv \
  rtspsrc location=$URLA $RTSPSRC_SETTINGS \
  ! queue ! capsfilter caps="application/x-rtp,media=video" \
  ! rtph264depay ! h264parse ! mux.video_0 \
  rtspsrc location=$URLB $RTSPSRC_SETTINGS  \
  ! queue ! capsfilter caps="application/x-rtp,media=video" \
  ! rtph264depay ! h264parse ! mux.video_1 &

sleep $RECORDTIME
kill $!

sleep 3

gst-launch-1.0 -ev \
  filesrc location=$DAYANDTIME-rec-t$RECORDTIME.mkv \
  ! queue ! matroskademux name=demux \
    demux.video_0  ! decodebin3 ! queue ! mix. \
    demux.video_1  ! decodebin3 ! queue ! mix. \
  videomixer name=mix \
  sink_0::xpos=0 sink_0::ypos=0    sink_0::alpha=1 \
  sink_1::xpos=0 sink_1::ypos=2160 sink_1::alpha=1 \
  ! videoconvert \
  ! video/x-raw,width=3840,height=4320,framerate=30000/1001 \
  ! glupload \
  ! glshader fragment="\"`cat shader.frag`\"" \
  ! gldownload \
  ! videoconvert \
  ! videocrop top=0 left=0 right=0 bottom=1248 \
  ! x265enc bitrate=16000 \
  ! h265parse \
  ! matroskamux \
  ! filesink location=$DAYANDTIME-stack-t$RECORDTIME.mkv

ffprobe -hide_banner $DAYANDTIME-rec-t$RECORDTIME.mkv
ffprobe -hide_banner $DAYANDTIME-stack-t$RECORDTIME.mkv

endtime=`date +%s`
runtime=$((endtime-starttime))
echo "TOTAL RUNNING TIME: "$runtime "secs"
