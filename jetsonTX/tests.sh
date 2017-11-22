#!/bin/bash

VIDEO_DEV='/dev/video0'
AUDIO_DEV='hw:1'
WIDTH='3840'
HEIGHT='2160'
DAYANDTIME=$(date +"%Y%m%d-%H%M%S")
TODAY=$(date +"%b%d")
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

mkdir -p $SCRIPT_DIR/clips/$TODAY/

CLIPS_DIR="$SCRIPT_PATH/clips/$TODAY"
#CLIPS_DIR="/mnt/container/hardware/Jetson\ TX/AVtests/17nov"


echo 'SCRIPT_DIR ' $SCRIPT_DIR
echo 'SCRIPT_PATH ' $SCRIPT_PATH

exit 0
