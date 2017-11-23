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

echo "Starting recoring: " $FILE_PATH/$DAYANDTIME

GST_DEBUG=3 gst-launch-1.0 -e \
	v4l2src \
		! progressreport update-freq=10 \
		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
		! "video/x-raw, format=(string)UYVY, framerate=30/1, width=(int)3840, height=(int)2160" \
		! nvvidconv \
		! "video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160, framerate=30/1" \
		! omxh265enc \
		! matroskamux min-index-interval=1000000 \
		! filesink location=$FILE_PATH/$DAYANDTIME.mkv

exit 0

#---OMXH265ENC---#
#iframeinterval --> Unsigned Integer. Range: 0 - 4294967295 Default: 0


#! multifilesink next-file=max-duration max-file-duration=30000000000 location=$VID_DIR/$FILENAME-%05d.mkv
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


