#!/usr/bin/env bash

die() {
  printf "["; case ${1} in
    benign) printf "WARNING" ;;
    fatal) FATAL=1; printf "ERROR" ;;
  esac; printf "] ${2}\n"
  case ${FATAL} in 1) exit 1 ;; esac
}

case ${1} in down) CFG=`cat .current` && rm .current ;;
  up)
    CONFS=`find . -name "${2}*.conf"`
    case ${CONFS} in "")
      die fatal "no configs matching a '${2}' pattern found."
    esac
    CFG=$(echo ${CONFS} | tr ' ' '\n' | \
      head -$(\
        shuf -i 1-$(\
          echo ${CONFS} | tr ' ' '\n' | \
            wc -l | sed 's/ //g'\
        ) -n 1\
      ) | \
        tail -10 | \
        tail -1\
    ) ;; *) printf "${0} [up/down] {suffix}\n" && exit 0 ;;
esac

case `id -u` in 0) ;; *)
  die benign "you're not root, this probably won't work."
esac

case ${CFG} in "") die "failed to find a config.\n" ;; esac

wg-quick ${1} ${CFG}
echo ${CFG} > .current
