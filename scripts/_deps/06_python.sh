#!/bin/bash
set -e

install_python() {
    trap "ok" RETURN
    local DEP="python@3.10"
    (brew list | grep python &> /dev/null) || (log_install && brew install ${DEP})
    local python_libexec_bin=$(brew --prefix)/opt/${DEP}/libexec/bin

    if [[ ! $(cat ~/.zshrc | grep ${python_libexec_bin}) ]]; then
        echo "export PATH=\"${python_libexec_bin}:\$PATH\"" >> ~/.zshrc
    fi
}

install_python
