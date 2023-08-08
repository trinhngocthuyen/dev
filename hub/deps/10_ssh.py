from functools import cached_property
from pathlib import Path

from hub.deps.base import Installer


class SshInstaller(Installer):
    def run(self):
        if (self.ssh_dir / 'id_rsa').exists():
            return self.log_installed('ssh key')
        if (self.ssh_dir / 'config').exists():
            return self.log_installed('ssh config')
        if input('Would you like to gen ssh key? [y/n]: ').lower() == 'y':
            self.gen_ssh_key()

    @cached_property
    def ssh_dir(self) -> Path:
        path = Path('~/.ssh').expanduser()
        path.mkdir(parents=True, exist_ok=True)
        return path

    def gen_ssh_key(self):
        self.sh('ssh-keygen -t rsa -b 4096')
