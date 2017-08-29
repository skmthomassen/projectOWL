#/bin/bash

mkdir $PWD/tmp

ls $PWD/clips/*202*.ts > $PWD/tmp/concat202
ls $PWD/clips/*203*.ts > $PWD/tmp/concat203

sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concat202
sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concat203

#ffmpeg -y -safe 0 -f concat -i $PWD/tmp/concat202 -c copy $PWD/clips/cat202.ts
#ffmpeg -y -safe 0 -f concat -i $PWD/tmp/concat203 -c copy $PWD/clips/cat203.ts
ffmpeg -y -safe 0 -f concat -i $PWD/tmp/concat202 -c:v hevc_nvenc -preset fast $PWD/clips/catt202.mp4
ffmpeg -y -safe 0 -f concat -i $PWD/tmp/concat203 -c:v hevc_nvenc -preset fast $PWD/clips/catt203.mp4

rm -r $PWD/tmp

exit 0
