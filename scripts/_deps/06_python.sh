#!/bin/bash
set -e
source $(dirname $0)/_base.sh

install_python() {
    trap "ok" RETURN
    local DEP="python3.8"
    [[ -f /usr/local/opt/python@3.8/bin/python3 ]] || (log_install && brew install python@3.8)

    if [[ ! $(cat ~/.zshrc | grep /usr/local/opt/python@3.8/bin) ]]; then
        echo 'export PATH="/usr/local/opt/python@3.8/bin:$PATH"' >> ~/.zshrc
    fi
}

install_python
