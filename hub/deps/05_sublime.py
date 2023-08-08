import typing as t
from pathlib import Path

from hub.deps.base import Installer


class SublimeInstaller(Installer):
    def run(self):
        if self.sublime_path():
            self.log_installed('Sublime Text')
        else:
            self.download_sublime()
        self.install_symlink()
        self.install_user_settings()

    def sublime_path(self) -> t.Optional[Path]:
        if (path := self.app_path('Sublime Text')).exists():
            return path

    def download_sublime(self):
        self.download(
            'https://download.sublimetext.com/sublime_text_build_4152_mac.zip',
            save_to=f'{self.tmp_dir}/SublimeText.zip',
            unzip=True,
        )
        self.mv(f'{self.tmp_dir}/Sublime Text.app', '/Applications/Sublime Text.app')

    def install_symlink(self):
        self.create_symlink(
            self.sublime_path() / 'Contents/SharedSupport/bin/subl',
            self.opt_bin_path / 'subl',
            sudo=True,
        )

    def install_user_settings(self):
        self.merge_settings(
            '_config/subl/Preferences.sublime-settings',
            '~/Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings',
        )
