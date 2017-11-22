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

GST_DEBUG=3 gst-launch-1.0 -e nvcamerasrc fpsRange="30 30" \
	! 'video/x-raw(memory:NVMM), width=(int)1920, height=(int)1080, format=(string)I420, framerate=(fraction)30/1' \
	! nvtee \
	! nvvidconv \
	! 'video/x-raw(memory:NVMM), width=(int)640, height=(int)480, format=(string)NV12' \
	! omxh265enc \
	! matroskamux \
	! filesink location=$VID_DIR/$FILENAME.mkv


exit 0

#	! omxh264enc \
#	! qtmux \


#gst-launch-1.0 nvcamerasrc fpsRange="30.0 30.0" \
#	! 'video/x-raw(memory:NVMM), width=(int)1920, height=(int)1080, format=(string)I420, framerate=(fraction)30/1' \
#	! nvtee ! nvvidconv flip-method=2 \
#	! 'video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160' \
#	! omxh265enc iframeinterval=24 bitrate=10000000 \
#	! h265parse \
#	! queue name=queenc \
#	! matroskamux name=mux \
#	! filesink location=$VID_DIR/fromnvcam.mkv -e
