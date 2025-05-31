#!/bin/bash

# Check for default route
if ip route | grep -q '^default'; then
  # Confirm internet access
  if timeout 0.5 bash -c "</dev/tcp/8.8.8.8/53" &>/dev/null; then
    # Check active interface type
    iface=$(ip route show default | awk '{print $5}')

    if [[ "$iface" == e* ]]; then
      printf "󰈀⠀ ETH\n"  # Ethernet icon
    elif [[ "$iface" == w* ]]; then
      strength="$(awk 'NR==3 {print int($3)}' /proc/net/wireless)"
      if [[ "$strength" -eq 0 ]]; then
        printf "󰤯⠀\n"
      elif [[ "$strength" -le 25 ]]; then
        printf "󰤟⠀\n"
      elif [[ "$strength" -le 50 ]]; then
        printf "󰤢⠀\n"
      elif [[ "$strength" -le 75 ]]; then
        printf "󰤥⠀\n"
      else
        printf "󰤨⠀\n"
      fi
    else
      printf "🌐 Connected\n"  # Unknown device type
    fi

    exit 0
  fi
fi

printf "Disconnected 󰤮⠀\n"
exit 1

