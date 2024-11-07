#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!" 1>&2
    exit 1
fi
URLS=(
    "https://raw.githubusercontent.com/KodoPengin/GameIndustry-hosts-Template/refs/heads/master/Main-Template/hosts"
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    # Add more URLs as needed
)
TEMP_FILE=$(mktemp)
for URL in "${URLS[@]}"; do
    echo "Fetching data from $URL..."
    curl -s "$URL" >> "$TEMP_FILE"
    if [ $? -ne 0 ]; then
        echo "Failed to fetch data from $URL" 1>&2
    fi
done
if [ -s "$TEMP_FILE" ]; then
    echo "Appending fetched data to /etc/hosts..."
 sudo  cat "$TEMP_FILE" >> /etc/hosts
    echo "secure hosts-file created successfully!"
else
    echo "No data fetched; /etc/hosts not modified."
fi
rm "$TEMP_FILE"
