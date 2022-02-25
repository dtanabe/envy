# shellcheck shell=bash

export GOENV_ROOT="$HOME/.goenv"
export GOPATH="${HOME}/.go"

if command -v goenv >/dev/null 2>&1; then
    eval "$(goenv init -)"
fi