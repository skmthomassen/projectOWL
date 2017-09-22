
IP2="192.168.0.202"
SEGTIME="600"

ffmpeg -hide_banner -thread_queue_size 512 -rtsp_transport tcp -i rtsp://$IP2/av0_0 -f segment \
  -segment_time $SEGTIME -y -c:v copy -segment_format mpegts "$PWD/clips/trials-202-%03d.ts"


# -loglevel 0
