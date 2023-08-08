from hub.deps.base import Installer


class EndInstaller(Installer):
    def run(self):
        def print_separator():
            self.log.info(''.ljust(50, '='))

        print_separator()
        self.log.info(
            '''
🎉 Congratulations! You've finished the dependencies setup.
Please switch to use iTerm from now on.
You might need to restart iTerm for all the changes to take effect.
'''
        )
        print_separator()
        self.sh("osascript -e 'tell application \"iTerm\" to activate'")
