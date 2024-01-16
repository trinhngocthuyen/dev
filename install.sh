#!/bin/bash
set -e

clone_if_needed() {
    local WORKING_DIR=~/projects/dev
    [[ ${CLONE} != "false" ]] || return 0
    [[ $(PWD) != ${WORKING_DIR} ]] || return 0

    rm -rf ${WORKING_DIR}
    git clone --single-branch --depth 1 https://github.com/trinhngocthuyen/dev.git ${WORKING_DIR} && cd ${WORKING_DIR}
}

clone_if_needed
source scripts/base.sh

log_info -b "DEPS: $@"
which python3 && python3 install.py --dep $@
