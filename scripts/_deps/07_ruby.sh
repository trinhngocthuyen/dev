#!/bin/bash
set -e

config_rbenv() {
    if ! (cat ~/.zshrc | grep "rbenv init -") &> /dev/null; then
        sed -i.bkp '1s/^/eval "$(rbenv init -)"\n/' ~/.zshrc
    fi

    if ! (rbenv version | grep 3.0.0) &> /dev/null; then
        log_info "Installing ruby 3.0.0 (via rbenv)..."
        rbenv install 3.0.0
        log_info "-> Set global ruby version: 3.0.0"
        rbenv global 3.0.0
    fi
}

install_with_brew rbenv
config_rbenv
