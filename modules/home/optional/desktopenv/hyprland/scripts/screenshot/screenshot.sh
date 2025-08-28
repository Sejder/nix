#!/usr/bin/env bash

# Directory to save screenshots
screenshot_dir=~/Pictures/Screenshots

# Ensure the directory exists
mkdir -p "$screenshot_dir"

# Create filename with timestamp
filename="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Full path to save file
filepath="$screenshot_dir/$filename"

# Take screenshot of a selected area, copy to clipboard and save
grimblast --notify --freeze copysave area "$filepath"
