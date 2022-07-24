# draumaz/prorun
# Run executable inside of a Proton prefix.
# $1 ~ the prefix (e.g. 10090)
# $2 ~ the executable

export PROTON_BIN="" # Set to Proton's path.

if [ -z "$PROTON_BIN" ]; then echo "You forgot to set the Proton binary variable. Enter it below."; read $PROTON_BIN; fi
export STEAM_COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata/$1"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
export WINEPREFIX=$STEAM_COMPAT_DATA_PATH/pfx
"$PROTON_BIN" run "$2" 2>&1
