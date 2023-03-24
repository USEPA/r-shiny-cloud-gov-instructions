#!/bin/bash

#Make sure we get a command line parameter for the file
if [ $# -eq 0 ]
  then
    echo "Supply the location of the lib (e.g. /usr/lib/libgdal.so)"
    exit
fi

#Check that the file exists
if ! test -e "$1"; then
    echo "$1 does not exist"
    exit
fi

DIR=$(dirname "$1")
FILE=$(basename "$1")

TEMP_DIR=temp_lib

mkdir $TEMP_DIR

if test -d "$1"; then
    cp -vr $1 $TEMP_DIR
else
    cp -v $1 $TEMP_DIR
fi

if [[ "$FILE" == *".so"* ]]; then
    ldd $1 | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' $TEMP_DIR
fi

FILE_NAME="$FILE.tar.gz"

cd $TEMP_DIR

tar czvf $FILE_NAME *

cp $FILE_NAME ../r-lib
cd -

rm -rf $TEMP_DIR

echo "Complete: created $FILE_NAME containing the shared objects"