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


GST_DEBUG=3 gst-launch-1.0 -e filesrc location=/home/nvidia/projectOWL/jetsonTX/videos/kittens.mkv ! ximagesink
		

exit 0

#		! h265parse \
#		! matroskamux \
#! multifilesink next-file=max-duration max-file-duration=10000000000 location=$VID_DIR/$FILENAME-%05d.mkv
#		! matroskademux \
# omxh265enc
#		! filesink location=$VID_DIR/$FILENAME.mkv

