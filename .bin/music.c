#include <mpd/client.h>
#include <mpd/status.h>
#include <mpd/song.h>
#include <string.h>
#include <stdio.h>

// char* artist() {

// }

const char* get_title(struct mpd_song* song) {
    const char* t = mpd_song_get_tag(song, MPD_TAG_TITLE, 0);
    const char* a = mpd_song_get_tag(song, MPD_TAG_ARTIST, 0);
    static char buffer[45];
    static char title[20];
    static char artist[25];

    // // if title is longer than 15 characters
    if (strlen(t) > 20) {
        strncpy(title, t, 19);
        strcat(title, "...");
    } else {
        strcpy(title, t);
    }

    // // if artist name is longer than 20 characters
    if (strlen(a) > 15) {
        strncpy(artist, a, 14);
        strcat(artist, "...");
    } else {
        strcpy(artist, a);
    }

    // create the title - artist status line
    // snprintf(buffer, sizeof(buffer), a);
    strncpy(buffer, artist, 20);
    strcat(buffer, " - ");
    strncat(buffer, title, 25);
    return buffer;
}

const char* change_state(int state) {
    static char btn[5];
    if (state == MPD_STATE_PAUSE) {
        strncpy(btn,"", 5);
    } else if (state == MPD_STATE_PLAY) {
        strncpy(btn, "", 5);
    } else {
        stpcpy(btn, "");
    }
    return btn;
}

int main() {
    struct mpd_connection *conn;
    struct mpd_status *status;
    int state;
    static char title[45];
    static char play_pause_btn[20];
    
    strncpy(play_pause_btn, "", 20);

    char *prev_btn = "%{A1:mpc prev:}%{A}";
    char *next_btn = "%{A1:mpc next:}%{A}";
    static char buffer[255];
    char *mpc_toggle = "%{A1:mpc toggle}";

    conn = mpd_connection_new(NULL, 0, 0);
    status = mpd_run_status(conn);
    state = mpd_status_get_state(status);

    if (state == MPD_STATE_PAUSE) {
        strncpy(play_pause_btn,"", 5);
    } else if (state == MPD_STATE_PLAY) {
        strncpy(play_pause_btn, "", 5);
    } else {
        stpcpy(play_pause_btn, "");
    }

    if (conn) {
        printf("yeah! \n");
    } else {
        printf("nope\n");
    }
    
    struct mpd_song *song = mpd_run_current_song(conn);
    int id = mpd_song_get_id(song);
    strncpy(title, get_title(song), 45);

    // update the action buttons
    static char action_btns[255];
    strncpy(action_btns, prev_btn, 60);
    strncat(action_btns, mpc_toggle, 60);
    strncat(action_btns, play_pause_btn, 60);
    strncat(action_btns, "%{A}", 60);
    strncat(action_btns, next_btn, 60);

    strncpy(buffer, action_btns, 255);
    strcat(buffer, title);

    do {
        song = mpd_run_current_song(conn);

        // if the song is changed evoke the status changer
        int current_id = mpd_song_get_id(song);
        if (current_id != id) {
            id = current_id;
            strncpy(title, get_title(song), 45);
        }

        // handle the play-pause view
        int current_state = mpd_status_get_state(status);
        if (current_state != state) {
            stpncpy(play_pause_btn, change_state(current_state), 10);
            state = current_state;
        }

        printf("%s\n\n", buffer);


    } while (true);

    return 0;
}