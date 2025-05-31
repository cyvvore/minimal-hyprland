#!/usr/bin/env bash

hyprctl clients -j | jq -r '.[] | [ .title, .class, .pid  ] | join(" | ")' |
tofi --prompt-text="window: " |
awk '{print $NF}' | {
  read -r id
  hyprctl dispatch focuswindow pid:$id;
}
