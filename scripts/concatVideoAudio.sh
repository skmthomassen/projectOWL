#/bin/bash

if [ $# -ne 1 ] ; then
    echo "ERROR: no suffix provided"
    exit 10
fi

SUF=$1
DIR=$SUF

mkdir $PWD/tmp

ls $PWD/$DIR/*202*.ts > $PWD/tmp/concat202
ls $PWD/$DIR/*203*.ts > $PWD/tmp/concat203
ls $PWD/$DIR/*.aac > $PWD/tmp/concatAud

sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concat202
sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concat203
sed -i -e "s/\(.*\)/file '\1'/" $PWD/tmp/concatAud

ffmpeg -y -safe 0 -f concat -i $PWD/tmp/concat202 -c copy $PWD/$DIR/$SUF-cat202.ts
ffmpeg -y -safe 0 -f concat -i $PWD/tmp/concat203 -c copy $PWD/$DIR/$SUF-cat203.ts
ffmpeg -y -safe 0 -f concat -i $PWD/tmp/concatAud -c copy $PWD/$DIR/$SUF-catAud.aac

rm -r $PWD/tmp

#$PWD/merger.sh $SUF

exit 0
