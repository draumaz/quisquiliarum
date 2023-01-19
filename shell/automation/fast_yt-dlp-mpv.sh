#!/bin/sh -e

# an ultra-fast, hacky way
# to watch YouTube videos in mpv
# with quite literally zero lag.

case "${@}" in "") cat << EOF
$ ${0} [URL] [flag]

flags
-------
--blind | audio only
EOF
exit ;; esac

case "${2}" in -b|--blind) VIDEO_FLAG="--no-video" ;; esac

yt-dlp --quiet "${1}" -o - 2> /dev/null | \
  mpv - ${VIDEO_FLAG}
