#!/bin/bash
set -e

install_sublime_text() {
    trap "ok" RETURN
    local DEP="Sublime Text"
    [[ -d "/Applications/Sublime Text.app" ]] && return 0 || confirm || return 0

    curl -L "https://download.sublimetext.com/sublime_text_build_4113_mac.zip" \
            -o ${TMP_DIR}/SublimeText.zip \
        && unzip -q ${TMP_DIR}/SublimeText.zip -d ${TMP_DIR} \
        && mv "${TMP_DIR}/Sublime Text.app" "/Applications/Sublime Text.app"
}
config_symlink_subl() {
    if ! which subl &> /dev/null; then
        log_info "   Config: Create symlink (subl) for Sublime Text"
        sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
    fi
}

install_sublime_text
config_symlink_subl
