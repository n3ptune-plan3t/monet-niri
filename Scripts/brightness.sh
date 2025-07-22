#!/bin/bash

# Brightness control script using brightnessctl and notify-send for swaync

# Get current brightness and maximum brightness
CURRENT_BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
BRIGHTNESS_PERCENT=$((CURRENT_BRIGHTNESS * 100 / MAX_BRIGHTNESS))

# Handle brightness commands
case $1 in
    up)
        brightnessctl set +5%
        CURRENT_BRIGHTNESS=$(brightnessctl get)
        BRIGHTNESS_PERCENT=$((CURRENT_BRIGHTNESS * 100 / MAX_BRIGHTNESS))
        ;;
    down)
        brightnessctl set 5%-
        CURRENT_BRIGHTNESS=$(brightnessctl get)
        BRIGHTNESS_PERCENT=$((CURRENT_BRIGHTNESS * 100 / MAX_BRIGHTNESS))
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

# Send notification to swaync
notify-send -e -h string:x-canonical-private-synchronous:brightness \
            -h "int:value:$BRIGHTNESS_PERCENT" -t 1500 "Brightness: ${BRIGHTNESS_PERCENT}%"
