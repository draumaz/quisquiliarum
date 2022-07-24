#!/usr/local/bin bash

# Copyright 2022 draumaz

# run this in a directory with a bunch of mp4s,
# and they will be turned into a lovely folder
# hierarchy

for i in *.mp4; do 
  mkdir -v "${i%.mp4}"
  mv -v "$i" "${i%.mp4}"/video.mp4
done
