#!/bin/bash

get_playerctl_title() {
    title=$(playerctl metadata title 2>/dev/null)
    if [[ -n "$title" ]]; then
        echo "𜱆 $title 𜱆"
        return 0
    fi
    return 1
}

get_qmmp_title() {
    qmmp_player=$(playerctl -l 2>/dev/null | grep -i qmmp | head -n1)
    if [[ -z "$qmmp_player" ]]; then
        return 1
    fi
    title=$(playerctl --player="$qmmp_player" metadata title 2>/dev/null)
    if [[ -n "$title" ]]; then
        echo "$title"
        return 0
    fi
    return 1
}

get_youtube_title() {
    window_title=$(xdotool search --onlyvisible --name "YouTube" getwindowname 2>/dev/null | head -n1)
    if [[ -n "$window_title" ]]; then
        clean_title="${window_title// - YouTube/}"
        echo "$clean_title"
        return 0
    fi
    return 1
}

if ! get_playerctl_title && ! get_qmmp_title && ! get_youtube_title; then
    # Nothing playing
    :
fi

