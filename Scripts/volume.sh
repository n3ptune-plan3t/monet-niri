#!/bin/bash

# Volume control script using wpctl and notify-send for swaync

# Get current volume and mute status
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q 'MUTED' && echo "true" || echo "false")

# Handle volume commands
case $1 in
    up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
        ;;
    toggle)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q 'MUTED' && echo "true" || echo "false")
        ;;
    *)
        echo "Usage: $0 {up|down|toggle}"
        exit 1
        ;;
esac

# Send notification to swaync
if [ "$MUTED" = "true" ]; then
    notify-send -e -h string:x-canonical-private-synchronous:volume \
                -h "int:value:$VOLUME" -t 1500 "Volume: Muted"
else
    notify-send -e -h string:x-canonical-private-synchronous:volume \
                -h "int:value:$VOLUME" -t 1500 "Volume: ${VOLUME}%"
fi
