#!/bin/bash
set -e

clone_if_needed() {
    if [[ ${CLONE} != "false" ]]; then
        local WORKING_DIR=/var/tmp/dev
        rm -rf ${WORKING_DIR}
        git clone --single-branch --depth 1 https://github.com/trinhngocthuyen/dev.git ${WORKING_DIR} && cd ${WORKING_DIR}
    fi
}

clone_if_needed
source scripts/base.sh

log_info -b "DEPS: $@"
which python3 && python3 install.py --dep $@
