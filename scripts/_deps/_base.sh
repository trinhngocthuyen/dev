#!/bin/sh

TMP_DIR="/tmp/mv-hub"

log_info() {
  echo "\033[32;1m$1\033[0m"
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
