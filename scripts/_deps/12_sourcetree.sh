#!/bin/bash
set -e

install_sourcetree() {
    trap "ok" RETURN
    local DEP="Sourcetree"
    [[ -d "/Applications/Sourcetree.app" ]] && return 0 || confirm || return 0

    curl -L "https://product-downloads.atlassian.com/software/sourcetree/ga/Sourcetree_4.1.8_244.zip" \
            -o ${TMP_DIR}/Sourcetree.zip \
        && unzip -q ${TMP_DIR}/Sourcetree.zip -d ${TMP_DIR} \
        && mv "${TMP_DIR}/Sourcetree.app" "/Applications/Sourcetree.app"
}

install_sourcetree
