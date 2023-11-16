from hub.deps.base import Installer


class BrewInstaller(Installer):
    def run(self):
        self.install_brew()
        self.update_zprofile()
        self.install_common_formulas()

    def install_brew(self):
        if not self.bin('which brew &> /dev/null')().returncode:
            return self.log_installed('brew')
        self.log.debug('-> Install brew')
        cmd = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        self.sh(cmd)

    def update_zprofile(self):
        line = f'eval "$({self.brew_prefix}/bin/brew shellenv)"'
        self.insert_content(self.zprofile_path, line, prepend=True)

    def install_common_formulas(self):
        with self.can_fail():
            formulas = ['jq', 'xcbeautify', 'swiftlint', 'hugo', 'node']
            for formula in formulas:
                self.install_with_brew(formula)
