# shellcheck shell=bash
# shellcheck disable=SC1090
# SC1090: Ignored because we're intentionally sourcing arbitrary paths

function _configure() {
    local sources=(
        "${HOME}/.apps/google-cloud-sdk/completion.bash.inc"
        "${ENVY_ROOT}/libexec/git/git-completion.bash"
    )

    for src in "${sources[@]}"; do
        [ -f "${src}" ] && . "${src}"
    done

    # This is unfortunately simply too slow
    #type kubectl >/dev/null && source <(kubectl completion bash)
}
_configure
unset -f _configure
