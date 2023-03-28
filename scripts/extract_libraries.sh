#!/bin/bash

if [ -d "/home/vcap" ]; then 
    if [ -d "r-lib" ]; then 
        for L in $(ls r-lib); do
            tar -xf r-lib/$L -C /home/vcap/deps/0/r/lib
        done;
    fi;
fi;

# /home/vcap/deps/0/apt/usr/share/gdal/2.2/