#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <curses.h> // <3

// -lncurses (Linux -ltinfo)

int main() {
        initscr(); // let's get this going
        noecho(); // don't you fucking dare
        raw(); // we like it like that
        curs_set(0); // boolean boys
        clear(); // a new screen just for us
        move(0, 0); // (y,x) for some reason???
        printw("\nPress a key.\n");
        refresh(); // like blitting but for curses
        keypad(stdscr, true); // make the arrows actually fucking work
        switch (getch()) {
                case KEY_UP:
                        printw("UP!");
                        refresh();
                        break;
                case KEY_DOWN:
                        printw("DOWN!");
                        refresh();
                        break;
        }
        sleep(1);
        endwin(); // fuck off
        curs_set(1); // bring that back
        system("stty sane"); // or 'pause' if you use windows
        return 0;
}
