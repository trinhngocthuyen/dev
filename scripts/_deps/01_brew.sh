#!/bin/bash
set -e

install_brew() {
    trap "ok" RETURN
    local DEP="Homebrew"
    which brew &> /dev/null && return 0 || confirm || return 0

    log_info "Installing brew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    local this_arch=$(uname -m)

    if [[ ${this_arch} == "x86_64" ]]; then
        local BREW_PATH="/usr/local"
    elif [[ ${this_arch} == "arm64" ]]; then
        local BREW_PATH="/opt/homebrew"
    fi

    if ! (cat ~/.zprofile | grep "${BREW_PATH}/bin/brew shellenv") &> /dev/null; then
        echo 'eval "$('${BREW_PATH}/bin/brew' shellenv)"' >> ~/.zprofile
    fi
    eval "$(${BREW_PATH}/bin/brew shellenv)"

}

install_brew
install_with_brew jq
