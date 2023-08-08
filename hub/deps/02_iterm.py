from pathlib import Path

from hub.deps.base import Installer


class ItermInstaller(Installer):
    def run(self):
        if self.app_path('iTerm').exists():
            return self.log_installed('iTerm')

        self.download_iterm()
        self.install_color_schemes()
        self.install_profiles()

    def download_iterm(self):
        self.download(
            'https://iterm2.com/downloads/stable/iTerm2-3_4_9.zip',
            save_to=f'{self.tmp_dir}/iTerm.zip',
            unzip=True,
        )
        self.mv(f'{self.tmp_dir}/iTerm.app', '/Applications/iTerm.app')

    def install_color_schemes(self):
        color_schemes_dir = self.tmp_dir / 'color-schemes'
        self.git_clone(
            'https://github.com/mbadolato/iTerm2-Color-Schemes.git',
            dir=color_schemes_dir,
        )
        cmd = (
            f'{self.quote(color_schemes_dir)}/tools/import-scheme.sh '
            f'{self.quote(color_schemes_dir)}/schemes/Andromeda.itermcolors'
        )
        self.sh(cmd)

    def install_profiles(self):
        profiles_dir = Path(
            '~/Library/Application Support/iTerm2/DynamicProfiles'
        ).expanduser()
        profiles_dir.mkdir(parents=True, exist_ok=True)
        self.cp('_config/iterm2/profiles.json', profiles_dir / 'profiles.json')
