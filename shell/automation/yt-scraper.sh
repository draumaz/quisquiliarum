#!/usr/bin/env bash

# Copyright 2022 draumaz
# Distributed under the terms of the MIT license

# sloice
# scrape every video ID of a channel using invidious

# set environment variable CHANNEL to the channel ID
# (the long string that comes after channel/ in the URL)

# e.g. $ CHANNEL="U$)WUTOWIERWERwoE" bash yt-scraper.sh
# i hope this documentation is sufficient :)

# SET THIS
INSTANCE="" # insecure http only

touch .sloicetmp
echo "-- scraping channel ID $CHANNEL --"

for ((PAGE=1; ;++PAGE)); do
  
  echo -n "- scraping page $PAGE... "

  curl --silent http://$INSTANCE/channel/"$CHANNEL"?page=$PAGE | \
    grep -i "title=" | \
    grep -i "Watch on YouTube" | \
    cut -c75-85 \
  > .sloicetmp

  if [ "$(cat .sloicetmp)" == "" ]; then
    echo -e " done\n-- complete --"
    break
  else
    echo " done ($(wc -l .sloicetmp | sed 's/ .sloicetmp//g') IDs scraped)"
    cat .sloicetmp >> "sloice_ids.txt"
  fi
  
  > .sloicetmp

done

rm .sloicetmp

while read x; do
  yt-dlp https://youtu.be/"$x" -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
done < 'sloice_ids.txt'
