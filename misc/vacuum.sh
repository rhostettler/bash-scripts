#!/bin/bash
# 
# Bash script to remove files that match a filter/pattern
#
# Roland Hostettler <r.hostettler@gmx.ch>
# vacuum.sh -- 2018-04-18 -- Version 1.0

if [ ${#} -lt 1 ]; then
    echo "Usage: ${0} <file>"
    echo "  <file>  File containing the file list and/or filters"
    exit 1
fi

# Find all files that match the filters/list in the file provided
TMPFILE=`mktemp`
FILES=(`cat "${1}"`)
for i in "${FILES[@]}"; do
    find . -name "${i}" >> "${TMPFILE}"
done

# Show how many files were found and let the user choose how to continue.
echo "Found" `wc -l < "${TMPFILE}"` "files."
ANSWER="x"
while [ $ANSWER != "s" ] && [ $ANSWER != "S" ] && [ $ANSWER != "d" ] && [ $ANSWER != "D" ] && [ $ANSWER != "a" ] && [ $ANSWER != "A" ]; do
    echo -n "(S)how files, (D)elete, or (A)bort? "
    read -e ANSWER

    if [ -z $ANSWER ]; then
        ANSWER="x"
    fi
    if [ $ANSWER == "s" ] || [ $ANSWER == "S" ]; then
        less "${TMPFILE}"
        ANSWER="x"
    fi
done

# Delete the files if requested
if [ $ANSWER == "d" ] || [ $ANSWER == "D" ]; then
    echo -n "Removing files..."
    exec 0< "$TMPFILE"
    while read -r FILE; do
        rm -rf "$FILE"
    done
    echo "done."
fi
if [ $ANSWER == "a" ] || [ $ANSWER == "A" ]; then
    echo "Aborting."
fi

# Clean up
rm "${TMPFILE}"

# EOF

