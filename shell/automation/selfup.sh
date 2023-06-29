#!/bin/sh

ls -l ${BIN_PATH}/${SOFTWARE}
curl -sL https://github.com/${AUTHOR}/${SOFTWARE}/archive/refs/heads/main.tar.gz | \
  sudo tar -xpzf - \
    --strip-components=1 \
    -C ${BIN_PATH} \
    ${SOFTWARE}-${BRANCH}/${SOFTWARE}
ls -l ${BIN_PATH}/${SOFTWARE}
