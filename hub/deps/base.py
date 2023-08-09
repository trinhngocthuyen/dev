import contextlib
import json
import logging
import os
import platform
import shlex
import shutil
import subprocess
import tempfile
import typing as t
from functools import cached_property
from pathlib import Path

StrPath = t.Union[str, Path]


class Installer:
    def run(self):
        pass

    def cleanup(self):
        shutil.rmtree(self.tmp_dir)

    def bin(self, p: StrPath):
        def fn(*args, **kwargs):
            cmd = f'source {self.quote(self.zprofile_path)} && {p}'
            if args:
                cmd = '{} {}'.format(cmd, ' '.join(args))
            return self.sh(cmd, **kwargs)

        return fn

    @cached_property
    def zprofile_path(self) -> Path:
        path = Path('~/.zprofile').expanduser()
        path.touch()
        return path

    @cached_property
    def brew_prefix(self) -> Path:
        return Path('/opt/homebrew' if self.is_m1 else '/usr/local')

    @cached_property
    def opt_bin_path(self) -> Path:
        return Path('/opt/bin')

    @cached_property
    def tmp_dir(self):
        return Path(tempfile.mkdtemp())

    @property
    def log(self):
        return logging

    @property
    def platform_processor(self) -> str:
        return platform.processor()

    @property
    def is_m1(self) -> bool:
        return self.platform_processor == 'arm'

    @contextlib.contextmanager
    def can_fail(self):
        try:
            yield
        except Exception as e:
            self.log.warning(f'An error has occurred: {e}. This error is tolerated')

    def subprocess(self, *args, **kwargs) -> subprocess.CompletedProcess:
        return subprocess.run(*args, **kwargs)

    def sh(self, *args, **kwargs):
        kwargs['shell'] = True
        if kwargs.pop('log_cmd', True):
            self.log.debug(f'$ {args[0]}')
        return self.subprocess(*args, **kwargs)

    def quote(self, s) -> t.Optional[str]:
        return shlex.quote(str(s)) if s is not None else None

    def log_installed(self, name: str):
        self.log.info(f'✔ {name} was installed')

    def mv(self, src: StrPath, dst: StrPath):
        shutil.move(src, dst)

    def cp(self, src: StrPath, dst: StrPath) -> Path:
        if os.path.isdir(src):
            return Path(shutil.copytree(src, dst))
        return Path(shutil.copy(src, dst))

    def download(self, url: str, save_to: StrPath, unzip=False):
        save_to = Path(save_to)
        self.log.debug(f'-> Download and save to: {save_to}')
        save_to.parent.mkdir(parents=True, exist_ok=True)
        self.sh(
            f'curl -L {self.quote(url)} -o {self.quote(save_to)}'
        )  # Use curl for now
        if unzip:
            self.log.debug(f'-> Unzip: {save_to}')
            self.sh(f'unzip -q {self.quote(save_to)} -d {self.quote(save_to.parent)}')

    def install_with_brew(self, formula: str):
        brew = self.bin(f'{self.brew_prefix}/bin/brew')
        if not brew(f'list | grep {formula}').returncode:
            return self.log_installed(formula)
        self.log.debug(f'{formula} was not installed')
        self.log.debug(f'-> Install {formula}')
        brew(f'install {formula}')

    def insert_content(self, path: StrPath, content: str, prepend=False):
        path = Path(path).expanduser()
        path.touch()
        existing = path.read_text()
        if content not in existing:
            if prepend:
                updated = f'{content}\n{existing}'
            else:
                updated = f'{existing}\n{content}'
            path.write_text(updated)

    def app_path(self, name: str) -> Path:
        return Path(f'/Applications/{name}.app')

    def git_clone(self, repo: str, dir: t.Optional[StrPath]):
        cmps = ['git clone --depth=1 --single-branch', repo, self.quote(dir)]
        cmd = ' '.join(x for x in cmps if x)
        self.sh(cmd)

    def create_symlink(self, source: StrPath, target: StrPath, sudo=False):
        if Path(target).exists():
            return
        self.log.debug(f'-> Create symlink: {source} -> {target}')
        cmd = 'sudo ' if sudo else ''
        cmd += f'ln -s {self.quote(source)} {self.quote(target)}'
        self.sh(cmd)

    def merge_settings(self, src: StrPath, dst: StrPath):
        src, dst = Path(src).expanduser(), Path(dst).expanduser()
        if not dst.exists():
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.touch()
        try:
            existing_data = json.loads(dst.read_text())
        except:
            existing_data = {}
        data = json.loads(src.read_text())
        data.update(**existing_data)
        dst.write_text(json.dumps(data, indent=4))
