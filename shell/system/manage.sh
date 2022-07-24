#!/usr/bin/env bash
# draumaz/manage, 2022 | GPLv3
# CLI OpenVPN manager

export TYPE_FLAG="$1"
export OVPN_FILE="$2"

# Uncomment and fill out the below line to make your login info persistent.
# export OVPN_LOGIN_FILE=""

error_handler() {
	echo -n "ERROR: "
	case "$1" in
		"ALREADY_RUN")
			echo "OpenVPN is already running"
			;;
		"NOT_RUN")
			echo "OpenVPN is not running"
			;;
		"NO_SERVER")
			echo "no .ovpn file supplied"
			;;
		"NO_LOGIN")
			echo "OVPN_LOGIN_FILE path variable not found"
			;;
		"INV_ARG")
			echo "invalid argument"
			;;
		"NO_ARG")
			echo "no argument given"
			;;
		"NOT_ROOT")
			echo "please run as root"
			;;
	esac
	exit
}

help_screen() {
	echo "Usage: sudo ./manage [options] [path/to/file.ovpn]"
	echo " --enable    begin OpenVPN daemon"
	echo " --disable   end OpenVPN daemon"
	echo " --status    check OpenVPN status"
	echo " --help      display this screen"
	exit
}

root_check() {
	if [ "$(id -u)" == 1000 ]; then error_handler "NOT_ROOT"; fi
}

case "$TYPE_FLAG" in
	--*)
		VPN_STATUS="$(ps aux | grep '[o]penvpn')"
		case "$TYPE_FLAG" in
			"--enable")
				root_check
				if [ ! "$VPN_STATUS" == "" ]; then error_handler "ALREADY_RUN"; fi
				if [ "$OVPN_FILE" == "" ]; then error_handler "NO_SERVER"; fi
				echo -n "connecting to $OVPN_FILE..."
				openvpn --config "$OVPN_FILE" --auth-user-pass "$OVPN_LOGIN_FILE" --daemon
				;;
			"--disable")
				root_check
				if [ "$VPN_STATUS" == "" ]; then error_handler "NOT_RUN"; fi
				echo -n "disconnecting..."
				pkill openvpn
				;;
			"--status")
				if [ ! "$VPN_STATUS" == "" ]; then 
					echo "OpenVPN is currently running" 
					echo -n "IP: $(curl -s ifconfig.me)"; echo ""
				else
					echo "OpenVPN is not currently running"
				fi
				exit
				;;
			"--help")
				help_screen
				;;
			*)
				root_check
				error_handler "INV_ARG"
				;;
		esac
		;;
	*)
		root_check
		error_handler "NO_ARG"
		;;
esac

sleep 2; echo "done"
echo -n "New IP: $(curl -s ifconfig.me)"; echo ""
