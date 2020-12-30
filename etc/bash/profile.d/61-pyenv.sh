# shellcheck shell=bash

if command -v pyenv >/dev/null 2>&1; then
    export PYENV_SHELL=bash

    command pyenv rehash 2>/dev/null

    pyenv() {
        local cmd
        unset GREP_OPTIONS

        cmd="${1:-}"
        if [ "$#" -gt 0 ]; then
            shift
        fi

        case "${cmd:-}" in
        rehash|shell)
            eval "$(pyenv "sh-$cmd" "$@")";;
        *)
            command pyenv "$cmd" "$@";;
        esac
    }
fi
