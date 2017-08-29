#/bin/bash

#ffmpeg -i "$PWD/clips/cat202.ts" -i "$PWD/clips/cat203.ts" \
#-filter_complex "[1][0]scale2ref[2nd][ref];[ref][2nd]vstack" \
#-y -c:v libx265 -preset veryfast -crf 28 -c:a aac "$SUF-mixer.mp4"

SUF="57"

#-i "$PWD/clips/$SUF-audio.wav"

##FOR RUNNING WITHOUT HW ACCELERATION
#ffmpeg -i "$PWD/clips/cat202.ts" -i "$PWD/clips/cat203.ts" -filter_complex "[1][0]scale2ref[2nd][ref];[ref][2nd]vstack" \
#-y -c:v libx265 -preset veryfast -crf 28 -c:a aac "$SUF-mixer.mp4"

ffmpeg -i "$PWD/clips/cat202.ts" -i "$PWD/clips/cat203.ts" \
-filter_complex "[1][0]scale2ref[2nd][ref];[ref][2nd]vstack" \
-y -c:v hevc_nvenc -preset fast -crf 28 -c:a aac "$SUF-mixer.mp4"


exit 0
