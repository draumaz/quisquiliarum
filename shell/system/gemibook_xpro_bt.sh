#!/bin/sh

I="/usr/lib/firmware/intel/ibt"

for J in sfi ddc; do
  ln -sv $I-1040-4150.$J.xz $I-0040-1050.$J.xz
done
