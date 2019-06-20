#!/bin/bash

# fetch.sh: Run fetch-macos.py with safety checks
# by Foxlet <foxlet@furcode.co>

set +x;
SCRIPTDIR="$(dirname "$0")";
cd $SCRIPTDIR

getpython(){
    if [ -x "$(command -v python3)" ]; then
        PYTHONBIN=python3
    elif [ -x "$(command -v python)" ]; then
        PYTHONBIN=python
    elif [ -x "$(command -v python2)" ]; then
        PYTHONBIN=python2
    else
        echo "Please install Python 3 before continuing." >&2
        exit 1;
    fi
}

fetchrequires(){
    cat /etc/*release | if grep -Eiq "void"; then
        sudo xbps-install -Syu python3-{click,requests}
    elif grep -Eiq "arch"; then
        sudo pacman -Syu python-{click,requests}
    elif grep -Eiq "(debian|ubuntu|pop|mint)"; then
        sudo apt install -y python3-{click,requests}
    elif grep -Eiq "(centos|rhel)"; then
        sudo yum install -y python-{click,requests}
    elif grep -Eiq "(fedora)"; then
        sudo dnf install -y python3-{click,requests}
    elif grep -Eiq "(suse)"; then
        sudo zypper install -y python3-{click,requests}
    fi
}

getpython
fetchrequires
$PYTHONBIN fetch-macos.py $*

exit;
