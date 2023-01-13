#!/bin/sh -e

cat >> PKGBUILD << EOF
pkgname="${NAME}"
pkgver="git"
pkgrel="1"
pkgdesc="A program from the quisquilarum repository."
arch=("x86_64")
url="https://git.goatopossum.com/draumaz/quisquiliarum"
license=("GPL")
makedepends=("git")

source=("git+https://git.goatopossum.com/draumaz/quisquiliarum")
sha256sums=("SKIP")

package() {
  mv -v quisquiliarum/shell/${SUBDIR}/\${pkgname}.sh \${pkgname}
  chmod -v +x "\${pkgname}"
  install -v -dm755 "\${pkgdir}/usr/bin"
  mv -v "\${pkgname}" "\${pkgdir}/usr/bin"
}
EOF
