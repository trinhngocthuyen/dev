from hub.deps.base import Installer


class EnvInstaller(Installer):
    def run(self):
        self.log.info(f'Platform processor: {self.platform_processor}')
        if not self.opt_bin_path.exists():
            self.log.debug(f'Create dir: {self.opt_bin_path}')
            self.sh(f'sudo mkdir -p {self.opt_bin_path}')
        self.insert_content(self.zprofile_path, 'export PATH="/opt/bin:${PATH}"')
