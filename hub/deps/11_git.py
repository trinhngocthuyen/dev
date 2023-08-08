from hub.deps.base import Installer


class GitInstaller(Installer):
    def run(self):
        cmd = '(git config --global user.name) &> /dev/null'
        if not self.sh(cmd).returncode:
            return
        name = input('Global git config - user.name: ')
        email = input('Global git config - user.email: ')
        self.sh(f'git config --global user.name "{name}"')
        self.sh(f'git config --global user.email "{email}"')
