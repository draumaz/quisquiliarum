#!/bin/sh -e

# this script initalizes up a Time Machine
# netatalk server on FreeBSD 13.1.

which -s netatalk || \
  su -c "pkg install -y netatalk3"

FILE_PATH="/usr/local/etc/afp.conf"

test -e ${FILE_PATH} && \
  cp -v ${FILE_PATH} ${FILE_PATH}.bak

cat > "${FILE_PATH}" << EOF
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

case `cat /etc/rc.conf` in
  *netatalk_enable=*YES*) echo "netatalk already enabled in /etc/rc.conf." ;;
  *)
    echo 'netatalk_enable="YES"' >> /etc/rc.conf
    echo "netatalk enabled in /etc/rc.conf." ;;
esac

case `ps aux | grep [n]etata` in
  "") service netatalk start ;;
  *) service netatalk restart ;;
esac
