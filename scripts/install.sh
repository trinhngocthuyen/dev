#!/bin/bash
set -e
source $(dirname $0)/_deps/_base.sh

if [[ $(uname -m) != "x86_64" ]]; then
    log_warning "Disclaimer: This script is not well tested with M1 Macs. You might consider running this terminal session with Rosetta."
fi

for file in $(find $(dirname $0)/_deps -depth 1 -name *.sh | sort); do
    source "${file}"
done

log_info "------------------------------------------"
log_info "🎉 Congratulations! You've finished the dependencies setup."
log_info "Now restart iTerm for the settings to take effect."

rm -rf ${TMP_DIR}
