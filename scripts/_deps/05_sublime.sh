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
config_subl_settings() {
    local user_settings_path=~/Library/Application\ Support/Sublime\ Text/Packages/User/Preferences.sublime-settings
    if [[ -f "${user_settings_path}" ]]; then
        mkdir -p /tmp/subl
        cat "${user_settings_path}" | grep -v -E '^//' > /tmp/subl/Preferences.sublime-settings
        jq -s '.[0] * .[1]' \
            _config/subl/Preferences.sublime-settings \
            /tmp/subl/Preferences.sublime-settings \
            > "${user_settings_path}"
    else
        mkdir -p $(dirname "${user_settings_path}")
        cp _config/subl/Preferences.sublime-settings "${user_settings_path}"
    fi
}

install_sublime_text
config_symlink_subl
config_subl_settings
