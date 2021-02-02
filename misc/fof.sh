#!/usr/bin/env bash

# fof - Find orphaned files

case "$1" in
    "-h" | "--help")
        echo "Usage: $(basename $0) [parents] [children]"
        echo ""
        echo "Find all files (children) that are not included in any parent"
        echo "file."
        echo ""
        exit 0
        ;;
esac

if [ $# -lt 2 ]; then
    echo "Please specify parent(s) and child/children."
    exit 1
fi

parents=$(basename "$1")
children=$2
#children=$(ls $2)
orphaned=0

for child in "$children"/*; do
    # Strip the path and determine the file name and extension
    filename=$(basename "$child")
    extension="${filename##*.}"
    filename="${filename%.*}"

    # Check if the file is used in any file in the parent directory
    used=$(grep -d skip "$filename" "$parents"/* | wc -l)
    if [ $used -eq 0 ]; then
        if [ $orphaned -eq 0 ]; then
            echo "The following files are orphaned:"
            orphaned=1
        fi
        echo "$child"
    fi
done

if [ $orphaned -eq 0 ]; then
    echo "No orphaned files found."
fi
