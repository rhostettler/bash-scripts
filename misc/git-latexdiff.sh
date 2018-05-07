# !/bin/bash

# A script for making a latexdiff from git
# Usage:
# latexdiff-git2 REV1 file

# TODO
#  * I should move the diff flags from the command-line to a variable and also
#    ship a config with the script.
#  * It should be noted somewhere that the command \PICTUREfigure should be 
#    defined somewhere.

TMPDIR="/tmp/latexdiff-git2"
TMPFILE="latexdiff-git2.tar"
CURDIR=`pwd`
#LATEXDIFFFLAGS="--flatten \
#   --config=\"PICTUREENV=(?:picture|DIFnomarkup|figure)[\w\d*@]*\" \
#   --math-markup=0"

# Make a temproary directory and export the git archive of revision "$1" there.
# Then, extract the archive and move back to the working directory
mkdir $TMPDIR
git archive --format=tar -o "$TMPDIR/$TMPFILE" "$1"
cd "$TMPDIR"
tar xf "$TMPFILE"
cd "$CURDIR"

# Get the filename without extension, then create the file "$FILENAME-diff.tex".
# Note that we ignore changed figure-environments, tables, and math. This is to
# prevent issues with TikZ and friends.
FILENAME=${2%.*}
#latexdiff --flatten --config="PICTUREENV=(?:picture|figure|table|DIFnomarkup)[\w\d*@]*" --math-markup=0 "$TMPDIR/$2" "$2" > "$FILENAME-diff.tex"
latexdiff --flatten --config="PICTUREENV=(?:picture|figure|table|DIFnomarkup)[\w\d*@]*" --math-markup=1 "$TMPDIR/$2" "$2" > "$FILENAME-diff.tex"
rm -rf $TMPDIR

# EOF
