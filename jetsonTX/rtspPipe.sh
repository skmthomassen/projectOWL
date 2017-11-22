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
	rtspsrc location=rtsp://root:hest1234@192.168.130.201/axis-media/media.amp \
	latency=0 ntp-sync=true \
		! decodebin \
		! omxh265enc \
		! matroskamux \
		! filesink location=$VID_DIR/$FILENAME.mkv
		

exit 0

#! multifilesink next-file=max-duration max-file-duration=10000000000 location=$VID_DIR/$FILENAME-%05d.mkv

#gst-launch-1.0 rtspsrc location=rtsp://root:hest1234@192.168.130.201/axis-media/media.amp latency=0 ntp-sync=true ! rtph264depay ! h264parse ! omxh264dec ! videomixer name=mix sink_0::alpha=1 sink_1::alpha=0.5 ! omxh265enc ! matroskamux ! filesink location=out3.mkv rtspsrc location=rtsp://root:hest1234@192.168.130.200/axis-media/media.amp latency=0 ntp-sync=true ! rtph264depay ! h264parse ! omxh264dec ! mix.
