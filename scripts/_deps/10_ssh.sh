#!/bin/bash
set -e

config_ssh() {
    trap "ok" RETURN
    local DEP="ssh key"

    [[ -f ~/.ssh/id_rsa ]] && return 0 || confirm || return 0
    mkdir -p ~/.ssh
    ssh-keygen -t rsa -b 4096
}

config_ssh
