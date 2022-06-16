#!/bin/bash
set -e

if [[ ! -f ~/Library/Fonts/SourceCodePro-Regular.otf ]]; then
    if [[ ! -d ${TMP_DIR}/source-code-pro ]]; then
        log_info "Installing font Source Code Pro..."
        git clone --depth=1 https://github.com/adobe-fonts/source-code-pro.git ${TMP_DIR}/source-code-pro
    fi
    rsync -ra ${TMP_DIR}/source-code-pro/OTF/*.otf ~/Library/Fonts/
fi
