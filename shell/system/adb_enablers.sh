#!/bin/sh

case `adb devices | wc | awk '{print $1}'` in
  2) echo "[fatal] please connect your phone and try again."; exit 1 ;;
esac

kde_connect_bidirectional_clipboard_sync_enable() {
  local pkg="org.kde.kdeconnect_tp"

  case `adb shell dumpsys package $pkg | grep versionName | tr '=' '\n' | tail -1` in
    1.28.0) ;;
    *) echo "[fatal] please downgrade KDE Connect to 1.28.0 and try again."; exit 1 ;;
  esac

  for i in \
    "pm grant $pkg android.permission.READ_LOGS" \
    "appops set $pkg SYSTEM_ALERT_WINDOW allow" \
    "am force-stop $pkg" \
    "monkey -p $pkg 1 > /dev/null 2>&1"; do
      adb shell "${i}" && echo "${i}"
  done
}

shizuku_enable() {
  for i in "sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh &> /dev/null"; do
    adb shell "${i}" && echo "${i}"
  done
}

case "${1}" in
  shizuku*) shizuku_enable ;;
  kde*) kde_connect_bidirectional_clipboard_sync_enable ;;
  *) shizuku_enable; kde_connect_bidirectional_clipboard_sync_enable ;;
esac
