#!/usr/bin/env bash

# Copyright 2022 draumaz
# Distributed under the terms of the MIT license

# yt-scraper
# scrape every video ID of a channel using invidious

touch .scrapefile
echo "-- connecting to invidious instance $INSTANCE"
echo "-- accessing channel ID $CHANNEL --"

for ((PAGE=1; ;++PAGE)); do
  
  echo -n "- scraping page $PAGE... "

  curl --silent $INSTANCE/channel/"$CHANNEL"?page=$PAGE | \
    grep -i "title=" | \
    grep -i "Watch on YouTube" | \
    cut -c75-85 \
  > .scrapefile

  if [ "$(cat .scrapefile)" == "" ]; then
    echo -e " done\n-- complete --"
    break
  else
    echo " done ($(wc -l .scrapefile | sed 's/ .scrapefile//g') IDs scraped)"
    cat .scrapefile >> "scrape_list.txt"
  fi
  
  > .scrapefile

done

rm .scrapefile

while read x; do
  yt-dlp https://youtu.be/"$x" -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
done < 'scrape_list.txt'

rm scrape_list.txt
