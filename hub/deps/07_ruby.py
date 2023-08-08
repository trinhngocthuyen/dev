from hub.deps.base import Installer


class RubyInstaller(Installer):
    def run(self):
        self.install_with_brew('rbenv')
        self.install_ruby()
        self.update_zprofile()

    @property
    def ruby_version(self) -> str:
        return '3.0.0'

    def install_ruby(self):
        rbenv = f'source {self.quote(self.zprofile_path)} && rbenv'
        if not self.sh(
            f'({rbenv} version | grep {self.ruby_version}) &> /dev/null'
        ).returncode:
            return self.log_installed(f'ruby {self.ruby_version}')
        self.log.debug(f'-> Install ruby {self.ruby_version}')
        self.sh(f'{rbenv} install {self.ruby_version}')
        self.sh(f'{rbenv} global {self.ruby_version}')

    def update_zprofile(self):
        self.insert_content(self.zprofile_path, 'eval "$(rbenv init -)"')
