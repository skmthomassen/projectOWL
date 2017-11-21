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

echo "Starting recoring: "$FILENAME

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
