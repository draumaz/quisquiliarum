#!/bin/sh

# KISS Linux automated install script
# Still can't figure out graphics tho

# assumes a partition layout as follows:
# 512MB FAT32: /boot
# ...GB EXT4:  /

# initialize repos directory

cd /
mkdir -pv repos
cd repos

# clone repositories

git clone https://github.com/kiss-community/repo
git clone https://github.com/kiss-community/community

# create environment profile

cat << EOF >> /root/.bash_profile
export KISS_PATH="/repos/repo/core:/repos/repo/extra:/repos/repo/wayland:/repos/community/community"
export CFLAGS="-march=znver2 -O2 -pipe"
export CXXFLAGS="-march=znver2 -O2 -pipe"
export MAKEFLAGS="-j16 -l16"
EOF

# rebuild packages

source /root/.bash_profile
cd /var/db/kiss/installed
kiss update
kiss build * openssh libelf lz4 bash grub dhcpcd baseinit

# prepare kernel directories

mkdir -pv /usr/src
mkdir -pv /usr/lib/firmware

# retrieve firmware blobs

cd /usr/lib/firmware

curl -fLO https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-20220610.tar.gz
tar --strip-components=1 -xpvf linux-firmware-20220610.tar.gz -C .

# retrieve kernel

cd /usr/src
curl -fLO https://git.kernel.org/torvalds/t/linux-5.19-rc5.tar.gz
tar -xpvf linux-5.19-rc5.tar.gz
ln -s /usr/src/linux-5.19-rc5 /usr/src/linux

# apply KISS kernel patches

cd /usr/src/linux
patch -p1 < /usr/share/doc/kiss/wiki/kernel/no-perl.patch
sed '/<stdlib.h>/a #include <linux/stddef.h>' tools/objtool/arch/x86/decode.c > decode.tmp
mv -vf decode.tmp tools/objtool/arch/x86/decode.c
rm -vf decode.tmp

# compile kernel

echo -n "WAIT: .config "; read # move kernel config to /usr/src/linux/.config and hit enter
make clean
make -j16 -l16
make INSTALL_MOD_STRIP=1 modules_install
make install

mv -vf /boot/System.map /boot/System.map-5.19-rc5
mv -vf /boot/vmlinuz /boot/vmlinuz-5.19-rc5

# install bootloader

grub-install --target=x86_64-efi --bootloader-id=GRUB --removable --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
