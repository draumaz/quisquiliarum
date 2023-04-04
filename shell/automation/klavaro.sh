#!/bin/sh -e

REPO="mac-keyboard-esperanto"

printf "> elŝutado de la dosiero...  "
curl -s -fLO https://github.com/jakwings/${REPO}/archive/refs/heads/master.zip
REPO=$REPO-master
unzip -q -o master.zip; rm -f master.zip

printf "[bone]\n> instalado de la klavaro... "

DEST="${HOME}/Library/Keyboard Layouts/Esperanto.bundle"
rm -rf "${DEST}"; mv -f \
  "${REPO}/Esperanto.bundle" \
  "${HOME}/Library/Keyboard Layouts/Esperanto.bundle"

rm -rf ${REPO}

printf "[bone]\n\n"

cat << EOF
== Direktoj por uzi ===

- Keyboard
-- Input Sources

Aldonu vian preferan Esperantan klavaron tie.
EOF

open -a "System Preferences"
