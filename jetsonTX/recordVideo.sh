#!/bin/bash

VIDEO_DEV='/dev/video0'
AUDIO_DEV='hw:1'
WIDTH='3840'
HEIGHT='2160'
DAYANDTIME=$(date +"%Y%m%d-%H%M%S")
TODAY=$(date +"%b%d")
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
mkdir -p $SCRIPT_DIR/clips/$TODAY
CLIPS_DIR=$SCRIPT_DIR/clips/$TODAY
#CLIPS_DIR=$(mkdir -p /mnt/container/hardware/jetsontxx/clips/$TODAY/)

echo "Starting recoring: " $CLIPS_DIR/$DAYANDTIME


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
