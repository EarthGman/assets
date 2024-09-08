#!/usr/bin/env bash

OBJECT_TYPE=${1:-wallpapers}

# The GitHub API URL to fetch JSON file listing files in a subdirectory
GITHUB_API_URL="https://api.github.com/repos/EarthGman/personal-cache/contents/${OBJECT_TYPE}?ref=master"

# Temporary file to store JSON response
TEMP_JSON="files.json"

# Fetch the JSON file from GitHub
echo "Fetching JSON data from GitHub..."
curl -s -H "Accept: application/vnd.github.v3+json" "$GITHUB_API_URL" -o "$TEMP_JSON"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq to proceed."
    exit 1
fi

# Check if nix-prefetch-url is installed
if ! command -v nix-prefetch-url &> /dev/null; then
    echo "Error: nix-prefetch-url is not installed. Please install nix-prefetch-url to proceed."
    exit 1
fi

# Check if the JSON file was fetched properly
if [ ! -s "$TEMP_JSON" ]; then
    echo "Error: Failed to fetch JSON data. The file is empty or does not exist."
    exit 1
fi

# Initialize an empty array to store the output JSON objects
echo "{" > $OBJECT_TYPE.json

# Initialize a variable to track the first element
first=true

# Process each item in the JSON response
jq -c '.[] | select(.type == "file")' "$TEMP_JSON" | while read -r item; do
    # Extract the file name and download URL
    name=$(echo "$item" | jq -r '.name')
    url=$(echo "$item" | jq -r '.download_url')

    # Remove the file extension from the name
    name_no_ext=$(basename "$name" | cut -f 1 -d '.')

    # Debug: Print the name without extension and URL being processed
    echo "Processing file: $name_no_ext"
    echo "Download URL: $url"

    # Check if URL is valid
    if [ -z "$url" ]; then
        echo "Warning: Skipping $name_no_ext as no valid download URL was found."
        continue
    fi

    # Compute the SHA256 using nix-prefetch-url and handle failures
    sha256=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch or compute SHA256 for $url. Skipping."
        continue
    fi

    # Debug: Print the computed SHA256
    echo "Computed SHA256: $sha256"

    # If this is not the first item, prepend a comma
    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> $OBJECT_TYPE.json
    fi

    # Append the object to the output JSON array
    echo "\"$name_no_ext\":{ \"url\": \"$url\", \"sha256\": \"$sha256\"}" >> $OBJECT_TYPE.json
done
echo "}" >> $OBJECT_TYPE.json

rm "$TEMP_JSON"

echo "SHA256 hashes have been computed and stored in $OBJECT_TYPE.json"
