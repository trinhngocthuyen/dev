from hub.deps.base import Installer


class PythonInstaller(Installer):
    def run(self):
        self.install_with_brew(f'python@{self.python_version}')
        self.update_zprofile()
        self.install_common_packages()

    @property
    def python_version(self) -> str:
        return '3.10'

    @property
    def libexec_bin_path(self):
        return self.brew_prefix / f'opt/python@{self.python_version}/libexec/bin'

    def update_zprofile(self):
        line = f'export PATH="{self.libexec_bin_path}:${{PATH}}"'
        self.insert_content(self.zprofile_path, line)

    def install_common_packages(self):
        python = (
            f'source {self.quote(self.zprofile_path)} && {self.libexec_bin_path}/python'
        )
        packages = [
            'isort',
            'black',
            'autoflake',
        ]
        self.sh(f'{python} -m ensurepip --upgrade')
        self.sh(f'{python} -m pip install ' + ' '.join(packages))
