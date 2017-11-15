#!/bin/bash

V_DEV='/dev/video0'
A_DEV='hw:1'
FILENAME=$(date +"%Y%m%d-%H%M%S")
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#VID_DIR="$SCRIPTPATH/videos"
VID_DIR="/mnt/container/hardware/Jetson\ TX/AVtests"

echo "Starting recoring: "$FILENAME

gst-launch-1.0 -e \
	v4l2src device=$V_DEV \
		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
		! "video/x-raw, format=(string)UYVY, framerate=30/1, width=(int)3840, height=(int)2160" \
		! nvvidconv \
		! "video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160, framerate=30/1" \
		! omxh265enc \
		! mux. \
	alsasrc device=$A_DEV \
		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
		! audioconvert \
		! voaacenc \
		! mux. \
	matroskamux name=mux \
		! filesink location=$VID_DIR/$FILENAME.mkv

exit 0

#		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#		! progressreport update-freq=3 \

#	alsasrc device=$A_DEV \
#		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#		! audioconvert \
#		! flacenc \
#		! mux. \

#gst-launch-1.0 v4l2src ! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 ! "video/x-raw, format=(string)UYVY, framerate=30/1, width=(int)3840, height=(int)2160" ! nvvidconv ! "video/x-raw(memory:NVMM), format=(string)I420, framerate=30/1, width=(int)3840, height=(int)2160" ! omxh264enc ! matroskamux ! queue ! \filesink location=now1.mkv

#gst-launch-1.0 
#	v4l2src 
#		! "video/x-raw, format=(string)UYVY, width=(int)3840, height=(int)2160" 
#		! nvvidconv 
#			! "video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160" 
#		! omxh264enc 
#		! matroskamux 
#		! queue 
#	! filesink location=file.mkv

#gst-launch-1.0 -e \
#	v4l2src \
#		! progressreport update-freq=10 \
#		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#		! 'video/x-raw, format=(string)I420, framerate=30/1, width=(int)3840, height=(int)2160' \
#		! videoconvert \
#		! omxh265enc \
#		! mux. \
#	alsasrc device=$A_DEV \
#		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#		! audioconvert \
#		! flacenc \
#		! mux. \
#	matroskamux name=mux min-index-interval=1000000000\
#		! filesink location=$VID_DIR/$FILENAME.mkv

