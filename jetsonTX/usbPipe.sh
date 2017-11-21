#!/bin/bash

#V_DEV='/dev/video0'
#A_DEV='hw:1'
width='640'
height='480'
FILENAME=$(date +"%Y%m%d-%H%M%S")
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
VID_DIR="$SCRIPTPATH/videos"
#VID_DIR="/mnt/container/hardware/Jetson\ TX/AVtests/17nov"

echo "Starting recoring: "$FILENAME

GST_DEBUG=3 gst-launch-1.0 -e \
	rtspsrc location=rtsp://192.168.130.200 \
		! decodebin
		! xvideosink

exit 0



