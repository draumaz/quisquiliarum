#!/bin/sh

file=`find /sys/class/backlight/*`/brightness

case ${1} in
  -*|+*) INC=0; VAL=$(($(cat $file)${1}${2})) ;; # funky shell-based math
  *) INC=1; VAL=${1} ;;
esac

printf "${0}: setting brightness to $VAL"
case $INC in 0) printf " (a change of ${1})\n" ;; 1) printf "\n" ;; esac

echo $VAL > $file

# End of file
