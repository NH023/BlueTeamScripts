#!/bin/bash

# One-liner to download this script
# wget https://raw.githubusercontent.com/NH023/BlueTeamScripts/refs/heads/main/repo_download.sh -O repo_download.sh
# chmod +x repo_download.sh && ./repo_download.sh

# Constants
ARCHIVE_LINK="https://github.com/NH023/BlueTeamScripts/archive/refs/heads/main.zip"
EXTRACTION_PATH="/usr/local/bin/steam/"
DOWNLOAD_PATH="/usr/local/bin/steam/CSGO.zip"

# Check if program is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./repo_download.sh)"
  exit 1
fi

# Create the extraction math if it doesn't exist
if [ ! -d "$EXTRACTION_PATH" ]; then
  mkdir -p "$EXTRACTION_PATH"
fi

# Download the repository
echo "Downloading repository..."
wget -q "$ARCHIVE_LINK" -O "$DOWNLOAD_PATH"

# Extract the repository
echo "Extracting archive..."
unzip -o "$DOWNLOAD_PATH" -d "$EXTRACTION_PATH" > /dev/null

# Delete the original zip
rm -f "$DOWNLOAD_PATH"

# Done
echo "Finished downloading tools!"
