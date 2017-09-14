#/bin/bash

if [ $# -ne 1 ] ; then
    echo "ERROR: no suffix provided"
    exit 10
fi

SUF=$1

mkdir $PWD/tmp

ls $PWD/clips/$1-202*.ts > $PWD/tmp/concat202
ls $PWD/clips/$1-203*.ts > $PWD/tmp/concat203
ls $PWD/clips/$1-audio*.aac > $PWD/tmp/concatAud

sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concat202
sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concat203
sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concatAud

ffmpeg -hide_banner -y -safe 0 -f concat -i $PWD/tmp/concat202 -c copy $PWD/clips/$SUF-cat202.ts
ffmpeg -hide_banner -y -safe 0 -f concat -i $PWD/tmp/concat203 -c copy $PWD/clips/$SUF-cat203.ts
ffmpeg -hide_banner -y -safe 0 -f concat -i $PWD/tmp/concatAud -c copy $PWD/clips/$SUF-catAud.aac

rm -r $PWD/tmp

$PWD/merger.sh $SUF

exit 0
