#!/bin/bash
set -e
source $(dirname $0)/_base.sh

config_rbenv() {
    if ! (cat ~/.zshrc | grep "rbenv init -") &> /dev/null; then
        sed -i.bkp '1s/^/eval "$(rbenv init -)"\n/' ~/.zshrc
    fi

    if ! (rbenv version | grep 2.7.0) &> /dev/null; then
        log_info "Installing ruby 2.7.0 (via rbenv)..."
        rbenv install 2.7.0
        log_info "-> Set global ruby version: 2.7.0"
        rbenv global 2.7.0
    fi
}

install_with_brew rbenv
config_rbenv
