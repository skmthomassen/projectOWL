#!/bin/bash

V_DEV='/dev/video0'
A_DEV='hw:1'
width='3840'
height='2160'
FILENAME=$(date +"%Y%m%d-%H%M%S")
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
VID_DIR="$SCRIPTPATH/videos"
#VID_DIR="/mnt/container/hardware/Jetson\ TX/AVtests/20nov"

echo "---Recording: "$FILENAME

GST_DEBUG=3 gst-launch-1.0 -e videotestsrc num-buffers=200 \
	! 'video/x-raw, width=(int)1280, height=(int)720, format=(string)I420' \
	! omxh265enc iframeinterval=100 \
	! matroskamux \
	! multifilesink next-file=max-duration max-file-duration=10000000000 location=$VID_DIR/$FILENAME-%05d.mkv


exit 0
