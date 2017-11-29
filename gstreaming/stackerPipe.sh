#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Give fucking arg.."
    exit 10
fi

ARG=$1
VIDEO_DEV='/dev/video0'
AUDIO_DEV='hw:1'
DAYANDTIME=$(date +"%Y%m%d-%H%M%S")
TODAY=$(date +"%b%d")
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

TODAY_DIR=$SCRIPT_DIR/clips/$TODAY
#TODAY_DIR="/mnt/container/hardware/jetsontxx/clips/$TODAY"
mkdir -p $TODAY_DIR

#camera network addresses
URLA='rtsp://root:hest1234@192.168.130.200/axis-media/media.amp'
URLB='rtsp://root:hest1234@192.168.130.201/axis-media/media.amp'
RTSPSRC_SETTINGS='ntp-sync=true protocols=GST_RTSP_LOWER_TRANS_TCP'

echo "Starting recoring: " $TODAY_DIR/$DAYANDTIME
#3840 x 2160

case $ARG in
  -13)
  #NOT working - extracts two videostreams from mp4 file, shows to screen
  GST_DEBUG=3 gst-launch-1.0 -e \
    videomixer name=mix \
        sink_0::xpos=0 sink_0::ypos=0 \
        sink_1::xpos=0 sink_1::ypos=2160 \
        sink_2::xpos=0 sink_2::ypos=0 \
    ! videoconvert ! xvimagesink \
    videotestsrc pattern=3 \
      ! "video/x-raw,format=AYUV,width=3840,height=4320,framerate=(fraction)30/1" \
      ! queue \
      ! mix.sink_0 \
    filesrc location=$TODAY_DIR/20171129-085356-two-anna.mp4 \
      ! qtdemux name=demux \
      demux.video_0 \
      ! h264parse ! decodebin ! multiqueue ! mix.sink_1 \
      demux.video_1 \
      ! h264parse ! decodebin ! multiqueue ! mix.sink_2

  ffprobe -hide_banner $TODAY_DIR/$DAYANDTIME.mp4
  ;;
  -12)
  #NOT working - extracts two videostreams from mp4 file, saves to file
  GST_DEBUG=4 gst-launch-1.0 -e \
    videomixer name=mix \
        sink_0::xpos=0 sink_0::ypos=0 \
        sink_1::xpos=0 sink_1::ypos=2160 \
        sink_2::xpos=0 sink_2::ypos=0 \
    ! videoconvert ! x264enc ! h264parse ! mp4mux ! queue \
    ! filesink location=$TODAY_DIR/$DAYANDTIME.mp4 \
    videotestsrc pattern=3 \
      ! "video/x-raw,format=AYUV,width=3840,height=4320,framerate=(fraction)30/1" \
      ! queue \
      ! mix.sink_0 \
    filesrc location=$TODAY_DIR/20171129-085356-two-anna.mp4 \
      ! qtdemux name=demux \
      demux.video_0 \
      ! h264parse ! decodebin ! queue ! mix.sink_1 \
      demux.video_1 \
      ! h264parse ! decodebin ! queue ! mix.sink_2

  ffprobe -hide_banner $TODAY_DIR/$DAYANDTIME.mp4
  ;;
  -11)
  #Working - extracts two videostreams from mp4 file, shows to screen
  GST_DEBUG=3 gst-launch-1.0 -e \
    videomixer name=mix \
        sink_0::xpos=0 sink_0::ypos=0 \
        sink_1::xpos=0 sink_1::ypos=2160 \
        sink_2::xpos=0 sink_2::ypos=0 \
      ! videoconvert ! xvimagesink \
    videotestsrc pattern=3 \
      ! "video/x-raw,format=AYUV,width=3840,height=4320,framerate=(fraction)30/1" \
      ! queue \
      ! mix.sink_0 \
    filesrc location=$TODAY_DIR/20171129-085356-two-anna.mp4 \
      ! qtdemux name=demux \
      demux.video_0 \
      ! h264parse ! avdec_h264 ! queue ! mix.sink_1 \
      demux.video_1 \
      ! h264parse ! avdec_h264 ! queue ! mix.sink_2
  ;;
  -10)
  #working... - mixing two videostreams from mp4 files into splitview
  GST_DEBUG=3 gst-launch-1.0 -e \
    videomixer name=mix \
        sink_0::xpos=0 sink_0::ypos=0 \
        sink_1::xpos=0 sink_1::ypos=2160 \
        sink_2::xpos=0 sink_2::ypos=0 \
      ! videoconvert ! x264enc ! h264parse ! mp4mux \
      ! filesink location=$TODAY_DIR/$DAYANDTIME.mp4 \
    videotestsrc pattern=3 \
      ! "video/x-raw,format=AYUV,width=3840,height=4320,framerate=(fraction)30/1" \
      ! mix.sink_0 \
    filesrc location=$SCRIPT_DIR/two20171127-000.mp4 \
      ! qtdemux ! h264parse ! decodebin ! queue \
      ! mix.sink_1 \
    filesrc location=$SCRIPT_DIR/two20171127-111.mp4 \
      ! qtdemux ! h264parse ! decodebin ! queue \
      ! mix.sink_2
  ;;
  -90)
  #works - extracts one videostreams from/into a mkv file
  fname='20171128-145535-two'
  GST_DEBUG=4 gst-launch-1.0 -e filesrc location=$TODAY_DIR/$fname.mp4 \
    ! qtdemux name=demux demux.video_0 ! h264parse ! matroskamux ! queue \
    ! filesink location=$SCRIPT_DIR/$fname-0.mkv
  ;;
  -9)
  #works - extracts one videostreams from/into a h265 mp4 file
  fname='20171128-145535-two'
  GST_DEBUG=4 gst-launch-1.0 -e filesrc location=$TODAY_DIR/$fname.mp4 \
    ! qtdemux name=demux demux.video_0 ! h264parse ! mp4mux \
    ! filesink location=$SCRIPT_DIR/$fname-0.mp4
  ;;
  -8)
  #works - extracts one videostream from a h265 mp4 file and plays
  fname='20171128-140616-two.mp4'
  GST_DEBUG=4 gst-launch-1.0 -e filesrc location=$TODAY_DIR/$fname \
    ! qtdemux name=demux demux.video_0 ! h264parse ! avdec_h264 \
    ! xvimagesink
  ;;
  -7)
  #works - saves a rtspstreams into a mp4
  GST_DEBUG=3 gst-launch-1.0 -e \
    rtspsrc location=$URLA $RTSPSRC_SETTINGS \
    ! queue ! capsfilter caps="application/x-rtp,media=video" \
    ! rtph264depay ! h264parse \
    ! mp4mux ! filesink location=$TODAY_DIR/$DAYANDTIME-two.mp4 \
  ;;
  -61)
  #Works - record two stream in TS
  gst-launch-1.0 -e \
    mpegtsmux ! filesink location=$TODAY_DIR/$DAYANDTIME.ts \
    rtspsrc location=$URLA $RTSPSRC_SETTINGS \
    ! queue ! capsfilter caps="application/x-rtp,media=video" \
    ! rtph264depay ! mpegtsmux0. \
    rtspsrc location=$URLA $RTSPSRC_SETTINGS \
    ! queue ! capsfilter caps="application/x-rtp,media=video" \
    ! rtph264depay ! mpegtsmux0.
  ;;
  -60)
  #works - saves 2rtspstreams into a MATROSKA
  GST_DEBUG=3 gst-launch-1.0 -e \
    mp4mux name=mmux ! videoscale ! video/x-raw-yuv,width=640,height=340 \
    filesink location=$TODAY_DIR/$DAYANDTIME-two.mp4 \
    rtspsrc location=$URLA $RTSPSRC_SETTINGS \
    ! queue ! capsfilter caps="application/x-rtp,media=video" \
    ! rtph264depay ! h264parse ! mmux.video_0 \
    rtspsrc location=$URLB $RTSPSRC_SETTINGS \
    ! queue ! capsfilter caps="application/x-rtp,media=video" \
    ! rtph264depay ! h264parse ! mmux.video_1
  ;;
  -6)
  #works - saves 2rtspstreams into a mp4
  GST_DEBUG=3 gst-launch-1.0 -e \
    mp4mux name=mmux ! filesink location=$TODAY_DIR/$DAYANDTIME-two.mp4 \
    rtspsrc location=$URLA $RTSPSRC_SETTINGS \
    ! queue ! capsfilter caps="application/x-rtp,media=video" \
    ! rtph264depay ! h264parse ! mmux.video_0 \
    rtspsrc location=$URLB $RTSPSRC_SETTINGS \
    ! queue ! capsfilter caps="application/x-rtp,media=video" \
    ! rtph264depay ! h264parse ! mmux.video_1 &

    childPID=$!
    echo "CHILD PID: " $childPID
    sleep 60
    kill $childPID
  ;;
  -5)
  #NOT working - extracts one/two videostreams from/into a h265 mp4 file
  GST_DEBUG=3 gst-launch-1.0 -e filesrc location=$SCRIPT_DIR/two20171127.mp4 \
    ! qtdemux name=demux \
    queue ! h264parse ! avdec_h264 ! videoconvert \
    ! x265enc ! h265parse ! mp4mux \
    ! filesink location=$TODAY_DIR/$DAYANDTIME.mp4
  ;;
  -3)
  #Works - mixes two testsrcs into one stacked view
    GST_DEBUG=4 gst-launch-1.0 -e \
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
  -2)
  #NOT working
    GST_DEBUG=3 gst-launch-1.0 -e \
      videomixer name=mix \
          sink_0::xpos=0  sink_0::ypos=0   sink_0::alpha=0\
          sink_1::xpos=0  sink_1::ypos=0   sink_1::alpha=1 \
          sink_2::xpos=0  sink_2::ypos=100 sink_2::alpha=1 \
        ! x265enc ! h265parse ! matroskamux \
        ! filesink location=$TODAY_DIR/$DAYANDTIME.mkv sync=false \
      videotestsrc pattern="black" \
        ! "video/x-raw,format=(string)UYVY,width=3840,height=4320" \
        ! mix.sink_0 \
      filesrc location$SCRIPT_DIR/h265file0.mkv \
        ! matroskademux ! h265parse ! avdec_h265 \
        ! mix.sink_0 \
      filesrc location=$SCRIPT_DIR/h265file1.mkv \
        ! matroskademux ! h265parse ! avdec_h265 \
        ! mix.sink_1
  ;;
  -1)
  #NOT working
    GST_DEBUG=4 gst-launch-1.0 -e \
      videomixer name=mix \
          sink_0::xpos=0  sink_0::ypos=0    sink_0::alpha=0\
          sink_1::xpos=0  sink_1::ypos=2160 sink_1::alpha=1 \
          sink_2::xpos=0  sink_2::ypos=0    sink_2::alpha=1 \
        ! x265enc ! h265parse ! matroskamux \
        ! filesink location=$TODAY_DIR/$DAYANDTIME.mkv sync=false \
      videotestsrc pattern="black" \
        ! "video/x-raw,format=(string)UYVY,width=3840,height=4320" \
        ! mix.sink_0 \
      filesrc location=$SCRIPT_DIR/twotracks.mkv \
        ! matroskademux name=demux \
      demux.video_0 \
        ! avdec_h265 ! h265parse ! decodebin ! queue \
        ! mix.sink_0 \
      demux.video_1 \
        ! avdec_h265 ! h265parse ! decodebin ! queue \
        ! mix.sink_1
  ;;
esac

#

exit 0
