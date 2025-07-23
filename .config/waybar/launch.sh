#!/bin/bash

PROGRAM_NAME="waybar"

if pgrep -x "$PROGRAM_NAME" > /dev/null; then
    pkill -x "$PROGRAM_NAME"
else
    "$PROGRAM_NAME" &
    disown
fi
