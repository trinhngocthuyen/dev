from functools import cached_property
from pathlib import Path

from hub.deps.base import Installer


class FontsInstaller(Installer):
    def run(self):
        self.install_fonts()

    @cached_property
    def fonts_library_dir(self) -> Path:
        return Path('~/Library/Fonts').expanduser()

    def install_fonts(self):
        if (self.fonts_library_dir / 'SourceCodePro-Regular.otf').exists():
            return self.log_installed('SourceCodePro')
        self.log.debug('-> Install SourceCodePro')
        self.git_clone(
            'https://github.com/adobe-fonts/source-code-pro.git', self.tmp_dir
        )
        for path in self.tmp_dir.glob('**/*.otf'):
            self.cp(path, self.fonts_library_dir / path.name)
