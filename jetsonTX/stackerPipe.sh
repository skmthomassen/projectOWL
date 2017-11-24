#!/bin/bash

ARG=$1
VIDEO_DEV='/dev/video0'
AUDIO_DEV='hw:1'
DAYANDTIME=$(date +"%Y%m%d-%H%M%S")
TODAY=$(date +"%b%d")
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

#FILE_PATH=$SCRIPT_DIR/clips/$TODAY
FILE_PATH="/mnt/container/hardware/jetsontxx/clips/$TODAY"
mkdir -p $FILE_PATH

echo "Starting recoring: " $FILE_PATH/$DAYANDTIME
#3840 x 2160

case $ARG in
  -4)
    GST_DEBUG=3 gst-launch-1.0 -e \
    videomixer name=mix \
          sink_1::xpos=0 sink_1::ypos=2160 \
          sink_2::xpos=0 sink_2::ypos=0 \
      ! videoconvert ! xvimagesink \
    videotestsrc pattern=0 \
      ! "video/x-raw,format=AYUV,width=3840,height=2160,framerate=(fraction)30/1" \
      ! mix.sink_1 \
    videotestsrc pattern=1 \
      ! "video/x-raw,format=AYUV,width=3840,height=2160,framerate=(fraction)30/1" \
      ! mix.sink_2 \
  ;;
  -3)
    GST_DEBUG=3 gst-launch-1.0 -e \
    videomixer name=mix \
          sink_1::xpos=0 sink_1::ypos=2160 \
          sink_2::xpos=0 sink_2::ypos=0 \
      ! videoconvert ! xvimagesink \
    videotestsrc pattern=smpte \
      ! "video/x-raw,format=AYUV,width=3840,height=2160,framerate=(fraction)30/1" \
      ! mix.sink_1 \
    videotestsrc pattern=smpte \
      ! "video/x-raw,format=AYUV,width=3840,height=2160,framerate=(fraction)30/1" \
      ! mix.sink_2 \
  ;;
  -2)
    GST_DEBUG=3 gst-launch-1.0 -e \
      videomixer name=mix \
          sink_0::xpos=0  sink_0::ypos=0   sink_0::alpha=0\
          sink_1::xpos=0  sink_1::ypos=0   sink_1::alpha=1 \
          sink_2::xpos=0  sink_2::ypos=100 sink_2::alpha=1 \
        ! x265enc ! h265parse ! matroskamux \
        ! filesink location=$FILE_PATH/$DAYANDTIME.mkv sync=false \
      videotestsrc pattern="black" \
        ! "video/x-raw,format=(string)UYVY,width=3840,height=4320" \
        ! mix.sink_0 \
      filesrc location=$SCRIPT_DIR/h265file0.mkv \

        ! avdec_h265 \
        ! mix.sink_0 \
      filesrc location=$SCRIPT_DIR/h265file1.mkv \

        ! avdec_h265 \
        ! mix.sink_1
  ;;
  -1)
    GST_DEBUG=3 gst-launch-1.0 -e \
      videomixer name=mix \
          sink_0::xpos=0  sink_0::ypos=0   sink_0::alpha=0\
          sink_1::xpos=0  sink_1::ypos=0   sink_1::alpha=1 \
          sink_2::xpos=0  sink_2::ypos=100 sink_2::alpha=1 \
        ! x265enc ! h265parse ! matroskamux \
        ! filesink location=$FILE_PATH/$DAYANDTIME.mkv sync=false \
      videotestsrc pattern="black" \
        ! "video/x-raw,format=(string)UYVY,width=3840,height=4320" \
        ! mix.sink_0 \
      filesrc location=$SCRIPT_DIR/twostreams.mkv \
        ! matroskademux name=mux \
      mux.video_0 \
        ! h265parse \
        ! avdec_h265 \
        ! mix.sink_0 \
      mux.video_1 \
        ! h265parse \
        ! avdec_h265 \
        ! mix.sink_1
  ;;
esac
