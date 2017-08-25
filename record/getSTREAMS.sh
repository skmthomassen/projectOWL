#/bin/bash

T="7"
NOCAMERAS=$(wc -l < $PWD/camIPs)
REMAINDER=$((60 - $(date +%S) ))
SNOOZE="$((REMAINDER+$T))"
NOW=$(date +"%m%d_%H%M")
BEGIN=$(date +%s)

SUF=$(head -n 1 $PWD/suffix)
SUF=$(( $SUF + 1 ))
echo $SUF > $PWD/suffix

if [ $NOCAMERAS -eq 2 -o $NOCAMERAS -eq 4 ] ; then
  for ((n=0;n<$NOCAMERAS;n++))
  do
    l="$(($n+1))"
    IP=$(sed "$l!d" $PWD/camIPs)
    at now +1 minutes <<< "$PWD/captureVIDEO.sh $IP $T" &
  done
else
  echo "ERROR: Incorrect number of cameras supplied"
  exit 10
fi

at now +1 minutes <<< "$PWD/captureAUDIO.sh $T" &

echo "Snoozing for:" $SNOOZE"s || "$(($SNOOZE/60))"m || "$(($SNOOZE/3600))"h"
sleep $SNOOZE

echo "Starting merging job at: " $(date +"%H%M")

ffmpeg -i "$PWD/clips/$SUF-202.ts" -i "$PWD/clips/$SUF-203.ts" -i "$PWD/clips/$SUF-audio.wav" \
-filter_complex "[1][0]scale2ref[2nd][ref];[ref][2nd]vstack" \
-y -c:v libx265 -preset veryfast -crf 28 -c:a aac "$SUF-mixerVA.mp4"

END=$(date +%s)
TOTALTIME=$(expr $END - $BEGIN)
echo "Total time of execution: " $TOTALTIME"s || "$(($TOTALTIME/60))"m || "$(($TOTALTIME/3600))"h"

exit 0
