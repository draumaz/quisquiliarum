#!/usr/bin/env bash

case ${1} in down) CFG=`cat .current` && rm .current ;;
  up)
    CONFS=`find . -name "${2}*.conf"`
    CFG=$(echo ${CONFS} | tr ' ' '\n' | \
      head -$(\
        shuf -i 1-$(\
          echo ${CONFS} | tr ' ' '\n' | \
            wc -l | sed 's/ //g'\
        ) -n 1\
      ) | \
        tail -10 | \
        tail -1\
    ) ;; *) exit ;;
esac

wg-quick ${1} ${CFG}
echo ${CFG} > .current
