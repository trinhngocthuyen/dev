#!/bin/bash
set -e

install_python() {
    trap "ok" RETURN
    local DEP="python3.8"
    [[ -f $(brew --prefix)/opt/python@3.8/bin/python3 ]] || (log_install && brew install python@3.8)

    if [[ ! $(cat ~/.zshrc | grep $(brew --prefix)/opt/python@3.8/bin) ]]; then
        echo 'export PATH="'$(brew --prefix)'/opt/python@3.8/bin:$PATH"' >> ~/.zshrc
    fi
}

install_python
