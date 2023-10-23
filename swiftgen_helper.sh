#!/bin/bash

ROOT_FOLDER="./"
OUTPUT_FILE="swiftgen.yml"
CONFIG_FILE="$ROOT_FOLDER/$OUTPUT_FILE"

echo "xcassets:" > "$CONFIG_FILE"
echo "  inputs:" >> "$CONFIG_FILE"
find "$ROOT_FOLDER" -type d -name "*.xcassets" -not -path "*/Pods/*" | while read -r folder; do
    echo "    - \"$folder\"" >> "$CONFIG_FILE"
done
echo "  outputs:" >> "$CONFIG_FILE"
echo "    - templateName: swift5" >> "$CONFIG_FILE"
echo "      output: Resources/ImageEnum.swift" >> "$CONFIG_FILE"

echo "" >> "$CONFIG_FILE"



echo "strings:" >> "$CONFIG_FILE"
echo "  inputs:" >> "$CONFIG_FILE"

find "$ROOT_FOLDER" -type d -name "en.lproj" | while read -r folder; do
    folder_path=$(dirname "$folder")
    
    # Check if the folder path contains the term "Pods"
    if [[ $folder_path != *"Pods"* ]]; then
        echo "    - \"$folder_path/en.lproj\"" >> "$CONFIG_FILE"
    fi
done

echo "  outputs:" >> "$CONFIG_FILE"
echo "    - templateName: structured-swift5" >> "$CONFIG_FILE"
echo "      output: Resources/LocalizedStrings.swift" >> "$CONFIG_FILE"
echo "      params:" >> "$CONFIG_FILE"
echo "        enumName: Local" >> "$CONFIG_FILE"
