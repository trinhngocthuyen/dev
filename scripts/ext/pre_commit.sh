#!/bin/bash
set -e
source ${0:A:h}/../base.sh

if which pre-commit &> /dev/null; then
    log_info -b pre-commit was installed at: $(which pre-commit)
else
    log_debug -b "Installing pre-commit via pip..."
    pip install pre-commit
fi
