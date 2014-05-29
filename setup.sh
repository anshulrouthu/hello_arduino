#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then
    if [ ! -f "arduino-1.0.5-macosx.zip" ]; then
        curl http://arduino.googlecode.com/files/arduino-1.0.5-macosx.zip -o arduino-1.0.5-macosx.zip
    fi
    unzip arduino-1.0.5-macosx.zip
    mkdir arduino-1.0.5
    cp -r Arduino.app/Contents/Resources/Java/* arduino-1.0.5
    rm -rf Arduino.app
    rm arduino-1.0.5-macosx.zip

elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    if [ ! -f "arduino-1.0.5-linux32.tgz" ]; then
        wget http://arduino.googlecode.com/files/arduino-1.0.5-linux32.tgz
    fi
    tar xvzf arduino-1.0.5-linux32.tgz
    rm arduino-1.0.5-linux32.tgz
fi
