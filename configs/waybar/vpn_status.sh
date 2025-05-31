#!/bin/bash

status=$(mullvad status | tr -d '\n')  # Remove newlines

# Check for exact status
if echo "$status" | grep -qi "Disconnected"; then
    echo "Disconnected"
elif echo "$status" | grep -qi "Connecting" && ! echo "$status" | grep -qi "Disconnecting"; then
    echo "Connecting..."
elif echo "$status" | grep -qi "Disconnecting"; then
    echo "Disconnecting..."
else
    echo "<span color='#ff85ba'>Connected</span>"
fi


