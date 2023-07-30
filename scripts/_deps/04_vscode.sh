#!/bin/bash
set -e

CODE_BIN=/opt/bin/code

_vscode_path() {
    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        echo "/Applications/Visual Studio Code.app"
    elif [[ -d "/Applications/VSCode.app" ]]; then
        echo "/Applications/VSCode.app"
    fi
}

install_vscode() {
    trap "ok" RETURN
    local DEP="VSCode"
    [[ "$(_vscode_path)" != "" ]] && return 0 || confirm || return 0

    curl -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" \
            -o ${TMP_DIR}/VSCode.zip \
        && unzip -q ${TMP_DIR}/VSCode.zip -d ${TMP_DIR} \
        && mv "${TMP_DIR}/Visual Studio Code.app" /Applications/VSCode.app
}

config_symlink_code() {
    if [[ ! -f ${CODE_BIN} ]]; then
        log_info "   Config: Create symlink (code) for VSCode"
        sudo ln -s "$(_vscode_path)/Contents/Resources/app/bin/code" ${CODE_BIN}
    fi
}

config_vscode_settings() {
    log_info "Config: VSCode settings"
    [[ -f ~/Library/Application\ Support/Code/User/settings.json ]] || \
        (log_info "VSCode user settings was absent" && mkdir -p ~/Library/Application\ Support/Code/User && echo  "{}" > ~/Library/Application\ Support/Code/User/settings.json)
    jq -s '.[0] * .[1]' \
        _config/vscode/settings.json \
        ~/Library/Application\ Support/Code/User/settings.json \
        > ${TMP_DIR}/vscode_settings.json
    mv ${TMP_DIR}/vscode_settings.json ~/Library/Application\ Support/Code/User/settings.json

    log_info "Config: VSCode - Install extensions"
    local existing_extensions=$(${CODE_BIN} --list-extensions)
    local extensions=(
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        Perkovec.emoji
        shardulm94.trailing-spaces
        trinhngocthuyen.chris-decor
    )
    for extension in ${extensions[@]}; do
        if [[ ${existing_extensions} =~ "${extension}" ]]; then
            log_info "-> Extension: ${extension} exists!"
        else
            log_info "-> Extension: ${extension} -> Installing..."
            ${CODE_BIN} --install-extension ${extension}
        fi
    done
}

install_vscode
config_symlink_code
config_vscode_settings
