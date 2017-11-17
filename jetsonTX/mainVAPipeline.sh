#!/bin/bash

V_DEV='/dev/video0'
A_DEV='hw:1'
FILENAME=$(date +"%Y%m%d-%H%M%S")
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#VID_DIR="$SCRIPTPATH/videos"
VID_DIR="/mnt/container/hardware/Jetson\ TX/AVtests/16november"

echo "Starting recoring: "$FILENAME

gst-launch-1.0 -e \
	v4l2src device=$V_DEV \
		! progressreport update-freq=10 \
		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
		! "video/x-raw, format=(string)UYVY, framerate=30/1, width=(int)3840, height=(int)2160" \
		! nvvidconv \
		! "video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160, framerate=30/1" \
		! omxh265enc gst_omx_video_enc_change_state iframeinterval=1100000000 \
		! matroskamux \
		! filesink location=$VID_DIR/$FILENAME.mkv

exit 0


#SliceIntraRefreshEnable=true SliceIntraRefreshInterval=1

# iframe-period=10
#		! multifilesink next-file=max-duration max-file-duration=300000000000 location=$VID_DIR/$FILENAME-%05d.mkv

#duration i nanosekunder: 5min=300000000000 - 3*e^11 || 1min=60000000000 - 6*e^10 || 30sec=30000000000 - 3*e^10
#streamable=true 
#		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \

#gst-launch-1.0 -e \
#	v4l2src device=$V_DEV \
#		! progressreport update-freq=10 \
#		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#		! "video/x-raw, format=(string)UYVY, framerate=30/1, width=(int)3840, height=(int)2160" \
#		! nvvidconv \
#		! "video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160, framerate=30/1" \
#		! omxh265enc \
#		! mux. \
#	alsasrc device=$A_DEV \
#		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#		! audioconvert \
#		! voaacenc \
#		! mux. \
#	matroskamux name=mux \
#		! filesink location=$VID_DIR/$FILENAME.mkv

#		! splitmuxsink muxer=matroskamux location=$VID_DIR/$FILENAME-%03d.mkv max-size-time=100000000000


