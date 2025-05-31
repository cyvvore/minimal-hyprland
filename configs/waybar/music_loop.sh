#!/bin/bash

# Interval (in seconds) to update the status (for refreshing the media info)
UPDATE_INTERVAL=5

# Define the width of the display (characters shown at once)
WIDTH=17  # You can adjust this to the size of your display

# Define the scrolling speed in seconds (lower is faster)
SCROLL_SPEED=0.20  # Adjust this to control scroll speed, smaller value = faster scroll

# Initial media info
current_media_info=""
scrolling_pid=""

# Function to fetch current media info
get_media_info() {
    # Get current media status (title)
    media_info=$(playerctl metadata --format "{{title}}")

    # If no media is playing, show a message
    if [[ -z "$media_info" ]]; then
        media_info="No media playing"
    fi

    # Return the media info
    echo "$media_info"
}

# Function to scroll the text smoothly to the right
scroll_text() {
    text="$1"

    # Remove trailing space and dash (if present) to avoid extra separator
    text="${text%}"

    # Add a space at the end to ensure the gap between the end and beginning
    long_text="$text  $text"  # Duplicate text to create a seamless loop

    len=${#long_text}

    # Infinite loop to scroll text
    while true; do
        # Loop over the text to create continuous scrolling (starting from the right)
        for ((i=$len-$WIDTH; i>=0; i--)); do
            # Format the output as JSON with the 'text' field
            echo "{\"text\": \"${long_text:$i:$WIDTH}\"}"
            sleep $SCROLL_SPEED  # Sleep time controls scroll speed
        done
    done
}

# Function to start the scrolling and handle transitions
start_scrolling() {
    # Start the scrolling loop with the initial media info
    current_media_info=$(get_media_info)

    # Start the scrolling loop with the current media info
    scroll_text "$current_media_info" &  # Start scrolling in the background
    scrolling_pid=$!  # Store the PID of the scrolling loop
}

# Function to update media info and scrolling together
update_media_and_scroll() {
    # Initially start scrolling
    start_scrolling

    # Handle cleanup when script exits
    trap 'kill $scrolling_pid' EXIT

    while true; do
        # Get the current media info at regular intervals
        new_media_info=$(get_media_info)

        # Only update current_media_info if it has changed
        if [[ "$new_media_info" != "$current_media_info" ]]; then
            current_media_info="$new_media_info"

            # Kill the previous scrolling loop
            kill $scrolling_pid

            # Start new scrolling loop with updated media info
            start_scrolling
        fi

        # Wait before checking for media change again
        sleep $UPDATE_INTERVAL
    done
}

# Start the combined update and scroll function
update_media_and_scroll
