#!/bin/bash
set -e

rm -rf /tmp/dev
git clone --single-branch --depth 1 https://github.com/trinhngocthuyen/dev.git /tmp/dev
cd /tmp/dev

which python3 && python3 install.py --dep $1
