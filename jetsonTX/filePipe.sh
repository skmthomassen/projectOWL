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

echo "---Recording: "$FILENAME

GST_DEBUG=3 gst-launch-1.0 -e filesrc location=/home/nvidia/projectOWL/jetsonTX/videos/kittens.mkv ! ximagesink
		

exit 0

#		! h265parse \
#		! matroskamux \
#! multifilesink next-file=max-duration max-file-duration=10000000000 location=$VID_DIR/$FILENAME-%05d.mkv
#		! matroskademux \
# omxh265enc
#		! filesink location=$VID_DIR/$FILENAME.mkv

