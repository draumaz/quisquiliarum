#!/usr/bin/bash -e

# a tarball wrapper for quick LFS binary creation

PKG_PATH="/sources/bin-11.3/${CHAPTER}-chap"

case $PKG_NAME in "")
  PKG_NAME="`cd ..; basename $PWD`" # start inside dest/
esac

mkdir -pv ${PKG_PATH}

c() {
  printf "creating ${PKG_NAME}.pkgz... "
  tar -czf ${PKG_PATH}/${PKG_NAME}.pkgz *
  printf "done.\n"
}

s() {
  printf "unpacking ${PKG_NAME}.pkgz to /... "
  cd /
  tar -xpf ${PKG_PATH}/${PKG_NAME}.pkgz
  printf "done.\n"
}

a() { c ${@};s ${@}; }
die() { printf "DIE: ${@}\n"; exit 1; }

case ${CHAPTER} in "") die "please set \$CHAPTER.";; esac

"${@}"
