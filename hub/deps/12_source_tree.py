import typing as t
from pathlib import Path

from hub.deps.base import Installer


class SourceTreeInstaller(Installer):
    def run(self):
        if self.stree_app():
            return self.log_installed('Source Tree')
        self.download_source_tree()

    def stree_app(self) -> t.Optional[Path]:
        if (path := Path('/Applications/Sourcetree.app')).exists():
            return path

    def download_source_tree(self):
        self.download(
            'https://product-downloads.atlassian.com/software/sourcetree/ga/Sourcetree_4.2.4_254.zip',
            save_to=f'{self.tmp_dir}/SourceTree.zip',
            unzip=True,
        )
        self.mv(f'{self.tmp_dir}/SourceTree.app', '/Applications/SourceTree.app')
