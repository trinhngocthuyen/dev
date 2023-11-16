import logging
from argparse import ArgumentParser

from hub.deps import installers
from hub.logger import config_logger

if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--dep', dest='deps', help='Dependencies', nargs='*')
    args = parser.parse_args()

    config_logger()

    for installer in installers:
        if args.deps and installer.name not in args.deps:
            continue
        logging.info((installer.__class__.__name__ + ' ').ljust(50, '-'))
        installer.run()
        installer.cleanup()
