#!/bin/bash

#V_DEV=''
A_DEV='hw:1'
FILENAME=$(date +"%Y%m%d-%H%M%S")
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#VID_DIR="$SCRIPTPATH/videos"
VID_DIR="/mnt/container/hardware/Jetson\ TX/AVtests"

gst-launch-1.0 -e \
	v4l2src \
		! "video/x-raw, format=(string)UYVY, width=(int)3840, height=(int)2160" \
		! nvvidconv \
		! "video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160" \
		! omxh265enc \
		! matroskamux \
		! queue \
		! filesink location=$VID_DIR/$FILENAME.mkv


exit 0
