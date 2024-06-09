from pathlib import Path

from hub.deps.base import Installer


class PythonInstaller(Installer):
    def run(self):
        self.install_with_brew(f'pyenv')
        self.install_python()
        # self.install_with_brew(f'python@{self.python_version}')
        self.update_zprofile()
        self.install_common_packages()

    @property
    def python_version(self) -> str:
        return '3.10'

    def install_python(self):
        pyenv = self.bin('pyenv')
        if not pyenv(f'version | grep {self.python_version}').returncode:
            return self.log_installed(f'python {self.python_version}')
        self.log.debug(f'-> Install python {self.python_version}')
        pyenv(f'install {self.python_version}')
        pyenv(f'global {self.python_version}')

    def update_zprofile(self):
        self.insert_content(self.zprofile_path, 'eval "$(pyenv init -)"')

    def install_common_packages(self):
        python = self.bin(Path('~/.pyenv/shims/python').expanduser())
        packages = [
            'virtualenv',
            'isort',
            'black',
            'autoflake',
            'ipython',
            'jupyterlab',
            'pre-commit',
        ]
        with self.can_fail():
            python(f'-m ensurepip --upgrade')
            python(f'-m pip install ' + ' '.join(packages))
