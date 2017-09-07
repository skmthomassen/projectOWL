#/bin/bash

if [ $# -ne 1 ] ; then
    echo "ERROR: no suffix provided"
    exit 10
fi

SUF=$1

echo "---------------Will concatenate videos and audios---------------"
$PWD/concat.sh $1

echo "---------------Will now merge input into one video---------------"
$PWD/merger.sh $1
