#!/bin/bash
set -e  # Exit on error

# Ensure user-local bin is available (for pipx/waypaper)
export PATH="$HOME/.local/bin:$PATH"

# Debugging: Print environment details
notify-send "WallPaper.sh Script Running....."

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
BLUR_DIR="$HOME/.cache/wallpaper-blur"

# Launch Waypaper and wait until user picks wallpaper manually
waypaper &

echo -e "🖼️ Please select a wallpaper in Waypaper. Waiting...\n\n"
# Wait for the user to finish selecting (give them time or wait for Enter)
read -p "⏳ Press [Enter] after you've selected your wallpaper in Waypaper..."

# Get current wallpaper from swww
WALLPAPER=$(swww query | grep image | awk -F'image: ' '{print $2}')

# Validate
if [ ! -f "$WALLPAPER" ]; then
    echo -e "❌ Couldn't find wallpaper from swww. Exiting.\n\n"
    exit 1
fi

# Set wallpaper with swww and matugen colors
echo -e "😎😎 Running matugen... 😎😎\n\n"
matugen image "$WALLPAPER" || { echo -e "swww failed\n\n"; exit 1; }
sleep 1

# Set background for sway (run in background)
notify-send "Running swww and swaybg..."
echo -e "🥰🥰 Generating blurred background for overview... 🥰🥰\n\n"

BLURRED="$BLUR_DIR/$(basename "$WALLPAPER" .jpg)-blur.jpg"
# Kill any existing swaybg processes
pkill swaybg || true
if [ ! -f "$BLURRED" ]; then
    magick "$WALLPAPER" -blur 0x12 "$BLURRED"
    echo "$BLURRED" > ~/.cache/wallpaper-blur/current-blur-wallpaper

else 
    echo "$BLURRED" > ~/.cache/wallpaper-blur/current-blur-wallpaper

fi

echo -e "🙂‍↕️🙂‍↕️ LOGOUT AND LOGIN for better effect 🙂‍↕️🙂‍↕️\n\n"

# Complete
echo -e "Done & Enjoy...\n\n"
notify-send "Wallpaper.sh complete..."

sleep 4