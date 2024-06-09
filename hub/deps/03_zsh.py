import re
from pathlib import Path

from hub.deps.base import Installer


class ZshInstaller(Installer):
    def run(self):
        if self.zsh_dir.exists():
            self.log_installed('zsh')
        else:
            self.install_zsh()
        self.install_zsh_config()
        self.update_zsh_theme()
        self.update_zsh_plugins()

    @property
    def zsh_dir(self) -> Path:
        return Path('~/.oh-my-zsh').expanduser()

    @property
    def zsh_custom_dir(self) -> Path:
        return self.zsh_dir / 'custom'

    @property
    def zshrc_path(self) -> Path:
        return Path('~/.zshrc').expanduser()

    def install_zsh(self):
        cmd = (
            'env RUNZSH=no sh -c '
            '"$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
        )
        self.sh(cmd)

    def install_zsh_config(self):
        config_dir = Path('_config/zsh')
        paths = list(config_dir.glob('**/*.plugin.zsh')) + list(
            config_dir.glob('**/*.zsh-theme')
        )
        for path in paths:
            if path.suffix == '.zsh':
                dst_path = (
                    self.zsh_custom_dir / 'plugins' / path.parent.stem / path.name
                )
            elif path.suffix == '.zsh-theme':
                dst_path = self.zsh_custom_dir / 'themes' / path.name
            self.log.debug(f'-> Link: {dst_path} -> {path}')
            dst_path.parent.mkdir(parents=True, exist_ok=True)
            dst_path.write_text(f'source "{path.absolute()}"')

    def update_zsh_theme(self):
        selected_theme = 'chris'
        lines = self.zshrc_path.read_text().splitlines()
        current_theme, idx = None, None
        for idx, line in enumerate(lines):
            if m := re.search(r'^ZSH_THEME="(\S+)"', line):
                current_theme = m.group(1)
                break

        self.log.debug(f'Current theme: {current_theme}')
        if current_theme != selected_theme:
            self.log.debug(f'-> Change theme to: {selected_theme}')
            updated_line = f'ZSH_THEME="{selected_theme}"'
            if current_theme is None:
                lines.insert(0, updated_line)
            else:
                lines[idx] = updated_line
            self.zshrc_path.write_text('\n'.join(lines))
            return

    def update_zsh_plugins(self):
        lines = self.zshrc_path.read_text().splitlines()
        current_plugins, idx = set(), None
        for idx, line in enumerate(lines):
            if m := re.search(r'^plugins=\((.*)\)', line):
                current_plugins = set(m.group(1).split(' '))
                break

        to_clone = {'zsh-autosuggestions', 'zsh-syntax-highlighting'}
        to_activate = current_plugins.union(to_clone).union(
            {'git', 'python', 'swiftpm', 'last-working-dir', 'chris'}
        )
        for plugin in to_clone:
            plugin_dir = self.zsh_custom_dir / 'plugins' / plugin
            if not plugin_dir.exists():
                self.git_clone(f'https://github.com/zsh-users/{plugin}.git', plugin_dir)

        self.log.debug(f'Current plugins: {current_plugins}')
        if current_plugins != to_activate:
            self.log.debug(f'-> Change plugins to: {to_activate}')
            updated_line = 'plugins=({})'.format(' '.join(to_activate))
            if not current_plugins:
                lines.insert(0, updated_line)
            else:
                lines[idx] = updated_line
        self.zshrc_path.write_text('\n'.join(lines))
