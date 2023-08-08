import logging

from hub.deps import installers
from hub.logger import config_logger

if __name__ == '__main__':
    config_logger()
    for installer in installers:
        logging.info((installer.__class__.__name__ + ' ').ljust(50, '-'))
        installer.run()
        installer.cleanup()
