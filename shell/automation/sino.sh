#!/bin/sh

curl -sL https://en.wiktionary.org/wiki/${1} | \
  grep "Sinological" | grep "Mandarin"| tr ' ' '\n' | \
  grep class | grep IPA | sed 's/class="IPA">//g' | \
  sed 's|</span><br||g' | head -1
