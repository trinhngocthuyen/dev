#!/bin/bash
set -e
source $(dirname $0)/_base.sh

install_brew() {
    trap "ok" RETURN
    local DEP="Homebrew"
    which brew &> /dev/null && return 0 || confirm || return 0

    log_info "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $(uname -m) == "x86_64" ]]; then
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    elif [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_brew
