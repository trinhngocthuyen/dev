#!/bin/bash
set -e

config_git() {
    trap "ok" RETURN
    local DEP="git"

    if ! git config --global user.name &> /dev/null; then
        read -p "Global git config - user.name: " git_name
        read -p "Global git config - user.email: " git_email
        git config --global user.name "${git_name}"
        git config --global user.email "${git_email}"
    fi
}

config_git
