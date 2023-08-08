import imp
import re
import typing as t
from pathlib import Path

from hub.deps.base import Installer

__all__ = ['installers']

installers: t.List[Installer] = []

for path in sorted(Path(__file__).parent.glob('*.py')):
    if m := re.search(r'\d+_(\S+)', path.stem):
        module = imp.load_source(path.stem, str(path))
        name = ''.join(x.title() for x in m.group(1).split('_'))
        installer = getattr(module, name + 'Installer')()
        installers.append(installer)
