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
	-2)
	GST_DEBUG=3 gst-launch-1.0 -e nvcamerasrc fpsRange="30 30" \
		! "video/x-raw(memory:NVMM), width=(int)1920, height=(int)1080, format=(string)I420, framerate=(fraction)30/1" \
		! nvtee \
		! nvvidconv \
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

#duration i nanosekunder: 5min=300000000000 - 3*e^11 || 1min=60000000000 - 6*e^10 || 30sec=30000000000 - 3*e^10 || 5sec=5000000000 - 5*e^9
#! multifilesink next-file=max-duration max-file-duration=5000000000 location=$FILE_PATH/$DAYANDTIME-%05d.mkv


#---SRC---#
#videotestsrc num-buffers=200
#filesrc location=/home/nvidia/projectOWL/jetsonTX/videos/kittens.mkv
#rtspsrc location=rtsp://root:hest1234@192.168.130.201/axis-media/media.amp latency=0 ntp-sync=true

#---SINK---#
#ximagesink (x11 video output sink based on xlib)
#xvimagesink (gst BASE element)


#gst-launch-1.0 rtspsrc location=rtsp://root:hest1234@192.168.130.201/axis-media/media.amp latency=0 ntp-sync=true ! rtph264depay ! h264parse ! omxh264dec ! videomixer name=mix sink_0::alpha=1 sink_1::alpha=0.5 ! omxh265enc ! matroskamux ! filesink location=out3.mkv rtspsrc location=rtsp://root:hest1234@192.168.130.200/axis-media/media.amp latency=0 ntp-sync=true ! rtph264depay ! h264parse ! omxh264dec ! mix.







