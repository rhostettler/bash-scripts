#!/bin/bash

# A script for making a latexdiff from git
# Usage:
# latexdiff-git2 REV1 file

# TODO
#  * I should move the diff flags from the command-line to a variable and also
#    ship a config with the script.
#  * It should be noted somewhere that the command \PICTUREfigure should be 
#    defined somewhere.

if [ $# -lt 2 ]; then
    echo "Usage: git-latexdiff.sh REVISION FILE"
    exit 1
fi

# Directories and files
TMPDIR=`mktemp -d`          # temporary directory
TMPFILE="sources-${1}.tar"  # filename of the archive
CURDIR=`pwd`                # working directory

# Export a git archive of the chosen revision and unpack it in the temporary 
# directory
git archive --format=tar -o "${TMPDIR}/${TMPFILE}" "${1}"
cd "${TMPDIR}"
tar xf "${TMPFILE}"
cd "${CURDIR}"

#LATEXDIFFFLAGS="--flatten \
#   --config=\"PICTUREENV=(?:picture|DIFnomarkup|figure)[\w\d*@]*\" \
#   --math-markup=0"

# Get the filename without extension, then create the file "$FILENAME-diff.tex".
# Note that we ignore changed figure-environments, tables, and math. This is to
# prevent issues with TikZ and friends.
DIFFFILE=`basename ${2} .tex`
DIFFFILE="${DIFFFILE}-diff.tex"


latexdiff --flatten --config="PICTUREENV=(?:picture|figure|table|DIFnomarkup)[\w\d*@]*" --math-markup=0 "$TMPDIR/${2}" "${2}" > "${DIFFFILE}"
#latexdiff --flatten --config="PICTUREENV=(?:picture|figure|table|DIFnomarkup)[\w\d*@]*" --math-markup=1 "$TMPDIR/$2" "$2" > "$FILENAME-diff.tex"

# Clean up
rm -rf $TMPDIR

