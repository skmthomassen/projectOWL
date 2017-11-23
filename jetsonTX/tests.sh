#!/bin/bash

VIDEO_DEV='/dev/video0'
AUDIO_DEV='hw:1'
WIDTH='3840'
HEIGHT='2160'
DAYANDTIME=$(date +"%Y%m%d-%H%M%S")
TODAY=$(date +"%b%d")
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

#FILE_PATH=$SCRIPT_DIR/clips/$TODAY
FILE_PATH="/mnt/container/hardware/jetsontxx/clips/$TODAY"
mkdir -p $FILE_PATH

PIPE="nvcamerasrc fpsRange=\"30 30\" \
		! \"video/x-raw(memory:NVMM), width=(int)1920, height=(int)1080, format=(string)I420, framerate=(fraction)30/1\" \
		! nvtee \
		! nvvidconv \
		! \"video/x-raw(memory:NVMM), width=(int)640, height=(int)480, format=(string)NV12\" \
		! omxh265enc iframeinterval=5 \
		! matroskamux \
		! filesink location=$FILE_PATH/$DAYANDTIME-%05d.mkv"

GST_DEBUG=3 gst-launch-1.0 -e $PIPE

echo $PIPE

exit 0







