#!/bin/bash

path=`dirname $0`

SRC_DIR=$1
PRODUCT=CoronaEnterprise

if [ -z "$1" ]
then
	echo "$0 src_dir"
	echo ""
	echo "	src_dir is the folder containing $PRODUCT.tgz"
	exit -1
fi

# Create tmp dir
TMP_DIR=`mktemp -d /tmp/temp.XXXXXXXXXXXXXXXX`

# 
# Canonicalize relative paths to absolute paths
# 
pushd $path > /dev/null
dir=`pwd`
path=$dir
popd > /dev/null

pushd $SRC_DIR > /dev/null
dir=`pwd`
SRC_DIR=$dir
popd > /dev/null

#
# Checks exit value for error
# 
checkError() {
    if [ $? -ne 0 ]
    then
        echo "Exiting due to errors (above)"
        exit -1
    fi
}

# Unzip CoronaEnterprise into tmp dir
tar xzvf "$SRC_DIR/$PRODUCT.tgz" -C "$TMP_DIR"

APP_PROJECT_DIR="$TMP_DIR/$PRODUCT/Project Template/App"

#
# iOS
# 

# Remap CoronaEnterprise symlink to $TMP_DIR/$PRODUCT
cd "$APP_PROJECT_DIR/ios"
rm "$PRODUCT"
ln -s "$TMP_DIR/$PRODUCT" "$PRODUCT"
cd -

# Test build iOS Device
xcodebuild -project "$APP_PROJECT_DIR/ios/App.xcodeproj" -target App -configuration Release -sdk iphoneos
checkError

# Test build iOS Simulator
xcodebuild -project "$APP_PROJECT_DIR/ios/App.xcodeproj" -target App -configuration Release -sdk iphonesimulator
checkError


#
# Android
#
 
# Test build Android
cd "$APP_PROJECT_DIR/android"
./build.sh "$ANDROID_SDK" "$TMP_DIR/$PRODUCT"
checkError
cd -

# Remove tmp files
rm -rf $TMP_DIR
