# iPod sync tool (rsync, bash)
# draumaz, 2022 | GPL v3

## BEGIN CONFIG ##

DESTINATION_MOUNT_DRIVE="" # e.g. /dev/sda2
DESTINATION_MOUNT_POINT="" # e.g. /mnt/iPod
DESTINATION_MUSIC_FOLDER="" # e.g. /mnt/iPod/Music (note the lack of a final slash)
LOCAL_MUSIC_FOLDER="" # e.g. /media/Storage/Music/ (note the final slash)

## END CONFIG ##

RSYNC_ARGUMENTS="--recursive --update --verbose --checksum --delete"

elev_chk() {
	if [ "$(id -u)" == "1000" ]; then 
		if [ -f /usr/bin/doas ]; then
			SU="doas"
		else
			SU="sudo"
		fi
	else 
		SU=""
	fi
}

su_att() {
	"$SU" false # init superuser access thru persist
}

dev_mnt() {
	if [ "$(ls $DESTINATION_MOUNT_POINT)" == "" ]; then
		echo -n "connect your iPod and hit enter to mount. "; read i
		if "$SU" mount $DESTINATION_MOUNT_DRIVE "$DESTINATION_MOUNT_POINT" > /dev/null 2>&1; then
			echo "mounted iPod."
		else
			echo "couldn't mount iPod."
			exit
		fi
	fi
}

rs_put() {
	"$SU" rsync $RSYNC_ARGUMENTS "$LOCAL_MUSIC_FOLDER_PREFIX" "$DESTINATION_MUSIC_FOLDER"
}

fs_post() {
	echo -n "syncing..."
	if sync; then echo " done"; else echo " fail"; fi
}

dev_umnt() {
	echo -n "unmount iPod? (y/n): "; read i
	if [ "$i" == "y" ] || [ "$i" == "Y" ]; then
		"$SU" umount "$DESTINATION_MOUNT_POINT"
		echo "unmounted. remember to update your rockbox database."
	fi
}

elev_chk
su_att
dev_mnt
rs_put
fs_post
dev_umnt
