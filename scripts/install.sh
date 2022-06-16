#!/bin/bash
set -e
source $(dirname $0)/_deps/_base.sh

for file in $(find $(dirname $0)/_deps -depth 1 -name *.sh | sort); do
    sh "${file}"
done

log_info "------------------------------------------"
log_info "🎉 Congratulations! You've finished the dependencies setup."
log_info "Now restart iTerm for the settings to take effect."

rm -rf ${TMP_DIR}
