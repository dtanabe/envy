# shellcheck shell=bash

if command -v goenv >/dev/null 2>&1; then
    eval "$(goenv init -)"
fi