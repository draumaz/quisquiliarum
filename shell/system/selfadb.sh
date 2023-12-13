#!/bin/sh

printf "enter pairing port: "; read PAIR_PORT
adb pair localhost:$PAIR_PORT

printf "enter debugging port: "; read DEBUG_PORT
adb connect localhost:$DEBUG_PORT

adb shell
