#!/bin/bash
export LANG=en_US.UTF-8

#Kernel
KERNEL=$(uname -r)

# Uptime formatted as "Xd Xh Xm"
uptime_raw=$(cat /proc/uptime | awk '{print int($1)}')
days=$(( uptime_raw / 86400 ))
hours=$(( (uptime_raw % 86400) / 3600 ))
minutes=$(( (uptime_raw % 3600) / 60 ))
UPTIME_FORMATTED="${days}d ${hours}h ${minutes}m"

# Get number of available updates (Arch Linux)
UPDATES=$(checkupdates 2>/dev/null | wc -l)
if [ -z "$updates" ]; then UPDATES=0; fi


# Bar functionality
BAR_LEN=10  # or adjust to taste

draw_bar() {
  local percent=$1
  local filled=$((percent * BAR_LEN / 100))
  local empty=$((BAR_LEN - filled))

  local bar=""
  for ((i = 0; i < filled; i++)); do bar+="🬋"; done
  for ((i = 0; i < empty; i++)); do bar+=" "; done

  echo "$bar $percent%"
}


# Disk data
get_disk_data() {
  local path=$1
  df -B1 "$path" | awk 'NR==2 {print $3, $2}' | while read used total; do
    percent=$(( used * 100 / total ))
    used_h=$(numfmt --to=iec --suffix=b $used)
    total_h=$(numfmt --to=iec --suffix=b $total)
    echo "$used_h $total_h $percent"
  done
}

read SW_USED SW_TOTAL SW_PCT <<< $(free -b | awk '/Swap:/ {print $3, $2}' | while read used total; do
  percent=$(( used * 100 / total ))
  used_h=$(numfmt --to=iec --suffix=b $used)
  total_h=$(numfmt --to=iec --suffix=b $total)
  echo "$used_h $total_h $percent"
done)

read RT_USED RT_TOTAL RT_PCT <<< $(get_disk_data "/")
read HM_USED HM_TOTAL HM_PCT <<< $(get_disk_data "/home")

read MEM_USED MEM_TOTAL MEM_PCT <<< $(free -b | awk '/Mem:/ {print $3, $2}' | while read used total; do
  percent=$(( used * 100 / total ))
  used_h=$(numfmt --to=iec --suffix=b $used)
  total_h=$(numfmt --to=iec --suffix=b $total)
  echo "$used_h $total_h $percent"
done)





# System section

CPU_TEMP=$(sensors | awk '/Tctl:/ {print $2; exit}' | sed 's/+//')
GPU_TEMP=$(sensors | awk '/amdgpu-pci-0300/,/^$/' | awk '/junction:/ { gsub(/\+|°C/, "", $2); print $2 "°C"; exit }')

# Total Connections = established only
TOTAL_CONN=$(ss -Htan state established | awk '$5 !~ /(^127\.|^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|::1)/' | wc -l)

# User Programs = launched windows
USER_PROGRAMS=$(hyprctl clients | grep 'pid:' | awk '{print $2}' | xargs -r ps -o user=,comm= -p | awk -v user="$USER" '$1 == user {print $2}' | sort -u | wc -l)

# Active Programs = user-launched, session-visible processes 
ACTIVE_PROGRAMS=$(comm -23 <(ps -u "$USER" -o tty=,comm= | awk '$1 != "?" { print $2 }' | sort -u) <(ps -u "$USER" -o tty=,comm= | awk '$1 == "?" { print $2 }' | sort -u) | wc -l)

# Daemons = all user session based Daemons
DAEMONS=$(ps -u "$USER" -o tty=,comm= | awk '$1 ~ /^(tty1|\?|pts\/[0-3])$/ { print $2 }' | sort | uniq | wc -l)

# Local user sessions (TTY or local graphical)
LOCAL_CONN=$(who | awk '$2 !~ /^pts\// && $NF !~ /\([0-9a-fA-F:.]+\)/' | wc -l)

# Remote user sessions (SSH, remote IP, etc.)
REMOTE_CONN=$(who | awk '$NF ~ /\([^\)]*\)/ && $NF !~ /\(:[0-9]*\)/' | wc -l)


# ASCII Formatting
echo -e "				┌─────┐"
printf "[ %s ]      KERNEL ┄─┤     │\n" "$KERNEL"
printf "[ %s ]	       UPTIME ┄─┤     │\n" "$UPTIME_FORMATTED"
printf "[ %s ]	              UPDATES ┄─┘     │\n" "$UPDATES"
echo -e "				      │"
echo -e "				      │"
echo -e "			  RESOURCES ┄─┤"
printf   "[ %s/%s ]     	  swap ┄─┤    │\n" "$SW_USED" "$SW_TOTAL"
printf   "[ %s ] 	  ┄─┘    │    │\n" "$(draw_bar $SW_PCT)"
printf   "[ %s/%s ]		  root ┄─┤    │\n" "$RT_USED" "$RT_TOTAL"
printf   "[ %s ]	  ┄─┘    │    │\n" "$(draw_bar $RT_PCT)"
printf   "[ %s/%s ]		  home ┄─┘    │\n" "$HM_USED" "$HM_TOTAL"
printf   "[ %s ]	  ┄─┘	      │\n" "$(draw_bar $HM_PCT)"
echo -e "				      │"
echo -e "			     SYSTEM ┄─┤"
printf "[ %s/%s ] 		  mem  ┄─┤    │\n" "$MEM_USED" "$MEM_TOTAL"
printf   "[ %s ]	 ┄─┘	 │    │\n" "$(draw_bar $MEM_PCT)"
echo -e "			 temp  ┄─┘    │"
printf   "[ %s ]	     cpu ┄─┤          │\n" "$CPU_TEMP"
printf   "[ %s ]	     gpu ┄─┘          │\n" "$GPU_TEMP"
echo -e "				      │"
echo -e "				NET ┄─┘"
printf   "[ %s ]		   connections ┄─┤\n" "$TOTAL_CONN"
printf   "[ %s ]	    user programs ┄─┤	 │\n" "$USER_PROGRAMS"
printf   "[ %s ]	  active programs ┄─┘	 │\n" "$ACTIVE_PROGRAMS"
printf   "[ %s ]		       daemons ┄─┤\n" "$DAEMONS"
printf   "[ %s ]	     	   in / locale ┄─┤\n" "$LOCAL_CONN"
printf   "[ %s ]	   	  out / remote ┄─┘\n" "$REMOTE_CONN"
echo -e "${RESET}"

