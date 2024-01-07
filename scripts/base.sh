#!/bin/bash
set -e

log() {
    local color_code=$1
    case $2 in
    -b|--bold)
        color_code="\x1b[1;${color_code}"
        shift 2
        ;;
    *)
        shift 1
        ;;
    esac
    echo "\033[${color_code}$*\033[0m"
}
log_debug() { log 37m $* ; }
log_info() { log 32m $* ; }
log_warning() { log 33m $* ; }
log_error() { log 31m $* ; }
