#!/usr/bin/env bash

# ANSI кольори
_LOG_RED="\033[0;31m"
_LOG_GREEN="\033[0;32m"
_LOG_YELLOW="\033[0;33m"
_LOG_BLUE="\033[0;34m"
_LOG_RESET="\033[0m"

log_info() {
    printf "${_LOG_BLUE}[INFO]${_LOG_RESET} %s\n" "$*"
}

log_success() {
    printf "${_LOG_GREEN}[OK]${_LOG_RESET} %s\n" "$*"
}

log_warn() {
    printf "${_LOG_YELLOW}[WARN]${_LOG_RESET} %s\n" "$*"
}

log_error() {
    printf "${_LOG_RED}[FAIL]${_LOG_RESET} %s\n" "$*" >&2
}

log_time() {
    printf "${_LOG_BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${_LOG_RESET} %s\n" "$*"
}