#/bin/bash

L=$"20171018-101830-cat202.ts"
R=$"20171018-101830-cat203.ts"
A=$"20171018-101830-catAud.aac"

#-c:v hevc_nvenc -preset fast -crf 28 -c:a aac
ffmpeg -hide_banner -i clips/$L -i clips/$A -c:v hevc_nvenc -preset fast -map 0:v:0 -map 1:a:0 -c:a aac 20171018-101830-cam2-aud.mp4
ffmpeg -hide_banner -i clips/$R -i clips/$A -c:v hevc_nvenc -preset fast -map 0:v:0 -map 1:a:0 -c:a aac 20171018-101830-cam3-aud.mp4

exit 0
