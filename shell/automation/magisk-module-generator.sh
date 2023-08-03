#!/bin/sh -e

WORK="$PWD/module-working"

mkdir -pv "${WORK}"; cd "${WORK}"

mkdir -pv META-INF/com/google/android
cat > META-INF/com/google/android/update-binary << EOF
#!/sbin/sh

#################
# Initialization
#################

umask 022

# echo before loading util_functions
ui_print() { echo "$1"; }

require_new_magisk() {
  ui_print "*******************************"
  ui_print " Please install Magisk v20.4+! "
  ui_print "*******************************"
  exit 1
}

#########################
# Load util_functions.sh
#########################

OUTFD=$2
ZIPFILE=$3

mount /data 2>/dev/null

[ -f /data/adb/magisk/util_functions.sh ] || require_new_magisk
. /data/adb/magisk/util_functions.sh
[ $MAGISK_VER_CODE -lt 20400 ] && require_new_magisk

install_module
exit 0
EOF

echo "#MAGISK" > META-INF/com/google/android/updater-script

cat > module.prop << EOF
id=example
name=example
version=1
versionCode=1
author=draumaz
description=Example
EOF

ls -l module.prop

cat > service.sh << EOF
#!/system/bin/sh
MODDIR=\${0%/*}
MNAME=\$(basename \$MODDIR)

sleep 20
EOF

ls -l service.sh

echo "service.sh prepared for code. edit module.prop."
