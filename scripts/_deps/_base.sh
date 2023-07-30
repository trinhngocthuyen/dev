#!/bin/sh

TMP_DIR="/tmp/mv-hub"

_log_color() {
    echo "\033[$1m$2\033[0m"
}

log_debug() {
    echo $@
}

log_info() {
    _log_color "32;1" "$1"
}

log_warning() {
    _log_color "33;1" "$1"
}

ok() {
    log_info "${DEP:-$1} ✔"
}

log_install() {
    log_info "Installing ${DEP:-$1}..."
}

confirm() {
    local DEP=${DEP:-$1}
    read -p "Install ${DEP}? [y/n]: " confirm \
        && [[ $confirm == [yY] ]] \
        && log_install \
        || (log_info "--> Skip ${DEP}" && return 1)
}

install_with_brew() {
    trap "ok" RETURN
    local DEP=$1
    which $1 &> /dev/null || (log_install && brew install $1)
}

mkdir -p ${TMP_DIR}

if [[ ! -d /opt/bin ]]; then
    log_info "Creating /opt/bin..."
    sudo mkdir -p /opt/bin
fi
if ! (cat ~/.zprofile | grep "/opt/bin") &> /dev/null; then
    echo 'export PATH="${PATH}:/opt/bin"' >> ~/.zprofile
fi
