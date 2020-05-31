#include <mpd/status.h>
#include <mpd/connection.h>
#include <stdio.h>

int main() {
    unsigned time = 0;
    struct mpd_connection *conn;
    struct mpd_status *status;
    enum mpd_state state;

    conn = mpd_connection_new(NULL, 0, 0);
    status = mpd_run_status(conn);
    if (!status) return 1;
    time = mpd_status_get_elapsed_time(status);
    state = mpd_status_get_state(status);
    mpd_status_free(status);
    mpd_connection_free(conn);

    if (state > 1) {
        unsigned min = 0;
        unsigned sec;
        while (time >= 60) {
            min += 1;
            time -= 60;
        }
        sec = time;
        printf("%u:%02u\n", min, sec);
    }
    return 0;
}