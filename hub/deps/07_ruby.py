from pathlib import Path

from hub.deps.base import Installer


class RubyInstaller(Installer):
    def run(self):
        self.install_with_brew('rbenv')
        self.install_ruby()
        self.update_zprofile()
        self.install_common_gems()

    @property
    def ruby_version(self) -> str:
        return '3.0.0'

    def install_ruby(self):
        rbenv = self.bin('rbenv')
        if not rbenv(f'version | grep {self.ruby_version}').returncode:
            return self.log_installed(f'ruby {self.ruby_version}')
        self.log.debug(f'-> Install ruby {self.ruby_version}')
        rbenv(f'install {self.ruby_version}')
        rbenv(f'global {self.ruby_version}')

    def update_zprofile(self):
        self.insert_content(self.zprofile_path, 'eval "$(rbenv init -)"')

    def install_common_gems(self):
        with self.can_fail():
            gem = self.bin(Path('~/.rbenv/shims/gem').expanduser())
            deps = ['cocoapods', 'fastlane', 'pry', 'pry-nav']
            gem(f'install ' + ' '.join(deps))
