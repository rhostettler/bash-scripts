#!/bin/bash

# Bash script to remove backup copies (ending with .m~)

# Where to save the list of found files
TMPFILE="/tmp/vacuum"

# Find all MATLAB backup files
#BACKUP_FILES=`find . -name "*.pls"`
#BACKUP_FILES=`find . -name "*.m3u"`
#BACKUP_FILES=`find . -name "*.m~"`
#BACKUP_FILES=`find . -name "*.asv"`
BACKUP_FILES=`find . -name "*.*~"`

# Show the found files
echo "Deleting the following files:"
echo "$BACKUP_FILES"

# Ask the user whether he/she wants to delete these files
echo -n "Continue? [Y/n] "
read -e ANSWER

if [ -z $ANSWER ]; then
	ANSWER="Y"
fi

while [ $ANSWER != "y" ] && [ $ANSWER != "Y" ] && [ $ANSWER != "n" ] && [ $ANSWER != "N" ]; do
	echo -n "Continue? [Y/n] "
	read -e ANSWER

	if [ -z $ANSWER ]; then
		ANSWER="Y"
	fi
done

# Delete the files if needed
if [ $ANSWER == "y" ] || [ $ANSWER == "Y" ]; then
	# Save the list of files in a file and read it line by line afterwards
	echo "$BACKUP_FILES" > $TMPFILE
	exec 0< "$TMPFILE"
	while read -r FILE;	do
		rm -rf "$FILE"
	done
	echo "Files removed."
fi

# EOF

