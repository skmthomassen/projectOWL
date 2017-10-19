#/bin/bash


ffmpeg -i inputfile -map 0 -c:a copy -c:s copy -c:v libx264 output.mkv

exit 0
