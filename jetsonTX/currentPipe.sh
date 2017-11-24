#!/bin/bash

ARG=$1
VIDEO_DEV='/dev/video0'
AUDIO_DEV='hw:1'
DAYANDTIME=$(date +"%Y%m%d-%H%M%S")
TODAY=$(date +"%b%d")
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

#FILE_PATH=$SCRIPT_DIR/clips/$TODAY
FILE_PATH="/mnt/container/hardware/jetsontxx/clips/$TODAY"
mkdir -p $FILE_PATH

echo "Starting recoring: " $FILE_PATH/$DAYANDTIME

case $ARG in
	-5)
	GST_DEBUG=3 gst-launch-1.0 -e nvcamerasrc fpsRange="30 30" \
		! "video/x-raw(memory:NVMM), width=(int)3840, height=(int)2160, format=(string)I420, framerate=(fraction)30/1" \
		! nvtee ! nvvidconv \
		! "video/x-raw(memory:NVMM), width=(int)3840, height=(int)2160, format=(string)NV12" \
		! omxh265enc \
		! h265parse \
		! mux. \
	alsasrc device=$A_DEV \
		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
		! audioconvert \
		! voaacenc \
		! mux. \
		! splitmuxsink muxer="matroskamux name=mux max-size-time=9000000000 location=$FILE_PATH/$DAYANDTIME-%05d.mkv"
	;;
	-4)
	GST_DEBUG=3 gst-launch-1.0 -e nvcamerasrc fpsRange="30 30" \
		! "video/x-raw(memory:NVMM), width=(int)3840, height=(int)2160, format=(string)I420, framerate=(fraction)30/1" \
		! nvtee ! nvvidconv \
		! "video/x-raw(memory:NVMM), width=(int)3840, height=(int)2160, format=(string)NV12" \
		! omxh265enc \
		! h265parse \
		! splitmuxsink location=$FILE_PATH/$DAYANDTIME-%05d.mkv max-size-time=9000000000 muxer=matroskamux
	;;
	-3)
	GST_DEBUG=3 gst-launch-1.0 -e nvcamerasrc fpsRange="30 30" \
		! "video/x-raw(memory:NVMM), width=(int)1920, height=(int)1080, format=(string)I420, framerate=(fraction)30/1" \
		! nvtee ! nvvidconv \
		! "video/x-raw(memory:NVMM), width=(int)640, height=(int)480, format=(string)NV12" \
		! omxh264enc  \
		! h264parse \
		! splitmuxsink location=$FILE_PATH/$DAYANDTIME-%05d.mkv max-size-time=5000000000
	;;
	-2)
	GST_DEBUG=3 gst-launch-1.0 -e nvcamerasrc fpsRange="30 30" \
		! "video/x-raw(memory:NVMM), width=(int)1920, height=(int)1080, format=(string)I420, framerate=(fraction)30/1" \
		! nvtee ! nvvidconv \
		! "video/x-raw(memory:NVMM), width=(int)640, height=(int)480, format=(string)NV12" \
		! omxh265enc iframeinterval=5 \
		! matroskamux \
		! filesink location=$FILE_PATH/$DAYANDTIME-%05d.mkv
	;;
	-1)
	GST_DEBUG=3 gst-launch-1.0 -e v4l2src device=$V_DEV \
		! progressreport update-freq=10 \
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
	;;
	*)
	GST_DEBUG=3 gst-launch-1.0 -e v4l2src \
		! progressreport update-freq=10 \
		! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
		! "video/x-raw, format=(string)UYVY, framerate=30/1, width=(int)3840, height=(int)2160" \
		! nvvidconv \
		! "video/x-raw(memory:NVMM), format=(string)I420, width=(int)3840, height=(int)2160, framerate=30/1" \
		! omxh265enc \
		! matroskamux min-index-interval=1000000\
		! filesink location=$FILE_PATH/$DAYANDTIME.mkv
	;;
esac








