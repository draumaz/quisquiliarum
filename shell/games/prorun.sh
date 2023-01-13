#!/bin/sh

err() { printf "sh prorun.sh [prefix] [file]\n"; exit; }

test -z $1 && err
test -z $2 && err

export PROTON_BIN="$HOME/.steam/root/steamapps/common/Proton - Experimental/proton"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
export STEAM_COMPAT_DATA_PATH="${STEAM_COMPAT_CLIENT_INSTALL_PATH}/steamapps/compatdata/$1"
export WINEPREFIX="${STEAM_COMPAT_DATA_PATH}/pfx"

cat << EOF
loading file "$2" in prefix "$1"
EOF

"$PROTON_BIN" run "$2" > /dev/null 2>&1
