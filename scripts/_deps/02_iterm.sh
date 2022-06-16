#!/bin/bash
set -e

install_iterm() {
    trap "ok" RETURN
    local DEP="iTerm"

    [[ -d /Applications/iTerm.app ]] && return 0 || confirm || return 0

    curl -L https://iterm2.com/downloads/stable/iTerm2-3_4_9.zip \
            -o ${TMP_DIR}/iTerm.zip \
        && unzip -q ${TMP_DIR}/iTerm.zip -d ${TMP_DIR} \
        && mv ${TMP_DIR}/iTerm.app /Applications/iTerm.app

    local color_schemes_dir=${TMP_DIR}/iTerm2-Color-Schemes

    git clone --depth=1 https://github.com/mbadolato/iTerm2-Color-Schemes.git ${color_schemes_dir} \
        && ${color_schemes_dir}/tools/import-scheme.sh ${color_schemes_dir}/schemes/Andromeda.itermcolors
}
config_iterm () {
    mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
    cp _config/iterm2/profiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/profiles.json
}

install_iterm
config_iterm
