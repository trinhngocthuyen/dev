import typing as t
from pathlib import Path

from hub.deps.base import Installer


class VscodeInstaller(Installer):
    def run(self):
        if self.vscode_path():
            self.log_installed('VSCode')
        else:
            self.download_vscode()
        self.install_symlink()
        self.install_user_settings()
        self.install_extensions()

    def download_vscode(self):
        self.download(
            'https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal',
            save_to=f'{self.tmp_dir}/VSCode.zip',
            unzip=True,
        )
        self.mv(f'{self.tmp_dir}/Visual Studio Code.app', '/Applications/VSCode.app')

    def vscode_path(self) -> t.Optional[Path]:
        paths = [
            self.app_path('VSCode'),
            self.app_path('Visual Studio Code'),
        ]
        return next((p for p in paths if p.exists()), None)

    def install_symlink(self):
        self.create_symlink(
            self.vscode_path() / 'Contents/Resources/app/bin/code',
            self.opt_bin_path / 'code',
            sudo=True,
        )

    def install_user_settings(self):
        self.merge_settings(
            '_config/vscode/settings.json',
            '~/Library/Application Support/Code/User/settings.json',
        )

    def install_extensions(self):
        cmd = f'{self.opt_bin_path}/code --list-extensions'
        existing_extensions: t.List[str] = (
            self.sh(cmd, capture_output=True).stdout.decode('utf-8').strip().split('\n')
        )
        to_install = {
            'ms-python.python',
            'ms-python.vscode-pylance',
            'ms-toolsai.jupyter',
            'ms-toolsai.jupyter-keymap',
            'Perkovec.emoji',
            'shardulm94.trailing-spaces',
            'trinhngocthuyen.chris-decor',
        }.difference(existing_extensions)
        self.log.debug(f'Existing extensions: {existing_extensions}')
        for extension in to_install:
            self.log.debug(f'-> Install extension: {extension}')
            self.sh(f'{self.opt_bin_path}/code --install-extension {extension}')
