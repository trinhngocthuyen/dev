#!/bin/bash
set -e
source $(dirname $0)/_base.sh

if ! (fc-list | grep "Source Code Pro") &> /dev/null; then
    if [[ ! -d ${TMP_DIR}/source-code-pro ]]; then
        log_info "Installing font Source Code Pro..."
        git clone --depth=1 https://github.com/adobe-fonts/source-code-pro.git ${TMP_DIR}/source-code-pro
    fi
    rsync -ra ${TMP_DIR}/source-code-pro/OTF/*.otf ~/Library/Fonts/
fi
