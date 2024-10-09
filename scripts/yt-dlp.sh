#!/bin/bash
# Generated using Ansible Playbook (mani-sh-reddy/.dotfiles)

OPTIONS="1080p\n4k\nAudio Only"
VIDEO_URL=$1

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it and try again."
    exit 1
fi

# Prompt user for quality selection
CHOICE=$(echo -e "$OPTIONS" | fzf --prompt="Choose download quality: " --height=5)

if [ -z "$CHOICE" ]; then
    echo "No choice made. Exiting."
    exit 0
fi

# Set the yt-dlp format based on the choice
if [[ "$CHOICE" == "1080p" ]]; then
    FORMAT="bestvideo[height<=1080][ext=mp4][protocol=https]+bestaudio[ext=m4a][protocol=https]/best[height<=1080][ext=mp4][protocol=https]/best[protocol=https]"
elif [[ "$CHOICE" == "4k" ]]; then
    FORMAT="bestvideo[height=2160]+bestaudio/best[height=2160]/best"
elif [[ "$CHOICE" == "Audio Only" ]]; then
    FORMAT="bestaudio[ext=m4a]/best[ext=m4a]"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Prompt user for video URL
if [[ -z "$VIDEO_URL" ]]; then
    read -p "Enter the video URL: " VIDEO_URL
fi

# Execute yt-dlp command with the chosen format
echo "Downloading $CHOICE from $VIDEO_URL..."
echo "FORMAT: $FORMAT"
\yt-dlp -f "$FORMAT" --sponsorblock-remove sponsor -o "%(title)s - %(uploader)s.%(ext)s" "$VIDEO_URL"

echo "Download complete."