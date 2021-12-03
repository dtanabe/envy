# shellcheck shell=bash

function _configure() {
    local IFS
    local path_tmp=":${PATH}:"
    local path_components=(
        "${HOME}/.bin"
        "${HOME}/.apps/google-cloud-sdk/bin"
        "${HOME}/.cargo/bin"
        "${HOME}/.daml/bin"
        "${HOME}/.local/bin"
        "${HOME}/.poetry/bin"
        "${HOME}/.pyenv/bin"
        "${HOME}/.pyenv/shims"
        "${HOME}/.apps/.venv/bin"
        /opt/homebrew/bin
        /usr/local/opt/gettext/bin
        /usr/local/opt/openssl/bin
        /usr/local/bin
        /usr/bin
        /bin
        /usr/sbin
        /sbin
        /snap/bin
        /opt/local/bin
        /opt/local/sbin
        /Applications/MacVim.app/Contents/bin
        "${HOME}/Applications"
        "${ENVY_ROOT}/bin"
        node_modules/.bin
    )

    # first remove any path components that are already present that we also want
    for p in "${path_components[@]}"; do
        path_tmp=${path_tmp//:$p:/:}
    done

    # the final PATH is all of our components in our order, followed by whatever
    # was already set on the current system
    IFS=":"
    PATH="${path_components[*]}:${path_tmp}"
    PATH="${PATH//::/:}"
    PATH="${PATH/#:/}"
    PATH="${PATH/%:/}"
    export PATH
}
_configure
unset -f _configure
