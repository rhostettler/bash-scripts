#!/bin/bash
#
# rsync-based two-way backup/synchronization tool
#
# 2016-10-22 -- R. Hostettler

RSYNC=rsync
CONFIGDIR="${HOME}/.synk"
if [ `uname -s` == "Darwin" ]; then
    CAFFEINATE=/usr/bin/caffeinate
else
    CAFFEINATE=
fi

function pull(){
    EXTRA_OPTIONS="${2} --dry-run"
    ${CAFFEINATE} ${RSYNC} ${OPTIONS} ${EXTRA_OPTIONS} ${REMOTEDIR} ${LOCALDIR}
    confirm
    EXTRA_OPTIONS="${2}"
    ${CAFFEINATE} ${RSYNC} ${OPTIONS} ${EXTRA_OPTIONS} ${REMOTEDIR} ${LOCALDIR}
}

function push(){
    EXTRA_OPTIONS="${2} --dry-run"
    ${CAFFEINATE} ${RSYNC} ${OPTIONS} ${EXTRA_OPTIONS} ${LOCALDIR} ${REMOTEDIR}
    confirm
    EXTRA_OPTIONS="${2}"
    ${CAFFEINATE} ${RSYNC} ${OPTIONS} ${EXTRA_OPTIONS} ${LOCALDIR} ${REMOTEDIR}
}

function confirm(){
    echo ""
    read -p "Accept changes and continue? [y/N] " yn
    if [ "$yn" != "Y" ] && [ "$yn" != "y" ]; then
        echo "Aborting."
        exit 1
    fi
}

function usage(){
    echo "Usage: ${0} <action> <collection> [rsync options]"
    echo ""
    echo "Action:"
    echo "  push    Push local changes to the remote collection."
    echo "  pull    Pull remote changes to the local collection."
    echo "  help    Show this help text."
    echo ""
    echo "Collection:"
    echo "  The name of the collection located in ~/.zynkk/<collection>."
    echo ""
    echo "rsync options:"
    echo "  Extra options to be passed to rsync not specified in the"
    echo "  collection."
}

# Help or incomplete command
if [ "${#}" -lt 2 ]; then
    usage
    exit 1
fi

# Check if the collection exists and include it
if [ ! -f "${CONFIGDIR}/${2}" ]; then
    echo "Collection ${2} not found."
    exit 1
fi

# Include the configuration file specified by the user
. "${CONFIGDIR}/${2}"

if [ "${1}" == "pull" ]; then
    # PULL the changes from the remote
    pull
elif [ "${1}" == "push" ]; then
    # PUSH the local changes to the remote
    push
else
    echo "Invalid action (push/pull/help)."
fi

