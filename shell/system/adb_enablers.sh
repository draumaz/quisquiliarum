#!/bin/sh

do_cmd() { adb shell "${1}" && echo "${1}"; }

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
    "monkey -p $pkg 1 &> /dev/null"; do
      do_cmd "${i}"
  done
}

shizuku_enable() { do_cmd "sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh &> /dev/null"; }
wavelet_permissions() { do_cmd "pm grant com.pittvandewitt.wavelet android.permission.DUMP"; }

immersive_toggle() {
  case "`adb shell settings get global policy_control | grep immersive.full`" in
    "") do_cmd "settings put global policy_control immersive.full=*" ;;
    *)  do_cmd "settings put global policy_control null*" ;;
  esac
}
case "${1}" in
  "") shizuku_enable; kde_connect_bidirectional_clipboard_sync_enable; wavelet_permissions ;;
  immersive*|i*) immersive_toggle ;;
  wavelet*|w*) wavelet_permissions ;;
  shizuku*|s*) shizuku_enable ;;
  kde*|k*) kde_connect_bidirectional_clipboard_sync_enable ;;
  *) "${1}" ;;
esac
