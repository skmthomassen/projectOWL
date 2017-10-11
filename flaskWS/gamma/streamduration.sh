 #/bin/bash

ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4

exit 0
