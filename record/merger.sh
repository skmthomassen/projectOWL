#/bin/bash

#ffmpeg', '-y', '-f', 'concat', '-i', 'tmpdir/render', '-c', 'copy', 'tmpdir/outRender.mp4'
#ffmpeg -y -f concat -i $PWD/clips -c copy OUT.mp4

SUF="56"

ffmpeg -i "$PWD/clips/$SUF-202.ts" -i "$PWD/clips/$SUF-203.ts" -i "$PWD/clips/$SUF-audio.wav" \
-filter_complex "[1][0]scale2ref[2nd][ref];[ref][2nd]vstack" \
-y -c:v libx265 -preset veryfast -crf 28 -c:a aac "$SUF-mixerVA.mp4"




exit 0
