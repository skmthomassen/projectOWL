#/bin/bash

TIME=$1
SUF=$(head -n 1 $PWD/suffix)

ffmpeg -thread_queue_size 512 -f alsa -i hw:2 -y -acodec copy -t $TIME "$PWD/clips/$SUF-audio.wav"
#ffmpeg -f alsa -i hw:2 -t $T "audio-$NOW.wav"

exit 0
