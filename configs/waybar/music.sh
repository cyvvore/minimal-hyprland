#!/bin/bash

UPDATE_INTERVAL=5
WIDTH=20
SCROLL_SPEED=0.20

current_media_info=""
scrolling_pid=""

# Ignore SIGPIPE to prevent broken pipe crashes
trap '' PIPE

# Cleanup function
cleanup() {
    [[ -n "$scrolling_pid" && -e /proc/$scrolling_pid ]] && kill "$scrolling_pid"
}
trap cleanup EXIT

# Fetch current media info
get_media_info() {
    media_info=$(playerctl metadata --format "{{title}}" 2>/dev/null)
    [[ -z "$media_info" ]] && media_info="No media playing"
    echo "$media_info"
}

# Scroll text
scroll_text() {
    local text="$1"
    local long_text="$text                       $text"
    local len=${#long_text}

    while true; do
        for ((i = len - WIDTH; i >= 0; i--)); do
            visible_text="${long_text:$i:$WIDTH}"
            echo "{\"text\": \"$visible_text\"}" 2>/dev/null || return
            sleep "$SCROLL_SPEED"
        done
        sleep 1
    done
}

# Start scrolling with current info
start_scrolling() {
    scroll_text "$current_media_info" &
    scrolling_pid=$!
}

# Update loop
update_media_and_scroll() {
    current_media_info=$(get_media_info)
    start_scrolling

    while true; do
        new_media_info=$(get_media_info)
        if [[ "$new_media_info" != "$current_media_info" ]]; then
            current_media_info="$new_media_info"
            [[ -n "$scrolling_pid" && -e /proc/$scrolling_pid ]] && kill "$scrolling_pid"
            start_scrolling
        fi
        sleep "$UPDATE_INTERVAL"
    done
}

# Run the loop
update_media_and_scroll

