#!/bin/bash

if [ -d "/home/vcap" ]; then 
    if [ -d "r-lib" ]; then 
        for L in $(ls r-lib); do
            tar -xf r-lib/$L -C /home/vcap/deps/0/r/lib
        done;
    fi;

    if [ -d "r-usr-share" ]; then
        if [ ! -d "/home/vcap/deps/0/r/usr" ]; then 
            mkdir "/home/vcap/deps/0/r/usr"; 
            mkdir "/home/vcap/deps/0/r/usr/share";
        fi
        for L in $(ls r-usr-share); do
            tar -xf r-usr-share/$L -C /home/vcap/deps/0/r/usr/share
        done;
        export GDAL_DATA=/home/vcap/deps/0/r/usr/share/gdal/2.2
    fi;
fi;

# /home/vcap/deps/0/apt/usr/share/gdal/2.2/