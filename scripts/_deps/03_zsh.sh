#!/bin/bash
set -e

install_zsh() {
    trap "ok" RETURN
    local DEP="Oh My Zsh"
    [[ -d ~/.oh-my-zsh ]] && return 0 || confirm || return 0

    env RUNZSH=no \
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
config_zsh() {
    log_info "Config: Oh My Zsh"
    zsh_custom_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    rsync -ra _config/zsh/plugins/ ${zsh_custom_dir}/plugins/
    rsync -ra _config/zsh/themes/ ${zsh_custom_dir}/themes/

    for path in _config/zsh/plugins/*; do
        local plugin_name=$(basename ${path})
        echo "source \"${PWD}/_config/zsh/plugins/${plugin_name}/${plugin_name}.plugin.zsh\"" > ${zsh_custom_dir}/plugins/${plugin_name}/${plugin_name}.plugin.zsh
    done

    for path in  _config/zsh/themes/*; do
        local fname=$(basename ${path})
        echo "source \"${PWD}/_config/zsh/themes/${fname}\"" > ${zsh_custom_dir}/themes/${fname}
    done

    local selected_theme=chris
    log_info "   Config: Use zsh theme: ${selected_theme}"
    sed -i .bkp "s/ZSH_THEME=.*/ZSH_THEME=${selected_theme}/g" ~/.zshrc

    local existing_plugins=$(cat ~/.zshrc | grep ^plugins | sed -E 's/^plugins=\((.*)\)$/\1/')
    echo "   Existing plugins: ${existing_plugins}"

    local plugins_to_install="zsh-autosuggestions zsh-syntax-highlighting"
    local plugins_to_activate="${existing_plugins} ${plugins_to_install} last-working-dir ${selected_theme}"

    for plugin in ${plugins_to_install}; do
        [[ ! -d ${zsh_custom_dir}/plugins/${plugin} ]] \
            && log_info "   Config: Install zsh plugin: ${plugin}" \
            && git clone --depth=1 https://github.com/zsh-users/${plugin}.git ${zsh_custom_dir}/plugins/${plugin}
    done

    for plugin in ${plugins_to_activate}; do
        [[ ${plugins_to_activate} =~ "${plugin}" ]] || plugins_to_activate="${plugins_to_activate} ${plugin}"
    done

    plugins_to_activate="$(echo ${plugins_to_activate} | xargs -n1 | sort -u | xargs)"
    if [[ "${plugins_to_activate}" != "${existing_plugins}" ]]; then
        log_info "-> Update plugins: ${plugins_to_activate}"
        sed -i .bkp "s/^plugins=.*/plugins=(${plugins_to_activate})/g" ~/.zshrc
    fi

    rm -rf ~/.zshrc.bkp
}

install_zsh
config_zsh
