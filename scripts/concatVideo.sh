#/bin/bash

if [ $# -ne 1 ] ; then
    FILE=$(ls | tail -1)
else
	FILE=$1
fi

EXT=${FILE##*.}

FILENAME=$"20171122-104839"
EXT=$"mkv"
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

mkdir -p $SCRIPT_DIR/tmp
ls $SCRIPT_DIR/$FILENAME*.$EXT > $SCRIPT_DIR/tmp/concat.txt
sed -i -e "s/\(.*\)/file '\1'/" $SCRIPT_DIR/tmp/concat.txt
ffmpeg -y -safe 0 -f concat -i $SCRIPT_DIR/tmp/concat.txt -c copy $SCRIPT_DIR/$FILENAME-cat.$EXT
rm -r $SCRIPT_DIR/tmp


exit 0

