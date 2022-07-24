#!/bin/bash
# warden, by draumaz | 2022
# Mount/unmount filesystems and safely enter/exit chroots
# usage: $ su -c "sh warden.sh /path/to/chroot"

if [ ! $(id -u) = 0 ]; then echo "Re-run as root" & exit; fi
if [ -z "$1" ]; then echo "No chroot given" & exit; fi
mpt=("dev" "run" "proc") # maybe adjust?
for i in ${mpt[@]}; do mount -v --bind /"${i}" ${1}/"${i}"; done
echo "Entering ${1}"; chroot ${1}/. /bin/bash
for i in ${mpt[@]}; do umount -v "${1}"/"${i}"; done
