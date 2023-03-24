if [ -d "/home/vcap" ]; then 
    if [ -d "r-lib" ]; then 
        for L in $(ls r-lib); do
            tar -xf r-lib/$L -C /home/vcap/deps/0/r/lib
        done;
    fi;
fi;

export GDAL_DATA=/home/vcap/deps/0/r/lib/gdal