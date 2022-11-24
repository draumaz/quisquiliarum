#!/bin/sh

file=`find /sys/class/backlight/*`/brightness

case ${1} in
  -*|+*) VAL=$(($(cat $file)${1}${2})) ;;
  *) VAL=${1} ;;
esac

echo "${0}: setting brightness to $VAL"

echo $VAL > $file

# End of file
