#!/bin/sh -e

# this script initalizes a Time Machine
# netatalk server on FreeBSD 13.1.

die() { printf "ERROR: $@\n" && exit; }

case `uname -s` in FreeBSD) ;; *) die "this script is only meant for FreeBSD." ;; esac
case `whoami` in root) die "this script should be run as a normal user." ;; esac

which -s mip || die "missing mip"

for i in sudo netatalk; do
  which -s $i || \
    sudo "pkg install -y $i"
done

FILE_PATH="/usr/local/etc/afp.conf"

test -e ${FILE_PATH} && \
  cp -v ${FILE_PATH} ${FILE_PATH}.bak

sudo cat > "${FILE_PATH}" << EOF
# ${FILE_PATH}

[Global]
hostname = `hostname`
hosts allow = `mip | sed 's/\.[^.]*$//'`.0/24
afp listen = `mip`
zeroconf = yes

[Time Machine]
path = /mnt/storage/time-machine
time machine = yes
valid users = `whoami`
EOF
echo "config written to ${FILE_PATH}."

RCC="/etc/rc.conf"

case `cat ${RCC}` in
  *netatalk_enable=*YES*) echo "netatalk already enabled in ${RCC}." ;;
  *)
    echo 'netatalk_enable="YES"' >> ${RCC}
    echo "netatalk enabled in ${RCC}." ;;
esac

case `ps aux | grep [n]etata` in
  "") service netatalk start ;;
  *) service netatalk restart ;;
esac
