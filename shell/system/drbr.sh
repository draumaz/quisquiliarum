#!/bin/bash
# drbr, by draumaz (2022) | GPL v3
# tmux-based twibright links wrapper for st

if [ "$HOMEPAGE" == "" ]; then
	export HOMEPAGE="" # Set your homepage here.
fi

new_win_st() {
	st -e sh -c 'tmux new-session -d && tmux set status off && tmux send-keys "links '$HOMEPAGE' && tmux kill-session" enter && tmux attach'
}

if [ "$1" == "-w" ]; then new_win_st; else links $HOMEPAGE; fi
