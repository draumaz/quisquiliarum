#!/bin/sh

# gitbin is a proof-of-concept one-line GitHub binary installer.
# required variables:
# $BIN_PATH $BINARY $AUTHOR $NAME $BRANCH

ls -l ${BIN_PATH}/${BINARY}
curl -sL https://github.com/${AUTHOR}/${NAME}/archive/refs/heads/main.tar.gz | \
  sudo tar -xpzf - \
    --strip-components=1 \
    -C ${BIN_PATH} \
    ${NAME}-${BRANCH}/${BINARY}
ls -l ${BIN_PATH}/${BINARY}
