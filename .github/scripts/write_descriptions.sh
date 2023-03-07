#!/usr/bin/bash

# Check if a temp direcorty is defined in the environment
if [[ -z $TMPDIR ]]
then
	echo "Did not find a temp directory (TMPDIR environment variable)"
	exit 1
fi

# Check to see if the package directory was passed as an argument
if [[ -z $1 ]]
then
	echo "Please pass the package directory as an argument" 
	exit 1
fi

# If the package directory did not end in a slash then add it
if [[ "$1" != *"/" ]]; then
	$1="${1}/"
fi

# The files to look through for the packages 
FILES="${1}*.gz"

# Set up a temporary directory in the system temp dir 
TMP_DIR="${TMPDIR}/tmp_vendor_packages"
mkdir $TMP_DIR 

# Copy the packages to the temporary directory
cp $FILES $TMP_DIR

cd $TMP_DIR

# Create the packages file
touch PACKAGES
count=0

# Iterate over the files and pull out the PACKAGE file
for f in *.gz 
do
	PKG_FILES=`tar tzf $f | grep DESCRIPTION`
	echo "Processing file $f $PKG_FILE"
	if [[ -n $PKG_FILES ]]
	then
		for descr in $PKG_FILES 
		do
			echo "Found package description $descr" 
			tar xvzf $f $descr 
			cat $descr >> PACKAGES 
			echo "" >> PACKAGES
			rm -rf "${descr/DESCRIPTION//}"
			count=$((count+1))
		done
	else
		echo "No DESCRIPTION file found for $f"
	fi
done

cd -

mv "${TMP_DIR}/PACKAGES" $1

echo "Wrote $count descriptions to the PACKAGES file in $1"

rm -rf $TMP_DIR
	
