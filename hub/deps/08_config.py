from hub.deps.base import Installer


class ConfigInstaller(Installer):
    def run(self):
        self.config_hidden_files()
        self.config_git_editor()

    def config_hidden_files(self):
        self.log.debug('-> Show hidden files')
        proc = self.sh(
            'defaults read com.apple.finder AppleShowAllFiles', capture_output=True
        )
        if proc.stdout.decode('utf-8').strip() != 'YES':
            self.sh('defaults write com.apple.finder AppleShowAllFiles YES')
            self.sh('killall Finder')

    def config_git_editor(self):
        self.log.debug('-> Set subl as git editor')
        self.sh('git config --global core.editor "subl -n -w"')
