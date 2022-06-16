#!/bin/bash
set -e

config_hidden_files() {
    log_info "Config: Show hidden files"
    if [[ "$(defaults read com.apple.finder AppleShowAllFiles)" == "YES" ]]; then
        return 0
    fi
    defaults write com.apple.finder AppleShowAllFiles YES
    killall Finder
}

config_git_editor() {
    if which subl &> /dev/null; then
        log_info "Config: Set subl as git editor"
        git config --global core.editor "subl -n -w"
    fi
}

config_hidden_files
config_git_editor

install_with_brew jq
