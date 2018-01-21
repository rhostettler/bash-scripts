# !/bin/bash
#
# Simple GPG & LibreOffice-based Password Manager
# 
# Roland Hostettler <r.hostettler@gmx.ch>
# pwman.sh -- 2018-01-21 -- Version 1.1

function open_pwdfile(){
    # Temporary files and directories
    TMPFILE=/tmp/pwman.ods
    LOTMPDIR=/tmp/pwman

    # Generate some passwords, just in case
    if [ `uname -s` == "Darwin" ]; then
        # Not on Mac, though.
        echo "On MacOS, not generating any random passwords."
    else
        echo "Here are a bunch of random passwords ('pwgen -sB 12 6'), you "
        echo "might find them useful:"
        echo ""
        pwgen -sB 12 6
        echo ""
    fi

    # Decrypt the file in $TMP and store the SHA256-hash, then open using 
    # libreoffice. This should be a blocking call enforced by the -env option 
    # for libreoffice.
    echo "Opening ${FILE}..."
    gpg --output "${TMPFILE}" -d "${FILE}"
    sha256sum ${TMPFILE} > "${TMPFILE}.sum"
    libreoffice -env:UserInstallation=file://${LOTMPDIR} \
        --calc "$TMPFILE" > /dev/null 2>&1

    # Check if the file changed (different SHA256-hash) and if so, re-encrypt 
    # and copy back
    sha256sum --status -c "${TMPFILE}.sum"
    CHANGED=$?
    if [ $CHANGED != 0 ]; then
    	# Remove original file and update it with the new, encrypted file
        echo "File updated, encrypting and replacing..."
    	rm -f "${FILE}"
        gpg --output "${FILE}" -r ${KEYID} -e -s "${TMPFILE}"
    fi

    # Remove the temporary files
    shred --remove "${TMPFILE}"
    rm -f "${TMPFILE}.sum"
    rm -rf "${LOTMPDIR}"
}

function usage(){
    echo "Usage: ${0} [config|help]"
    echo ""
    echo "config    Config file to use (default: ~/.pwmanrc)."
    echo "help      Show this help text."
}

# 
if [ "${1}" == "help" ]; then
    usage
    exit 1
fi

# Determine the config file to use and check if it exists
if [ "${#}" -lt 1 ]; then
    PWMANRC="${HOME}/.pwmanrc"
fi
if [ "${#}" -eq 1 ]; then
    PWMANRC="${1}"
fi
if [ ! -f "${PWMANRC}" ]; then
    echo "Config file ${PWMANRC} not found."
    exit 1
fi

# Include the config and open the password manager
. "${PWMANRC}"
open_pwdfile

