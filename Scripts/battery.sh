#!/bin/bash

# Battery monitoring script for swaync notifications

# Battery device (adjust BAT0 to your battery name, e.g., BAT1)
BATTERY="BAT0"
CAPACITY_FILE="/sys/class/power_supply/$BATTERY/capacity"
STATUS_FILE="/sys/class/power_supply/$BATTERY/status"

# Check if battery exists
if [ ! -f "$CAPACITY_FILE" ]; then
    echo "Battery $BATTERY not found!"
    exit 1
fi

# Initialize previous battery level (set to a value that ensures first check triggers if needed)
PREV_LEVEL=100

while true; do
    # Get current battery level and status
    CURRENT_LEVEL=$(cat "$CAPACITY_FILE")
    STATUS=$(cat "$STATUS_FILE")

    # Calculate the nearest 10% threshold below or equal to the current level
    THRESHOLD=$(( (CURRENT_LEVEL / 10) * 10 ))

    # Check if battery has dropped to a new 10% threshold and is not charging
    if [ "$CURRENT_LEVEL" -le "$PREV_LEVEL" ] && [ "$THRESHOLD" -lt "$PREV_LEVEL" ] && [ "$STATUS" != "Charging" ]; then
        # Send notification to swaync
        notify-send -e -h string:x-canonical-private-synchronous:battery \
                    -h "int:value:$CURRENT_LEVEL" -t 2000 "Battery: ${CURRENT_LEVEL}%"
        PREV_LEVEL=$THRESHOLD
    elif [ "$STATUS" = "Charging" ]; then
        # Reset PREV_LEVEL when charging to allow notifications when discharging again
        PREV_LEVEL=100
    fi

    # Sleep for 60 seconds before checking again
    sleep 60
done
