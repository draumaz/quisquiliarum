#!/bin/sh -e

printf "type some secret input below.\n"
stty -echo
printf "=> "
read x
stty echo
printf "it appears that you said: '$x'.\n"
unset x

