# Little Helper Scripts
A few bash scripts.

* `synk`: Two-way synchronization tool based on rsync.
* `pwman`: Password manager based on gpg and LibreOffice.
* `misc`: Contains several minor scripts:
    * `vacuum.sh`: To remove common temporary files (e.g. files ending in ~, .asv, etc.)

## Installation 
Make sure the per-user `bin` directory exists and is added to `$PATH`:

    mkdir -p "$HOME/.local/bin"
    echo PATH="\""\$HOME/.local/bin:$PATH"\"" >> "$HOME/.profile"

Install the skripts:

    ./install.sh
