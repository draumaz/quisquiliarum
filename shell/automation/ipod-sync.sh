#!/bin/sh -e
#
# iPod sync tool (rsync, shell)
# draumaz, 2022-23 | GPL v3
#

## BEGIN CONFIG ##
##
DESTINATION_MOUNT_DRIVE=""  # e.g. /dev/sda2
DESTINATION_MOUNT_POINT=""  # e.g. /mnt/iPod
DESTINATION_MUSIC_FOLDER="" # e.g. /mnt/iPod/Music (note the _lack_ of a final slash)
LOCAL_MUSIC_FOLDER=""       # e.g. /media/Storage/Music/ (note the final slash)
##
## END CONFIG ##

RSYNC_ARGUMENTS="--recursive --update --verbose --checksum --delete"

elev_chk() { case `id -u` in 1000) SU=sudo; which -s sudo || SU=doas ;; esac; }
rs_put() { "${SU}" rsync ${RSYNC_ARGUMENTS} ${LOCAL_MUSIC_FOLDER_PREFIX} ${DESTINATION_MUSIC_FOLDER}; }
fs_post() { printf "syncing... "; sync; printf "done\n"; }
su_att() { "$SU" false }

devi() {
	case $1 in
	  mnt)
	  	case `find ${DESTINATION_MOUNT_POINT}` in "")
			printf "connect your iPad and hit enter to mount. "; read i
			if "${SU}" mount ${DESTINATION_MOUNT_DRIVE} ${DESTINATION_MOUNT_POINT}; then
		  	printf "iPod mounted successfully.\n"; else printf "couldn't mount.\n" && exit; fi
	  	esac ;;
	  umnt)
	    printf "unmount iPod? [y/n]: "; read i
		case $i in y|Y)
		  ${SU} umount ${DESTINATION_MOUNT_POINT}
		  printf "unmounted. remember to update the rockbox database.\n"
		esac ;;
	esac
}

elev_chk; su_att; devi mnt; rs_put; fs_post; devu umnt